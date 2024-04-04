////////////////////////////////////////////////////////
// Distortions: Overdrive, Fuzz and Saturation
////////////////////////////////////////////////////////

s.boot;
s.plotTree;
s.meter;
s.scope;
FreqScope.new;

{SinOsc.ar(440, 0, 0.5) ! 2}.play; // clean signal to compare

(
SynthDef(\overdrive, { |out = 0, drive = 5, wet=0.5, mul=1|
    var signal, processed, mixed;
    // Test signal (freq, phase, mul)
    signal = SinOsc.ar(440, 0, 0.5);
    // Overdrive effect
	processed = (signal * drive).tanh * mul;
	// Mix the dry and wet signals based on the wet parameter
    mixed = Mix.new([signal, processed] * [1 - wet, wet]);
    // Output
    Out.ar(out, mixed ! 2);
}).add;
)

Synth(\overdrive, [\drive, 8, \wet, 1, \mul, 0.5]); // distorted
Synth(\overdrive, [\drive, 1, \wet, 0, \mul, 1]); // clean

(
SynthDef(\fuzz, { |out = 0, fuzzAmount = 5, wet=0.5, mul=1|
    var signal, processed, mixed;
    // Test signal (freq, phase, mul)
    signal = SinOsc.ar(440, 0, 0.5);
    // Fuzz effect
    processed = signal.distort * fuzzAmount * mul;
    // Mix the dry and wet signals based on the wet parameter
    mixed = Mix.new([signal, processed] * [1 - wet, wet]);
    // Output
    Out.ar(out, mixed ! 2);
}).add;
)

Synth(\fuzz, [\fuzzAmount, 15, \wet, 1, \mul, 0.1]); // distorted
Synth(\fuzz, [\fuzzAmount, 1, \wet, 0, \mul, 1]); // clean

(
SynthDef(\saturation, { |out = 0, satAmount = 1, wet=0.5, mul=1|
    var signal, processed, mixed;
    // Test signal (freq, phase, mul)
    signal = SinOsc.ar(440, 0, 0.5);
    // Saturation effect
    processed = (signal * satAmount).softclip * mul;
    // Mix the dry and wet signals based on the wet parameter
    mixed = Mix.new([signal, processed] * [1 - wet, wet]);
    // Output
    Out.ar(out, mixed ! 2);
}).add;
)

Synth(\saturation, [\satAmount, 8, \wet, 1, \mul, 0.5]); // distorted
Synth(\saturation, [\satAmount, 1, \wet, 0, \mul, 1]);  // clean

////////////////////////////////////////////////////////
// FM Synth to run through distortion
////////////////////////////////////////////////////////

(
// FM Source
SynthDef(\fmSynth, {
	arg out=0, freq=500, mRatio=1, cRatio=1, index=1, iScale=5,
	amp=0.2, atk=0.01, rel=3, cAtk=4, cRel=(-4), pan=0;
	var car, mod, env, iEnv;
	// env for index envelope
	iEnv = EnvGen.kr(
		Env.new(
			[index, index * iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	// amp env
	env = EnvGen.kr(
		Env.perc(atk, rel, curve: [cAtk, cRel]),
		doneAction: 2
	);
	mod = SinOsc.ar(freq * mRatio, mul: freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car ! 2);
}).add;

// Distortion Effect
SynthDef(\overdriveEffect, { |in, out = 0, drive = 5, wet=0.5, mul=1|
	var signal, processed, mixed;
	// Input Signal
	signal = In.ar(in, 2); // two channel in
	// Overdrive effect
	processed = (signal * drive).tanh * mul;
	// Mix the dry and wet signals based on the wet parameter
	mixed = Mix.new([signal, processed] * [1 - wet, wet]);
	// Output
	Out.ar(out, mixed);
}).add;
)

// busses
~busFx = Bus.audio(s, 2);
~busFx.index;

Synth(\fmSynth, [\out, 0, \freq, 40.midicps, \cRatio, 10, \mRatio, 4, \rel, 4, \iScale, 5]);

// synths
y = Synth(\overdriveEffect, [\in, ~busFx, \drive, 10, \wet, 1, \mul, 0.25]); // distorted
y.set(\drive, 4, \wet, 1, \mul, 0.5);
y.set(\drive, 1, \wet, 0, \mul, 1); // clean

x = Synth(\fmSynth, [\out, ~busFx, \freq, 40.midicps, \cRatio, 10, \mRatio, 4, \rel, 4, \iScale, 5]);

















////////////////////////////////////////////////////////