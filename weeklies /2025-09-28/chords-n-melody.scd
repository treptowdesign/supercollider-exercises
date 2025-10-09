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
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -14.dbamp, 30, 6, 0.9), 600);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(2.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1620, 0.3) * 16.dbamp;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] * 0.65, curve: -8).ar;
	snd = RLPF.ar(snd, XLine.ar(14000, 1000, 0.3), 0.7);
	// snd = snd + GVerb.ar(snd * -10.dbamp, 20, 3);
	snd = snd * 4.dbamp ! 2;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
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
	snd = snd + GVerb.ar(snd * -15.dbamp, 30, 6);
	snd = snd * -2.dbamp;
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


(
SynthDef(\sqr, {
	var freq, duration, snd, env;
	freq = \freq.kr(260);
	duration = \duration.kr(2);
	env = Env.perc(0.001, 3, curve: -4).ar;
	env = env * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = (LFPulse.ar(freq * [1, 2, 4]) * 2) - 1;
	// snd = snd + BPF.ar(PinkNoise.ar(1 ! 3), freq);
	snd = snd.product;
	snd = XFade2.ar(snd, CombC.ar(snd, 0.02, SinOsc.ar(0.5, 0).linlin(-1, 1, 0, 1) * 3e-3, 0), \comb.kr(0));
	snd = XFade2.ar(snd, DelayC.ar(snd, 0.2, LFNoise2.ar(3 ! 2).linlin(-1, 1, 0, 1) * 8e-3), \delc.kr(0));
	snd = snd + GVerb.ar(snd * -15.dbamp, 30, 6).mean;
	snd = LPF.ar(snd, 8000);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(0.1) * -2.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\pad, {
	var snd, duration, freq;
	duration = \duration.kr(2.0);
	snd = LFTri.ar(
		\freq.kr(440) * (LFNoise2.ar(60 ! 20) * 0.5).midiratio,
		Rand(0, 4 ! 20)
	);
	snd = Splay.ar(snd);
	snd = snd * -20.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
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
	snd = snd * -8.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\ping, {
	var snd, duration, freq;
	freq = \freq.kr(600);
	duration = \duration.kr(2.0);
	snd = SinOsc.ar(freq * 1) * 600;
	snd = SinOsc.ar((freq + snd) * (LFNoise2.ar(30) * 0.05).midiratio);
	snd = snd + HPF.ar(PinkNoise.ar, 2000);
	snd = snd * Env.perc(0.01, 0.5, curve: -8).ar;
	snd = LPF.ar(snd, 3000);
	snd = snd * -12.dbamp;
	snd = snd + GVerb.ar(snd, 20, 3);
	snd = snd.tanh;
	snd = snd * -6.dbamp;
	snd = snd * Env.linen(0.001, 5.0, 0.001, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\saw, {
	var snd, count, freq;
	count = 10;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.05).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(0.5) } ! count) * 0.3).midiratio, { Rand(0, 4) } ! count);
	snd = Splay.ar(snd) * -18.dbamp;
	snd = LPF.ar(snd, 8000);
	snd = snd * Env.perc(0.02, \rel.kr(4)).ar(Done.freeSelf);
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)









// Intervals:
0: root
1: b 2nd
2: 2nd
3: b 3rd
4: 3rd
5: 4th
6: tritione (#4th or b5)
7: 5th
8: b 6th
9: 6th
10: b 7th
11: 7th




(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;

// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				(0 + [0, 3, 7, 10, 17]), // root (#11)
				(1 + [0, 3, 7, 10, 14]), // b2nd
				(5 + [-9, 0, 3, 7, 10]), // 4th
				(7 + [-8, 0, 4, 7, 10]), // 5th
			].do { |chord|
				chord.sort.postln.do { |int|
					[0].do { |oct|
						play.(\saw, bar, [freq: noteHz.(int, oct)]);
						play.(\pad, bar, [freq: noteHz.(int, oct)]);
					};
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 4).wait;
	};
}).play;
)




// Intervals:
0: root
1: b 2nd
2: 2nd
3: b 3rd
4: 3rd
5: 4th
6: tritione (#4th or b5)
7: 5th
8: b 6th
9: 6th
10: b 7th
11: 7th


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;

// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				(0 + [0, 3, 6, 9]), // Diminished
				(1 + [0, 3, 6, 9]),
				(2 + [0, 3, 6, 9])
			].do { |chord|
				chord.sort.postln.do { |int|
					[0, 1].do { |oct|
						// play.(\saw, bar, [freq: noteHz.(int, oct)]);
						play.(\pad, bar, [freq: noteHz.(int, oct)]);
					};
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 4).wait;
	};
}).play;
)






// MODES ////////////////////////////////////////////

Scale.ionian.degrees; // [ 0, 2, 4, 5, 7, 9, 11 ]
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]
Scale.lydian.degrees; // [ 0, 2, 4, 6, 7, 9, 11 ]
Scale.mixolydian.degrees; // [ 0, 2, 4, 5, 7, 9, 10 ]
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.locrian.degrees; // [ 0, 1, 3, 5, 6, 8, 10 ]


[];


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;

// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				// [ 0, 2, 3, 5, 7, 8, 10 ]
				(0 + [0, 3, 7, 10]),
				(0 + [2, 5, 8, 0 +12]),
				(0 + [3, 7, 10, 2 +12]),
				(0 + [5, 8, 0 +12, 3 +12]),
				(0 + [7, 10, 2 +12, 5 +12]),
				(0 + [8, 0 +12, 3 +12, 7 +12]),
				(0 + [10, 2 +12, 5 +12, 8 +12]),
			].do { |chord|
				chord.sort.postln.do { |int|
					play.(\saw, bar, [freq: noteHz.(int, 0)]);
					[0, 1].do { |oct|
						play.(\pad, bar, [freq: noteHz.(int, oct)]);
					};
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 7).wait;
	};
}).play;
)

[ 0, 3, 7, 10, 14 ] -0;
[2, 5, 8, 0 +12] - 2;
[3, 7, 10, 2 +12] -3;
[5, 8, 0 +12, 3 +12] -5;
[7, 10, 2 +12, 5 +12] -7;
[8, 0 +12, 3 +12, 7 +12] -8;
[10, 2 +12, 5 +12, 8 +12] -10;



// [ 0, 2, 3, 5, 7, 8, 10 ]
(-0 + [0, 3, 7, 10, 2 +12]);
(-2 + [2, 5, 8, 0 +12, 3 +12]);
(-3 + [3, 7, 10, 2 +12, 5 +12]); // 14
(-5 + [5, 8, 0 +12, 3 +12, 7 + 12]); // 14
(-7 + [7, 10, 2 +12, 5 +12, 8 +12]); // 13
(-8 + [8, 0 +12, 3 +12, 7 +12, 10 +12]); // 14
(-10 + [10, 2 +12, 5 +12, 8 +12, 0 + 24]); // 14


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;
// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				// [ 0, 2, 3, 5, 7, 8, 10 ]
				// AEOLIAN MODE
				(0 + [ 0, 3, 7, 10, 14 ]), // min
				(2 + [ 0, 3, 6, 10, 13 ]), // dim
				(3 + [ 0, 4, 7, 11, 14 ]), // maj
				(5 + [ 0, 3, 7, 10, 14 ]), // min
				(7 + [ 0, 3, 7, 10, 13 ]), // min
				(8 + [ 0, 4, 7, 11, 14 ]), // maj
				(10 + [ 0, 4, 7, 10, 14 ]), // maj
			].do { |chord|
				chord.sort.postln.do { |int|
					play.(\saw, bar, [freq: noteHz.(int, 0)]);
					[0].do { |oct|
						play.(\pad, bar, [freq: noteHz.(int, oct)]);
					};
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 7).wait;
	};
}).play;
)







(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;
// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				// [ 0, 2, 3, 5, 7, 8, 10 ]
				// 2-5-1 jazz standard
				(2 + [ 0, 3, 6, 10, 13 ]), // dim
				(7 + [ 0, 3, 7, 10, 13 ]), // min
				(0 + [ 0, 3, 7, 10, 14 ]), // min
				(0 + [ 0, 3, 7, 10, 14 ]), // min
			].do { |chord|
				chord.sort.postln.do { |int|
					// play.(\saw, bar, [freq: noteHz.(int, 0)]);
					play.(\pad, bar, [freq: noteHz.(int, 1)]);
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 4).wait;
	};
}).play;
)


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;
// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				// [ 0, 2, 3, 5, 7, 8, 10 ]
				// aeolian
				(0 + [ 0, 3, 7, 10 ]), // root (min)
				(3 + [ 0, 4, 7, 11 ]), // b3rd maj
				// chromatic mediants
				(0 + [ 0, 3, 7, 10 ]), // root (min)
				(3 + [ 0, 3, 7, 10 ]), // b3rd min
				// chromatic mediants
				(0 + [ 0, 3, 7, 10 ]), // root (min)
				(4 + [ 0, 4, 7, 11 ]), // 3rd maj
				// chromatic mediants
				(0 + [ 0, 3, 7, 10 ]), // root (min)
				(4 + [ 0, 3, 7, 10 ]), // 3rd min


			].do { |chord|
				chord.sort.postln.do { |int|
					// play.(\saw, bar, [freq: noteHz.(int, 0)]);
					play.(\pad, bar, [freq: noteHz.(int, 0)]);
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 8).wait;
	};
}).play;
)


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;
// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(1, {
			[
				// [ 0, 2, 3, 5, 7, 8, 10 ]
				// aeolian
				(0 + [ 0, 3 + 12, 7, 17 ]), // root (min)
				(3 + [ 0, 4 + 12, 7, 11 ]), // b3rd maj
				// (5 + [ 0, 3, 7, 14 ]), // min
				// (7 + [ 0, 3, 7, 10 -12 ]), // min
			].do { |chord|
				chord.sort.postln.do { |int|
					play.(\saw, bar, [freq: noteHz.(int, 0)]);
					play.(\pad, bar, [freq: noteHz.(int, 0)]);
				};
				(bar).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 2).wait;
	};
}).play;
)



(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 112;
bar = beat * 4;
tatum = beat / 4;
root = 48;
// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		// chords subroutine ////////////////////////////////////////////
		subroutine.(2, {
			[0, 11, 5, 4, 9, 11, 5, 4].do { |int|
				seq.(\saw, beat, [freq: noteHz.(int, 0)]);
			};
		});
		subroutine.(1, {
			[
				(0 + [ 0, 4, 7, 11, 17 ]),
				(-3 + [ 0, 3, 7, 8, 14 ]),
			].do { |chord|
				chord.sort.postln.do { |int|
					play.(\pad, bar * 2, [freq: noteHz.(int, 0)]);
					play.(\pad, bar * 2, [freq: noteHz.(int, 1)]);
				};
				(bar * 2).wait;
			};
		});
		// global loop wait //////////////////////////////////////////////
		(bar * 4).wait;
	};
}).play;
)


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine, eighth;
s = Server.default;
beat = 60 / 112;
bar = beat * 4;
tatum = beat / 4;
eighth = beat / 2;
root = 48;

// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play   = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args) } };
seq    = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args) }; (dur).wait };
subroutine = { |num=1, sequence| fork { num.do { sequence.() } } };

// scheduling
Routine({
    loop {
        subroutine.(1, {
            // bar 1
            [3, 5, 8, 7,  3, 5, 7, 5].do { |int| seq.(\saw, eighth, [freq: noteHz.(int, 0)]) };
            // bar 2
            [3, 5, 8, 7,  3, 5, 7, 5].do { |int| seq.(\saw, eighth, [freq: noteHz.(int, 0)]) };
            // bar 3
            [5, 8, 3, 8,  5, 8, 3, 8].do { |int| seq.(\saw, eighth, [freq: noteHz.(int, 0)]) };
            // bar 4
            [7, 8, 10, 8,  7, 5, 3, 0].do { |int| seq.(\saw, eighth, [freq: noteHz.(int, 0)]) };
        });

        subroutine.(1, {
            [
                [ 0, [0, 3, 7, 10], 2],
                [ 1, [0, 4, 7],     1],
                [ 0, [0, 3, 7, 10], 1]
            ].do { |entry|
                var off = entry[0], ints = entry[1], bars = entry[2], dur = bar * bars;
                (off + ints).sort.do { |int|
                    play.(\pad, dur, [freq: noteHz.(int, 0)]);
                    play.(\pad, dur, [freq: noteHz.(int, 1)]);
                };
                dur.wait;
            };
        });
        (bar * 4).wait;
    };
}).play;
)
















// endfile...