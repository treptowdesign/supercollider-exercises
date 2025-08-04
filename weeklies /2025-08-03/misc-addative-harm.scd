

(
SynthDef(\harm, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = SinOsc.ar(
		freq * [1, 2, 2.4, 3, 4.12, 5, 6.02, 8] * (SinOsc.ar(3 ! 8, {Rand(0, pi)} ! 8) * 0.1).midiratio,
		[0, 0.5pi, pi, 0.25pi] * (LFNoise2.ar(8 ! 8) * 5).midiratio,
		[1, 0.1, 0.015, 0.05, 0.005, 0.08, 0.01, 0.03] * (SinOsc.ar(2 ! 8, {Rand(0, pi)} ! 8) * 5).midiratio
	).sum;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.3);
	snd = snd * Env.perc(0.1, 6).ar;
	snd = snd * Env.linen(0, 3, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0, 3, 7, 10].do { |int|
	Synth(\harm, [freq: (51 + int + (12 * 1)).midicps]);
};
)

(
[0, 5, 10, 15, 17].do { |int|
	Synth(\harm, [freq: (51 + int + (12 * 1)).midicps]);
};
)


{(LFNoise2.ar(4 ! 2) * 50).midiratio}.plot(1);