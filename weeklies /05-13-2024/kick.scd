(
SynthDef(\blip, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (1 * Env.perc(0, 0.3).ar))
		* (1 + (1 * Env.perc(0, 0.05).ar))
	);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)
