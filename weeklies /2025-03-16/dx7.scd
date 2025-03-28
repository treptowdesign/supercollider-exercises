///////////////////////////////////////////////////////////
// FM DX7
///////////////////////////////////////////////////////////

// Two Operators (Simple Carrier-Modulator)
(
SynthDef(\fm2op, {
	arg freq=220, amp=0.3, modRatio=2, modIndex=5, gate=1;
	var mod, car, env;

	// Modulator
	mod = SinOsc.ar(freq * modRatio, 0, freq * modIndex);

	// Carrier modulated by modulator
	car = SinOsc.ar(freq + mod);

	env = EnvGen.kr(Env.adsr(0.01,0.2,0.7,0.3), gate, doneAction:2);

	Out.ar(0, car * env * amp ! 2);
}).play;
)

// Three Operators in Series (Stacked FM)

(
SynthDef(\fm3opSeries, {
	arg freq=220, amp=0.3, modRatio1=2, modRatio2=3, modIndex1=4, modIndex2=2, gate=1;
	var op3, op2, op1, env;

	op3 = SinOsc.ar(freq * modRatio2, 0, freq * modIndex2);
	op2 = SinOsc.ar(freq * modRatio1 + op3, 0, freq * modIndex1);
	op1 = SinOsc.ar(freq + op2);

	env = EnvGen.kr(Env.adsr(0.01,0.2,0.7,0.3), gate, doneAction:2);

	Out.ar(0, op1 * env * amp ! 2);
}).play;
)
Synth(\fm3opSeries, [\freq, 110, \modRatio1, 2, \modRatio2, 3, \modIndex1, 5, \modIndex2, 2]);


// Three Operators (One Modulator, Two Carriers in Parallel)
(
SynthDef(\fm3opParallel, {
	arg freq=220, amp=0.3, modRatio=2, modIndex=3, gate=1;
	var mod, car1, car2, env;

	mod = SinOsc.ar(freq * modRatio, 0, freq * modIndex);

	car1 = SinOsc.ar(freq + mod);
	car2 = SinOsc.ar((freq * 1.5) + mod); // a harmonic interval carrier

	env = EnvGen.kr(Env.adsr(0.01,0.2,0.7,0.3), gate, doneAction:2);

	Out.ar(0, Mix([car1, car2]) * env * amp ! 2);
}).play;
)

// Feedback in FM Synthesis
(
SynthDef(\fmFeedback, {
	arg freq=220, amp=0.3, modIndex=2, feedbackAmt=0.8, gate=1;
	var fb, osc, env;

	// LocalIn/LocalOut create a feedback loop
	fb = LocalIn.ar(1);

	// Operator modulates itself via feedback
	osc = SinOsc.ar(freq + (fb * feedbackAmt * freq * modIndex));

	// Envelope
	env = EnvGen.kr(Env.adsr(0.01,0.2,0.7,0.3), gate, doneAction:2);

	// Send current output back as feedback
	LocalOut.ar(osc);

	Out.ar(0, osc * env * amp ! 2);
}).play;
)

(
Pbind(
	\instrument, \fmFeedback,
	\dur, 0.5,
	\degree, Pseq([0,1,3,5,7],inf),
	\scale, Scale.minorPentatonic,
	\octave, 4,
	\modIndex, 2.5,
	\feedbackAmt, Pseq([0,0.4,0.6,0.8,0.9],inf),
	\amp, 0.3
).play;
)

// Example: Four-operator FM patch, like DX7 Algorithm 5 (two stacked modulators into parallel carriers)
(
SynthDef(\dx7alg5, {
	arg freq=220, amp=0.3, modRatio1=2, modRatio2=3, modIndex1=4, modIndex2=2, gate=1;
	var op4, op3, op2, op1, env;

	op4 = SinOsc.ar(freq * modRatio2, 0, freq * modIndex2);
	op3 = SinOsc.ar(freq * modRatio1 + op4, 0, freq * modIndex1);

	// Two parallel carriers modulated by op3
	op2 = SinOsc.ar(freq + op3);
	op1 = SinOsc.ar((freq * 1.5) + op3);

	env = EnvGen.kr(Env.adsr(0.01,0.2,0.7,0.3), gate, doneAction:2);

	Out.ar(0, Mix([op1, op2]) * env * amp ! 2);
}).add;
)


(
Synth(\dx7alg5, [
	\freq, 110,
	\modRatio1, 2,
	\modRatio2, 3,
	\modIndex1, 4,
	\modIndex2, 2
]);
)

// DX7 "E. PIANO 1" (Classic DX7 Rhodes)
(
SynthDef(\dx7EPiano, {
	arg freq=440, amp=0.4, gate=1;
	var mod1, mod2, car, env;

	// Operator setup similar to DX7 algorithm #5 (two modulators into a carrier)
	mod2 = SinOsc.ar(freq * 14, 0, freq * 2);
	mod1 = SinOsc.ar(freq * 2 + mod2, 0, freq * 3);

	// Carrier
	car = SinOsc.ar(freq + mod1);

	env = EnvGen.kr(
		Env.adsr(0.01, 0.4, 0.3, 1.2),
		gate,
		doneAction:2
	);

	Out.ar(0, car * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \dx7EPiano,
	\dur, 0.75,
	\degree, Pseq([[0,2,4],[3,5,7],[4,6,8],[2,4,6]], inf),
	\scale, Scale.major,
	\octave, 4,
	\amp, 0.5,
	\legato, 0.9
).play;
)

// DX7 "TUBULAR BELLS" (Classic FM Bells)
(
SynthDef(\dx7Bells, {
	arg freq=440, amp=0.4, gate=1;
	var mod, car, env;

	// Bright metallic bell with complex modulator-carrier ratio
	mod = SinOsc.ar(freq * 7, 0, freq * 8);
	car = SinOsc.ar(freq + mod);

	env = EnvGen.kr(
		Env.perc(0.01, 3.5),
		gate,
		doneAction:2
	);

	Out.ar(0, car * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \dx7Bells,
	\degree, Pseq([0,2,4,7,4,2], inf),
	\scale, Scale.majorPentatonic,
	\octave, 5,
	\dur, 0.5,
	\amp, 0.05
).play;
)


// DX7 "LUSH STRINGS" (FM String Ensemble)
(
SynthDef(\dx7Strings, {
	arg freq=440, amp=0.4, gate=1;
	var mod, car, env, chorus;

	// Gentle modulation for lushness
	mod = SinOsc.ar(freq * 2, 0, freq * 0.5);
	car = SinOsc.ar(freq + mod);

	// Envelope for slow attack and long release
	env = EnvGen.kr(
		Env.adsr(attackTime:2, decayTime:1, sustainLevel:0.7, releaseTime:3),
		gate,
		doneAction:2
	);

	// Simple chorus effect
	chorus = Mix.fill(2, { |i|
		DelayC.ar(car, 0.03, SinOsc.kr(0.1 + i*0.05).range(0.015, 0.025))
	});

	Out.ar(0, chorus * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \dx7Strings,
	\degree, Pseq([[0,2,4],[5,7,9],[3,5,7],[4,6,8]], inf),
	\dur, 5,
	\scale, Scale.minor,
	\octave, 5,
	\amp, 0.1,
	\legato, 1.1
).play;
)

// DX7 "FLUTE 1" (FM Flute)
(
SynthDef(\dx7Flute, {
	arg freq=440, amp=0.4, gate=1, breathiness=0.5;
	var mod, noise, car, env, breath;

	// Noise component for breathiness
	noise = WhiteNoise.ar(0.1) * breathiness;

	// Simple modulation for a subtle FM character
	mod = SinOsc.ar(freq * 2, 0, freq * 0.5);

	// Carrier oscillator + modulation
	car = SinOsc.ar(freq + mod) + noise;

	// Envelope resembling flute articulation
	env = EnvGen.kr(
		Env.adsr(attackTime:0.3, decayTime:0.2, sustainLevel:0.7, releaseTime:0.5),
		gate,
		doneAction:2
	);

	// Gentle low-pass filtering to smooth tone
	breath = LPF.ar(car, 4000);

	Out.ar(0, breath * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \dx7Flute,
	\degree, Pseq([0,2,4,5,4,2,0,Rest()], inf),
	\scale, Scale.major,
	\octave, 5,
	\dur, 0.5,
	\amp, 0.1,
	\legato, 0.9
).play;
)

// DX7 "MARIMBA" (FM Marimba)
(
SynthDef(\dx7Marimba, {
	arg freq=440, amp=0.4, gate=1;
	var mod, car, env;

	// Bright, percussive modulator-carrier ratio (wooden character)
	mod = SinOsc.ar(freq * 3, 0, freq * 4);
	car = SinOsc.ar(freq + mod);

	// Percussive envelope (marimba-like attack and decay)
	env = EnvGen.kr(
		Env.perc(attackTime:0.001, releaseTime:1.2),
		gate,
		doneAction:2
	);

	Out.ar(0, car * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \dx7Marimba,
	\degree, Pseq([0, 4, 7, 11, 7, 4], inf),
	\scale, Scale.majorPentatonic,
	\octave, 5,
	\dur, 0.25,
	\amp, 0.1
).play;
)

// DX7 "BASS 1" (FM Synth Bass)

(
SynthDef(\dx7Bass1, {
	arg freq=110, amp=0.5, gate=1;
	var mod1, mod2, car, env;

	// Two modulators stacked for harmonic complexity
	mod2 = SinOsc.ar(freq * 3, 0, freq * 4);
	mod1 = SinOsc.ar(freq * 2 + mod2, 0, freq * 2.5);

	// Carrier with stacked modulators
	car = SinOsc.ar(freq + mod1);

	// Snappy envelope for punchy bass articulation
	env = EnvGen.kr(
		Env.adsr(attackTime:0.01, decayTime:0.2, sustainLevel:0.7, releaseTime:0.3),
		gate,
		doneAction:2
	);

	Out.ar(0, car * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \dx7Bass1,
	\degree, Pseq([0, Rest(), -2, Rest(), -3, Rest(), -2, Rest()], inf),
	\scale, Scale.minor,
	\octave, 3,
	\dur, 0.25,
	\amp, 0.5
).play;
)