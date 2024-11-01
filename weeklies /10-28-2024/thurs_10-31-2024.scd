(
SynthDef(\partials, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 2, 3, 4], 0, [1, 1/2, 1/3, 1/4].sqrt);
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)



[1, 1/2, 1/3, 1/4].sqrt;