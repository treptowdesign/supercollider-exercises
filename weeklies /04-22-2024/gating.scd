(
SynthDef(\gateSynth, {
	var snd, trigger;
	trigger = \trigger.kr(0);
	snd = Pulse.ar(\freq.kr(440));
	snd = snd * EnvGen.kr(Env([1, 0, 1], [0.001, 0.05], ['lin', 4]), trigger, doneAction: 0);
	Out.ar(0, snd ! 2);
}).add;
)

~gateSynth = Synth(\gateSynth);

~gateSynth.set(\trigger, 1); // trigger duck
~gateSynth.set(\trigger, 0); // reset

(

)