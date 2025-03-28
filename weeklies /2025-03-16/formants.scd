///////////////////////////////////////////////////////////
// Formant Lead
///////////////////////////////////////////////////////////

(
SynthDef(\formantLead, {
	arg freq=440, amp=0.4, gate=1, vibRate=6, vibDepth=0.005, formantPos=0;
	var osc, formants, env, vibrato, vowel;

	// Basic oscillator (rich sawtooth wave)
	osc = Saw.ar(freq);

	// Vibrato for expressive pitch movement
	vibrato = SinOsc.kr(vibRate, 0, vibDepth, 1);
	osc = Saw.ar(freq * vibrato);

	// Define vowels (a, e, i, o, u) formant frequencies
	vowel = Select.kr(formantPos, [
		[800, 1150, 2900],   // "a"
		[400, 1700, 2600],   // "e"
		[350, 2000, 2800],   // "i"
		[450, 800, 2830],    // "o"
		[325, 700, 2530]     // "u"
	]);

	// Apply formant filtering (three resonant peaks)
	formants = Mix(
		BPF.ar(osc, vowel, 0.1)
	);

	// Expressive amplitude envelope
	env = EnvGen.kr(
		Env.adsr(attackTime:0.05, decayTime:0.2, sustainLevel:0.8, releaseTime:0.5),
		gate,
		doneAction:2
	);

	Out.ar(0, (formants * env * amp * 10).tanh ! 2);
}).add;
)

(
Pbind(
	\instrument, \formantLead,
	\degree, Pseq([0,2,4,5,4,2], inf),
	\scale, Scale.minorPentatonic,
	\octave, 5,
	\dur, 0.5,
	\formantPos, Pseq([0,1,2,3,4,3,2,1], inf), // cycling through vowels "a e i o u"
	\amp, 0.1,
	\legato, 0.9
).play;
)