(
SynthDef(\partials, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(
		freq * [1, 2, 3, 4, 5, 6, 7] + (LFNoise2.ar(8) * 2).midiratio,
		[0, 0.5pi, 0.1pi, 0, 0.3pi, 0, 0],
		[1, 0.8, 0.6, 0.2, 0.1, 0.02, 0.01]
	);
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd * -20.dbamp ! 2);
}).add;
SynthDef(\fx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = GVerb.ar(snd.sum * -12.dbamp, 10, 1, 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~fxBus = Bus.audio(nil, 2);
)

~fxBus.index;

(
var s, root, beat;
s = Server.default;
root = 62;
beat = 60 / 110;
Routine({
	var fx;
	fx = Synth(\fx, [in: ~fxBus]);
	loop {
		[0, 0, 3, 1].do { |bassNote|
			[0, 3, 7, 10].do { |interval, index|
				(index).postln;
				Synth(\partials, [freq: (root + bassNote + interval).midicps, out: ~fxBus]);
			};
			beat.wait;
		};

	}
}).play;
)

(
var root;
root = 62;
[0, 3, 7, 10].do { |interval| // min 7th
	Synth(\partials, [freq: (root + interval).midicps]);
};
)

(
var root;
root = 62;
[0, 4, 7, 10].do { |interval| // 7th
	Synth(\partials, [freq: (root + interval).midicps]);
};
)


