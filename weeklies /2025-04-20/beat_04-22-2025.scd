////////////////////////////////////////////////////////
// Instruments
////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2100), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1600, 0.6) * -3.dbamp;
	snd = LPF.ar(snd, 6200);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.001, 0.01, 0.003, 0.01, 0.003, 0.08, 0.2] * 0.5, curve: -2).ar ** 1.4;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -26.dbamp, 10, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 90);
	snd = BPF.ar(snd, [12240, 6230, 10832, 9830, 8320], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -18.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -26.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var snd, dry, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), 0.5);
	snd = MoogFF.ar(snd, XLine.kr(400, 100, duration * 2), 0);
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 12.dbamp).tanh, 600), 0.2, SinOsc.ar(3, [0, pi]).linlin(-1, 1, 0, 1) * 0.5e-4);
	snd = XFade2.ar(dry, snd, -0.25);
	snd = (snd * 2.dbamp).tanh;
	snd = snd * (0.25 + Env.perc(0.01, duration).ar);
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\padA, {
	var snd;
	snd = (\freq.kr(440) * [0, 1, 2, 3] * \ratio.kr(1)).collect { |freq, index|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio, Rand(0, 2pi)) * LFNoise2.kr(8 ! 2);
		snd = snd * (1 / (index + 1));
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = snd * Env.perc(0.1, 3.0).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -8).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -15.dbamp * \amp.kr(1);
	Out.ar(\out.kr.(0), snd);
}).add;

SynthDef(\brownWash, {
	var snd, duration, n;
	n = 10;
	duration = \duration.kr(10);
	snd = { BrownNoise.ar } ! 2;
	snd = BPF.ar([snd], ((0..n) ** 1.2).normalize.linexp(0, 1, 40, 400), 0.03);
	snd = snd * (0..n) / n;
	snd = snd.sum;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\glitterWash, { |duration=2, amp=1, lfoRate=1|
	var snd, lfo;
	lfo = SinOsc.kr(lfoRate);
	snd = WhiteNoise.ar;
	snd = 10.collect {
		FreqShift.ar(
			CombC.ar(snd * (1 + (0.5 * LFNoise2.kr(7))) * (1 + (0.3 * LFNoise2.kr(30))),
				0.1,
				1 / (ExpRand(500, 1000) * (LFNoise2.kr(3) * 0.3).midiratio),
				1.0
			),
			ExpRand(1000, 5000)
		)
	};
	snd = Splay.ar(snd) * -10.dbamp;
	snd = BPF.ar(snd, lfo.range(8200, 9800), 0.3);
	3.do { snd = HPF.ar(snd, 8000); };
	snd = snd * -23.dbamp * amp;
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.9 * Env.perc(0.001, 0.2, curve: 2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumsFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = (snd + LPF.ar(HPF.ar(GVerb.ar(snd.sum * -40.dbamp, 10, 1), 100), 3000)) * -2.dbamp;
	snd = BLowShelf.ar(snd, 200, 0.3, -4);
	snd = BHiShelf.ar(snd, 3200, 0.3, -4);
	snd = (snd * 10.dbamp).tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 4);
	snd = BHiShelf.ar(snd, 3200, 0.3, 4);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

)

////////////////////////////////////////////////////////
// Bussing
////////////////////////////////////////////////////////

(
~sidechainBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
)
~sidechainBus.index;
~drumsBus.index;

////////////////////////////////////////////////////////
// Baisc Routine
////////////////////////////////////////////////////////


(
var s, bpm, beat, root;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = -2;
Routine({
	var sidechainFx, drumsFx, pump;

	// fx
	drumsFx = Synth.tail(nil, \drumsFx, [in: ~drumsBus, out: 0]);
	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);


	// functions
	pump = {
		s.bind { sidechainFx.set(\trigger, 1) };
	};

	// loops
	/*fork {
		loop {
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(beat/2).wait;
		}
	};*/
	fork {
		loop {
			pump.();
			s.bind { Synth(\kick, [out: ~drumsBus]); };
			((beat * 1.5)).wait;
			pump.();
			s.bind { Synth(\kick, [out: ~drumsBus]); };
			((beat * 0.5)).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			((beat * 1.5) - 0.01).wait;
			((beat * 0.5) + 0.01).wait;
		}
	};
	fork {
		loop {
			Synth(\glitterWash, [amp: 0.3, duration: beat * 4, lfoRate: beat, out: ~sidechainBus]);
			Synth(\brownWash, [amp: 0.2, out: ~sidechainBus]);
			[
				(intervals: (0 + [-12, 2, 7, 10]), length: beat * 2),
				(intervals: (1 + [-12, 4, 7, 11]), length: beat),
				(intervals: (-2 + [-12, 3, 7, 10]), length: beat)
			].do { |chord|
				chord[\intervals].do { |degree|
					var note = (root + (12 * 5) + degree).midicps;
					s.bind{
						Synth(\padA, [freq: note, amp: 1.25, duration: chord[\length], out: ~sidechainBus]);
					};
				};
				chord[\length].wait;
			};

		};
	};
	fork {
		var octave = 3;
		loop {
			[
				// bar 1
				(interval: 0, length: beat * 2, span: 1, amp: 1),
				(interval: 1, length: beat, span: 1, amp: 1),
				(interval: -2, length: beat, span: 1, amp: 1),
			].do{ |note|
				var n = ( root + (12 * octave) + note[\interval]).midicps;
				s.bind {
					Synth(\bass, [freq: n, duration: note[\length] * note[\span], amp: note[\amp], out: 0]);
				};
				note[\length].wait;
			}
		};
	};

}).play;
)