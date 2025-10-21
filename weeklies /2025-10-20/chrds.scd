(
/////////////////////////////////
// Drums
/////////////////////////////////
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.15).ar.linexp(0, 1, 50, 250) * XLine.ar(1, 0.5, 0.5));
	snd = snd * (1 + (3 * Env.perc(0, 0.05).ar));
	snd = snd + (BPF.ar(Env.perc(0.001, 0.02).ar * Hasher.ar(Sweep.ar), 1840, 0.3) * 10.dbamp);
	snd = snd.tanh;
	snd = BHiShelf.ar(snd, 3400, 0.3, 4);
	snd = BLowShelf.ar(snd, 100, 0.3, 4);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [30e-3, 45e-3]), 200), 3000);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * -6.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1230);
	snd = snd * 22.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08] * 1, -4).ar;
	snd = snd * Env.perc(0, 0.6, curve: -8).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.2) ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12.3e3], 0.1);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.01, 0.02, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.23, 1 / 50, 1);
	snd = FreqShift.ar(snd, -34);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
/////////////////////////////////
// Instruments
/////////////////////////////////
SynthDef(\keys, {
	var snd, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.05, 0, 0.05] * LFNoise2.ar(30 ! 3)).midiratio;
	pm = SinOsc.ar(freq * 1.001) * 1  * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq, pm);
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-24.dbamp * \amp.kr(1)));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	snd = snd * SinOsc.ar(Rand(0.1, 1.0), Rand(0.0, pi) + [0, pi]).linlin(-1, 1, 0.3, 1);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 3.dbamp).tanh * 0.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = Balance2.ar(snd[0], snd[1]);
	snd = snd * Env.perc(0.01, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keys2, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq, snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 3.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Env.perc(0.001, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.7, 1);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	snd = snd * -28.dbamp;
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
	snd = snd * Env.perc(0.01, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
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
	snd = snd * Env.perc(0.001, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
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
	snd = snd * Env.perc(0.001, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
/////////////////////////////////
// FX
/////////////////////////////////
SynthDef(\reverbFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 8);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
/*SynthDef(\reverbFx, {
	var snd, wet;
	snd = In.ar(\in.kr(0), 2);
	wet = snd;
	wet = AllpassC.ar(wet, 0.2, [0.0344, 0.05], 0.1);
	wet = [wet[0], wet[1], wet[0], wet[1]] + LocalIn.ar(4);
	wet = DelayC.ar(wet, 1.0, [0.2, 0.343, 0.4335, 0.5242] * 0.2);
	wet = AllpassC.ar(wet, 0.2, ([0.12, 0.445, 0.31, 0.38] * 0.03) + (LFNoise2.ar(3 ! 4) * 0.0001), [0.3, 0.5, 0.6, 0.7]);
	wet = AllpassC.ar(wet, 0.2, [0.42, 0.245, 0.11, 0.78] * 0.01, [0.3, 0.5, 0.6, 0.7]);
	wet = wet * -2.dbamp;
	wet = LPF.ar(wet, 6000);
	wet = HPF.ar(wet, 100);
	wet = wet * ([
		[1, 1, 1, 1],
		[1, -1, 1, -1],
		[1, 1, -1, -1],
		[1, -1, -1, 1],
	] / 2);
	wet = wet.sum;
	LocalOut.ar(wet);
	wet = [wet[0] + wet[3], wet[1] + wet[2]];
	wet = DelayC.ar(wet, 0.05, 0.05);
	wet = wet * -10.dbamp * \wet.kr(0).lag(0.1);
	snd = snd + wet;
	Out.ar(\out.kr(0), snd);
}).add;*/
)

/////////////////////////////////////////////////////////////////
// Bussing
/////////////////////////////////////////////////////////////////

(
~reverbBus = Bus.audio(nil, 2);
)

~reverbBus.index;

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
		// Synth(\pad2, [freq: ~noteHz.(int, 1)]);
		// Synth(\pad, [freq: ~noteHz.(int, 2)]);
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

( // ii7 (1-b7-b3-5)
~playChord.(2 + [0, 15, 19, 22]);
)

( // iii7 (1-b7-b3-5)
~playChord.(4 + [0, 15, 19, 22]);
)

( // IV7 (1-3-5-7)
~playChord.(5 + [0, 16, 19, 23]);
)

( // V7 (1-b7-3-5)
// ~playChord.(7 + [0, 10, 16, 19]);
~playChord.(-5 + [0, 16 + 12, 19, 22]);
)

( // vi7
~playChord.(-3 + [0, 15 +12, 19, 22]);
)

( // viio7 (1-b3-b5-b7)
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

( // viio7 (0-b7-b3-bb5)
~playChord.(-1 + [0, 15 +12, 18, 21]);
)

( // I7 (1-3-5-7)
~playChord.(0 + [0, 16, 19, 23]);
)

/////////////////////////////////////////////////////////////////
// Misc
/////////////////////////////////////////////////////////////////

( // ii7
~playChord.(2 + [0, 15, 19, 22]);
)

( // bii7 (0-b3-b5-b7)
~playChord.(1 + [0, 15, 18, 22]);
)



( // V7/iii7 (1-b3-5-b7)
~playChord.(-1 + [0, 16 + 12, 19, 22]);
)

( // iii11v(1-b3-5-b7)
~playChord.(4 + [0, 15, 17, 22]);
)



( // ii7
~playChord.(2 + [0, 7 +12, 10, 15]);
)

( // bii7 (0-b3-b5-b7)
~playChord.(1 + [0, 7 +12, 11, 16]);
)




////////////////////////////////////////
// IV7 - I7 (mjor)

~root = 44; // Ab
// https://www.hooktheory.com/theorytab/view/teebs/studie-(feat-panda-bear)

( // I7 (1-3-5-7)
~playChord.(0 + [0, 16, 19, 23]);
)
( // IV9 (1-3-5-7)
~playChord.(5 + [0, 16, 14, 11]);
)
( // I7 4/3
~playChord.(0 + [12, 16, 7, 23]);
)
( // IV9 (1-3-5-7)
~playChord.(5 + [0, 16, 14, 11]);
)

////////////////////////////////////////
// Lone

(
~root = 49; // F#
~noteHz = { |int=0, oct=0| (~root + int + (12 * oct)).midicps };
~playChord = { |notes=#[]|
	var bassNote = notes.sort[0];
	bassNote.postln;
	((notes - bassNote) % 12).sort.postln;
	Synth(\sub, [freq: ~noteHz.(notes[0], -1)]); // sub
	notes.do { |int|
		Synth(\pad2, [freq: ~noteHz.(int, 1)]);
		Synth(\pad, [freq: ~noteHz.(int, 1)]);
		Synth(\keys, [freq: ~noteHz.(int, 0)]);
	};
};
)
// https://www.hooktheory.com/theorytab/view/lone/as-a-child-%28feat-machinedrum%29

( // i7
~playChord.(0 + [0, 10, 15, 19]);
)

( // v7
~playChord.(-5 + [0, 15, 19, 22]);
)

( // I7
~playChord.(0 + [0, 11, 16, 19]);
)

( // V7
~playChord.(-5 + [0, 16, 19, 23]);
)

( // bVI7
~playChord.(-4 + [0, 16, 19, 23]);
)

( // VII7
~playChord.(-2 + [0, 16, 19, 11]);
)

( // V7
~playChord.(-5 + [0, 16, 19, 23]);
)

( // bVI7
~playChord.(-4 + [0, 16, 19, 23]);
)

// https://www.hooktheory.com/theorytab/view/lone/airglow-fires

( // bII9 (5th->9th)
~playChord.(1 + [0, 11, 14, 16]);
)

( // i11 (3rd->9th, 5th->11th)
~playChord.(0 + [0, 10, 14, 17]);
)

( // ii 6/5 (7th->6th)
~playChord.(-7 + [0, 19, 21, 28]);
)



/////////////////////////////////////////////////////////////////
// JAZZY PROGRESSION
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
// Routine
/////////////////////////////////////////////////////////////////

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 112;
bar = beat * 4;
tatum = beat / 4;
root = 42; // 48=C, 50=D, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork { latency.wait; s.bind { Synth(synth, [duration: dur] ++ args); }; };
};
seq = { |synth, dur, args=#[], latency=0.0|
	play.(synth, dur, args, latency); (dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	var reverbFx;
	'Start Routine'.postln;

	reverbFx = Synth.tail(nil, \reverbFx, [in: ~reverbBus, out: 0, wet: 1]);

	loop {
		subroutine.(8, { // 8
			2.do {
				(beat * 1).wait;
				seq.(\clap, beat * 1, latency: 0);
			};
		});
		subroutine.(8, { // 8
			8.do { |index| seq.(\hat, (tatum * 2), [amp: rrand(0.4, 1.0)]); };
		});
		subroutine.(8, { // 8
			[6, 8, 2].do { |dur| seq.(\kick, dur * tatum); };
		});
		subroutine.(1, { // 2
			[
				(2 + [0, 10, 15, 21]),
				(7 + [0, 10, 14, 16]),
				(2 + [0, 10, 15, 21]),
				(7 + [0, 10, 14, 16]),
				(4 + [0, 15, 19, 22]),
				(9 + [0, 10, 14, 16]),
				(2 + [0, 15, 22, 26]),
				(1 + [0, 18, 21, 27])
			].do { |chord|
				[6, 8, 2].do { |item|
					var dur = (item * tatum);

					play.(\sub, dur, [freq: noteHz.(chord.sort[0], -1), rel: 6]);
					chord.sort.postln.do { |int|
						// play.(\pad, bar, [freq: noteHz.(int, 1), rel: 2, out: ~reverbBus]);
						play.(\keys, dur, [freq: noteHz.(int, 0), rel: 2, out: 0]);
					};
					dur.wait;
				};
			};
		});
		// global wait ////////////////////////////////////////////////
		(bar * 8).wait;
	};
}).play;
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