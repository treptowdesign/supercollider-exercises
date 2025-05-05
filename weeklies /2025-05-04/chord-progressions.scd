(
SynthDef(\keyWip, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.4), 100);
	snd = snd * SinOsc.ar(3, 0, 30, 220) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.2), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.06));
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 10, 3, 1);
	snd = snd * Env.perc(0.01, \rel.kr(3.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, beat, root;
s = Server.default;
beat = 60 / 96;
root = 50; // D
Routine({
	loop {
		[
			(notes: (5 + [-12, 5, 10, 14]), length: 2), // iv 11 (5 == 4th/11th)
			(notes: (10 + [-8, -2, 0, 7]), length: 2), // VII 6/5 (-8 == 6th)
			(notes: (0 + [0, 3, 7, 14]), length: 1.5), // i add9 (14 == 9th)
			(notes: (0 + [0, 10, 15, 19]), length: 2), // i7
			(notes: (10 + [-12, 0, 7]), length: 0.5), // vii (just root and 5th)
		].do { |chord|
			chord[\notes].do { |degree|
				s.bind { Synth(\key, [
					freq: (root + degree).midicps,
					duration: (beat * chord[\length]),
					bend: 0
				]); };
			};
			(beat * chord[\length]).wait;
		};
	};

}).play;
)

(
var root = 50;
(5 + [-12, 5, 10, 14]).do{ |degree|
	Synth(\keyWip, [freq: (root + degree).midicps]);
};
)

(
var root = 50;
(10 + [ -8, -2, 0, 7 ]).do{ |degree|
	Synth(\keyWip, [freq: (root + degree).midicps]);
};
)

(
var root = 50;
(0 + [0, 3, 7, 14]).do{ |degree|
	Synth(\keyWip, [freq: (root + degree).midicps]);
};
)

(
var root = 50;
(0 + [0, 10, 15, 19]).do{ |degree|
	Synth(\keyWip, [freq: (root + degree).midicps]);
};
)

(5 + [-12, 5, 10, 14]);
(10 + [ -8, -2, 0, 7 ]);
(0 + [0, 3, 7, 14]);
(0 + [0, 10, 15, 19]);

