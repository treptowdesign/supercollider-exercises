// Harmonic Series


100 * (1..16)

(2 ** (1..5))

(1..5).linlin(1, 5, 1.0, 0.2);

(
SynthDef(\harmonicsOctaves, {
	var freq, partials, snd;
	partials = (2 ** (1..4));
	freq = \freq.kr(160) * ([1] ++ partials) * ({LFNoise1.kr(2.0.rand) * 0.2} ! 5).midiratio;
	snd = SinOsc.ar(freq) * (1..5).linlin(1, 5, 1.0, 0.005);
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 10).ar(Done.freeSelf);
	snd = snd * 0.3 ! 2;
	Out.ar(0, snd)
}).play;
)


(100) * (2 ** (1..5));


(2 ** (1..4))


[1] ++ [ 2.0, 4.0, 8.0, 16.0, 32.0 ]


(
SynthDef(\harmonics, {
	var freq, partials, snd;
	partials = (1..10);
	freq = \freq.kr(180) * partials * ({LFNoise1.kr(1.0.rand) * 0.3} ! 10).midiratio;
	snd = SinOsc.ar(freq) * (1..10).linlin(1, 10, 1.0, 0.05);
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 10).ar(Done.freeSelf);
	snd = snd * 0.1 ! 2;
	Out.ar(0, snd)
}).play;
)



