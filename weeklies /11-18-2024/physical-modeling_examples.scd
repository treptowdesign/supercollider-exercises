(
{
    var exciter = WhiteNoise.ar * EnvGen.ar(Env.perc(0.001, 0.1), doneAction: 2); // Exciter: noise burst
    var resonator = Ringz.ar(exciter, 100, 0.2) + Ringz.ar(exciter, 200, 0.2); // Resonator: resonant filters
    resonator * 0.1 // Adjust output volume
}.play;
)

(
{
    var freq = 220; // Frequency of the plucked string
    var decay = 5;  // Decay time in seconds
    var pluck = PinkNoise.ar(Decay2.ar(Impulse.ar(1), 0.001, 0.05)); // Exciter: short noise burst
    var string = CombL.ar(pluck, 1/freq, 1/freq, decay); // Resonator: delay line
    string * 0.1 // Adjust output volume
}.play;
)

(
{
    var freq = 220; // String frequency (A3)
    var bowForce = MouseX.kr(0.1, 1); // Bowing force (adjust with mouse)
    var bowVelocity = SinOsc.kr(0.5).range(0.1, 0.3); // Simulate bow velocity (or use fixed value)
	var exciter = Saw.ar(freq, 0.2) * bowForce * bowVelocity * Env.perc(0.001, 0.6).ar; // Bow interaction
    var resonator = CombL.ar(exciter, 1 / freq, 1 / freq, 4); // String resonance
    resonator * 0.1 ! 2; // Adjust output volume
}.play;
)


(
{
	var strike, env, noise, pitch, delayTime, detune;
	strike = Impulse.ar(0.01);
	env = Decay2.ar(strike, 0.008, 0.04);
	pitch = (36 + 54.rand);

	Pan2.ar(
			// array of 3 strings per note
			Mix.ar(Array.fill(3, { arg i;
				// detune strings, calculate delay time :
				detune = #[-0.05, 0, 0.04].at(i);
				delayTime = 1 / (pitch + detune).midicps;
				// each string gets own exciter :
				noise = LFNoise2.ar(3000, env); // 3000 Hz was chosen by ear..
				CombL.ar(noise,		// used as a string resonator
					delayTime, 		// max delay time
					delayTime,			// actual delay time
					6) 				// decay time of string
			})),
			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right
		)
}.play;
)


(
{
	var strike, env, noise, pitch, delayTime, detune;
	strike = Impulse.ar(0.01);
	env = Decay2.ar(strike, 0.008, 0.04);
	pitch = 69;
	Pan2.ar(
			// array of 3 strings per note
			Mix.ar(Array.fill(3, { arg i;
				// detune strings, calculate delay time :
				detune = #[-0.05, 0, 0.04].at(i);
				delayTime = 1 / (pitch + detune).midicps;
				// each string gets own exciter :
				noise = LFNoise2.ar(3000, env); // 3000 Hz was chosen by ear..
				CombL.ar(noise,		// used as a string resonator
					delayTime, 		// max delay time
					delayTime,			// actual delay time
					6) 				// decay time of string
			})),
			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right
		)
}.play;
)


(
// synthetic piano patch (James McCartney)
var n;
n = 7;	// number of keys playing
play({
	Mix.ar(Array.fill(n, {	// mix an array of notes
		var delayTime, pitch, detune, strike, hammerEnv, hammer;
		// calculate delay based on a random note
		pitch = (36 + 54.rand);
		strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
		hammerEnv = Decay2.ar(strike, 0.008, 0.04); // excitation envelope
		Pan2.ar(
			// array of 3 strings per note
			Mix.ar(Array.fill(3, { arg i;
				// detune strings, calculate delay time :
				detune = #[-0.05, 0, 0.04].at(i);
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

(69 +  [-0.07, 0, 0.08]).midicps


0.midicps;

(
SynthDef(\simplePiano, {
	var freq, snd, detune;
	detune = [-0.07, 0, 0.08];
	freq = \freq.kr(440) + detune;
}).play;
)

(69 + [-0.07, 0, 0.08]).midicps

[-0.07, 0, 0.08].cpsmidi


(
	{Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(4), 440.reciprocal, 440.reciprocal, 10,
		coef:MouseX.kr(-0.999, 0.999))
	}.play(s)
)


