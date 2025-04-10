///////////////////////////////////////////////////////////
// SynthDefs
///////////////////////////////////////////////////////////

(
SynthDef(\basic, {
	|freq=330, atk=0.01, rel=1, pan=0, amp=0.5, cutoff=4e3, vibRate=6, vibDepth=3|
	var snd, env, vibrato;
	env = Env.perc(atk, rel).ar(Done.freeSelf);
	vibrato = SinOsc.kr(vibRate, 0, vibDepth, freq);
	snd = Mix(Pulse.ar(vibrato * [1, 1.006, 1.998], 0.5, [1, 1, 0.3]));
	snd = Pan2.ar(snd * env, pan, amp);
	snd = RLPF.ar(snd, cutoff, 0.8);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(0, snd);
}).add;
)

Synth(\basic, [freq: 440]);

///////////////////////////////////////////////////////////
// Pattern Gen
///////////////////////////////////////////////////////////

(
// Setup
var bpm = 120;
var beat = 60 / bpm;
var root = 32;
var scale = Scale.aeolian.degrees;

// Weighted Markov for scale degrees
~degreeMarkov = (
	0:  [0,0.5, 2,0.31, 3,1.0,  5,0.0,  7,0.05, 8,0.88, 10,0.84],
	2:  [0,0.21, 2,1.0,  3,0.0,  5,0.04, 7,0.74, 8,0.3,  10,0.65],
	3:  [0,1.0,  2,0.07, 3,0.97, 5,0.69, 7,0.67, 8,0.65, 10,0.0],
	5:  [0,0.62, 2,0.39, 3,0.0,  5,0.71, 7,1.0,  8,0.06, 10,0.64],
	7:  [0,1.0,  2,0.87, 3,0.38, 5,0.27, 7,0.0,  8,0.28, 10,0.57],
	8:  [0,0.0,  2,0.67, 3,1.0,  5,0.62, 7,0.49, 8,0.58, 10,0.8],
	10: [0,0.93, 2,0.02, 3,0.0,  5,0.52, 7,0.31, 8,1.0,  10,0.5],
);

// function to generate a pattern
~generatePattern = { |beatLength=4|
	var pattern = List[];
	var totalDur = 0;
	var degree = ~degreeMarkov.keys.choose; // initial note

	while ({totalDur < beatLength}, {
		var nextArray = ~degreeMarkov[degree].clump(2);
		var degrees = nextArray.collect(_.first);
		var weights = nextArray.collect(_.last).normalizeSum;

		var dur = [1, 0.5, 0.25].wchoose([0.2, 0.5, 0.3]);
		var octave = [0, 1, 2].wchoose([0.1, 0.5, 0.4]);

		// ensure total duration does not exceed 4 beats
		if ((totalDur + dur) > beatLength) {
			dur = beatLength - totalDur; // adjust last note to fit exactly
		};

		// add the note event to the pattern
		pattern.add((
			degree: degree,
			octave: octave,
			dur: dur
		));

		totalDur = totalDur + dur;

		degree = degrees.wchoose(weights); // next degree using Markov
	});

	pattern;
};

Routine({
	var currentPattern, patternLength = 4, repetitions = 8;
	loop {

		currentPattern = ~generatePattern.(patternLength).value;
		"New pattern: %".format(currentPattern).postln;

		repetitions.do {
			currentPattern.do { |event|
				var freq = (root + event[\degree] + (event[\octave]*12)).midicps;
				Synth(\basic, [freq: freq, amp: 0.3]);
				(event[\dur] * beat).wait;
			};
		};
	};
}).play;
)










///////////////////////////////////////////////////////////
// Pattern Gen + Alterations
///////////////////////////////////////////////////////////

(
var bpm = 140;
var beat = 60 / bpm;
var root = 34;
var scale = Scale.aeolian.degrees;

~degreeMarkov = (
	0:  [0,0.5, 2,0.31, 3,1.0,  5,0.0,  7,0.05, 8,0.88, 10,0.84],
	2:  [0,0.21, 2,1.0,  3,0.0,  5,0.04, 7,0.74, 8,0.3,  10,0.65],
	3:  [0,1.0,  2,0.07, 3,0.97, 5,0.69, 7,0.67, 8,0.65, 10,0.0],
	5:  [0,0.62, 2,0.39, 3,0.0,  5,0.71, 7,1.0,  8,0.06, 10,0.64],
	7:  [0,1.0,  2,0.87, 3,0.38, 5,0.27, 7,0.0,  8,0.28, 10,0.57],
	8:  [0,0.0,  2,0.67, 3,1.0,  5,0.62, 7,0.49, 8,0.58, 10,0.8],
	10: [0,0.93, 2,0.02, 3,0.0,  5,0.52, 7,0.31, 8,1.0,  10,0.5],
);

// generate fresh melodic pattern
~generatePattern = { |beatLength=4|
	var pattern = List[], totalDur = 0;
	var degree = ~degreeMarkov.keys.choose;

	while ({ totalDur < beatLength }, {
		var nextArray = ~degreeMarkov[degree].clump(2);
		var degrees = nextArray.collect(_.first);
		var weights = nextArray.collect(_.last).normalizeSum;

		// var dur = [1, 0.5, 0.25].wchoose([0.2, 0.5, 0.3]);
		// var octave = [0, 1, 2].wchoose([0.1, 0.5, 0.4]);
		var dur = [1, 0.5, 0.25].choose();
		var octave = [0, 1, 2].choose();

		if ((totalDur + dur) > beatLength) {
			dur = beatLength - totalDur;
		};

		pattern.add((degree: degree, octave: octave, dur: dur));

		totalDur = totalDur + dur;
		degree = degrees.wchoose(weights);
	});

	pattern;
};

// alter existing pattern
~alterPattern = { |pattern, changes=1|
	var alteredPattern = pattern.deepCopy;

	changes.do {
		// randomly choose alteration type: degree, octave, or duration
		var alterationType = [\degree, \octave, \duration].choose;
		switch(alterationType,
			\degree, {
				// alter one random note's degree based on Markov weights
				var idx = alteredPattern.size.rand;
				var currentDegree = alteredPattern[idx][\degree];
				var nextArray = ~degreeMarkov[currentDegree].clump(2);
				var degrees = nextArray.collect(_.first);
				var weights = nextArray.collect(_.last).normalizeSum;
				"Degree Altered".postln;
				alteredPattern[idx][\degree] = degrees.wchoose(weights);
			},
			\octave, {
				// alter one random note's octave slightly (+/- 1 octave)
				var idx = alteredPattern.size.rand;
				var currentOctave = alteredPattern[idx][\octave];
				"Octave Altered".postln;
				alteredPattern[idx][\octave] = (currentOctave + [1,-1].choose).clip(0,2);
			},
			\duration, {
				if (alteredPattern.size > 1) {
					// pick two different indices to swap
					var indices = alteredPattern.size.collect{|i| i}.scramble.keep(2);
					var idxA = indices[0];
					var idxB = indices[1];
					// swap durations
					var tempDur = alteredPattern[idxA][\dur];
					"Duration Altered".postln;
					alteredPattern[idxA][\dur] = alteredPattern[idxB][\dur];
					alteredPattern[idxB][\dur] = tempDur;
				};
			}
		);
	};

	alteredPattern;
};

// Main Routine: generate pattern -> loop it -> alter -> occasionally regenerate
Routine({
	var currentPattern, repetitions = 4, alterations = 3;

	loop {
		// generate new pattern
		currentPattern = ~generatePattern.(4);
		"New pattern generated: %".format(currentPattern).postln;

		alterations.do {
			// loop current pattern
			repetitions.do {
				currentPattern.do { |event|
					var freq = (root + event[\degree] + (event[\octave] * 12)).midicps;
					Synth(\basic, [freq: freq, amp: 0.3]);
					// "Note Duration: %".format(event[\dur]*beat).postln;
					(event[\dur]*beat).wait;
				};
			};

			// alter the pattern
			currentPattern = ~alterPattern.(currentPattern, (1..3).choose);
			"Pattern altered: %".format(currentPattern).postln;
		};
	};
}).play;
)
