(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		60
		* (1 + (3 * Env.perc(0.001, 0.01).ar))
		* (1 + (2 * Env.perc(0.01, 0.1).ar))
	);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)