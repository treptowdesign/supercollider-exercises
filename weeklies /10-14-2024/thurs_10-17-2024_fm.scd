(
SynthDef(\fmOps, {
	var snd, freq, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [3, 5]) * Env.perc(0, [3, 2]).ar * (1 + (5 * Env.perc(0, 0.1).ar));
	snd = SinOsc.ar((freq * [1, 2]) + (50 * snd), 0);
	snd = snd * [0, -10, -25].dbamp;
	snd = snd.sum * -5.dbamp;
	snd = snd * Env.perc(0, 0.6).ar;
	snd = snd * -24.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)


(
SynthDef(\fbPad, {
	var snd, freq, fb, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (LFNoise2.ar(3 ! 8) * 0.2).midiratio * [1, 2, 1, 2, 2, 1, 2, 1], LFNoise2.ar(3 ! 8).linlin(-1, 1, 0.1, 0.9));
	snd = snd * LFNoise2.ar(32 ! snd.size).linlin(-1, 1, 0.5, 1);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, freq * XLine.ar(1, 3, duration));
	snd = snd.tanh;
	snd = snd + DelayC.ar(snd * -8.dbamp, 0.2, SinOsc.ar(Rand(0.1, 0.3), [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 0.1e-3);
	snd = snd * freq.explin(100, 1000, 0, -10).dbamp;
	snd = snd * -20.dbamp;


	snd = snd * Env.linen(duration * 0.1, duration * 0.8, duration * 0.1, curve: \sin).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\fbPad, {
	var snd, freq, fb, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (LFNoise2.ar(3 ! 8) * 0.2).midiratio * [1, 2, 1, 2, 2, 1, 2, 1], LFNoise2.ar(3 ! 8).linlin(-1, 1, 0.1, 0.9));
	snd = snd * LFNoise2.ar(32 ! snd.size).linlin(-1, 1, 0.5, 1);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, freq * XLine.ar(1, 3, duration));
	snd = snd.tanh;
	snd = snd + DelayC.ar(snd * -8.dbamp, 0.2, SinOsc.ar(Rand(0.1, 0.3), [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 0.1e-3);
	snd = snd * freq.explin(100, 1000, 0, -10).dbamp;
	snd = snd * -20.dbamp;
	snd = snd * Env.linen(duration * 0.1, duration * 0.8, duration * 0.1, curve: \sin).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)