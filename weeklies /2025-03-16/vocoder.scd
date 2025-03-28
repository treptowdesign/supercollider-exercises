///////////////////////////////////////////////////////////
// Vocoder
///////////////////////////////////////////////////////////


(
SynthDef(\vocoderSynth, {
	arg freq=220, amp=0.4, gate=1, modRate=0.3;
	var carrier, modulator, formants, env, mod;

	// Carrier oscillator: rich saw wave
	carrier = Saw.ar(freq);

	// Modulator: noise modulated slowly (emulating vocal modulation)
	modulator = LFNoise1.kr(modRate).range(0.8, 1.2);

	// Vocoder-style formant frequencies (classic "robot" vowel formants)
	formants = [600, 900, 2200, 3000, 4200]; // typical vocoder band centers

	// Formant filtering with noise-based modulation
	carrier = Mix(formants.collect { |formantFreq|
		BPF.ar(carrier, formantFreq * modulator, 0.1)
	});

	// Envelope shaping
	env = EnvGen.kr(
		Env.adsr(attackTime:1.5, decayTime:0.5, sustainLevel:0.8, releaseTime:2.0),
		gate,
		doneAction:2
	);

	Out.ar(0, (carrier * env * amp * 5).tanh ! 2);
}).add;
)


(
Pbind(
	\instrument, \vocoderSynth,
	\degree, Pseq([[0,2,4],[-3,0,2],[2,4,7],[0,3,5]], inf),
	\scale, Scale.minor,
	\octave, 4,
	\dur, 6,
	\modRate, 0.1, // slow modulation
	\amp, 0.3,
	\legato, 1.2
).play;
)

(
Pbind(
	\instrument, \vocoderSynth,
	\degree, Pseq([0,2,4,5,4,2,0,Rest()], inf),
	\scale, Scale.minorPentatonic,
	\octave, 5,
	\dur, 0.4,
	\modRate, 1.5, // faster modulation for more expressive lead
	\amp, 0.4,
	\legato, 0.9
).play;
)

