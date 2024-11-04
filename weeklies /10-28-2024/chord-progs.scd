(
SynthDef(\piano, {
	var snd, duration;
	duration = \duration.kr(2);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 3] * (LFNoise2.kr(7 ! 3) * 0.1).midiratio);
	snd = snd * Env.perc(0, [5, 7, 4]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -15.dbamp, 10, 4, damping: 0.2);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.6).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp * \velocity.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\piano2, {
	var snd, duration;
	duration = \duration.kr(2);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 3, 4, 6] * (LFNoise2.kr(7 ! 3) * 0.2).midiratio);
	snd = snd * Env.perc(0, [5, 7, 4, 6, 2]).ar;
	snd = snd * [0, -5, -10, -20, -24].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -15.dbamp, 10, 4, damping: 0.2);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.6).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp * \velocity.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)


////////////////////////////////////////////////////////////////////
// Basic Rock I-V-vi-IV
(
var s, root, beat;
s = Server.default;
root = 42;
beat = 60 / 120;
Routine({
	var dur, note, octave, chordBass, chordIntervals;
	dur = beat;
	octave = 1;
	loop {
		[
			(intervals: 0 + [0, 4, 7], length: 2),
			(intervals: 7 + [0, 4, 7], length: 2),
			(intervals: 9 + [0, 3, 7], length: 2),
			(intervals: 5 + [0, 4, 7], length: 2),

		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\piano, [freq: note, duration: dur]); };
			};
			dur.wait;
		};
	};
}).play;
)

////////////////////////////////////////////////////////////////////
// Basic Rock I-V-vi-IV with 7ths
(
var s, root, beat;
s = Server.default;
root = 42;
beat = 60 / 120;
Routine({
	var dur, note, octave, chordBass, chordIntervals;
	dur = beat;
	octave = 1;
	loop {
		[
			(intervals: 0 + [0, 4, 7, 11], length: 2),
			(intervals: 7 + [0, 4, 7, 10], length: 2),
			(intervals: 9 + [0, 3, 7, 10], length: 2),
			(intervals: 5 + [0, 4, 7, 11], length: 2),

		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\piano, [freq: note, duration: dur]); };
			};
			dur.wait;
		};
	};
}).play;
)

////////////////////////////////////////////////////////////////////
// Basic Rock I-V-vi-IV with 7ths + drop root and 5th one octave
(
var s, root, beat;
s = Server.default;
root = 42;
beat = 60 / 120;
Routine({
	var dur, note, octave, chordBass, chordIntervals;
	dur = beat;
	octave = 2;
	loop {
		[
			(intervals: 0 + [-12, 4, -5, 11], length: 2),
			(intervals: 7 + [-12, 4, -5, 10], length: 2),
			(intervals: 9 + [-12, 3, -5, 10], length: 2),
			(intervals: 5 + [-12, 4, -5, 11], length: 2),

		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\piano, [freq: note, duration: dur]); };
			};
			dur.wait;
		};
	};
}).play;
)

////////////////////////////////////////////////////////////////////
// Basic Rock I-V-vi-IV with 9ths (omit 5ths)
(
var s, root, beat;
s = Server.default;
root = 42;
beat = 60 / 120;
Routine({
	var dur, note, octave, chordIntervals;
	dur = beat;
	octave = 1;
	loop {
		[
			(intervals: 0 + [0, 4, 11, 14], length: 2),       // Cmaj9 (C, E, B, D)
			(intervals: 7 + [0, 4, 10, 14], length: 2),      // G9 (G, F, A, B)
			(intervals: 9 + [0, 3, 10, 14], length: 2),      // Am9 (A, G, B, C)
			(intervals: 5 + [0, 4, 11, 14], length: 2),       // Fmaj9 (F, A, E, G)
		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\piano2, [freq: note, duration: dur]); };
			};
			dur.wait;
		};
	};
}).play;
)



