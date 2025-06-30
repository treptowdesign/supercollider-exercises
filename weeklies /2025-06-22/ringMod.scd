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


(
x = {
    MoogFF.ar(
        in: Pulse.ar([40, 121], [0.3, 0.7]),
        freq: SinOsc.kr(
			LFNoise0.kr(0.42).range(0.001, 2.2)
		).range(30, 4200),
        gain: 0.75 * 4
	)
}.play(s);
)

