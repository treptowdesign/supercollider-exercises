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
	freq = \freq.kr(440) * ([-0.04, 0, 0.05].midiratio * ({ LFNoise2.ar(0.5) * 0.1 } ! 3).midiratio);
	snd = LFNoise2.ar(3200, Decay2.ar(Impulse.ar(0, 0, 0.08), 0.008, 0.1));
	snd = CombL.ar(snd, 1/freq, 1/freq, \rel.kr(6));
	snd = snd.sum * -10.dbamp;
	snd = FreeVerb.ar(snd, 0.4, 0.6, 0.8);
	snd = snd * Env.linen(0, \duration.kr(6), 0.1).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd ! 2);
}).play;
)


[-0.04, 0, 0.05].midiratio
[-0.04, 0, 0.05].midiratio * (rrand(-0.3, 0.3) ! 3).midiratio;
[-0.04, 0, 0.05].midiratio * (rrand(-0.01, 0.01) ! 3).midiratio
[-0.04, 0, 0.05].midiratio

(
Synth(\simplePiano, [freq: (36 + 0 + (12 * 3)).midicps, rel: 3]);
Synth(\simplePiano, [freq: (36 + 4 + (12 * 3)).midicps, rel: 3]);
Synth(\simplePiano, [freq: (36 + 7 + (12 * 3)).midicps, rel: 3]);
Synth(\simplePiano, [freq: (36 + 11 + (12 * 3)).midicps, rel: 3]);
)


( // Routine for chord progression
var s, root, scale, beat;
s = Server.default;
root = 36;
scale = Scale.lydian.degrees;
beat = 60 / 110;
Routine({
	var dur;
	loop {
		[
			(intervals: 0 + [0, 4, 7, 11], length: 2),
			(intervals: 7 + [0, 4, 7, 10], length: 2),
			(intervals: 9 + [0, 3, 7, 10], length: 2),
			(intervals: 5 + [0, 4, 7, 11], length: 2),
		].do { |chord|
			chord[\intervals].do { |interval|
				dur = beat * chord[\length];
				s.bind {
					Synth(\simplePiano,
						[freq: (root + interval + (12 * 2)).midicps, duration: dur]
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
		octave = 12 * [1, 2, 3, 4].choose;
		note = (root + scale.choose + octave).midicps;
		s.bind { Synth(\simplePiano, [freq: note]); };
		dur.wait;
	}
}).play;
)


