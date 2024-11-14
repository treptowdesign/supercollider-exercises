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
	Out.ar(out, snd ! 2);
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
	snd = Saw.ar(freq * LFNoise2.kr(0.5, detune).midiratio);
	snd = BPF.ar(snd, cf, rq);
	snd = snd * env * amp;
	Out.ar(out, snd ! 2);
}).add;
)

(
8.do {
	Synth(
		\bpfSaw,
		[
			freq: (Scale.lydian.degrees + ([4,5,6].choose * 12)).midicps.choose,
			atk: 0.1,
			rel: 1,
			amp: 0.25,
			cf: exprand(200, 5000),
			rq: exprand(0.01, 0.5),
			detune: 3
		]
	);
};
)

// Noise on filter

(
SynthDef(\bpfSaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=440, detune=0.2, cfMin=500, cfMax=2000, rqMin=0.1, rqMax=0.2,
	pan=0, amp=1, out=0;
	var snd, env;
	env = EnvGen.kr(Env([0,1,1,0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	snd = Saw.ar(freq * LFNoise1.kr(0.5, detune).midiratio);
	snd = BPF.ar(
		snd,
		LFNoise1.kr(0.2).exprange(cfMin, cfMax),
		LFNoise1.kr(0.2).exprange(rqMin, rqMax),
	);
	snd = Pan2.ar(snd, pan);
	snd = snd * env * amp;
	Out.ar(out, snd);
}).add;
)

(
10.do {
	var freq=50;
	Synth(
		\bpfSaw,
		[
			freq: freq,
			amp: 0.3,
			atk: 0.01,
			cfMin: freq * 2,
			cfMax: freq * 50,
			rqMin: 0.8,
			rqMax: 1,
			pan: rrand(-1, 1)
		]
	);
};
)

(
10.do {
	var freq=50;
	Synth(
		\bpfSaw,
		[
			freq: freq,
			amp: 3,
			atk: 0.01,
			cfMin: freq * 2,
			cfMax: freq * 50,
			rqMin: 0.005,
			rqMax: 0.03,
			pan: rrand(-1, 1)
		]
	);
};
)

// Stereo Noise

(
SynthDef(\bpfSaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=440, detune=0.2, cfMin=500, cfMax=2000, rqMin=0.1, rqMax=0.2,
	pan=0, amp=1, out=0;
	var snd, env;
	env = EnvGen.kr(Env([0,1,1,0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	snd = Saw.ar(freq * { LFNoise1.kr(0.5, detune).midiratio} ! 2);
	snd = BPF.ar(
		snd,
		{ LFNoise1.kr(0.2).exprange(cfMin, cfMax) } ! 2,
		{ LFNoise1.kr(0.2).exprange(rqMin, rqMax) } ! 2,
	);
	snd = Balance2.ar(snd[0], snd[1], pan);
	snd = snd * env * amp;
	Out.ar(out, snd);
}).add;
)

(
10.do {
	var freq=50;
	Synth(
		\bpfSaw,
		[
			freq: freq,
			amp: 1.35,
			atk: 0.01,
			cfMin: freq * 2,
			cfMax: freq * 50,
			rqMin: 0.005,
			rqMax: 0.03,
			pan: rrand(-1, 1)
		]
	);
};
)

(
10.do {
	var freq=50;
	Synth(
		\bpfSaw,
		[
			freq: freq,
			amp: 0.3,
			atk: 0.01,
			cfMin: freq * 2,
			cfMax: freq * 50,
			rqMin: 0.8,
			rqMax: 1,
			pan: rrand(-1, 1)
		]
	);
};
)





















// endfile...
