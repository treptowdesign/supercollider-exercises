

(
SynthDef(\src, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 2, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 11.991) * 1;
	snd = SinOsc.ar(freq * 8.009, snd.mod(2pi)) * 0.5;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\src1, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 2, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 12) * 1;
	snd = SinOsc.ar(freq * 8, snd.mod(2pi)) * 0.5;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\chords, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 4, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 8.991) * 0.5;
	snd = SinOsc.ar(freq * 4.009, snd.mod(2pi)) * 0.1;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	Out.ar(\out.kr(0), snd);
}).add;
)


(
(32 + 2 + [0, 15, 19, 22]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)


(
(32 + 0 + [0, 16, 19, 23]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + 5 + [0, 16, 19, 11]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + 7 + [0, 16, 7, 11]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + 9 + [0, 15, 7, 10]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)





(
(32 + [0, 16, 18, 23]).do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + [0, 15, 19, 22]).do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + [0, 15, 17, 22]).do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
var s, bpm, beat, root, scale, play;
s = Server.default;
bpm = 130;
beat = 60 / bpm;
root = 32;
scale = Scale.ionian.degrees;
play = { |synth, duration, args = #[]|
	s.bind { Synth(synth, [duration: duration] ++ args) };
	(duration).wait;
};
Routine({
	loop {
		var dur, note;
		dur = beat/2;
		note = root + scale.choose + (12 * (0..3).choose);
		play.(\src, dur, [freq: note.midicps]);
	};
}).play;
)