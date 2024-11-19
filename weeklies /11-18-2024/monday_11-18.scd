// Monday 11-18-2024

(
SynthDef(\pulseBass, {
	var snd, env, freq;
	freq = \freq.kr(60);
	env = Env.perc(0.01, 1).kr(Done.freeSelf);
	snd = Pulse.ar(freq);
	snd = snd * env;
	snd = RLPF.ar(snd, env.range(freq, freq * 30), 0.1);
	snd = snd + ((snd * 8.dbamp).tanh * -8.dbamp);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd * -8.dbamp);
}).play;
)

