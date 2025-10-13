////////////////////////////////////////////
////////////////////////////////////////////
// Modes
////////////////////////////////////////////
////////////////////////////////////////////

[]; // empty array
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ] - standard minor
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ] - minor w/ raised 6th
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ] - minor with flat 2nd
Scale.locrian.degrees; // [ 0, 1, 3, 5, 6, 8, 10 ] - phrygian w/ flat 5 (tritione instead of perf 5th)
Scale.ionian.degrees; // [ 0, 2, 4, 5, 7, 9, 11 ] - standard major
Scale.lydian.degrees; // [ 0, 2, 4, 6, 7, 9, 11 ] - major with a sharp 4th (tritone)
Scale.mixolydian.degrees; // [ 0, 2, 4, 5, 7, 9, 10 ] - major with flat 7th


[7, 10, 2 + 12, 5 + 12] -7;


[0, 3, 7]; // min
[0, 4, 7]; // maj
[0, 3, 7, 10]; // min 7th
[0, 4, 7, 11]; // maj 7th
[0, 2, 7]; // sus2
[0, 5, 7]; // sus4
[0, 3, 6, 10]; // half dim
[0, 3, 6, 9]; // full dim


[2, 5, 8, 12] -2;


////////////////////////////////////////////
////////////////////////////////////////////
// Pad
////////////////////////////////////////////
////////////////////////////////////////////




( // V7
(0 + [-5, 10, 14, 17]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

( // VI7
(0 + [-4, 7, 12, 15]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

( // ii7
(0 + [2, 9 + 12, 12, 17]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

( // bII7
(0 + [1, 8 + 12, 12, 17]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)


( // i9
(0 + [0, 3, 10, 14]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

( // i7
(0 + [0, 10, 15, 19]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)


( // iv7
(0 + [-7, 8, 12, 15]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

( // VII7
(0 + [-2, 11, 14, 20]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)



// DRUMS
(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.6]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar * [0, -5, -15].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (6 * Env.perc(0.0, 0.02).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10520, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 160, 1, 4);
	snd = snd * \amp.kr(1) * -8.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -14.dbamp, 30, 6, 0.9), 600);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, duration, freq;
	duration = \duration.kr(2.0);
	snd = SinOsc.ar(225 * [1, 2.34, 3.67]);
	snd = snd * [0, -10, -15].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.tanh;
	snd = snd + (SinOsc.ar(XLine.ar(1200, 100, 0.02)) * Env.perc(0.001, 0.02).ar);
	snd = snd + (SinOsc.ar(XLine.ar(800, 500, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (SinOsc.ar(XLine.ar(2000, 500, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.05).ar, 2520, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.05).ar, 1520, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.001, 0.02).ar, 5520, 0.3);
	snd = snd * (1 + Env.perc(0, 0.03).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.05, 1.5);
	snd = snd + GVerb.ar(snd * -30.dbamp, 30, 6, 0.8);
	snd = snd * -6.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp, brightness;
	amp = \amp.kr(1);
	brightness = \brightness.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030] * brightness.linlin(0, 1, 2, 1), 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.06 * brightness.linlin(0, 1, 0.7, 1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), amp * -8.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\crash, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = CombC.ar([snd], 0.2, 1 / [90, 123, 140]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 520);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.5, curve: -4).ar;
	snd = HPF.ar(snd, 930);
	snd = snd + GVerb.ar(snd.sum * -2.dbamp, 30, 20, damping: 0.1);
	snd = LeakDC.ar(snd);
	snd = snd * -20.dbamp;
	snd = snd * Env.perc(0.01, 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)







////////////////////////////////////////////
////////////////////////////////////////////
// Sequencing
// https://www.hooktheory.com/theorytab/view/crystal-waters/gypsy-woman
////////////////////////////////////////////
////////////////////////////////////////////


(
SynthDef(\pad, {
	var snd, duration, freq;
	freq = \freq.kr(440);
	duration = \duration.kr(2.0);
	snd = LFTri.ar(freq * (LFNoise2.ar(60 ! 20) * 0.15).midiratio, Rand(0, 4 ! 20));
	// snd = RLPF.ar(snd, XLine.ar(800, 500, duration) * (ExpRand(1 ! snd.size, 4)) * (LFNoise2.ar(3 ! snd.size) * 12).midiratio, 0.9);
	snd = Splay.ar(snd);
	// snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.7, 1);
	snd = snd * freq.explin(400, 1200, 1, 0.4);

	snd = BLowShelf.ar(snd, 400, 1, 4);
	snd = BHiShelf.ar(snd, 800, 1, -4);

	snd = snd * -12.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0, 6, curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)



~padFxBus = Bus.audio(nil, 2);
~padFxBus.index;

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 112;
bar = beat * 4;
tatum = beat / 4;
root = 50; // 48=C, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	'Start Routine'.postln;
	loop {
		/*subroutine.(2, { // set to 2
			// bar 1
			8.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			// bar 2
			8.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			// bar 3
			8.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			// bar 4
			5.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			seq.(\crash, tatum * 2);
			2.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
		});
		subroutine.(2, { // set to 2
			// bar 1
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 5);
			// bar 2
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 5);
			// bar 1 alt
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 5);
			// bar 2 alt
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 4);
			seq.(\kick, tatum * 1);
		});
		subroutine.(4, { // set to 4
			// bar 1
			(tatum * 4).wait;
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 2);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 1);
			// bar 2
			(tatum * 4).wait;
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 2);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 1);
		});*/
		subroutine.(1, {
			[
				// bar 1-4
				(notes: -5 + [ 0, 15, 19, 22 ], length: 2), // V7
				(notes: -4 + [ 0, 11, 16, 19 ], length: 2), // VI7
				(notes: 2 + [ 0, 7, 10, 15 ], length: 2), // ii7
				(notes: 1 + [ 0, 7, 11, 16 ], length: 2), // bII7
				(notes: 0 + [ 0, 3, 10, 14 ], length: 2), // i9 (root - 3rd - 7th - 9th)
				(notes: 0 + [ 0, 10, 15, 19 ], length: 2), // i7
				(notes: 0 + [ 0, 3, 10, 14 ], length: 2), // i9 (root - 3rd - 7th - 9th)
				(notes: 0 + [ 0, 10, 15, 19 ], length: 2), // i7
				// bar 5-8
				(notes: -5 + [ 0, 15, 19, 22 ], length: 2), // V7
				(notes: -4 + [ 0, 11, 16, 19 ], length: 2), // VI7
				(notes: -7 + [ 0, 15, 19, 22 ], length: 2), // iv7
				(notes: -2 + [ 0, 13, 16, 22 ], length: 2), // VII7(b9) (root - b9th - 3rd - 7th)
				(notes: 0 + [ 0, 3, 10, 14 ], length: 2), // i9 (root - 3rd - 7th - 9th)
				(notes: 0 + [ 0, 10, 15, 19 ], length: 2), // i7
				(notes: 0 + [ 0, 3, 10, 14 ], length: 2), // i9 (root - 3rd - 7th - 9th)
				(notes: 0 + [ 0, 10, 15, 19 ], length: 2), // i7
			].do { |chord|
				var dur = (chord[\length] * beat);
				chord[\notes].sort.postln.do { |int|
					[0, 1].do { |oct|
						// var amp = oct.linlin(0, 1, 1, 0.15);
						play.(\pad, dur, [freq: noteHz.(int, oct), amp: 1, rel: 5, out: 0]);
					};
				};
				dur.wait;
			};
		});
		(bar * 8).wait;
	};
}).play;
)

///////////////////////////////////////////////////////////////
// Chord Voicing
///////////////////////////////////////////////////////////////

( // Standard Voicing (bass/root - 3rd - 5th - 7th)
(0 + [0, 3, 7, 10]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

( // Voicing  (bass/root - 5th - 7th - 3rd+)
(0 + [0, 7, 10, 15]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

( // Voicing (bass/root - 7th - 3rd+ - 5th+ )
(0 + [0, 10, 15, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)





///////////////////////////////////////////////////////////////
// I - IV
///////////////////////////////////////////////////////////////
( // I7 (bass/root - 3rd+ - 5th+ - 7th+)
(0 + [0, 16, 19, 23]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)
( // IV7 (7th - 3rd -5th)
(5 + [0, 11, 16, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

///////////////////////////////////////////////////////////////
// I - IV - bVII
///////////////////////////////////////////////////////////////

( // Helpers...
~noteHz = { |int=0, oct=0| (51 + int + (12 * oct)).midicps; };
)

( // I7 (bass/root - 3rd+ - 9th+ - 7th+)
(0 + [0, 16, 14, 23]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)

( // IV7 (7th - 3rd -5th)
(5 + [0, 11, 16, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)

( // bVII (bass/root - 3rd+ - 9th+ - 7th+)
(-2 + [0, 16, 14, 23]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)


///////////////////////////////////////////////////////////////
// I - IV - bVII (shifted down)
///////////////////////////////////////////////////////////////

( // I7 (bass/root | 3rd+ | 7th+ | 9th+ )
(0 + [0, 4, 11, 14]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)

( // IV7 (bass/root | 3rd | 5th | 7th)
(5 + [0, 4, 7, 11]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)

( // bVII (bass/root | 3rd+ | 7th+ | 9th+ )
(-2 + [0, 4, 11, 14]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)

///////////////////////////////////////////////////////////////
// Massage Situation
///////////////////////////////////////////////////////////////

( // Helpers...
~noteHz = { |int=0, oct=0| (47 + int + (12 * oct)).midicps; };
)

( // I7 (sus2)
(0 + [0, 2 +12, 7 +12, 10 +12]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)

( // vii7
(-1 + [0, 3 +12, 7 +12, 10 +12]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: ~noteHz.(int, oct), rel: 6]); };
};
)




///////////////////////////////////////////////////////////////
// i - iv - bvii
///////////////////////////////////////////////////////////////

( // i7(9) (bass/root - 3rd+ - 9th+ - 7th+)
(0 + [0, 15, 14, 22]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 6]); };
};
)

( // iv7 (7th - 3rd -5th)
(5 + [0, 10, 15, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 6]); };
};
)

( // bvii7(9) (bass/root - 3rd+ - 9th+ - 7th+)
(-2 + [0, 15, 14, 22]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 6]); };
};
)



///////////////////////////////////////////////////////////////
// Intervals
///////////////////////////////////////////////////////////////

-12, 0, 12 // root/tonic
-11, 1, 13 // b2 (b9th)
-10, 2, 14 // 2 (sus2, 9th)
-9, 3, 15 // b3
-8, 4, 16 // 3
-7, 5, 17 // 4 (sus4, 11th)
-6, 6, 18 // #4 / b5
-5, 7, 19 // 5
-4, 8, 20  // b6 (b13th)
-3, 9, 21 // 6 (13th)
-2, 10, 22 // b7
-1, 11, 23 // 7

///////////////////////////////////////////////////////////////
// MISC CHORDS
///////////////////////////////////////////////////////////////

( // i7 (1-7-3-5)
(0 + [0, 10, 15, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

( // II
(2 + [0, 11, 16, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

( // III
(4 + [0, 11, 16, 19]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

( // vii
(-1 + [0, 15, 19, 10]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)

( // #IV
(6 + [0, 7, 11, 16]).sort.postln.do { |int|
	[0, 1].do { |oct| Synth(\pad, [freq: (51 + int + (12 * oct)).midicps, rel: 3]); };
};
)


///////////////////////////////////////////////////////////////
// MISC CHORDS (end)
///////////////////////////////////////////////////////////////













[-5, 10, 14, 17] + 5;
-5 + [ 0, 15, 19, 22 ];
root, 3rd, 7th, 10th;


( // V7
(0 + [-5, 10, 14, 17]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

( // V7
(-5 + [ 0, 15, 19, 22 ]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)


( // V7
(-5 + [ 0, 3, 7, 10 ]).sort.postln.do { |int|
	[0, 1].do { |oct|
		var hz = (51 + int + (12 * oct)).midicps;
		Synth(\pad, [freq: hz, amp: 1]);
	};
};
)

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////


(
SynthDef(\pad, {
	var snd, duration, freq;
	freq = \freq.kr(440);
	duration = \duration.kr(2.0);
	snd = LFTri.ar(freq * (LFNoise2.ar(60 ! 20) * 0.25).midiratio, Rand(0.0, 4.0 ! 20));
	// snd = RLPF.ar(snd, XLine.ar(1600, 500, duration) * (ExpRand(1 ! snd.size, 4)) * (LFNoise2.ar(3 ! snd.size) * 12).midiratio, 0.4);
	snd = Splay.ar(snd);
	snd = snd * freq.explin(400, 800, 1, 0.65);
	snd = BLowShelf.ar(snd, 400, 1, 4);
	snd = BHiShelf.ar(snd, 1000, 1, -4);
	snd = snd * -20.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.001, \rel.kr(1.2), curve: -8).ar;
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
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
	hi = HPF.ar((snd * 4).tanh * -5.dbamp, 6000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -10.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.001, \rel.kr(1), curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

~padFxBus = Bus.audio(nil, 2);
~padFxBus.index;

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 112;
bar = beat * 4;
tatum = beat / 4;
root = 50; // 48=C, 50=D, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	'Start Routine'.postln;
	loop {
		subroutine.(0, { // set to 8
			16.do { seq.(\hat, tatum * 1, [amp: rrand(0.6, 0.3)]); }; // bar 1
		});
		subroutine.(2, { // set to 2
			29.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); }; // bar 1 -4
			seq.(\crash, tatum * 2); // 29 (8+8+8+5) x2 = 58, then +6 = 64
			2.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
		});
		subroutine.(2, { // set to 2
			3.do { // bar 1-3
				[2,8,1,5].do { |dur| seq.(\kick, tatum * dur); };
			};
			[2,8,1,4,1].do { |dur| seq.(\kick, tatum * dur); }; // bar 4
		});
		subroutine.(8, { // set to 8
			(tatum * 4).wait;
			[3,2,3,3,1].do { |dur| seq.(\snare, tatum * dur); }; // bar 1
		});
		/*subroutine.(1, {
			[
				-5, -4, 2, 1, 0, 0, 0, 0,
				-5, -4, -7, -2, 0, 0, 0, 0,
			].do { |spec|
				2.do { |dur|
					seq.(\sub, beat * 0.5, [freq: noteHz.(spec, -1)]);
				};
				(beat).wait;

			};
		});*/
		subroutine.(1, {
			[
				// bar 1-4
				(notes: -5 + [ 0, 15, 19, 22 ], length: [4, 3]), // V7
				(notes: -4 + [ 0, 11, 16, 19 ], length: [3, 3, 2]), // VI7
				(notes: \, length: [1]),
				(notes: 2 + [ 0, 7 +12, 10, 15 ], length: [4, 3]), // ii7
				(notes: 1 + [ 0, 7 +12, 11, 16 ], length: [3, 3, 2]), // bII7
				(notes: \, length: [1]),
				(notes: 0 + [ 0, 3, 10, 14 ], length: [4, 3]), // i9
				(notes: 0 + [ 0, 10, 15, 19 ], length: [3, 3, 2]), // i7
				(notes: \, length: [1]),
				(notes: 0 + [ 0, 3, 10, 14 ], length: [4, 3]), // i9
				(notes: 0 + [ 0, 10, 15, 19 ], length: [3, 3, 2]), // i7
				(notes: \, length: [1]),
				// bar 5-8
				(notes: -5 + [ 0, 15, 19, 22 ], length: [4, 3]), // V7
				(notes: -4 + [ 0, 11, 16, 19 ], length: [3, 3, 2]), // VI7
				(notes: \, length: [1]),
				(notes: -7 + [ 0, 15, 19, 22 ], length: [4, 3]), // ii7
				(notes: -2 + [ 0, 13, 16, 22 ], length: [3, 3, 2]), // bII7
				(notes: \, length: [1]),
				(notes: 0 + [ 0, 3, 10, 14 ], length: [4, 3]), // i9
				(notes: 0 + [ 0, 10, 15, 19 ], length: [3, 3, 2]), // i7
				(notes: \, length: [1]),
				(notes: 0 + [ 0, 3, 10, 14 ], length: [4, 3]), // i9
				(notes: 0 + [ 0, 10, 15, 19 ], length: [3, 3, 2]), // i7
				(notes: \, length: [1]),
			].do { |chord|
				chord[\length].do { |item|
					var dur = item * tatum;
					if(chord[\notes] != \, {
						chord[\notes].sort.postln.do { |int|
							[0, 1, 2].do { |oct| play.(\organ, dur, [freq: noteHz.(int, oct), amp: oct.linlin(0, 2, 0.3, 0.1), out: 0]); };
							// [0, 1, 2].do { |oct| play.(\pad, dur, [freq: noteHz.(int, oct), amp: 1, out: 0]); };
						};
					});
					dur.wait;
				};
			};
		});
		(bar * 8).wait;
	};
}).play;
)

















////////////////////////////////////////////
////////////////////////////////////////////
// endfile
////////////////////////////////////////////
////////////////////////////////////////////