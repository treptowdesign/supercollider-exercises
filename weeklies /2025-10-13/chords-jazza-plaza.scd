(
SynthDef(\keys, {
	var snd, fm, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.05, 0, 0.05] * LFNoise2.ar(60 ! 3)).midiratio;
	fm = SinOsc.ar(freq * 1.001) * 80 * (1 + Env.perc(0, 0.01).ar);
	pm = SinOsc.ar(freq * 0.999) * 1.5 * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq + fm, pm);
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-24.dbamp * \amp.kr(1)));
	snd = snd * Env.perc(0.01, \rel.kr(4)).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 6).tanh * -5.dbamp, 4000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -6.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.001, \rel.kr(4)).ar;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, duration, freqs;
	duration = \duration.kr(3.0);
	freqs = \freq.kr(260) * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30).linlin(-1, 1, 0, 1) * 0.3);
	snd = Splay.ar(snd);
	snd = snd * -4.dbamp;
	snd = snd * Env.perc(0.001, \rel.kr(4)).ar;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -28.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad2, {
	var snd, duration, freq;
	duration = \duration.kr(3.0);
	snd = LFTri.ar(
		\freq.kr(440) * (LFNoise2.ar(60 ! 20) * 0.1).midiratio,
		Rand(0, 4 ! 20)
	);
	snd = Splay.ar(snd);
	snd = snd * -24.dbamp;
	snd = snd * Env.perc(0.001, \rel.kr(4)).ar;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

/////////////////////////////////////////////////////////////////
// Functions
/////////////////////////////////////////////////////////////////

(
~root = 42; // F#
~noteHz = { |int=0, oct=0| (~root + int + (12 * oct)).midicps };
~playChord = { |notes=#[]|
	var bassNote = notes.sort[0];
	bassNote.postln;
	((notes - bassNote) % 12).sort.postln;
	Synth(\sub, [freq: ~noteHz.(notes[0], -1)]); // sub
	notes.do { |int|
		Synth(\pad2, [freq: ~noteHz.(int, 1)]);
		Synth(\pad, [freq: ~noteHz.(int, 2)]);
		Synth(\keys, [freq: ~noteHz.(int, 0)]);
	};
};
)

/////////////////////////////////////////////////////////////////
// Intervals
0: tonic
1: b2nd / b9th
2: 2nd / 9th
3: b3rd
4: 3rd
5: 4th / 11th
6: tritone (#4 or b5) / #11th
7: 5th
8: b6th / b13th
9: 6th / 13th
10: b7th
11: 7th

// +12 brings up an octave, -12 brings down an octave

// Breaking down major scale into chords...
Scale.ionian.degrees; // [ 0, 2, 4, 5, 7, 9, 11 ]
// 1st: [0, 4, 7, 11, 14 (2), 17 (5), 21 (9)] I7
// 2nd: [2, 5, 9, 12] => (2 + [ 0, 3, 7, 10 ]); => ii7
// 3rd: [4, 7, 11, 14] => (4 + [ 0, 3, 7, 10 ]); => iii7
// 4th: [5, 9, 12, 16] => (5 + [ 0, 4, 7, 11 ]); => IV;
// 5th: [7, 11, 14, 17] => (7 + [ 0, 4, 7, 10 ]); => Vm7 (maj 3, min 7)
// 6th: [9, 12, 16, 19] => (9 + [ 0, 3, 7, 10 ]); => vi7
// 7th: [11, 14, 17, 21] => (11 + [ 0, 3, 6, 10 ]); => viio7
/////////////////////////////////////////////////////////////////


( // I7 (1-3-5-7)
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
// ~playChord.(-5 + [0, 16 + 12, 19, 22]);
)

( // vi7
~playChord.(-3 + [0, 15 +12, 19, 22]);
)

( // viio7 (0-b3-b5-b7)
~playChord.(-1 + [0, 15, 18, 22]);
)



/////////////////////////////////////////////////////////////////
// BORROWED CHORDS
/////////////////////////////////////////////////////////////////

( // iv7 (0-b7-b3-5)
~playChord.(5 + [0, 10, 15, 19]);
)

( // III7
~playChord.(4 + [0, 11, 16, 19]);
)

( // viioo7 (0-b7-b3-b5)
~playChord.(-1 + [0, 15 +12, 18, 21]);
)

( // I7 (1-3-5-7)
~playChord.(0 + [0, 16, 19, 23]);
)

/////////////////////////////////////////////////////////////////
// JAZZY PROGRESSION
/////////////////////////////////////////////////////////////////

( // ii13 (1-b7-b3-6) - traded out 5th for the 13th (6)
~playChord.(2 + [0, 10, 15, 21]);
)

( // V9 (1-b7-2-3) - traded out 5th for the 9th (2)
~playChord.(7 + [0, 10, 14, 16]);
)

( // iii7 (1-b3-5-b7)
~playChord.(4 + [0, 15, 19, 22]);
)

( // V9/ii (1-b7-2-3) - 5th of the 2 == 9, then V9
~playChord.(9 + [0, 10, 14, 16]);
)

( // ii9 (1-b3-b7-2)
~playChord.(2 + [0, 15, 22, 26]);
)

( // viio7/ii (1-b5-bb7-b3)
~playChord.(1 + [0, 18, 21, 27]);
)


/////////////////////////////////////////////////////////////////
// Minor Chord i7-V9/V-V7
/////////////////////////////////////////////////////////////////

(
~root = 52; // F#
~noteHz = { |int=0, oct=0| (~root + int + (12 * oct)).midicps };
~playChord = { |notes=#[]|
	var bassNote = notes.sort[0];
	bassNote.postln;
	((notes - bassNote) % 12).sort.postln;
	Synth(\sub, [freq: ~noteHz.(notes[0], -1)]); // sub
	notes.do { |int|
		Synth(\pad, [freq: ~noteHz.(int, 1)]);
		Synth(\keys, [freq: ~noteHz.(int, 0)]);
	};
};
)

( // I7 (1-5-7-3)
~playChord.(0 + [0, 7, 10, 15]);
)

( // V9/V
~playChord.(-10 + [0, 16, 22, 26]);
)

( // V7
~playChord.(-5 + [0, 10, 16, 19]);
)

( // IV7
~playChord.(-4 + [0, 10, 16, 19]);
)



/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
// Section
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////





// endfile...
