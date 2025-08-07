(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1).clip(0, 1);
	snd = SinOsc.ar(
		XLine.ar(58, 50, 0.1)
		* (1 + (3 * Env.perc(0.0, 0.2, curve: -8).ar * velocity))
		* (1 + (3 * Env.perc(0.0, 0.01, curve: -4).ar * velocity))
		* [1, 2.3, 1.2]
	);
	snd = snd * (Env.perc(0, [1.0, 0.2, 0.1]).ar);
	snd = (snd * [0, -15, -10].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3420, 0.3) * Env.perc(0.001, 0.02).ar * 5.dbamp);
	snd = (snd * 2.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.5 * velocity.sqrt).ar(Done.freeSelf);
	snd = (snd * 5.dbamp * velocity).clip2;
	snd = snd * -6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
SynthDef(\sinSub, {
	var snd, dry, freq;
	freq = \freq.kr(80);
	snd = SinOsc.ar(freq) * -12.dbamp;
	snd = (snd * 2.dbamp).tanh + (snd * 2.dbamp).clip2;
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 8.dbamp).tanh, 400), 0.2, SinOsc.ar(2, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 2e-4);
	snd = dry + (snd * 0.dbamp);
	snd = snd * Env.perc(0.01, 4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)