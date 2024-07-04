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
var root, bpm, beat, noteToMidi, intervalToMidi, n, getIntervalOfNote;
root = 36;
bpm = 72;
beat = 60 / bpm;

noteToMidi = Dictionary[
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

intervalToMidi = Dictionary[
	"1" -> 0,
	"b2" -> 1, // b9th
	"2" -> 2, // 9th
	"b3" -> 3,
	"3" -> 4,
	"4" -> 5, // 11th
	"#4" -> 6, "b5" -> 6, // #11th
	"5" -> 7,
	"b6" -> 8, // b13th
	"6" -> 9,  // 13th
	"b7" -> 10,
	"7" -> 11
];

getIntervalOfNote = { |note="C", interval="1"|
	var result;
	result = ((noteToMidi[note] + intervalToMidi[interval]) % 12);
	noteToMidi.findKeyForValue(result).postln;
};

// getIntervalOfNote.("Eb", "7");

n = { |note="C", octave=2|
	(root + noteToMidi[note] + (12 * octave));
};

/*1, 2, 3, 4, 5, 6, 7
C, D, E, F, G, A, B, */


Routine({
	loop {
		[
			( // Measure 01 ////////////////////////////////////////////////////
				root: "C", // I: C, E, G
				treble: [
					(notes: [["G", 2], ["E", 3]], length: 1/4, span: 2.5), // 5th, 3rd
					(notes: \, length: 3/4),
				],
				bass: [
					(notes: [["C", 1]], length: 1/4, span: 0.8), // root
					(notes: [["G", 1]], length: 2/4, span: 0.8), // 5th
					(notes: [["C", 2]], length: 1/4, span: 0.8), // octave
				]
			),
			( // Measure 02 ////////////////////////////////////////////////////
				root: "D", // ii: D, F, A
				treble: [
					(notes: [["A", 2], ["F", 3]], length: 1/4, span: 2.5), // 5th, b3rd
					(notes: \, length: 3/4),
				],
				bass: [
					(notes: [["D", 1]], length: 1/4, span: 0.8), // root
					(notes: [["A", 1]], length: 2/4, span: 0.8), // 5th
					(notes: [["D", 1]], length: 1/4, span: 0.8), // octave
				]
			),
			( // Measure 02 ////////////////////////////////////////////////////
				root: "A", // vi: A, C, E
				treble: [
					(notes: [["E", 2], ["C", 3]], length: 1/4, span: 2.5), // 5th, b3rd
					(notes: \, length: 5/6),
				],
				bass: [
					(notes: [["A", 0]], length: 1/4, span: 0.8), // root
					(notes: [["E", 1]], length: 1/4, span: 0.8), // 5th
					(notes: [["A", 1]], length: 1/4, span: 0.8), // octave
					(notes: [["E", 1]], length: 1/4, span: 0.8), // 5th
				]
			),
			( // Measure 02 ////////////////////////////////////////////////////
				root: "G", // V: G, B, D
				treble: [
					(notes: [["D", 2], ["B", 2]], length: 1/4, span: 2.5), // 5th, b3rd
					(notes: \, length: 3/4),
				],
				bass: [
					(notes: [["G", 0]], length: 1/4, span: 0.8), // root
					(notes: [["D", 1]], length: 1/4, span: 0.8), // 5th
					(notes: [["G", 1]], length: 1/4, span: 0.8), // octave
					(notes: [["D", 1]], length: 1/4, span: 0.8), // 5th
				]
			),
		].do { |measure|
			Routine({ // play treble part...
				measure[\treble].do { |part|
					part[\notes].do { |midi|
						if(midi != \, {
							var dur = part[\length] * part[\span] * beat;
							Synth(\square8, [freq: n.(midi[0], midi[1]).midicps, duration: dur]);
						});
					};
					(part[\length] * beat).wait;
				};
			}).play;
			Routine({ // play bass part...
				measure[\bass].do { |part|
					part[\notes].do { |midi|
						if(midi != \, {
							var dur = part[\length] * part[\span] * beat;
							Synth(\square8, [freq: n.(midi[0], midi[1]).midicps, duration: dur]);
						});
					};
					(part[\length] * beat).wait;
				};
			}).play;
			beat.wait;
		};
	};
}).play;

)










///////////////////////////////////////////////////////////

