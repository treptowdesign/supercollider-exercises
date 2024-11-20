// Monday 11-18-2024

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (5 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -12.dbamp];
	snd[1] = snd[1] * Env.perc(0, 3).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 4).ar;
	snd = snd ! 2;
	snd = snd * \amp.kr(-10).dbamp;
	snd = snd * (1 + (4 * Env.perc(0, 0.02).ar));
	snd = (snd * 2.5.dbamp).tanh;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1520, 0.3) * 26.dbamp;
	snd = snd + snd.tanh;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.14], curve: -12).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0) * -18.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(34 * [1, 2.23, 3.45, 5.7, 7.8]).sum;
	snd = FreqShift.ar(snd, 41.2);
	snd = snd + (Hasher.ar(Sweep.ar) * -8.dbamp);
	snd = snd * Env.perc(0.005, \rel.kr(0.02)).ar;
	snd = BPF.ar(snd, 7923 * [1, 1.5] * XLine.ar(1, 1.3, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 5000);
	snd = snd * \amp.kr(-8).dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 0.1, [44e-3, 23e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pulseBass, {
	var snd, env, freq;
	freq = \freq.kr(60) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).kr;
	snd = Pulse.ar(freq, 0.5);
	snd = RLPF.ar(snd, env.exprange(freq, freq * 28), 0.5);
	snd = snd * env * Env.linen(0, \duration.kr(1), 0.1).kr(Done.freeSelf);
	snd = LowShelf.ar(snd, 140, 0.5, -4);
	Out.ar(\out.kr(0), Pan2.ar(snd, 0) * -12.dbamp);
}).add;
SynthDef(\sidechain, {
	var snd, fb, scTrig;
	scTrig = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.7 * Env.perc(0.005, 0.2, curve: 4).ar(gate: scTrig)));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~sidechainBus = Bus.audio(nil, 2);
)

~sidechainBus.index;

(
var s, root, scale, beat, sidechainFx;
s = Server.default;
root = 32;
scale = Scale.phrygian.degrees;
beat = 60 / 110;

sidechainFx = Synth(\sidechain, [in: ~sidechainBus]);

Routine({
	fork {
		loop {
			// bar
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 3)]); };
			(beat * 3).wait;
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 1), amp: -16]); };
			(beat * 1).wait;
			// bar
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 4)]); };
			(beat * 4).wait;
			// bar
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 0.5)]); };
			(beat * 0.5).wait;
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 0.5), amp: -16]); };
			(beat * 0.5).wait;
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 3)]); };
			(beat * 3).wait;
			// bar
			s.bind { sidechainFx.set(\trigger, 1) };
			s.bind { Synth(\kick, [freq: root.midicps, duration: (beat * 4)]); };
			(beat * 4).wait;
		};
	};
	fork {
		loop {
			(beat * 2).wait;
			s.bind { Synth(\clap); };
			(beat * 2).wait;
		};
	};
	fork {
		loop {
			[1, 2, 4, 2, 1, 2, 4, 8].do { |speed|
				speed.do {
					s.bind { Synth(\hat); };
					(beat / speed).wait;
				}
			}
		};
	};
	fork {
		var note, dur;
		loop {
			[
				// bar
				(interval: 0, length: 1, bend: 0),
				(interval: 7, length: 1/2, bend: -12),
				(interval: 7, length: 1/2, bend: 0),
				(interval: 6, length: 1, bend: -6),
				(interval: 1, length: 1, bend: 0),
				// bar
				(interval: 0, length: 1, bend: 6),
				(interval: 7, length: 1/2, bend: -12),
				(interval: 7, length: 1/2, bend: 0),
				(interval: 6, length: 1/2, bend: -6),
				(interval: 8, length: 1/2, bend: 0),
				(interval: 1, length: 1, bend: 0),
				// bar
				(interval: 0, length: 1/2, bend: 0),
				(interval: 1, length: 1/2, bend: -6),
				(interval: 7, length: 1, bend: -6),
				(interval: 6, length: 1, bend: -6),
				(interval: 1, length: 1, bend: 0),
				// bar
				(interval: 0, length: 1, bend: 6),
				(interval: 7, length: 1/2, bend: -12),
				(interval: 7, length: 1/2, bend: 0),
				(interval: 6, length: 1/2, bend: -6),
				(interval: 8, length: 1/2, bend: 0),
				(interval: 1, length: 1, bend: 0),
			].do { |item|
				note = (root + item[\interval] + (12 * 0)).midicps;
				dur = beat * item[\length];
				s.bind { Synth(\pulseBass, [freq: note, duration: dur, bend: item[\bend], out: ~sidechainBus]) };
				dur.wait;
			};
		};
	};


}).play;
)
