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