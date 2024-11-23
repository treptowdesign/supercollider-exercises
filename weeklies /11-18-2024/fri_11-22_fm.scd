

(
SynthDef(\fmSynth, {
	var freq, car, mod;
	freq = \freq.kr(440);
	mod = SinOsc.ar(freq * \modRatio.kr(1), 0, \modAmp.kr(1000));
	car = SinOsc.ar(freq + mod);
	car = car * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, car * -10.dbamp ! 2);
}).add;
)

Synth(\fmSynth, [freq: 440, modRatio: 1, modAmp: 1000]);


(
SynthDef(\fmSynthG, {
	var freq, car, mod, amp, env;
	freq = \freq.kr(440);
	amp = \amp.kr(-10.dbamp);
	env = EnvGen.ar(Env.perc(0.001, 0.6), \gate.kr(1), doneAction: Done.freeSelf);
	mod = SinOsc.ar(freq * \modRatio.kr(1), \modPhase.kr(0), freq * \modAmp.kr(1));
	car = SinOsc.ar(freq * \carRatio.kr(1) + mod);
	car = LeakDC.ar(car);
	Out.ar(0, car * env * amp ! 2);
}).add;
)

Synth(\fmSynthG, [freq: 220, carRatio: 1, modRatio: 1, modAmp: 10]);

Synth(\fmSynthG, [freq: 50, carRatio: 1, modRatio: 1, modAmp: 10]);
Synth(\fmSynthG, [freq: 220, carRatio: 1, modRatio: 1, modAmp: 8]);

(
SynthDef(\fmSynthFeedback, {
	var freq, car, mod, amp, env, modFeedback;
	freq = \freq.kr(440);
	amp = \amp.kr(-10.dbamp);
	env = EnvGen.ar(Env.perc(0.001, \rel.kr(1)), \gate.kr(1), doneAction: Done.freeSelf);
	modFeedback = LocalIn.ar(1);
	mod = SinOsc.ar((freq * \modRatio.kr(1)) + (modFeedback * \fbAmt.kr(0)), \modPhase.kr(0), freq * \modAmp.kr(1));
	LocalOut.ar(mod);
	car = SinOsc.ar(freq * \carRatio.kr(1) + mod);
	car = LeakDC.ar(car);
	Out.ar(0, car * env * amp ! 2);
}).add;
)

Synth(\fmSynthFeedback, [freq: 220, carRatio: 1, modRatio: 6, modAmp: 2, fbAmt: 0.1]);


(
var s, root, scale, beat;
s = Server.default;
root = 58;
scale = Scale.lydian.degrees;
beat = 60 / 110;
Routine({
	var note, dur;
	loop {
		s.bind {
			dur = beat / [2, 4].choose;
			note = (root + scale.choose + (12 * [0, 1, 2].choose)).midicps;
			Synth(\fmSynthFeedback, [freq: note, carRatio: 1, modRatio: 7, modAmp: 3, fbAmt: 0.3, rel: dur]);
		};
		dur.wait;
	};
}).play;
)


