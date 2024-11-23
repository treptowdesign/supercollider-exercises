(
// synthetic piano patch (James McCartney) ALTERED
var n;
n = 7;	// number of keys playing
play({
	Mix.ar(Array.fill(n, {	// mix an array of notes
		var delayTime, pitch, detune, strike, hammerEnv, hammer;
		// calculate delay based on a random note
		pitch = (36 + 54.rand);
		strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
		hammerEnv = Decay2.ar(strike, 0.008, 0.08); // excitation envelope
		Pan2.ar(
			// array of 3 strings per note
			Mix.ar(Array.fill(3, { arg i;
				// detune strings, calculate delay time :
				detune = #[-0.07, 0, 0.08].at(i);
				delayTime = 1 / (pitch + detune).midicps;
				// each string gets own exciter :
				hammer = LFNoise2.ar(3000, hammerEnv); // 3000 Hz was chosen by ear..
				CombL.ar(
					hammer,		// used as a string resonator
					delayTime, 		// max delay time
					delayTime,			// actual delay time
					6 // decay time of string
				)
			})),
			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right
		)
	}))
})
)

(
SynthDef(\simplePiano, {
	var freq, snd;
	freq = \freq.kr(440) * ([-0.04, 0, 0.05].midiratio * ({ LFNoise2.ar(Rand(2.0, 8.0)) * 0.1 } ! 3).midiratio);
	snd = LFNoise2.ar(3000, Decay2.ar(Impulse.ar(0, 0, 0.08), 0.008, 0.1));
	snd = CombL.ar(snd, 1/freq, 1/freq, \rel.kr(6));
	snd = snd.sum * -18.dbamp;
	// snd = snd + GVerb.ar(snd, 10, 5, 0.92);
	snd = snd * Env.linen(0, \duration.kr(6), 0.1).ar(Done.freeSelf);
	snd = DelayN.ar(snd, 0.2, \delay.kr(0));
	snd = LeakDC.ar(snd ! 2);
	Out.ar(0, snd);
}).add;
)

[-0.04, 0, 0.05].midiratio;
[-0.04, 0, 0.05].midiratio * (rrand(-0.3, 0.3) ! 3).midiratio;
[-0.04, 0, 0.05].midiratio * (rrand(-0.01, 0.01) ! 3).midiratio;
[-0.04, 0, 0.05].midiratio;

(
Synth(\simplePiano, [freq: (36 + 0 + (12 * 3)).midicps, rel: 6]);
Synth(\simplePiano, [freq: (36 + 3 + (12 * 3)).midicps, rel: 6]);
Synth(\simplePiano, [freq: (36 + 7 + (12 * 3)).midicps, rel: 6]);
Synth(\simplePiano, [freq: (36 + 10 + (12 * 3)).midicps, rel: 6]);
)

(
Synth(\simplePiano, [freq: (36 + 0 + (12 * 3)).midicps, rel: 6]);
Synth(\simplePiano, [freq: (36 + 4 + (12 * 3)).midicps, rel: 6]);
Synth(\simplePiano, [freq: (36 + 7 + (12 * 3)).midicps, rel: 6]);
Synth(\simplePiano, [freq: (36 + 11 + (12 * 3)).midicps, rel: 6]);
)


( // Routine for chord progression
var s, root, beat;
s = Server.default;
root = 36;
beat = 60 / 110;
Routine({
	var dur;
	loop {
		[
			(intervals: 0 + [0, 4, 7, 11], length: 2), // I
			(intervals: 7 + [0, 4, 7, 10], length: 2), // V
			(intervals: 9 + [0, 3, 7, 10], length: 2), // vi
			(intervals: 5 + [0, 4, 7, 11], length: 2), // IV
		].do { |chord|
			chord[\intervals].do { |interval|
				dur = beat * chord[\length];
				s.bind {
					Synth(\simplePiano,
						[
							freq: (root + interval + (12 * 2)).midicps,
							duration: dur,
							rel: 4.0,
							delay: rrand(0, 0.02)
						]
					);
				};
			};
			dur.wait;
		};
	}
}).play;
)

( // Routine for chord progression
var s, root, beat;
s = Server.default;
root = 36; // MIDI note for root of progression
beat = 60 / 110; // Tempo in beats per minute
Routine({
	var dur;
	loop {
		[
			(intervals: 2 + [0, 3, 7, 10], length: 2), // ii
			(intervals: 7 + [0, 4, 7, 10], length: 2), // V
			(intervals: 0 + [0, 4, 7, 11], length: 2), // I
			(intervals: 9 + [0, 3, 7, 10], length: 2), // vi
		].do { |chord|
			chord[\intervals].do { |interval|
				dur = beat * chord[\length];
				s.bind {
					Synth(\simplePiano,
						[
							freq: (root + interval + (12 * 2)).midicps,
							duration: dur,
							rel: rrand(5.0, 7.0),
							delay: rrand(0, 0.05)
						]
					);
				};
			};
			dur.wait;
		};
	}
}).play;
)


( // Routine for chord progression
var s, root, beat;
s = Server.default;
root = 36; // MIDI note for root of progression
beat = 60 / 110; // Tempo in beats per minute
Routine({
	var dur;
	loop {
		[
			(intervals: 0 + [0, 4, 7, 11], length: 2), // I
			(intervals: 5 + [0, 4, 7, 11], length: 2), // IV
			(intervals: 7 + [0, 4, 7, 10], length: 2), // V
			(intervals: 0 + [0, 4, 7, 11], length: 2), // I
		].do { |chord|
			chord[\intervals].do { |interval|
				dur = beat * chord[\length];
				s.bind {
					Synth(\simplePiano,
						[
							freq: (root + interval + (12 * 2)).midicps,
							duration: dur,
							rel: rrand(5.0, 7.0),
							delay: rrand(0, 0.05)
						]
					);
				};
			};
			dur.wait;
		};
	}
}).play;
)

( // Routine for chord progression
var s, root, beat;
s = Server.default;
root = 36; // MIDI note for root of progression
beat = 60 / 110; // Tempo in beats per minute
Routine({
	var dur;
	loop {
		[
			(intervals: 9 + [0, 3, 7, 10], length: 2), // vi
			(intervals: 5 + [0, 4, 7, 11], length: 2), // IV
			(intervals: 0 + [0, 4, 7, 11], length: 2), // I
			(intervals: 7 + [0, 4, 7, 10], length: 2), // V
		].do { |chord|
			chord[\intervals].do { |interval|
				dur = beat * chord[\length];
				s.bind {
					Synth(\simplePiano,
						[
							freq: (root + interval + (12 * 2)).midicps,
							duration: dur,
							rel: rrand(5.0, 7.0),
							delay: rrand(0, 0.05)
						]
					);
				};
			};
			dur.wait;
		};
	}
}).play;
)







( // Routine for random scale degrees
var s, root, scale, beat;
s = Server.default;
root = 36;
scale = Scale.lydian.degrees;
beat = 60 / 110;
Routine({
	var dur, note, octave, rel;
	loop {
		dur = beat / [1, 2, 4].choose;
		octave = 12 * [0, 1, 2, 3, 4].choose;
		note = (root + scale.choose + octave).midicps;
		s.bind { Synth(\simplePiano, [freq: note]); };
		dur.wait;
	}
}).play;
)

( // Routine for chord progression
var s, root, beat;
s = Server.default;
root = 36;
beat = 60 / 110;
Routine({
	var dur;
	loop {
		[
			(intervals: 2 + [0, 4, 7, 11], length: 2), // II
			(intervals: 7 + [0, 4, 7, 11], length: 2), // V
			(intervals: 0 + [0, 4, 7, 11], length: 4), // I
		].do { |chord|
			chord[\intervals].do { |interval|
				dur = beat * chord[\length];
				s.bind {
					Synth(\simplePiano,
						[
							freq: (root + interval + (12 * 2)).midicps,
							duration: dur,
							rel: rrand(5.0, 7.0),
							delay: rrand(0, 0.05)
						]
					);
				};
			};
			dur.wait;
		};
	}
}).play;
)



Here is a list of intervals I use to make chords in SuperCollider - is this list correct? and how would you label the 9ths, 11ths and 13ths?

// Key
0: Root
1: minor 2nd
2: major 2nd
3: minor 3rd
4: major 3rd
5: perfect 4th
6: tritone (aug 4th or dim 5th)
7: perfect 5th
8: minor 6th
9: major 6th
10: minor 7th
11: major 7th

12: Octave
13: minor 9th
14: maj 9th
15: aug 9th ?
16: perfect 11th
17: aug 11th
19:
20: minor 13th
21: major 13th
22:
23:
24:


