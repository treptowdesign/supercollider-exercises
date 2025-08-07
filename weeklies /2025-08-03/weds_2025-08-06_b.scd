


(
SynthDef(\hum, {
	var snd;
	snd = {SinOsc.ar(ExpRand(300, 3000), Rand(0.0, pi), 0.03)} ! 50;
	snd = snd.sum;
	snd = snd * EnvGen.kr(Env([0, 1, 0], [2, 2], [1, -1]), doneAction: 2);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)


////////////////////////////////////////////////////////////////////////////
// Saw Version...

(
SynthDef(\bpfSaw, {
	var snd, freq, env;
	freq = \freq.kr(440) * LFNoise1.kr(0.5 ! 2, \detune.kr(0.3)).midiratio;
	env = EnvGen.kr(
		Env(
			[0, 1, 0.8, 0],
			[\atk.kr(0.1), \sus.kr(0.2), \rel.kr(3)],
			[1, 0, -1]
		),
		doneAction: 2
	);
	snd = Saw.ar(freq);
	snd = BPF.ar(
		snd,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(0.1, 0.6)
		).exprange(\cfmin.kr(500), \cfmax.kr(2000))} ! 2,
		{LFNoise1.kr(0.1).exprange(\rqmin.kr(0.1), \rqmax.kr(0.2)) } ! 2,
	);
	snd = snd * env;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(1) * 4.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)

{LFNoise1.kr(4).exprange(0.1, 0.6)}.plot(8); // plot...

(
[0, 3 + 12, -5, 10].do { |int|
	var freq = (51 + int + (12 * 0)).midicps;
	Synth(\bpfSaw, [freq: freq, cfmin: 100, cfmax: 1600, detune: 0.1]);
};
)

(
10.do {
	Synth(
		\bpfSaw,
		[
			freq: 20,
			amp: 0.5,
			detune: 1,
			cfmin: 20*40,
			cfmax: 20*50
		]
	);
};
)




////////////////////////////////////////////////////////////////////////////
// Saw Unison Version...

(
SynthDef(\bpfSawUnison, {
	var snd, freq, env;
	freq = \freq.kr(440);
	env = EnvGen.kr(
		Env(
			[0, 1, 0.8, 0],
			[\atk.kr(0.1), \sus.kr(0.2), \rel.kr(3)],
			[1, 0, -1]
		),
		doneAction: 2
	);
	// snd = LFSaw.ar(freq * LFNoise1.kr(0.5 ! 6, \detune.kr(0.3)).midiratio, Rand(0.0, pi)).sum * -10.dbamp;
	snd = LFSaw.ar(freq * LFNoise1.kr(0.5 ! 12, \detune.kr(0.3)).midiratio, Rand(0.0, pi));
	snd = Splay.ar(snd) * 0.dbamp;
	snd = BPF.ar(
		snd,
		{LFNoise2.kr(
			LFNoise2.kr(4).exprange(0.1, 0.8)
		).exprange(\cfmin.kr(500), \cfmax.kr(2000))} ! 2,
		{LFNoise2.kr(0.1).exprange(\rqmin.kr(0.1), \rqmax.kr(0.2)) } ! 2,
	);
	snd = snd * env;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(1) * 4.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)

{LFNoise1.kr(4).exprange(0.1, 0.6)}.plot(8); // plot...

(
[0, 3, 7, 10, 17].do { |int|
	var freq = (51 + int + (12 * 1)).midicps;
	Synth(\bpfSawUnison, [freq: freq, cfmin: 100, cfmax: 1600, detune: 0.3]);
	freq = (51 + int + (12 * 0)).midicps;
	Synth(\bpfSawUnison, [freq: freq, cfmin: 100, cfmax: 1600, detune: 0.3]);
};
)





////////////////////////////////////////////////////////////////////////////
// FM Version...

(
SynthDef(\bpfFm, {
	var snd, freq, env;
	freq = \freq.kr(440) * LFNoise1.kr(0.5 ! 2, \detune.kr(0.3)).midiratio;
	env = EnvGen.kr(
		Env(
			[0, 1, 0.8, 0],
			[\atk.kr(0.1), \sus.kr(0.2), \rel.kr(3)],
			[1, 0, -1]
		),
		doneAction: 2
	);
	// snd = SinOsc.ar(freq * [1, 2, 4]) * [300, 800, 1600];
	// snd = SinOsc.ar(freq + snd).sum * -6.dbamp ! 2;

	snd = (SinOsc.ar(freq * [1, 9]) * ([800, 1500] * LFNoise2.ar(8, 5).midiratio)).mean;
	snd = SinOsc.ar(freq + snd) * -6.dbamp ! 2;

	snd = BPF.ar(
		snd,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(0.1, 0.8)
		).exprange(\cfmin.kr(500), \cfmax.kr(2000))} ! 2,
		{LFNoise1.kr(0.1).exprange(\rqmin.kr(0.1), \rqmax.kr(0.2)) } ! 2,
	);
	snd = snd * env * LFTri.ar(XLine.kr(9, 4, 1)).unipolar;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(1) * 0.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
[0, 3, 7, 10, 17].do { |int|
	var freq = (51 + int + (12 * 0)).midicps;
	Synth(\bpfFm, [freq: freq, cfmin: 100, cfmax: 1500, detune: 0.1]);
};
)


{(1200 * LFNoise2.ar(8, 5).midiratio)}.plot(1);


{(SinOsc.ar(440 * [1, 9]) * ([1500, 600] * LFNoise2.ar(8, 5).midiratio)).mean}.plot(1);




////////////////////////////////////////////////////////////////////////////
// FM Version...
(
SynthDef(\sqrLead, {
	var snd, freq, env;
	env = EnvGen.kr(
		Env(
			[0, 1, 0.8, 0],
			[\atk.kr(0.01), \sus.kr(0.5), \rel.kr(0.1)],
			[1, 0, -1]
		),
		doneAction: 2
	);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq);
	snd = (snd * 10).tanh;
	// snd = snd + CombC.ar(snd, 0.2, LFNoise2.ar(8).range(0, 1e-3), 0);
	snd = MoogFF.ar(snd, freq * (1 + (4 * Env.perc(0, 3).ar)), 2);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.8));
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\phaseDist, {
	var snd, freq;
	freq = \freq.kr(660);
	snd = SinOsc.ar(freq, SinOsc.ar(freq * 4) * 0.6 * Env.perc(0.1, 0.2).ar);
	snd = (snd * 4).tanh + ((snd * 10).clip2 * -2.dbamp);
	// snd = RLPF.ar(snd, SinOsc.ar(8).exprange(2000, 2500), 0.2);
	snd = snd * -18.dbamp;
	// snd = snd + DelayC.ar(snd, 0.2, Amplitude.ar(snd, 0.05, 0.05) * 0.005);
	// snd = snd + CombC.ar(snd, 0.2, LFNoise2.ar(8).range(0, 1e-3), 0);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
var s, beat, bar, root, play;
s = Server.default;
beat = 60 / 128;
bar = beat * 4;
root = 51;
play = { |synth, duration, args|
	s.bind {
		Synth(synth, [duration: duration] ++ args);
	};
	duration.wait;
};
Routine({
	loop {
		[
			[0, bar/3],
			[3, bar/3],
			[-5, bar/3],
			[2, bar/3],
			[5, bar/3],
			[-2, bar/3],
			[-5, beat],
			[7, beat],
			[0, bar],
		].do { |spec|
			var int, dur;
			# int, dur = spec;
			play.(\phaseDist, dur, [freq: (root + int + (12 * 2)).midicps])
		};
	};
}).play;

)



//////////////////////////////////////////////////////////

55 * 5;
110 * 5;
220 * 5;
440 * 5;
660 * 5;


(
SynthDef(\phaseDist, {
	var snd, freq;
	freq = \freq.kr(660);
	snd = SinOsc.ar(freq, SinOsc.ar(freq * 4) * 0.6);

	5.do {
		snd = (snd * 4).tanh;
		snd = LPF.ar(snd, freq * 5);
	};

	snd = snd * -10.dbamp;

	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\phaseDist, {
	var snd, freq;
	freq = \freq.kr(330);
	snd = SinOsc.ar(freq, SinOsc.ar(freq * 4) * 0.6);
	// snd = (snd * 4).tanh + ((snd * 10).clip2 * -2.dbamp);
	/*snd = snd + 0.1;
	snd = (snd * 4).tanh;
	snd = LeakDC.ar(snd);
	snd = LPF.ar(snd, 4000);*/
	// snd = RLPF.ar(snd, SinOsc.ar(8).exprange(2000, 2500), 0.2);
	snd = snd * -10.dbamp;
	// snd = snd + DelayC.ar(snd, 0.2, Amplitude.ar(snd, 0.05, 0.05) * 0.005);
	// snd = snd + CombC.ar(snd, 0.2, LFNoise2.ar(8).range(0, 1e-3), 0);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)





// endfile... 