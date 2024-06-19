(
SynthDef(\fmBass, {|freq=60, cRatio=3, mRatio=1, index=2|
	var snd, mod, env;
	env = Env.perc(0.05, 1).ar.linlin(0, 1, 1, index);
	mod = SinOsc.ar(freq * mRatio) * (freq * mRatio * env);
	snd = SinOsc.ar(freq * cRatio + mod);
	snd = snd.clip2;
	snd = RLPF.ar(snd, Env.perc(0.2, 2).ar.linlin(0, 1, 60, 300), 0.8);
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play
)

(
SynthDef(\keyflip, {
	var snd, freq;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [2, 3]) * 200;
	snd = snd.sum;
	snd = SinOsc.ar(freq + snd);
	// snd = snd * Env([0, 10, 0.5, 1], [0.001, 0.01, 0.001], curve: -4).ar;
	snd = snd.fold2;
	snd = snd * Env.perc(0.1, 3.0, curve: -10).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)