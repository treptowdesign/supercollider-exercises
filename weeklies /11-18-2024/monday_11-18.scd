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
	freq = \freq.kr(60) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).kr;
	snd = Pulse.ar(freq, 0.5);
	snd = RLPF.ar(snd, env.exprange(freq, freq * 60), 0.2);
	snd = snd * env * Env.linen(0, \duration.kr(1), 0.1).kr(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -8.dbamp);
}).add;
)

(
var s, root, scale, beat;
s = Server.default;
root = 32;
scale = Scale.dorian.degrees;
beat = 60 / 110;

Routine({
	var note, dur;
	loop {
		dur = beat / [1, 2, 4].choose;
		note = (root + scale.choose + (12 * 0)).midicps;
		s.bind { Synth(\pulseBass, [freq: note, duration: dur, bend: [0, 6, -6].choose]) };
		dur.wait;
	};
}).play;

)
