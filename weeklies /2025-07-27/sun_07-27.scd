
(
SynthDef(\fmChords, {
	var snd, wet, freq, duration;
	freq = \freq.kr(330) * Line.kr(0.98, 1, 0.1);
	duration = \duration.kr(3);
	snd = SinOsc.ar(freq * [1, 2, 5]) * ([100, 80, 60] * ({LFNoise2.kr(4).range(0.1, 2)} ! 3));
	snd = SinOsc.ar(freq + snd, (pi / [1, 2, 3]) * SinOsc.ar(2).range(1, 0.5pi));
	// snd = Pan2.ar(snd.sum, 0, \amp.kr(1) * -28.dbamp);
	// snd = snd.tanh;
	snd = Splay.ar(snd, 1, \amp.kr(1) * -22.dbamp);
	2.do { snd = HPF.ar(snd, 100); };
	snd = snd * freq.explin(400, 1000, 1, 0.25);
	snd = snd * (2 + Env.perc(0, 0.2).ar);
	snd = snd * Env.perc(0.01, 6).ar;
	// snd = snd * Env.linen(0, span, 0.1).ar;
	snd = snd * Env.linen(0, duration, 0.1).ar.(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, bar, root, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 51; // D#/Eb

play = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
};

Routine({
	loop {
		[
			(notes: [0, 5, 7, 17], length: bar),
			(notes: [0, 3, -5, 10], length: bar),
			(notes: [0, 5, 10, 14], length: bar),
			(notes: [0, 3, -4, 15], length: bar)
		].do { |chord|
			var freq;
			chord[\notes].sort.do { |deg|
				freq = (root + deg + (12 * 0)).midicps;
				play.(\fmChords, chord[\length], [freq: freq]);
			};
			chord[\length].wait;
		};
	};
}).play;

)



{([200, 200, 40] * ({LFNoise2.kr(4).range(0.1, 2)} ! 3))}.plot(2);

{(pi / [1, 2, 3]) * SinOsc.ar(1).range(1, 0.5)}.plot(2);

(
[0, 3, 7, 10, 17, 14, 21].postln.do { |deg|
	Synth(\fmChords, [freq: (51 + deg + (12 * 0)).midicps]);
};
)


(51 + 21 + 12).midicps;

{ SinOsc.ar(220, 0, 0.3) ! 2 }.play

(
var freq = 70;

)