(
SynthDef(\synth, { | freq = 330 |
	var snd;
	snd = SinOsc.ar(freq * [1, 2, 4, 7] * (LFNoise2.kr(4 ! 4) * 0.2).midiratio );
	snd = snd * [0, -5, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1.4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)


(
SynthDef(\strings, {
	var snd, freq, detune, rate;
	freq = \freq.kr(440);
	rate = 1;
	detune = ((LFNoise2.kr(3 * rate) * 0.3) + (LFNoise2.kr(8) * 0.1) + Line.kr(10, 0, 0.003)).midiratio;
	snd = SinOsc.ar(freq * IRand(1, 3 ! 8) * (LFNoise2.kr(3 ! 8 * rate) * 0.7).midiratio * detune) * 1000 * (1 + Env.perc(0.05 * ExpRand(0.5, 2.0), 0.3 * ExpRand(0.5, 2.0)).ar);
	snd = SinOsc.ar((freq * (LFNoise2.kr(3 ! 8 * rate) * 0.4).midiratio * detune) + snd);
	snd = snd * (1 + LFNoise2.ar(3 ! snd.size));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, LFNoise2.kr(3).linexp(0, 1, 400, 600));
	snd = snd * Env.linen(0.1, \duration.kr(5.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)