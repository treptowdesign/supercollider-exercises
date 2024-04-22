(1..15).collect { |n| (1 + (n * n * 1e-3)).sqrt }

(
SynthDef(\piano, {
	var snd, freq, n, knock;
	freq = \freq.kr(440);
	n = (1..15);
	snd = [-0.05, 0, 0.05].collect { |detune|
		var snd, freqs;

		freqs = freq * n * (1 + (n * n * 1e-3)).sqrt * detune.midiratio;

		snd = SinOsc.ar(freqs, n.collect { Rand(0, 2pi) });
		snd = snd * Env.perc(snd.collect { Rand(0, 0.001) } * n, 20 * ((260 / freqs) ** 1.4)).ar;
		snd = snd * (1 + (0.5 * (n / Rand(3, 8)).sin));
		snd = snd * (n ** -1.5);
		snd = snd.sum;
		snd;
	};
	snd = snd.sum * -7.dbamp;
	snd = snd * -9.dbamp;
	snd = snd * (1 + (3 * Env.perc(0.0, 0.1).ar));
	snd = snd * Env.perc(0.01, 10.0).ar;

	knock = PinkNoise.ar;
	knock = BPF.ar(knock, freq * [1, 2.3], 0.7).sum * 10.dbamp;
	knock = knock * Env.perc(0.001, 0.06).ar;

	snd = snd + knock;
	snd = BHiShelf.ar(snd, 1230, 0.3, -3);
	snd = (snd * 2.dbamp).tanh;
	snd = BHiShelf.ar(snd, 3230, 0.3, 5);

	snd = snd * -7.dbamp;
	snd = snd * Env.linen(0, \duration.kr(2.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

