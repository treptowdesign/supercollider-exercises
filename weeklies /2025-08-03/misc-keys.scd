(
SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(2, 1, 0.004);
	snd = SinOsc.ar(freq * 2) * Env.perc(0.01, 0.6).ar * 900;
	snd = SinOsc.ar(freq + snd);
	snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 5e-3) * LFNoise2.kr(12 ! 2) * 0.dbamp);
	snd = Pan2.ar(snd.sum, 0, 1);
	snd = snd * Env.perc(0.01, 10, curve: -10).ar(Done.freeSelf);
	snd = snd * -24.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0, 4, 7, 11].do { |int|
	Synth(\key, [freq: (51 + int + (12 * 1)).midicps]);
};
)