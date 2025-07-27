
(
SynthDef(\fmChords, {
	var snd, wet, freq, duration;
	freq = \freq.kr(330) * Line.kr(0.98, 1, 0.1);
	duration = \duration.kr(3);
	snd = SinOsc.ar(freq * [1, 2, 3]) * ([200, 100, 50] * ({LFNoise2.kr(8).range(0.1, 2)} ! 3));
	snd = SinOsc.ar(freq + snd, pi * ({SinOsc.ar(1, Rand(0.0, pi)).range(0.1, 1)} ! 3));
	2.do { snd = HPF.ar(snd, 100); };
	snd = Splay.ar(snd, 1, \amp.kr(1) * -22.dbamp);
	snd = snd * freq.explin(400, 1000, 1, 0.65);
	snd = snd * (3 + Env.perc(0, 0.2).ar);
	snd = snd * Env.perc(0.05, 3).ar;
	snd = snd * Env.linen(0, duration, 0.1).ar.(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, wet, amp;
	amp = \amp.kr(1);
	snd = SinOsc.ar(46 * (1 + (5 * Env.perc(0, 0.1).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	wet = snd + 0.1;
	wet = (wet.clip2 + (wet.fold2 * 0.dbamp)).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.35).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 4620, 0.2) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -20.dbamp, 0.1, 0.015)) ! 2;
	snd = BHiShelf.ar(snd, 600, 0.5, -4);
	snd = BLowShelf.ar(snd, 120, 0.5, 4);
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp * amp;
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1550, 0.1) * 2.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15] * 0.25, curve: -2).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -30.dbamp, 20, 3, 0.7);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp;
	amp = \amp.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 800 * [3.1, 6.4, 4.5, 6.7, 7.8, 9.3, 10.3], 0.2) * 4.dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = (snd * 4).clip2;
	snd = RHPF.ar(snd, 8320, 0.3) * 6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	snd = snd * -16.dbamp * amp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\shaker, {
	var snd, amp;
	amp = \amp.kr(1);
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 50, 0.3);
	snd = BPF.ar(snd, [9120, 14230] * XLine.kr(0.5, 1, 2) * (2 * amp), 0.4).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.1, 0.1, 0.001, 0.01] * 0.4 * amp, curve: [1, 0.5, -4]).ar(Done.freeSelf);
	snd = snd * -30.dbamp * amp;
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, bar, root, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 51; // D#/Eb

play = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
};

Routine({
	loop {
		fork {
			8.do {
				[1, 0.8, 0.7, 0.9, 0.5, 0.6, 0.8, 0.7].do { |amp|
					play.(\shaker, beat/2, [amp: amp]);
					(beat/4).wait;
				}
			};
		};
		fork {
			8.do {
				(beat/2).wait;
				play.(\hat, beat/2, [amp: 0.35, pan: -0.5]);
				(beat/2).wait;
				play.(\hat, beat/2, [amp: 1, pan: 0.5]);
				(beat/2).wait;
				play.(\hat, beat/4, [amp: 0.5, pan: -0.25]);
				(beat/4).wait;
				play.(\hat, beat/4, [amp: 0.5, pan: 0.25]);
				(beat/4).wait;
			};
		};
		fork {
			4.do {
				play.(\kick, beat, [amp: 1]);
				(beat * 1).wait;
				play.(\kick, beat, [amp: 0.8]);
				(beat * 1).wait;
				play.(\clap, beat);
				(beat * 1.5).wait;
				play.(\kick, beat, [amp: 0.6]);
				(beat * 0.5).wait;
			};
		};
		[
			(notes: [0, 3, 7, 17], length: bar),
			(notes: [0, 3, 7, 10], length: bar),
			(notes: [0, 5, 10, 14], length: bar),
			(notes: [0, 3, 8, 15], length: bar)
		].do { |chord|
			var freq;
			chord[\notes].sort.do { |deg|
				freq = (root + deg + (12 * 0)).midicps;
				play.(\fmChords, chord[\length], [freq: freq, amp: 0.75]);
				freq = (root + deg + (12 * 1)).midicps;
				play.(\fmChords, chord[\length], [freq: freq, amp: 0.25]);
			};
			chord[\length].wait;
		};
	};
}).play;
)








{([200, 200, 40] * ({LFNoise2.kr(4).range(0.1, 2)} ! 3))}.plot(2);

{(pi / [1, 2, 3]) * SinOsc.ar(1).range(1, 0.5)}.plot(2);

(
[0, 3, 7, 10, 17, 14, 21].postln.do { |deg|
	Synth(\fmChords, [freq: (51 + deg + (12 * 0)).midicps]);
};
)


(51 + 21 + 12).midicps;

{ SinOsc.ar(220, 0, 0.3) ! 2 }.play;















(
var s, beat, bar, root, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 51; // D#/Eb

play = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
};

Routine({
	loop {
		[
			(notes: 2 + [0, 4, 7], length: bar),
			(notes: 5 + [0, 3, 7], length: bar),
			(notes: 7 + [0, 4, 7], length: bar),
			(notes: 0 + [0, 3, 7], length: bar)
		].do { |chord|
			var freq;
			chord[\notes].sort.do { |deg|
				freq = (root + deg + (12 * 0)).midicps;
				play.(\fmChords, chord[\length], [freq: freq]);
			};
			chord[\length].wait;
		};
	};
}).play;
)


// endfile