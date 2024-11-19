// Monday 11-18-2024


(
SynthDef(\pulseBass, {
	var snd, env;
	env = Env.perc(0.01, 0.5).ar(Done.freeSelf);
	snd = Pulse.ar(60);
	snd = snd * env;
	snd = snd + ((snd * 8.dbamp).tanh * -8.dbamp);
	snd = RLPF.ar(snd, env.range(80, 2000), 0.2);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)