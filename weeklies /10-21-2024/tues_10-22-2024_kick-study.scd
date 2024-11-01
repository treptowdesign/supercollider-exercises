// Kicks
(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 60, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01;
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -10.dbamp;
	snd = BLowShelf.ar(snd, 100, 0.4, 2);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\subKick, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (3 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -7.dbamp];
	snd[1] = snd[1] * Env.perc(0, 0.5).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2.0).ar;
	snd = snd ! 2;
	snd = snd * -10.dbamp;
	snd = snd * (1 + (6 * Env.perc(0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (1 * Env.perc(0, 0.5, curve: -8).ar)) * (1 + (2 * Env.perc(0, 0.05, curve: -8).ar)) * [1, 2.3, 4.8]);
	snd = snd * [0, -20, -30].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10e3, 0.3) * Env.perc(0.01, 0.01).ar * -6.dbamp);
	snd = snd + (SinOsc.ar(XLine.ar(3000, 200, 0.01)) * Env.perc(0, 0.01).ar);
	snd = snd + (SinOsc.ar(XLine.ar(1000, 100, 0.005)) * Env.perc(0, 0.005).ar);
	snd = BPeakEQ.ar(snd, 600, 0.3, -5.0);
	snd = BPeakEQ.ar(snd, 720, 0.2, -5.0);
	snd = BPeakEQ.ar(snd, 1300, 0.14, -5.0);
	snd = snd * 1.dbamp;
	snd = (snd * (1 + (3 * Env.perc(0, 0.01).ar))).tanh;
	snd = snd * (1 + Env.perc(0, 0.05).ar);
	snd = LPF.ar(snd, 1200);
	snd = snd * Env([0, 1, 0.4, 0.9, 0], [0.01, 0.05, 0.09, 3.0], curve: -4).ar;
	snd = snd + LPF.ar(GVerb.ar(snd * -10.dbamp, 90, 1, damping: 0.9), 500);
	snd = snd * Env.linen(0, 3, 1, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)
