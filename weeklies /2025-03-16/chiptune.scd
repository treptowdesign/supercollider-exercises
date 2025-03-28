///////////////////////////////////////////////////////////
// Chiptune
///////////////////////////////////////////////////////////


(
SynthDef(\chipLead, {
	arg freq=440, amp=0.4, gate=1, pulseWidth=0.5, vibRate=6, vibDepth=0.01;
	var osc, env, vibrato;

	// Vibrato modulation (expressive)
	vibrato = SinOsc.kr(vibRate, 0, vibDepth, 1);

	// Pulse wave oscillator (classic NES/Game Boy lead sound)
	osc = Pulse.ar(freq * vibrato, pulseWidth);

	// Short envelope
	env = EnvGen.kr(
		Env.adsr(attackTime:0.001, decayTime:0.15, sustainLevel:0.7, releaseTime:0.1),
		gate,
		doneAction:2
	);

	Out.ar(0, osc * env * amp ! 2);
}).add;
)


(
Pbind(
	\instrument, \chipLead,
	\degree, Pseq([0,2,4,7,9,7,4,2], inf),
	\scale, Scale.majorPentatonic,
	\octave, 5,
	\dur, 0.15,
	\amp, 0.4,
	\pulseWidth, 0.25 // thinner sound for NES authenticity
).play;
)

(
SynthDef(\chipBass, {
	arg freq=110, amp=0.5, gate=1, pulseWidth=0.5;
	var osc, env;

	// Square/pulse oscillator (typical NES/Game Boy bass)
	osc = Pulse.ar(freq, pulseWidth);

	// Short, percussive bass envelope
	env = EnvGen.kr(
		Env.perc(attackTime:0.001, releaseTime:0.25),
		gate,
		doneAction:2
	);

	Out.ar(0, osc * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \chipBass,
	\degree, Pseq([0,Rest(),0,-2,-3,-5,-7,Rest()], inf),
	\scale, Scale.minor,
	\octave, 3,
	\dur, 0.2,
	\amp, 0.5,
	\pulseWidth, 0.5 // classic square-wave sound
).play;
)
