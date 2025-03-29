(
SynthDef(\simpleSynth, { |freq=440, amp=0.5|
	var osc, snd, env;
	osc = Pulse.ar(freq, 0.5);
	env = Env.perc(0.01, 0.6).ar(Done.freeSelf);
	snd = Pan2.ar(osc * env, 0, amp);
	Out.ar(0, snd);
}).add;
)

(
Pbind(
	\instrument, \simpleSynth,
	\dur, 0.25,
	\degree, Pseq([0,1,2,3,4,5,6,7], inf),
	\scale, Scale.phrygian,
	\octave, Pseq([2,3,4], inf),
).play
)

