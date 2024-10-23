(
SynthDef(\bass, {
	var freq, dur, snd;
	freq = \freq.kr(60) + SinOsc.ar(16).range(-0.8, 0.8);
	dur = \dur.kr(1);
	snd = SinOsc.ar(freq, 0).cubed.cubed;
	snd = snd + (SinOsc.ar(freq, Env.perc(0.1, dur - 0.3).ar.linlin(0, 1, pi, pi/2)).cubed.cubed * -10.dbamp);
	snd = snd + ((snd * 8.dbamp).clip2 * 8.dbamp).tanh;
	snd = BLowShelf.ar(snd, 100, 0.4, 5);
	snd = LPF.ar(snd, Env.perc(0.2, dur - 0.3).ar.linlin(0, 1, 300, 600)) * 4.dbamp;
	snd = snd * Env.linen(0.1, dur, 0.2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -16.dbamp ! 2);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(52 * (1 + (4 * Env.perc(0.001, 0.03).ar)) * (1 + (0.5 * Env.perc(0.001, 0.4).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.04).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 12328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = (snd.clip2).tanh;
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1280, 0.4) * 25.dbamp;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.3], curve: -12).ar;
	snd = Pan2.ar(snd, 0) * -14.dbamp;
	snd = snd * Env.perc(0.0, 1.0).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(220 * XLine.ar(1.4, 1, 0.005) * [1, 2.4, 5.5]);
	snd = snd * [0, -5, -12].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 830, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1400, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.3 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.aeolian.degrees;
Routine({
	var dur, note;
	dur = beat * 2;
	loop {
		Routine({
			s.bind { Synth(\kick) };
		}).play;
		Routine({
			(dur/2).wait;
			s.bind { Synth(\snare) };
		}).play;
		dur.wait;
	};
}).play;
)














(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.aeolian.degrees;

Routine({
	var dur, note;
	dur = beat * 2;
	loop {
		[0, 0, 1, 0, 0, 0, 12, 0].do { |interval|
			note = (root + interval + (12 * -1)).midicps;
			// s.bind{ Synth(\bass, [dur: dur - 0.2, freq: note]); };
			s.bind{ Synth(\kick); };
			(dur/2).wait;
			s.bind{ Synth(\snare); };
			(dur/2).wait;
		};
	};
}).play;
)





































(
SynthDef(\kick2, {
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
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)