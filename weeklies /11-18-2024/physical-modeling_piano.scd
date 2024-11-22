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
	freq = \freq.kr(440) * [-0.04, 0, 0.05].midiratio;
	snd = LFNoise2.ar(3400, Decay2.ar(Impulse.ar(0, 0, 0.1), 0.008, 0.08));
	snd = CombL.ar(snd, 1/freq, 1/freq, \rel.kr(6));
	snd = snd.sum;
	Out.ar(0, snd ! 2);
}).add;
)

(
var s, root, scale, beat;
s = Server.default;
root = 36;
scale = Scale.aeolian.degrees;
beat = 60 / 110;
Routine({
	var dur, note, octave, rel;
	loop {
		dur = beat / [1, 2, 4].choose;
		octave = 12 * [1, 2, 3].choose;
		note = (root + scale.choose + octave).midicps;
		s.bind { Synth(\simplePiano, [freq: note]); };
		dur.wait;
	}
}).play;
)


