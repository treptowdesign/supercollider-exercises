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
SynthDef(\basicWashB, {
	var snd, duration, n;
	n = 20;
	duration = \duration.kr(10);
	snd = { WhiteNoise.ar } ! 2;
	snd = BPF.ar([snd], ((0..n) ** 0.8).normalize.linexp(0, 1, 50, 10000), 0.01) * -5.dbamp;
	snd = snd * (0..n) / n;
	snd = snd.sum;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\brownWash, {
	var snd, duration, n;
	n = 10;
	duration = \duration.kr(10);
	snd = { BrownNoise.ar } ! 2;
	snd = BPF.ar([snd], ((0..n) ** 1.2).normalize.linexp(0, 1, 40, 400), 0.03);
	snd = snd * (0..n) / n;
	snd = snd.sum;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\pinkWash, {
	var snd, duration, n;
	n = 10;
	duration = \duration.kr(10);
	snd = { PinkNoise.ar } ! 2;
	snd = BPF.ar([snd], ((0..n) ** 0.5).normalize.linexp(0, 1, 100, 2000), 0.01) * 10.dbamp;
	snd = snd * (0..n) / n;
	snd = snd.sum;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\glitterWash, {
	var snd;
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
	snd = BPF.ar(snd, 9200, 0.3);
	3.do { snd = HPF.ar(snd, 8000); };
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hiss, {
	var snd;
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 50, 0.3);
	snd = BPF.ar(snd, [10120, 14230] * XLine.kr(0.5, 1, 2), 0.3).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.5, 0.3, 0.03, 1], curve: [4, 0.1, -4]).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\rumble, {
	var snd;
	snd = SinOsc.ar(70 * (LFNoise2.kr(1 ! 16) * 10).midiratio);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 300, 3, 0.8);
	snd = (snd * 4.dbamp).tanh;
	snd = LPF.ar(snd, 300) + HPF.ar(snd, 3000);
	snd = snd * Env.perc(1.0, 1, curve: 8).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)