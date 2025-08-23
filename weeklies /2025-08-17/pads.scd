////////////////////////////////////////////////////////////////

(
SynthDef(\pad1, {
	var snd, freqs;
	freqs = \freq.kr(260) * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30 ! freqs.size).linlin(-1, 1, 0, 1) * 0.3);
	snd = Splay.ar(snd);
	snd = snd * Env.perc(0.2, 5, curve: -4).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0, 5, 7, 10]).do { |int|
	Synth(\pad1, [freq: (51 + int + (12 * 0)).midicps]);
};
)

(
(-1 + [0, 4, 7, 11]).do { |int|
	Synth(\pad1, [freq: (51 + int + (12 * 0)).midicps]);
};
)

////////////////////////////////////////////////////////////////

(
SynthDef(\pad2, {
	var snd, freqs;
	freqs = \freq.kr(260) * (LFNoise2.ar(60 ! 10) * 0.4).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * (1 + LFNoise2.ar(30).linlin(-1, 1, 0, 1)) * 1);
	snd = RLPF.ar(snd, XLine.ar(500, 100, \duration.kr(1.0) + 2.0) * (ExpRand(1 ! snd.size, 4)) * (LFNoise2.ar(3 ! snd.size) * 12).midiratio, 0.2);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 7000);
	snd = snd * -4.dbamp;
	snd = snd * Env.linen(0.2, \duration.kr(1.0) - 1.5, 1.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0, 3, 7, 10]).do { |int|
	Synth(\pad2, [freq: (51 + int + (12 * 0)).midicps]);
};
)

(
(-1 + [0, 4, 7, 11]).do { |int|
	Synth(\pad2, [freq: (51 + int + (12 * 0)).midicps]);
};
)

////////////////////////////////////////////////////////////////

(
SynthDef(\pad3, {
	var snd, freqs;
	freqs = \freq.kr(260) * (LFNoise2.ar(30 ! 10) * 0.5).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs + (snd * 500), snd * LFNoise2.ar(30).linlin(-1, 1, 0, 1) * 0.3);
	snd = Splay.ar(snd);
	snd = snd * Env.perc(0.2, 5, curve: -4).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0, 3, 7, 10]).do { |int|
	Synth(\pad3, [freq: (51 + int + (12 * 0)).midicps]);
};
)

(
(-1 + [0, 4, 7, 11]).do { |int|
	Synth(\pad3, [freq: (51 + int + (12 * 0)).midicps]);
};
)


////////////////////////////////////////////////////////////////

(
SynthDef(\pad1, {
	var snd, freqs;
	// freqs = (\freq.kr(260).cpsmidi * Line.kr(\bend.kr(-12), 0, 0.3).midiratio).midicps;
	freqs = \freq.kr(260) * Line.kr(\bend.kr(-12), 0, 0.3).midiratio;
	freqs = freqs * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30 ! freqs.size).linlin(-1, 1, 0, 1) * 0.3);
	snd = Splay.ar(snd);
	snd = HPF.ar(snd, 60);
	snd = snd * Env.perc(0.2, 5, curve: -4).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

{(\freq.kr(260).cpsmidi * Line.kr(-7, 0, 0.3).midiratio).midicps}.plot(0.5);
{\freq.kr(260) * Line.kr(-7, 0, 0.3).midiratio}.plot(0.5);


(
(0 + [0, 3, 7, 10]).do { |int|
	Synth(\pad1, [freq: (51 + int + (12 * 0)).midicps]);
};
)

////////////////////////////////////////////////////////////////

(
SynthDef(\pad4, {
	var snd, freqs;
	freqs = \freq.kr(260) * Line.kr(\bend.kr(-7), 0, 0.3).midiratio;
	freqs = freqs * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30 ! freqs.size).linlin(-1, 1, 0, 2pi) * 0.1);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -30.dbamp, 60, 4, 0.8);
	snd = snd * Env.perc(0.02, 4, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0, 3, 7, 10]).do { |int|
	Synth(\pad4, [freq: (51 + int + (12 * 1)).midicps, out: 0]);
	Synth(\pad4, [freq: (51 + int + (12 * 0)).midicps, out: 0]);
};
)

(
(-1 + [0, 4, 7, 11]).do { |int|
	Synth(\pad4, [freq: (51 + int + (12 * 1)).midicps, out: 0]);
	Synth(\pad4, [freq: (51 + int + (12 * 0)).midicps, out: 0]);
};
)


////////////////////////////////////////////////////////////////

(
SynthDef(\pad5, {
	var snd, freqs;
	freqs = \freq.kr(260) * Line.kr(\bend.kr(0), 0, 0.3).midiratio;
	freqs = freqs * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30 ! freqs.size).linlin(-1, 1, 0, 2pi) * 0.1);
	snd = Splay.ar(snd);
	// snd = snd + GVerb.ar(snd.mean * -30.dbamp, 20, 4, 0.8);
	snd = FreqShift.ar(snd, -30);
	snd = snd.blend(CombC.ar(snd, 0.2, 1 / Line.kr(90, 120, 1), 1), 0.5);
	snd = FreqShift.ar(snd, 30);
	snd = snd * Env.perc(0.02, 4, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
(0 + [0, 3, 7, 10]).do { |int|
	Synth(\pad5, [freq: (51 + int + (12 * 1)).midicps, out: 0]);
	// Synth(\pad5, [freq: (51 + int + (12 * 0)).midicps, out: 0]);
};
)






{(LFNoise2.ar(30 ! 4).linlin(-1, 1, 0, 2pi) * 0.1)}.plot(2);










////////////////////////////////////////////////////////////////



