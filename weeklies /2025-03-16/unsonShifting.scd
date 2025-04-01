PitchShift
FreqShift

(
SynthDef(\unisonShift, {|freq=440|
	var snd;
	snd = SinOsc.ar(freq);
	// unison here
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0, 0.3);
	Out.ar(0, snd);
}).play;
)

(
SynthDef(\unisonPitchShift, { |freq=440, amp=0.3|
	var base, shifts, env, snd;
	base = SinOsc.ar(freq);
	env = Env.perc(0.001, 2).ar(Done.freeSelf);
	shifts = Mix([
		base,
		PitchShift.ar(base, 0.2, pitchRatio: 0.98),
		PitchShift.ar(base, 0.2, pitchRatio: 1.02),
		PitchShift.ar(base, 0.2, pitchRatio: 0.96),
		PitchShift.ar(base, 0.2, pitchRatio: 1.04),
	]) * 0.2;
	snd = Pan2.ar(shifts * env, 0, amp);
	Out.ar(0, snd);
}).play;
)

(
SynthDef(\unisonFreqShift, { |freq=440, amp=0.3|
	var base, shifts, env, snd;
	base = SinOsc.ar(freq);
	env = Env.perc(0.001, 2).ar(Done.freeSelf);
	shifts = Mix([
		base,
		FreqShift.ar(base, 2),
		FreqShift.ar(base, -2),
		FreqShift.ar(base, 4),
		FreqShift.ar(base, -4),
	]) * 0.2;
	snd = Pan2.ar(shifts * env, 0, amp);
	Out.ar(0, snd);
}).play;
)


(
SynthDef(\unisonPitchShift, { |freq=440, amp=0.4|
	var base, shifts, env, snd;
	base = Pulse.ar(freq);
	env = Env.perc(0.001, 2).ar(Done.freeSelf);
	shifts = Mix([
		base,
		PitchShift.ar(base, 0.2, pitchRatio: 0.98),
		PitchShift.ar(base, 0.2, pitchRatio: 1.02),
		PitchShift.ar(base, 0.2, pitchRatio: 0.96),
		PitchShift.ar(base, 0.2, pitchRatio: 1.04),
	]) * 0.2;
	snd = Splay.ar(shifts * env, 1, amp);
	// snd = Pan2.ar(shifts * env, 0, amp);
	Out.ar(0, snd);
}).play;
)



(
SynthDef(\unisonPitchShift, { |freq=440, amp=0.3|
	var base, shifts, env, snd;
	base = Pulse.ar(freq);
	env = Env.perc(0.001, 2).ar(Done.freeSelf);
	shifts = Mix([
		base,
		PitchShift.ar(base, 0.2, pitchRatio: 0.98 * 0.1.midiratio * SinOsc.ar(Rand(0.01, 0.2), Rand(0, 2pi)) ),
		PitchShift.ar(base, 0.2, pitchRatio: 1.02 * 0.1.midiratio * SinOsc.ar(Rand(0.01, 0.2), Rand(0, 2pi)) ),
		PitchShift.ar(base, 0.2, pitchRatio: 0.96 * 0.1.midiratio * SinOsc.ar(Rand(0.01, 0.2), Rand(0, 2pi)) ),
		PitchShift.ar(base, 0.2, pitchRatio: 1.04 * 0.1.midiratio * SinOsc.ar(Rand(0.01, 0.2), Rand(0, 2pi)) ),
	]) * 0.2;
	snd = Pan2.ar(shifts * env, 0, amp);
	Out.ar(0, snd);
}).play;
)



(
SynthDef(\unisonFreqShift, { |freq=440, amp=0.3|
	var base, shifts, env, snd;
	base = Pulse.ar(freq);
	env = Env.perc(0.001, 2).ar(Done.freeSelf);
	shifts = Mix([
		base,
		FreqShift.ar(base, 2),
		FreqShift.ar(base, -2),
		FreqShift.ar(base, 4),
		FreqShift.ar(base, -4),
	]) * 0.2;
	snd = Pan2.ar(shifts * env, 0, amp);
	Out.ar(0, snd);
}).play;
)


(
SynthDef(\unisonClassic, { |freq=440, amp=0.3, detune=0.01|
	var detunedFreqs, oscArray, env, snd, voices, lfo;
	voices = 4;

	lfo = { |rate=1, phase=0|
		SinOsc.kr(rate, phase).unipolar;
	};

	// Create an array of slightly detuned frequencies centered around `freq`
	detunedFreqs = Array.fill(voices, { |i|
		var detuneAmount = ((i - (voices / 2)) / voices) * detune * lfo.(Rand(0.1, 2.0), Rand(0, 2pi));
		freq * (1 + detuneAmount)
	});

	// Create oscillators for each detuned frequency
	oscArray = detunedFreqs.collect { |f|
		Saw.ar(f)
	};

	// Mix/Splay them down to one signal and scale
	// snd = Mix(oscArray) * (1 / voices);
	snd = Splay.ar(oscArray, 1, (1 / voices));

	// Envelope
	env = Env.perc(0.01, 4).ar(Done.freeSelf);

	snd = Pan2.ar(snd * env * amp, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\unisonClassic, [freq: 440, detune: 0.03]);

(
~beat = 0.5;
Pbind(
	\instrument, \unisonClassic,
	\dur, 1,
	// \scale, Scale.phrygian,
	\scale, Pseq([Scale.phrygian,Scale.dorian,Scale.phrygian,Scale.dorian], inf),
	\degree, Pseq([[0,2,4,6],[5,7,9,11],[-2,0,3,5],[4,6,8,10]], inf),
	\octave, 4,
	\legato, 0.8,
	\amp, 0.2,
	\detune, 0.01
).play;
)

( // Jazz 2-5-1
~beat = 0.5;
Pbind(
	\instrument, \unisonClassic,
	\dur, 1,
	\scale, Scale.phrygian,
	\degree, Pseq([[1,3,5,7],[4,6,8,10],[0,2,4,6],[0,2,4,6]], inf),
	\octave, 4,
	\legato, 0.8,
	\amp, 0.2,
	\detune, 0.03
).play;
)

( // Jazz 2-5-1
~beat = 0.5;
Pbind(
	\instrument, \unisonClassic,
	\dur, 1,
	\scale, Pseq([Scale.phrygian,Scale.dorian,Scale.phrygian,Scale.dorian], inf),
	\degree, Pseq([[1,3,5,7],[4,6,8,10],[0,2,4,6],[0,2,4,6]], inf),
	\octave, 4,
	\legato, 0.8,
	\amp, 0.2,
	\detune, 0.03
).play;
)

(
~beat = 0.5;
Pbind(
	\instrument, \unisonClassic,
	\dur, 1,
	\scale, Scale.dorian,
	\degree, Pseq([[0,2,4,6]], inf),
	\octave, 4,
	\legato, 0.8,
	\amp, 0.2,
	\detune, 0.01
).play;
)



(
Array.fill(5, { |i|
	Array.fill(5, { |j|
		(j + 1) * (i + 1)
	});
});
)

[
	[ 1, 2, 3, 4, 5 ],
	[ 2, 4, 6, 8, 10 ],
	[ 3, 6, 9, 12, 15 ],
	[ 4, 8, 12, 16, 20 ],
	[ 5, 10, 15, 20, 25 ]
]








// end...
