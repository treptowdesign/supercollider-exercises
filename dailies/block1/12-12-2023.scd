////////////////////////////////////////////
// Sandbox for 12/12/2023
////////////////////////////////////////////

// Using ControlName syntax for args
(
SynthDef(\inst, {
	arg t_gate=1;
	var sig, amp=0.5, freq=\freq.kr(440), ampEnv;
	ampEnv = EnvGen.kr(
		Env(
			[0, 1, 0.05, 0],
			[0.1, 2.9, 0.5], // total 3.5
			[2, 1, -2]
		),
		gate: t_gate,
		doneAction: 2
	);
	freq = freq.lag(1); // pitch slide
	sig = Pulse.ar(freq) * ampEnv * amp; // source mod by ampEnv
	Out.ar(0, sig ! 2); // dup 2 channel (l/r) and send out
}).add;
)

x = Synth(\inst, [\freq, 35.midicps]);
x.set(\freq, 30.midicps, \t_gate, 1); //change freq and retrig
x.set(\freq, 32.midicps, \t_gate, 1); //change freq and retrig




// detune mult voices, mix/splay to two channels
// add a filter (lp/bp) and filt env
// tremolo w/ env
// mix in some filtered/env noise (grainy texture)