// Weds 04-09-2025

///////////////////////////////////////////////////////////
// Bussing
///////////////////////////////////////////////////////////

(

)

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
// Patterns/Routines
///////////////////////////////////////////////////////////

(
var bpm, beat, root, scale;
bpm = 120;
beat = 60 / bpm;
root = 32;
scale = Scale.aeolian.degrees;
Routine({
	fork {
		var note, octave;
		loop {
			octave = [1, 2].choose;
			note = (root + scale.choose + (12 * octave)).midicps;
			Synth(\basic, [freq: note, amp: 0.2, pan: rrand(-1.0, 1.0)]);
			(beat / [2, 4].choose).wait;
		};
	};
	fork {
		var note, octave;
		loop {
			octave = [0, 1].choose;
			note = (root + scale.choose + (12 * octave)).midicps;
			Synth(\basic, [freq: note, cutoff: 1e3 ,amp: 0.5]);
			(beat).wait;
		};
	};
}).play;
)

// Markov Chromatic
/*~markov = (
	0:  [2, 4, 5, 7, 9, 11],
	4:  [0, 5, 7, 9, 11, 3],
	7:  [0, 4, 9, 2, 11, 5],
	3:  [4, 2, 5, 8],
	8:  [7, 9, 4, 11],
	1:  [0, 2, 3],
	2:  [0, 3, 4],
	5:  [4, 7, 0, 6],
	6:  [5, 7, 8],
	9:  [8, 7, 11, 0],
	10: [9, 11, 7],
	11: [0, 9, 7]
);*/

// Markov

rrand(0.0, 1.0);

(
var weights;
weights = 7.collect { |i|
	rrand(0.0, 1.0);
};
weights.normalize.round(0.01);
)


// Weighted Markov
(
var bpm, beat, root, scale;
bpm = 120;
beat = 60 / bpm;
root = 32;
scale = Scale.aeolian.degrees;

~degreeMarkov = (
	0:  [0,0.5, 2,0.31, 3,1.0,  5,0.0,  7,0.05, 8,0.88, 10,0.84],
	2:  [0,0.21, 2,1.0,  3,0.0,  5,0.04, 7,0.74, 8,0.3,  10,0.65],
	3:  [0,1.0,  2,0.07, 3,0.97, 5,0.69, 7,0.67, 8,0.65, 10,0.0],
	5:  [0,0.62, 2,0.39, 3,0.0,  5,0.71, 7,1.0,  8,0.06, 10,0.64],
	7:  [0,1.0,  2,0.87, 3,0.38, 5,0.27, 7,0.0,  8,0.28, 10,0.57],
	8:  [0,0.0,  2,0.67, 3,1.0,  5,0.62, 7,0.49, 8,0.58, 10,0.8],
	10: [0,0.93, 2,0.02, 3,0.0,  5,0.52, 7,0.31, 8,1.0,  10,0.5],
);

Routine({
	var degree = ~degreeMarkov.keys.choose; // initial note
	fork {
		loop {
			var nextArray = ~degreeMarkov[degree].clump(2); // pairs [degree, weight]
			var degrees = nextArray.collect(_.first);
			var weights = nextArray.collect(_.last);

			// explicitly normalize weights
			var total = weights.sum;
			var normalizedWeights = weights.collect { |w| w / total };

			// debugging
			"Current degree: %".format(degree).postln;
			"Degrees: %".format(degrees).postln;
			"Normalized Weights: %".format(normalizedWeights.collect(_.round(0.01))).postln;

			Synth(\basic, [freq: (root + degree + (12 * [0,1,2].wchoose([0.1, 0.4, 0.5]))).midicps, amp: 0.2]);

			degree = degrees.wchoose(normalizedWeights);
			(beat / [1,2,4].wchoose([0.2, 0.5, 0.3])).wait;
		};
	};
}).play;
)


// Pattern Gen

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

// function to generate a 4-beat pattern
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
			dur = beatLength - totalDur; // adjust last note to fit
		};

		pattern.add((
			degree: degree,
			octave: octave,
			dur: dur
		));

		totalDur = totalDur + dur;

		// next degree using Markov selection
		degree = degrees.wchoose(weights);
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





















(
var bpm, beat, root, scale;
bpm = 120;
beat = 60 / bpm;
root = 32;
scale = Scale.aeolian.degrees;

// Markov Aeolian
~markov = (
	0:  [0, 2, 3, 5, 7, 8, 10], // [ 0.95, 0.31, 1.0, 0.0, 0.05, 0.88, 0.84 ]
	2:  [0, 2, 3, 5, 7, 8, 10], // [ 0.21, 1.0, 0.0, 0.04, 0.74, 0.3, 0.65 ]
	3:  [0, 2, 3, 5, 7, 8, 10], // [ 1.0, 0.07, 0.97, 0.69, 0.67, 0.65, 0.0 ]
	5:  [0, 2, 3, 5, 7, 8, 10], // [ 0.62, 0.39, 0.0, 0.71, 1.0, 0.06, 0.64 ]
	7:  [0, 2, 3, 5, 7, 8, 10], // [ 1.0, 0.87, 0.38, 0.27, 0.0, 0.28, 0.57 ]
	8:  [0, 2, 3, 5, 7, 8, 10], // [ 0.0, 0.67, 1.0, 0.62, 0.49, 0.58, 0.8 ]
	10: [0, 2, 3, 5, 7, 8, 10], // [ 0.93, 0.02, 0.0, 0.52, 0.31, 1.0, 0.5 ]
);

Routine({
    var degree = ~markov.keys.choose; // initial note
    loop {
        Synth(\basic, [freq: (root + degree + 12).midicps, amp: 0.4]);
        degree = ~markov[degree].choose; // get next note from dictionary
        (beat / 2).wait;
    }
}).play;
)

// Cellular Automata

(
var bpm, beat, root, scale;
bpm = 120;
beat = 60 / bpm;
root = 32;
scale = Scale.aeolian.degrees;

~cells = [0,1,0,1,1,0,1];

Routine({
  loop {
    ~cells = ~cells.collect{|cell, i|
      var l = ~cells.wrapAt(i-1);
      var r = ~cells.wrapAt(i+1);
      if(l == r, { 0 }, { 1 });
    };
    ~cells.do{|val, idx|
      if(val == 1){
        Synth(\basic, [freq: (root + scale.wrapAt(idx) + 12).midicps, amp:0.3]);
      };
    };
    beat.wait;
  }
}).play;
)
























// endfile