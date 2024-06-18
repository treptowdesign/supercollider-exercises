(
SynthDef(\wub, { |freq=110|
	var snd, mod;
	mod = Line.kr(0, 1, 0.8);
	snd = SinOsc.ar(
		freq * [1, 2, 3, 5, 7, 11],
		[0, pi/4, 0, pi/2, 0, 0],
		[1, 0.5, mod * 0.5, mod, mod, mod]
	).sum;
	snd = MoogFF.ar(snd, XLine.kr(40, 1200, 0.6), 1.8) * 8.dbamp;
	snd = (snd * 2.dbamp).tanh;
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

