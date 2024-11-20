// Monday 11-18-2024

(
SynthDef(\pulseBass, {
	var snd, env, freq;
	freq = \freq.kr(60);
	env = Env.perc(0.01, 1).kr(Done.freeSelf);
	snd = Pulse.ar(freq);
	snd = RLPF.ar(snd, env.range(freq, freq * 30), 0.1);
	snd = snd + ((snd * 8.dbamp).tanh * -8.dbamp);
	snd = snd * env;
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd * -8.dbamp);
}).play;
)

(
SynthDef(\pulseBass, {
	var snd, env, freq;
	freq = \freq.kr(60) * Line.kr(\bend.kr(-12), 0, 0.1).midiratio;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).kr;
	snd = Pulse.ar(freq, 0.5);
	snd = RLPF.ar(snd, env.range(freq, freq * 30), 0.1);
	snd = snd * env * Env.linen(0, \duration.kr(1), 0.1).kr(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -8.dbamp);
}).play;
)
