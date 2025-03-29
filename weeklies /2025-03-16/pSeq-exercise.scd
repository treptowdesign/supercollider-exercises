(
SynthDef(\simpleSynth, { |atk=0.01,rel=0.6,freq=440, amp=0.5|
	var osc, snd, env;
	osc = Pulse.ar(freq, 0.5);
	env = Env.perc(atk, rel, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(osc * env, 0, amp);
	Out.ar(0, snd);
}).add;
)

(
~beat = 0.5;
)

(
~beat = 0.5;
Pbind(
	\instrument, \simpleSynth,
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 1], inf) * ~beat,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], inf), // random from the set
	\scale, Scale.phrygian,
	\root, 0,
	\octave, 2,
	\amp, 0.2
).play;
)

(
~beat = 0.5;
Pbind(
	\instrument, \simpleSynth,
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 1], inf) * ~beat * 2,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], inf), // random from the set
	\scale, Scale.aeolian,
	\root, 0,
	\octave, 3,
	\amp, 0.2
).play;
)

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// Named Defs
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

(
Pdef(\phraseA, Pbind(
	\instrument, \simpleSynth,
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 1], inf) * ~beat / 4,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\scale, Scale.phrygian,
	\root, 0,
	\octave, 3,
	\amp, 0.2
));
Pdef(\phraseB, Pbind(
	\instrument, \simpleSynth,
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 1], inf) * ~beat * 4,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\scale, Scale.ionian,
	\root, 0,
	\octave, 2,
	\amp, 0.2
));
Pdef(\phraseC, Pbind(
	\instrument, \simpleSynth,
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 1], inf) * ~beat,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\scale, Scale.lydian,
	\root, 0,
	\octave, 2,
	\amp, 0.2
));
)


// in sequence
(
Pdef(\switcher, Pseq([
	Pfindur(4 * ~beat, Pdef(\phraseA)),
	Pfindur(4 * ~beat, Pdef(\phraseB)),
	Pfindur(4 * ~beat, Pdef(\phraseC)),
], inf)).play;
)

// in random
(
Pdef(\switcher, Prand([
	Pfindur(4 * ~beat, Pdef(\phraseA)),
	Pfindur(4 * ~beat, Pdef(\phraseB)),
	Pfindur(4 * ~beat, Pdef(\phraseC)),
], inf)).play;
)

// in random (no repeats)
(
Pdef(\switcher, Pxrand([
	Pfindur(4 * ~beat, Pdef(\phraseA)),
	Pfindur(4 * ~beat, Pdef(\phraseB)),
	Pfindur(4 * ~beat, Pdef(\phraseC)),
], inf)).play;
)

// in weighted random
(
Pdef(\switcher, Pwrand([
	Pfindur(4 * ~beat, Pdef(\phraseA)),
	Pfindur(4 * ~beat, Pdef(\phraseB)),
	Pfindur(4 * ~beat, Pdef(\phraseC)),
], [0.5, 0.2, 0.3], inf)).play; // probabilities: A 50%, B 20%, C 30%
)


