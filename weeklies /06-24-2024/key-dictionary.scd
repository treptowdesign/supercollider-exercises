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
			[["C", 1], ["G", 2], ["E", 3]],
			[["B", 0], ["F#", 2], ["D#", 3], ]
		].do { |chord|
			chord.do { |midi|
				Synth(\square8, [freq: n.(midi[0], midi[1]).midicps, duration: 0.3]);
			};
			beat.wait;
		};
	};
}).play;

)

