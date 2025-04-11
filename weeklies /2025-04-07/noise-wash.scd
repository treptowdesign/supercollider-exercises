(
SynthDef(\basicWash, {
	var snd, duration, n;
	n = 20;
	duration = \duration.kr(10);
	snd = { WhiteNoise.ar } ! 2;
	snd = BPF.ar([snd], ((0..n) ** 0.8).normalize.linexp(0, 1, 500, 8000), 0.03);
	snd = snd * (0..n) / n;
	snd = snd.sum;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\basicWash, {
	var snd, duration, n;
	n = 30;
	duration = \duration.kr(10);
	snd = { WhiteNoise.ar } ! 2;
	snd = BPF.ar([snd], ((0..n) ** 0.8).normalize.linexp(0, 1, 50, 10000), 0.01);
	snd = snd * (0..n) / n;
	snd = snd.sum;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)