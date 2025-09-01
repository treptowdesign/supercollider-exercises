(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.6]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar * [0, -5, -15].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (6 * Env.perc(0.0, 0.02).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10520, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 1, 4);
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -20.dbamp, 20, 3, 0.9), 600);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, [0.13, 0.1, 0.9]).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.2]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar * [0, -5, -15].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (6 * Env.perc(0.0, 0.02).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10520, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7520, 0.1) * Env.perc(0.001, 0.02).ar);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 1, 4);
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -18.dbamp, 20, 3, 0.9), 600);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.6]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar * [0, -5, -15].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (6 * Env.perc(0.0, 0.02).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10520, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd.tanh;
	snd = snd + FreqShift.ar(snd, 60, mul: -8.dbamp);
	snd = BLowShelf.ar(snd, 100, 1, 4);
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -12.dbamp, 20, 3, 0.9), 600);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)