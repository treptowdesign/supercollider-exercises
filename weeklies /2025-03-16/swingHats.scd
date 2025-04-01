~hatBus = Bus.audio(s, 2); // set this bus
~hatBus.index;


(
SynthDef(\kick, {
	arg amp=0.8, freq=60, decay=0.5;
	var env, pitchEnv, osc;
	pitchEnv = EnvGen.kr(Env.perc(0.001, 0.08), levelScale: freq*3, levelBias: freq);
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
	osc = SinOsc.ar(pitchEnv) * env * amp;
	Out.ar(0, osc ! 2);
}).add;
SynthDef(\snare, {
	arg amp=0.5, decay=0.15, lagTime=0;
	var snd, noise, tone, env;
	env = EnvGen.kr(Env.perc(0.005, decay), doneAction:2);
	noise = WhiteNoise.ar() * 0.5;
	tone = SinOsc.ar(130) * 0.4;
	snd = (noise + tone) * env * amp;
	snd = DelayN.ar(snd, lagTime, lagTime);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\clap, { |lagTime=0|
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1610);
	snd = snd * Env([0, 1, 0.1, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = snd * (1 + (1.3 * Env.perc(0.001, 0.12, curve: -8).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 7.dbamp;
	snd = snd * \amp.kr(1);
	snd = DelayN.ar(snd, lagTime, lagTime);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hihat, { |amp=0.3, decay=0.04, out=0|
	var env, noise, hat;
	env = Env.perc(0.001, decay).kr(Done.freeSelf);
	noise = WhiteNoise.ar().pow(2);
	hat = HPF.ar(noise, 7000);
	Out.ar(out, hat * env * amp ! 2);
}).add;
SynthDef(\swingLag, { |inBus=0, lagTime=0|
	var snd, delayed;
	snd = In.ar(inBus, 2);
	delayed = DelayN.ar(snd, lagTime, lagTime);
	snd = snd + delayed;
	snd = FreeVerb.ar(snd, 0.3, 0.2, 0.1);
	Out.ar(0, snd);
	// Out.ar(0, [snd.mean, delayed.mean]);
}).add;
)



(
~beat = 1;
Pbind(
	\instrument, \kick,
	\dur, Pseq([~beat, Rest(~beat), ~beat, Rest(~beat/2), ~beat/2], inf),
	\freq, 60,
	\decay, 0.6,
	\amp, 0.5,
).play;
Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.2
).play;
Pbind(
	\instrument, \clap,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.8,
	\lagTime, 0
).play;
Pbind(
	\instrument, \hihat,
	\dur, ~beat/4,
	\amp, Pseq([0.65, 0.4, 0.55, 0.6], inf),
	// \amp, 0.6,
	\out, ~hatBus
).play;
Synth(\swingLag, [\inBus, ~hatBus, \lagTime, ~beat/7.82]);
)


1/8.5;