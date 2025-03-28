
// Berlin School Arpeggio
(
SynthDef(\berlinArp, {
	arg freq=440, amp=0.3, gate=1, cutoff=1500, res=0.3;
	var osc, filt, env;

	// Saw oscillator (classic analog-style)
	osc = Saw.ar(freq);

	// Resonant low-pass filtering
	filt = RLPF.ar(osc, cutoff.clip(400, 5000), res.linlin(0,1,0.1,0.9));

	// Short envelope for rhythmic articulation
	env = EnvGen.kr(
		Env.adsr(attackTime:0.005, decayTime:0.1, sustainLevel:0.6, releaseTime:0.1),
		gate,
		doneAction:2
	);

	Out.ar(0, filt * env * amp ! 2);
}).add;
)

(
// Define a repeating, hypnotic sequence
Pbind(
	\instrument, \berlinArp,
	\degree, Pseq([0, 2, 3, 5, 7, 5, 3, 2], inf),  // cyclic minor/modal pattern
	\scale, Scale.dorian,
	\octave, Pseq([4,5], inf), // octave shifts typical of Berlin style
	\dur, 0.15, // fast-paced, driving rhythm
	\cutoff, Pseg([800, 3000, 800], [10, 10], \exp, inf), // slow evolving filter
	\amp, 0.3
).play;
)

// Simple Delay effect to enhance the rhythmic feel
(
~arp = SynthDef(\berlinDelay, {
	arg delayTime=0.3, feedback=0.3;
	var sig = In.ar(0, 2);
	var delayed = CombC.ar(sig, delayTime, delayTime, feedback, 1, sig);
	ReplaceOut.ar(0, delayed);
}).play(addAction: \addToTail);
)

// Techno Arps

(
SynthDef(\technoArp, {
	arg freq=440, amp=0.3, gate=1, cutoff=2000, res=0.3;
	var osc, filt, env;

	// Saw oscillator for bright clarity
	osc = Saw.ar(freq);

	// Resonant low-pass filter
	filt = RLPF.ar(osc, cutoff.clip(400,5000), res.linlin(0,1,0.1,0.9));

	// Short envelope for rhythmic articulation
	env = EnvGen.kr(
		Env.adsr(attackTime:0.001, decayTime:0.1, sustainLevel:0.6, releaseTime:0.1),
		gate,
		doneAction:2
	);

	Out.ar(0, filt * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \technoArp,
	\degree, Pseq([0,4,7,12,7,4], inf), // Common trance-style octave chord arp
	\scale, Scale.minor,
	\octave, 3,
	\dur, 0.125, // 16th notes for rhythmic drive
	\cutoff, Pseg([1200,4000,1200], [8,8], \exp, inf), // evolving filter sweep
	\amp, 0.3
).play;
)

(
// Rhythmic stereo delay
SynthDef(\rhythmicDelay, {
	arg delayTime=0.3, feedback=0.35;
	var sig = In.ar(0, 2);
	var delayed = CombC.ar(sig, delayTime, delayTime, feedback);
	ReplaceOut.ar(0, (sig + delayed).tanh);
}).play(addAction:\addToTail);
)

