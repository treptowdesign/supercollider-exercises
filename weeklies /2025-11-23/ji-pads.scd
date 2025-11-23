(
SynthDef(\pad, {
	var snd, freq, duration, env, lfo;
	duration = \duration.kr(3);
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 2) / 2)).fold2;
	};
	// env = Env.linen(0.001, duration, 0.1).ar(Done.freeSelf);
	env = Env.asr(0.001, 1, 5, curve: \sin).ar(Done.freeSelf, \gate.kr(1));
	freq = \freq.kr(440) * (LFNoise2.ar(20) * 0.1).midiratio;
	freq = freq * [1, 2, 1, 2, 2, 1, 2, 1];
	freq = freq * (({ lfo.(8) } ! freq.size) * 0.2).midiratio;
	snd = SinOsc.ar(freq);
	snd = snd * [0, -10, 0, -10, -10, 0, -10, 0].dbamp;
	snd = snd * (1 + ({ lfo.(5) } ! snd.size));
	snd = Splay.ar(snd);
	snd = snd + BPF.ar({ PinkNoise.ar } ! 2, freq * 2, 0.1);
	snd = snd + Latch.ar(snd * -25.dbamp, Impulse.ar(ExpRand(4e3, 16e3)));
	snd = snd * -18.dbamp;
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var freqs;
freqs = (50 + 0 + [0, 16, 19, 23]).midicps;
)

( // Midi
(50 + 0 + [0, 16, 19, 23]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(var freqs;
freqs = (50.midicps * [1, 5/4 * 2, 3/2 * 2, 15/8 * 2 ]);
)

( // Just Intonation
var root = 50.midicps;
(root * [1, 5/4 * 2, 3/2 * 2, 15/8 * 2 ]).do { |int|
	Synth(\pad, [freq: (int)]);
};
)










(
(50 + 5 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
(50 + 7 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
(50 + -5 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
(50 + -2 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)













(
SynthDef(\pad2, {
	var snd, freq, duration, env, lfo;
	duration = \duration.kr(3);
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 2) / 2)).fold2;
	};
	// env =  Env.linen(0.001, duration, 0.1).ar(Done.freeSelf);
	env = Env.asr(0.001, 1, 5, curve: \sin).ar(Done.freeSelf, \gate.kr(1));
	freq = \freq.kr(440);
	freq = freq * [1, 2, 1, 3, 4, 1, 2, 1];
	freq = freq * (({ lfo.(8) } ! freq.size) * 0.2).midiratio;
	snd = LFTri.ar(freq);
	snd = snd * [0, -10, 0, -15, -19, 0, -10, 0].dbamp;
	snd = snd * (1 + ({ lfo.(5) } ! snd.size));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 800);
	snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(1 / 4.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	snd = snd * -23.dbamp;
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
(50 + [0, 15, 19, 22]).do { |int|
	Synth(\pad2, [freq: (int).midicps]);
};
)

(
SynthDef(\bass, {
	var snd, freq, lfo;
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 3) / 3)).fold2;
	};
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * [-0.1, 0.1].midiratio, lfo.(4).linlin(-1, 1, 0.4, 0.6));
	snd = snd * -15.dbamp;
	snd = RLPF.ar(snd, LFNoise2.kr(0.5).linexp(-1, 1, 100, 1000), 0.3);
	snd = LPF.ar(snd, 530);
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
~bass = Synth(\bass, [freq: (50-24).midicps]);
)




(
SynthDef(\ping, {
	var snd, freq, fb;
	freq = \freq.kr(440);
	snd = LFTri.ar(freq);
	snd = snd * freq.explin(440, 1000, 0, -10).dbamp.lag(0.01);
	snd = snd ! 2;
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.none, \gate.kr(1));
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), 1432 * [0.95, 1, 1.2], 0.2) * 10.dbamp;
	snd = snd * Env([0, 5, 1, 0], [0.001, 0.01, 0.1]).delay([0.035, 0, 0.014]).ar;
	snd = snd.clip2;
	snd = Splay.ar(snd, 0.5);
	snd = snd + LPF.ar(GVerb.ar(snd.sum * -20.dbamp, 50, 2), 7000);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.13, 0.8);
	snd = snd * -2.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)











// endfile