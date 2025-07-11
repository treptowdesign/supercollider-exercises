(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.06).ar.linexp(0, 1, 60, 1000) * XLine.ar(1, 0.5, 0.5) * XLine.ar(3, 1, 0.01));
	// snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3000, 0.3) * Env.perc(0.001, 0.03).ar);
	// snd = snd + (BPF.ar(Hasher.ar(Sweep.ar(Impulse.ar(79))), 1900, 0.3) * Env.perc(0.001, 0.13).delay([0.01, 0.02]).ar * 1.dbamp);
	// snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 9000, 0.5) * Env.perc(0.005, 0.07).delay(0.01).ar * -5.dbamp);
	snd = snd * (1 + (5 * Env.perc(0.0, 0.01).ar));
	snd = snd * Env.perc(0.001, 1).ar;
	snd = snd.tanh + (snd.fold2 * -30.dbamp);
	// snd = snd.tanh;
	// snd = BHiShelf.ar(snd, 2000, 0.3, 5);
	snd = BLowShelf.ar(snd, 200, 0.3, 5);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.1, [30e-3, 40e-3]), 300), 3000);
	// snd = snd ! 2;
	snd = snd * Env.linen(0.0, 1, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\hasherPerc, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(90)) + [0, 1]);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * Env.perc(0.001, 0.3, curve: 0).ar;
	snd = Latch.ar(snd, Impulse.ar(9320));
	snd = snd + GVerb.ar(snd.sum * -10.dbamp, 13, 3);
	snd = snd * Env.linen(0.0, 10.0, 3.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\blipTuned, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(Env([freq * 12, freq * 6, freq * 15, freq, freq* 9, freq * 3], [0.05, 0.05, 0.05, 0.05, 0.05, 0.05], \hold).ar);
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, 0.3, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)