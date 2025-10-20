(
SynthDef(\keys, {
	var snd, fm, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.01, 0, 0.01] * LFNoise2.ar(20 ! 3)).midiratio;
	fm = SinOsc.ar(freq * 1.001) * 100 * (1 + Env.perc(0, 0.01).ar);
	pm = SinOsc.ar(freq * 0.999) * 1 * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq + fm, pm);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-20.dbamp * \amp.kr(1)));
	snd = snd * Env.perc(0.001, \rel.kr(4)).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

/////////////////////////////////////////////////////////////////

(
~playChord = { |notes=#[]|
	notes.sort.postln.do { |int|
		Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
	};
};
)

/////////////////////////////////////////////////////////////////
Scale.ionian.degrees; // [ 0, 2, 4, 5, 7, 9, 11 ]
// 1st: [0, 4, 7, 11, 14 (2), 17 (5), 21 (9)] I7
// 2nd: [2, 5, 9, 12] => (2 + [ 0, 3, 7, 10 ]); => ii7
// 3rd: [4, 7, 11, 14] => (4 + [ 0, 3, 7, 10 ]); => iii7
// 4th: [5, 9, 12, 16] => (5 + [ 0, 4, 7, 11 ]); => IV;
// 5th: [7, 11, 14, 17] => (7 + [ 0, 4, 7, 10 ]); => Vm7 (maj 3, min 7)
// 6th: [9, 12, 16, 19] => (9 + [ 0, 3, 7, 10 ]); => vi7
// 7th: [11, 14, 17, 21] => (11 + [ 0, 3, 6, 10 ]); => viio7
/////////////////////////////////////////////////////////////////

( // i7 (1-3-5-7)
~playChord.(0 + [0, 16, 19, 23]);
)

( // ii7 (0-b7-b3-5)
~playChord.(2 + [0, 15, 19, 22]);
)

( // iii7 (0-b7-b3-5)
~playChord.(4 + [0, 15, 19, 22]);
)

( // IV7 (0-3-5-7)
~playChord.(5 + [0, 16, 19, 23]);
)

( // V7 (0-b7-3-5)
~playChord.(7 + [0, 10, 16, 19]);
// ~playChord.(-5 + [0, 16, 19, 22]);
)

( // vi7
~playChord.(-3 + [0, 15, 19, 22]);
)

( // viio7 (0-b7-b3-b5)
~playChord.(-1 + [0, 15, 18, 22]);
)


/////////////////////////////////////////////////////////////////
// BORROWED CHORDS
/////////////////////////////////////////////////////////////////

( // iv7 (0-b7-b3-5)
(5 + [0, 10, 15, 19]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

( // viio7 (fully diminished [ 0, 3, 6, 9] )
(-1 + [0, 18, 21, 27]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

/////////////////////////////////////////////////////////////////
// JAZZY PROGRESSION
/////////////////////////////////////////////////////////////////

( // ii13 (1-b7-b3-6) - traded out 5th for the 13th (6)
(2 + [0, 10, 15, 21]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

( // V9 (1-b7-2-3) - traded out 5th for the 9th (2)
(7 + [0, 10, 14, 16]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

( // iii7
(4 + [0, 15, 19, 22]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

( // V9/ii (1-b7-2-3)
(9 + [0, 10, 14, 16]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

( // ii9 (1-b3-b7-2)
(2 + [0, 15, 22, 26]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

( // viio7/ii (1-b5-bb7-b3)
(1 + [0, 18, 21, 27]).sort.postln.do { |int|
	Synth(\keys, [freq: (42 + int + (12 * 0)).midicps]);
};
)

[0, 18, 21, 27] % 12;

/////////////////////////////////////////////////////////////////
// Section
/////////////////////////////////////////////////////////////////


[0, 18, 21, 27] % 12;









// endfile...
