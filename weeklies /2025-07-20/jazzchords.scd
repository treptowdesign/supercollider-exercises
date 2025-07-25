(
SynthDef(\sineKey, {
	var snd, velocity, duration;
	duration = \duration.kr(3);
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440) * XLine.ar(1.1, 1.0, 0.01));
	snd = snd * Env.perc(0.001, 3.0).ar;
	snd = snd * (1 + (2 * Env.perc(0, 0.15).ar));
	snd = snd * (1 + (0.15 * SinOsc.ar(3, [0, pi] + Rand(0, pi))));
	snd = snd.tanh;
	snd = snd * -13.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(100));
	snd = snd * \freq.kr(100).explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 6000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -8.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
[0, 3, 7, 10].do { | deg|
	Synth(\sineKey, [freq: (52 + deg + (12 * 0)).midicps, amp: 1]);
	// Synth(\sineKey, [freq: (52 + deg + (12 * 0)).midicps, amp: 0.2]);
};
)

(
var s, beat, root, play;
s = Server.default;
beat = 60 / 110;
root = 53;

play = { |synth, duration, args|
	s.bind {
		Synth(synth, [duration: duration] ++ args);
	};
};

Routine({
	'- - - - - - - - - -'.postln;
	loop {
		[
			(notes: (0 + [0, 3, 10, 17]).sort.postln, length: beat * 4),
			(notes: (8 + [0, 3 - 12, 10 -12, 8]).sort.postln, length: beat * 4),
			(notes: (7 + [0, 7, 10 -12, 3 - 12]).sort.postln, length: beat * 4),
			(notes: (3 + [0, 4, 11 - 12, 7]).sort.postln, length: beat * 4),
		].do { |chord|
			chord[\notes].do { |deg, index|
				play.(\sineKey, chord[\length], [freq: (root + deg + (12 * 1)).midicps, amp: 0.5]);
				play.(\sineKey, chord[\length], [freq: (root + deg + (12 * 0)).midicps, amp: 1]);
			};
			play.(\sub, chord[\length], [freq: (root + chord[\notes][0] + (12 * -1)).midicps]);
			(chord[\length]).wait;
		};
	};
}).play;

)