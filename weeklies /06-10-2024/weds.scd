(
SynthDef(\sinBass, {
	var snd;
	snd = SinOsc.ar(
		60 * [1, 3, 4, 6],
		[0, pi/2, 0, pi],
		[1, 0.8, 0.5, 0.3]);
	snd = snd.sum;
	snd = (snd.clip2 * 2.dbamp).tanh * 0.dbamp;
	snd = snd * (1 + (0.5 * Env.perc(0.01, 0.2).ar));
	snd = snd * Env.perc(0, 2).ar;
	snd = snd * Env.linen(0.1, 1, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0));
}).play;
)