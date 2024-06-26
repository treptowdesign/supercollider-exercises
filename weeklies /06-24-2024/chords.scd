(
SynthDef(\pulseChord, { |freq=440, pWidth=0.5, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * (LFNoise2.ar(16) * 0.1).midiratio * (SinOsc.ar(8) * 0.2).midiratio, pWidth);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = MoogFF.ar(snd, 7000, 0);
	snd = LeakDC.ar(snd);
	// snd = GVerb.ar(snd, 200, 2, 0.1);
	// snd = snd + CombN.ar(snd * -10.dbamp, 0.35, 0.35, 1);
	snd = snd * -18.dbamp * amp.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: 4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

// scales...
Scale.aeolian.degrees;
//    0,    2,  3,  5,  7,  8,  10
// [ -12, -10, -9, -7, -5, -4, -2 || 0, 2, 3, 5, 7, 8, 10 || 12, 14, 15, 17, 19, 20, 22 ]

//   i: [0, 3, 7]
//  ii: [2, 5, 8]
// iii: [3, 7, 10]
//  iv: [5, 8, 12]
//   v: [7, 10, 14]
//  vi: [8, 12, 15]
// vii: [10, 14, 17]

(
var root = 42, octave, note;
[0, 3, 7, 10].do { |degree|
	octave = 2;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)

(
var root = 42, octave, note;
[4, 7, 10, 14].do { |degree|
	octave = 2;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)


(
var root = 42, octave, note;
[0, 2, 10, 14, 5].do { |degree|
	octave = 1;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)

(
var root = 42, octave, note;
[2, 5, 9, 12].do { |degree|
	octave = 1;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)

(
var root = 42, octave, note;
[0, 4, 7, 9, 14 ].do { |degree| // Major 6th + 9th
	octave = 1;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)

(
var root = 42, octave, note;
[0, 3, 7, 9].do { |degree| // Minor 6th
	octave = 2;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)

(
var root = 42, octave, note;
[0, 3, 7, 8].do { |degree| // Minor flat 6th
	octave = 2;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.5, duration: 2, span: 1, amp: 0]);
};
)




(
var s, root, bpm, beat;
s = Server.default;
root = 42; // F#/Gb
bpm = 130;
beat = 60 / bpm;

Routine({
	var dur, note, octave;
	dur = beat * 2;
	loop {
		[
			[0, 4, 7, 9, 14],
			[2, 5, 9, 12],
			[0, 10, 14, 5],
			[0, 10, 14, 5]

		].do { |chord|
			chord.do{ | degree|
				octave = 2;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulseChord, [freq: note, pWidth: 0.3, duration: dur, span: 2, amp: -2]); };
			};
			dur.wait;
		};
	};
}).play;

)