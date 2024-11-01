(
SynthDef(\partials, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(
		freq * [1, 2, 3, 4, 5, 6, 7],
		[0, 0.5pi, 0.1pi, 0, 0.3pi, 0, 0],
		[1, 0.8, 0.6, 0.2, 0.1, 0.02, 0.01]
	);
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2).ar(Done.freeSelf);
	Out.ar(0, snd * -20.dbamp ! 2);
}).play;
)

(
var root;
root = 62;
[0, 3, 7, 10].do { |interval|
	Synth(\partials, [freq: (root + interval).midicps]);
};
)

(
var s, root, beat;
s = Server.default;
root = 62;
beat = 60 / 110;
Routine({
	loop {
		[0, 0, 3, 1].do { |bassNote|
			[0, 3, 7, 10].do { |interval|
				Synth(\partials, [freq: (root + bassNote + interval).midicps]);
			};
			beat.wait;
		};

	}
}).play;
)


