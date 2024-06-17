(
SynthDef(\wub, { |freq=110|
	var snd, mod;
	mod = Line.kr(0, 1, 0.8);
	snd = SinOsc.ar(
		freq * [1, 2, 4, 5, 6],
		[0, pi/2, 0, pi, 0],
		[1, 0.5, mod * 0.5, mod, mod]
	);
	snd = snd.sum;
	snd = MoogFF.ar(snd, XLine.kr(60, 1200, 0.6), 2.6) * 5.dbamp;
	snd = (snd * 0.dbamp).tanh;
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)