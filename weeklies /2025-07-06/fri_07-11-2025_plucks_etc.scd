(
SynthDef(\plkTst, {
	var snd, exciter, trigger, freq;
	freq = \freq.kr(60);
	trigger = Impulse.ar(0);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 60, 1000)
	) * Env.perc(0.0, 0.01).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / (freq), 30.0, 0.9);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 60, 1000)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0), 4.dbamp * \amp.kr(1));
	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 60, 1000)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0), 4.dbamp * \amp.kr(1));


	// snd = BRF.ar(snd, freq * 2, 0.1);

	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)
