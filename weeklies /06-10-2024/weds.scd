(
SynthDef(\sinBass, {
	var snd;
	snd = SinOsc.ar(
		60 * [1, 2, 3, 7],
		[0, pi/2, pi/4, 0],
		[1, 0.8, 0.5, 0.3]);
	snd = snd.sum;
	snd = (snd * 1.dbamp).tanh * 0.dbamp;
	snd = snd * Env.linen(0, 1, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0));
}).play;
)