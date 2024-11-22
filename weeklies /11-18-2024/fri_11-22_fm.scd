

(
SynthDef(\fmSynth, {
	var freq, car, mod;
	freq = \freq.kr(440);
	mod = SinOsc.ar(freq * \modRatio.kr(1), 0, \modAmp.kr(1000));
	car = SinOsc.ar(freq + mod);
	car = car * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, car * -10.dbamp ! 2);
}).play;
)

Synth(\fmSynth, [freq: 440, modRatio: 1, modAmp: 1000]);


(
SynthDef(\fmSynthG, {
	var freq, car, mod, amp, env;
	freq = \freq.kr(440);
	amp = \amp.kr(-10.dbamp);
	env = EnvGen.ar(Env.perc(0.001, 0.6), \gate.kr(1), doneAction: Done.freeSelf);
	mod = SinOsc.ar(freq * \modRatio.kr(1), \modPhase.kr(0), \modAmp.kr(1000).clip(0, 2000));
	car = SinOsc.ar(freq * \carRatio.kr(1) + mod);
	Out.ar(0, car * env * amp ! 2);
}).add;
)


Synth(\fmSynthG, [freq: 110, carRatio: 1, modRatio: 1, modAmp: 4000]);