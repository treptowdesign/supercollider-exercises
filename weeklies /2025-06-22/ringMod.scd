(
SynthDef(\basicSine, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.001, 1).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\ring, {
	var snd, carFreq, modFreq;
	carFreq = \carFreq.kr(440);
	modFreq = \modFreq.kr(300) * (Env.perc(0.001, 2).ar);
	snd = LFTri.ar(carFreq) * LFTri.ar(modFreq);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), snd);
}).play;
)


{800 * Env.perc(0.001, 1).kr}.plot(1)