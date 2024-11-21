// Monday 11-18-2024

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (4 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -10.dbamp];
	snd[1] = snd[1] * Env.perc(0, 3).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2).ar;
	snd = snd ! 2;
	snd = snd * \amp.kr(-18).dbamp;
	snd = snd * (1 + (4 * Env.perc(0, 0.02).ar));
	snd = (snd * 3.dbamp).tanh;
	// snd = BLowShelf.ar(snd, 120, 0.5, 2);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1540, 0.3) * 20.dbamp;
	snd = snd + snd.tanh;
	snd = snd * Env([0, 1, 0, 1, 0, 1, 0], [0.001, 0.001, 0.01, 0.001, 0.001, 0.08], curve: -12).ar(Done.freeSelf);
	snd = DelayN.ar(snd, 0.01, 0.01 + Rand(0.002, -0.002));
	snd = Pan2.ar(snd, 0) * -10.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(34 * [1, 2.23, 3.45, 5.7, 7.8]).sum;
	snd = FreqShift.ar(snd, 41.2);
	snd = snd + (Hasher.ar(Sweep.ar) * -8.dbamp);
	snd = snd * Env.perc(0.005, \rel.kr(0.04)).ar;
	snd = BPF.ar(snd, 7923 * [1, 1.5] * XLine.ar(1, 1.3, 0.1), 0.2).sum;
	snd = HPF.ar(snd, 5000);
	snd = snd * \amp.kr(-12).dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 0.1, [44e-3, 23e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\perc, {
	var snd;
	snd = SinOsc.ar(880 * (1.5 ** [0, 1, 1.2])).sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.2).ar;
	snd = snd + GVerb.ar(snd * -24.dbamp, 18);
	snd = snd * Env.perc(0.0, 3).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -24.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\pulseBass, {
	var snd, env, freq;
	freq = \freq.kr(60) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	env = Env.perc(\atk.kr(0.001), \rel.kr(1), curve: -4).kr;
	snd = LFPulse.ar(freq, Rand(0, 1), 0.5);
	snd = RLPF.ar(snd, env.exprange(freq, freq * 30), 0.6);
	snd = snd * env * Env.linen(0, \duration.kr(1), 0.1).kr(Done.freeSelf);
	snd = BLowShelf.ar(snd, 240, 0.5, -4);
	Out.ar(\out.kr(0), Pan2.ar(snd, 0) * \amp.kr(-14).dbamp);
}).add;
SynthDef(\sidechain, {
	var snd, fb, scTrig;
	scTrig = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.9 * Env.perc(0.005, 0.1, curve: -2).ar(gate: scTrig)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = BLowShelf.ar(snd, 600, 0.3, -4);
	snd = BHiShelf.ar(snd, 3400, 0.3, -4);
	snd = (snd * 14.dbamp).tanh;
	snd = BLowShelf.ar(snd, 600, 0.3, 4);
	snd = BHiShelf.ar(snd, 3400, 0.3, 4);
	snd = snd * -10.dbamp;
	snd = snd + GVerb.ar(snd.sum * -30.dbamp, 20, 0.8);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~sidechainBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
)

~sidechainBus.index;
~drumsBus.index;

(
var s, root, scale, beat, sidechainFx, drumsFX;
s = Server.default;
root = 32;
scale = Scale.phrygian.degrees;
beat = 60 / 112;

Routine({
	// FX Units
	sidechainFx = Synth(\sidechain, [in: ~sidechainBus]);
	drumsFX = Synth(\drumFx, [in: ~drumsBus]);

	// Kick/Sub/808
	fork {
		loop {
			[0, 1].do { |lastOct|
				// bar 1
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 3), out: ~drumsBus]); };
				(beat * 3).wait;
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 1), amp: -20, out: ~drumsBus]); };
				(beat * 1).wait;
				// bar 2
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 4), out: ~drumsBus]); };
				(beat * 4).wait;
				// bar 3
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 0.5), out: ~drumsBus]); };
				(beat * 0.5).wait;
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 0.5), amp: -20, out: ~drumsBus]); };
				(beat * 0.5).wait;
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 3), out: ~drumsBus]); };
				(beat * 3).wait;
				// bar 4
				s.bind { sidechainFx.set(\trigger, 1) };
				s.bind {
					Synth(\kick,
						[
							freq: (root + (12 * lastOct)).midicps,
							duration: (beat * 4),
							amp: if(lastOct == 1, {-20}, {-18}),
							out: ~drumsBus
						]
					);
				};
				(beat * 4).wait;
			};
		};
	};
	// Clap
	fork {
		loop {
			(beat * 2).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			s.bind { Synth(\perc, [out: ~drumsBus]); };
			(beat * 2).wait;
		};
	};
	// Hats
	fork {
		loop {
			[1, 2, 4, 2, 1, 2, 4, 8].do { |speed|
				speed.do {
					s.bind { Synth(\hat, [out: ~drumsBus, rel: rrand(0.03, 0.05)]); };
					(beat / speed).wait;
				}
			}
		};
	};
	// MidBass
	fork {
		var note, dur;
		loop {
			[
				// bar 1 ///////////////////////////////////
				(interval: 0, length: 1, bend: 0),
				(interval: 7, length: 1/2, bend: -12),
				(interval: 7, length: 1/2, bend: 0),
				(interval: 6, length: 1, bend: -6),
				(interval: 1, length: 1, bend: 0),
				// bar 2 ///////////////////////////////////
				(interval: 0, length: 1, bend: 6),
				(interval: 7, length: 1/2, bend: -12),
				(interval: 7, length: 1/2, bend: 0),
				(interval: 6, length: 1/2, bend: -6),
				(interval: 8, length: 1/2, bend: 0),
				(interval: 1, length: 1, bend: 0),
				// bar 3 ///////////////////////////////////
				(interval: 0, length: 1/2, bend: 0),
				(interval: 1, length: 1/2, bend: -6),
				(interval: 7, length: 1, bend: -6),
				(interval: 6, length: 1, bend: -6),
				(interval: 1, length: 1, bend: 0),
				// bar 4 ///////////////////////////////////
				(interval: 0, length: 1, bend: 6),
				(interval: 7, length: 1/2, bend: -12),
				(interval: 7, length: 1/2, bend: 0),
				(interval: 6, length: 1/2, bend: -6),
				(interval: 8, length: 1/2, bend: 0),
				(interval: 1, length: 1, bend: 0),
			].do { |item|
				note = (root + item[\interval] + (12 * 0 )).midicps;
				dur = beat * item[\length];
				s.bind { Synth(\pulseBass, [freq: note, duration: dur, bend: item[\bend], out: ~sidechainBus]) };
				dur.wait;
			};
		};
	};
}).play;
)


s.makeWindow;
