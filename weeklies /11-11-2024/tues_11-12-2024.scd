// Eli Fieldsteel Tutorial
// https://youtu.be/lGs7JOOVjag?si=uzF65UzcwcvINjAN


// Basic Setup
(
SynthDef(\bpfSaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=440, cf=1500, rq=0.2, amp=1, out=0;
	var snd, env;
	env = EnvGen.kr(Env([0,1,1,0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	snd = Saw.ar(freq);
	snd = BPF.ar(snd, cf, rq);
	snd = snd * env * amp;
	Out.ar(out, snd);
}).add;
)

Synth(\bpfSaw, [freq: 110, atk: 0.1]);

(
(1..6).choose.do {
	Synth(
		\bpfSaw,
		[
			freq: (Scale.phrygian.degrees + 60).midicps.choose,
			amp: 0.25,
			cf: exprand(200, 5000),
			rq: exprand(0.01, 0.5)
		]
	);
};
)

// Adding Noise Detune
(
SynthDef(\bpfSaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=440, detune=0.2, cf=1500, rq=0.2, amp=1, out=0;
	var snd, env;
	env = EnvGen.kr(Env([0,1,1,0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	snd = Saw.ar(freq * LFNoise1.kr(0.5, detune).midiratio);
	snd = BPF.ar(snd, cf, rq);
	snd = snd * env * amp;
	Out.ar(out, snd);
}).add;
)

(
10.do {
	Synth(
		\bpfSaw,
		[
			freq: (Scale.lydian.degrees + ([3,4,5,6].choose * 12)).midicps.choose,
			atk: 0.1,
			rel: 1,
			amp: 0.25,
			cf: exprand(200, 5000),
			rq: exprand(0.01, 0.5),
			detune: 0.4
		]
	);
};
)



























// endfile...
