(
SynthDef(\fmBass, {|freq=60, cRatio=2, mRatio=1, index=2|
	var snd, mod, env;
	env = Env.perc(0.1, 0.8).ar.linlin(0, 1, 1, index);
	mod = SinOsc.ar(freq * mRatio) * (freq * mRatio * env);
	snd = SinOsc.ar(freq * cRatio + mod);
	snd = RLPF.ar(snd, Env.perc(0.1, 2).ar.linlin(0, 1, 60, 300), 0.8);
	snd = snd.tanh;
	snd = snd * Env.perc(0.01, 3).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play
)