(
SynthDef(\partials, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 1.5, 2, 3, 4], 0, [1, 0.2, 0.8, 0.6, 0.1]);
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


