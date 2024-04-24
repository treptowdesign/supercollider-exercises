// bussing and fx
(
SynthDef(\smpleSin1, { // combL
	var snd;
	snd = SinOsc.ar(440);
	snd = snd + CombL.ar(snd, 0.4, 0.1, 4);
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\smpleSin2, { // combL
	var snd;
	snd = SinOsc.ar(440);
	snd = snd + CombC.ar(snd, 0.4, 0.1, 4);
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\smpleSin3, { // combL
	arg freq=440;
	var snd;
	snd = SinOsc.ar(freq);
	// snd = snd + CombN.ar(snd, 0.4, 0.1, 8);
	snd = snd * Env.perc(0.01, 1).ar; // actual shape of the sound
	snd = snd * Env.linen(0, \duration.kr(0.2), 0.1, curve: -4).ar(Done.freeSelf); // overall dratation, cuts off if needed
	Out.ar(0, snd * -10.dbamp ! 2);
}).add;
)

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 41;
scale = Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]

Routine({
	loop {
		[
			[1, 5, 10],
			[0, 3, 7]
		].do { |chord|
			chord.do { |deg|
				s.bind { Synth(\smpleSin3, [freq: (root + deg + (12 * 2)).midicps]); };
			};
			beat.wait;
		};

	};
}).play;

)