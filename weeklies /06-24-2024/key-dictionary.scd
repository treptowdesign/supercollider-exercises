// Key Dictionary
(
SynthDef(\square8, { |freq=440, pWidth=0.5, cutoff=12000, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * (SinOsc.kr(8) * 0.05).midiratio, pWidth);
	snd = snd * Env.perc(0, 0.3).ar.range(0.6, 1);
	snd = RLPF.ar(snd, cutoff, 1);
	snd = snd * Env.perc(0.01, duration * span, curve: 3).ar(Done.freeSelf);
	Out.ar(0, snd * -15.dbamp * amp.dbamp ! 2);
}).add;
)

Synth(\square8, [freq: 36.midicps, duration: 0.3]);

(
var root, bpm, beat, pianoIntervals, n;
root = 36;
bpm = 72;
beat = 60 / bpm;

pianoIntervals = Dictionary[
	"C" -> 0,
    "C#" -> 1, "Db" -> 1,
    "D" -> 2,
    "D#" -> 3, "Eb" -> 3,
    "E" -> 4,
    "F" -> 5,
    "F#" -> 6, "Gb" -> 6,
    "G" -> 7,
    "G#" -> 8, "Ab" -> 8,
    "A" -> 9,
    "A#" -> 10, "Bb" -> 10,
    "B" -> 11
];

n = { |note="C", octave=2|
	(root + pianoIntervals[note] + (12 * octave));
};

// n.(\Bb, 2)

// [n.(\C, 1), n.(\E, 3), n.(\G, 2)]

/*[[\C, 1], [\G, 2], [\E, 3]].do { |midi|
	Synth(\square8, [freq: n.(midi[0], midi[1]).midicps, duration: 0.3]);
};*/

Routine({
	loop {
		[
			// beat 1: C
			[["C", 1], ["G", 2], ["E", 3]], // root, 5th, 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave
			// beat 2: B7 (b13)
			[["B", 0], ["F#", 2], ["D#", 3]], // root, 5th, 3rd
			[["G", 1]], // b13th (b6th)
			[["B", 1]], // octave
			// beat 3:  C
			[["C", 1], ["G", 2], ["E", 3]], // root, 5th, 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave
			// beat 4: C
			[["E", 1]], // 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave
			// beat 5: C
			[["C", 1], ["G", 2], ["E", 3]], // root, 5th, 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave
			// beat 6: B7 (b13)
			[["B", 0], ["F#", 2], ["D#", 3]], // root, 5th, 3rd
			[["G", 1]], // b13th (b6th)
			[["B", 1], ["A", 2], ["F", 3]], // octave, b7th , b5th/#4th
			// beat 7: C
			[["C", 1], ["G", 2], ["E", 3]], // root, 5th, 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave
			// beat 8: C
			[["E", 1]], // 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave


			// beat 9: G7
			[["D", 1], ["F", 2], ["D", 3]], // 5th, b7th, 5th
			[["G", 1]], // root
			[["B", 1]], // 3rd
			// beat 10: F#7
			[["C#", 1], ["E", 2], ["C#", 3]], // 5th, b7th, 5th
			[["F#", 1]], // root
			[["A#", 1]], // 3rd
			// beat 11: G7
			[["D", 1], ["F", 2], ["D", 3]], // 5th, b7th, 5th
			[["G", 1]], // root
			[["B", 1]], // 3rd
			// beat 12: G7
			[["B", 0]], // 3rd
			[["G", 1]], // root
			[["B", 1]], // 3rd
			// beat 13: G7
			[["D", 1], ["F", 2], ["D", 3]], // 5th, b7th, 5th
			[["G", 1]], // root
			[["B", 1]], // 3rd
			// beat 14: G7
			[["B", 0], ["C", 2], ["G", 2]], // 3rd, 4th, root/octave
			[["G", 1]], // root
			[["B", 1], ["A", 2], ["F", 3]], // 3rd, 2nd/9th, b7th
			// beat 15: C
			[["C", 1], ["G", 2], ["E", 3]], // root, 5th, 3rd
			[["G", 1]], // 5th
			[["C", 2]], // octave
			// beat 16: C
			[["G", 0]], // 5th
			[["G", 1]], // 5th
			[["C", 2]], // octave




		].do { |chord|
			chord.do { |midi|
				Synth(\square8, [freq: n.(midi[0], midi[1]).midicps, duration: 0.32]);
			};
			(beat/3).wait;
		};
	};
}).play;

)

