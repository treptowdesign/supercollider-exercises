(
SynthDef(\partials, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 1.5, 2, 3, 4], 0, [1, 0.1, 0.4, 0.2, 0.06]);
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)


