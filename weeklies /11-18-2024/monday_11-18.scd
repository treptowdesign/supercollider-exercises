// Monday 11-18-2024


(
SynthDef(\paramBass, {
	var snd, env;
	env = Env.perc(0.01, 0.3).ar(Done.freeSelf);
	snd = Pulse.ar(80);
	snd = snd * env;
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)