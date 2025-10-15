(
SynthDef(\keys, {
	var snd, duration, freq;
	duration = \duration.kr(1.0);
	freq = \freq.kr(260) * ([-0.05, 0, 0.05] * LFNoise2.ar(20 ! 3)).midiratio;
	snd = SinOsc.ar(freq * 1.001) * 4 * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq, snd);
	snd = snd.sum * (-30.dbamp * \amp.kr(1)) ! 2;
	snd = snd * Env.perc(0.001, \rel.kr(1.6)).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
(0 + [0, 4 +12, 7, 11 +12]).do { |int|
	Synth(\keys, [freq: (50 + int + (12 * 0)).midicps]);
};
)

(
(0 + [0, 3 +12, 7, 10 +12]).do { |int|
	Synth(\keys, [freq: (50 + int + (12 * 0)).midicps]);
};
)

(
(0 + [0, 5 +12, 7, 10 +12]).do { |int|
	Synth(\keys, [freq: (50 + int + (12 * 0)).midicps]);
};
)


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
				chord[\length].do { |item, index|
					var dur = item * tatum;
					if(chord[\notes] != \, {
						chord[\notes].sort.postln.do { |int|
							[0].do { |oct| play.(\keys, dur, [freq: noteHz.(int, oct), amp: 1, out: 0]); };
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













// endfile