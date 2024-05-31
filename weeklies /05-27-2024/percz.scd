(
SynthDef(\seedPerc, {
	var snd, random, state;
	state = \seed.kr(0);
	random = {
		state = Hasher.kr(state);
	};
	snd = SinOsc.ar(
		random.().linexp(-1, 1, 30, 1000)
		* ({ random.().linlin(-1, 1, 0, 12) } ! 3).midiratio
		* (1 + (random.().linlin(-1, 1, 0, 16) * Env.perc(0, random.().linlin(-1, 1, 0.001, 0.05)).ar))
	);
	snd = snd * [0, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(random.().linexp(-1, 1, 1e-4, 1e-2), random.().linexp(-1, 1, 0.03, 0.5), curve: random.().linlin(-1, 1, 1, -4)).ar;
	snd = snd * (1 + (Env.perc(0, random.().linexp(-1, 1, 0.003, 0.01)).ar * random.().linlin(-1, 1, 0, 5)));
	snd = (snd * random.().linlin(-1, 1, 10, -8).dbamp).clip2;
	snd = Pan2.ar(snd, random.() * 0.5) + GVerb.ar(snd * random.().linlin(-1, 1, -15, -30).dbamp, random.().linexp(-1, 1, 1, 50), random.().linexp(-1, 1, 1, 5));
	snd = snd + PitchShift.ar(snd * 3.dbamp, random.().linexp(-1, 1, 0.002, 0.05), random.().linexp(-1, 1, 0.5, 2));
	snd = snd * Env.perc(0, random.().linexp(-1, 1, 0.2, 0.7)).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\sbKick, {
	var snd;
	snd = SinOsc.ar(60 * (1 + (4 * Env.perc(0, 0.1).ar)) * (1 + (4 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.02).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\ghostSbKick, {
	var snd;
	snd = SinOsc.ar(60 * (1 + (2 * Env.perc(0, 0.1).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (1 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.02).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(270 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.4, 4.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.19).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7720, 0.3) * Env.linen(0.01, 0.3, 0.01).ar * (1 + SinOsc.ar(16)) * -23.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.001, 0.11).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 30, 3, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.1, 1.6);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.06, 2.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.02, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\ghostSnare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(270 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.4, 4.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.05).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.001, 0.01).delay(0.025).ar);
	snd = snd * (1 + (1 * Env.perc(0.03, 0.02).ar));
	snd = snd * 1.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -17.dbamp, 30, 1, 0.9);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.02, 1.6);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare2, {
	var snd;
	snd = SinOsc.ar(370 * (1 + (1 * Env.perc(0, 0.01).ar)) * [1, 2.3, 7.8]);
	snd = snd * Env.perc([0.02, 0.01, 0.05], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -13].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6720, 0.3) * Env.perc(0.003, 0.04).delay(0.005).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3720, 0.2) * Env.perc(0.001, 0.02).delay(0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4020, 0.3) * Env.perc(0.001, 0.01).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 15.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -17.dbamp, 20, 1, 0.9);
	snd = snd * (1 + (2 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare3, {
	var snd;
	snd = SinOsc.ar(290 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 3.4, 6.8]);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.01, 0.029).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.01, 0.045).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.02, 0.31).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.01, 0.4).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 50, 3, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.15, 1.8 * XLine.kr(1, 2, 0.1));
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.13, 1.1);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.127, 1.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.024, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\ghostSnare3, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(290 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 3.4, 6.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.01, 0.029).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.01, 0.045).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.02, 0.31).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.01, 0.4).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 0.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 50, 3, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.08, 1.8 * XLine.kr(1, 2, 0.1));
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.13, 1.1);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.127, 1.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.024, 1.4);
	snd = LPF.ar(snd, 3000);
	snd = snd * Line.ar(0, 1, 0.01);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickSophie, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (16 * Env.perc(0.001, 0.03).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8600, 0.3) * -15.dbamp * Env.perc(0.05, 0.3).ar);
	snd = snd * \velocity.kr(1);
	snd = snd + ((snd * 10.dbamp).tanh * -10.dbamp);
	snd = snd + ((snd * 3.dbamp).fold2 * -10.dbamp);
	snd = snd + (snd * 10).tanh;
	snd = snd + snd.fold2;
	snd = (snd * (1 + Env.perc(0.001, 0.1).ar)).clip2;
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareSophie, {
	var snd;
	snd = SinOsc.ar(210 * (1 + (4 * Env.perc(0.001, 0.05).ar)) * [1, 1.75, 2.6, 4.3]);
	snd = snd * Env.perc(0.001, [1, 0.3, 0.2, 0.1]).ar;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2100, 0.3) * 5.dbamp * Env.perc(0.05, 0.3).ar);
	snd = snd + LPF.ar((snd * 20.dbamp).tanh, 8000);
	snd = snd + (CombC.ar(snd, 0.1, 1 / 120, 0.3) * -10.dbamp);
	snd = snd + PitchShift.ar(snd, 0.03, 2.6);
	snd = snd + PitchShift.ar(snd, 0.05, 3.6);
	snd = snd * (1 + (SinOsc.ar(1400) * -5.dbamp));
	snd = snd * (1 + (SinOsc.ar(5000) * -10.dbamp));
	snd = snd * Env.perc(0.001, 0.3, curve: -2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-12.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clap, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), [1520, 1320, 1730] * 1.1 * scale, 0.3) * 25.dbamp;
	snd = Splay.ar(snd, 0.5);
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] / scale, -4).ar;
	snd = snd + GVerb.ar(snd.sum * -10.dbamp, 30, 1);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clap2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1700, 0.3) * -3.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15], curve: -2).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -25.dbamp, 30, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd, n, scale;
	n = (1..20).normalize.squared;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, n.linexp(0, 1, 5000, 16000), 0.005) * 5.dbamp;
	snd = snd * Env.perc(n.linexp(0, 1, 0.02, 0.01), n.linexp(0, 1, 0.07, 0.05)).ar;
	snd = snd.sum;
	snd = snd + PitchShift.ar(snd, 0.013, 0.5);
	snd = snd + GVerb.ar(snd * -5.dbamp, 3, 1, 0.9);
	snd = snd * Env.linen(0.0, \duration.kr(0.1), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		60
		* ([-1, 1] * 0.3).midiratio
		* (1 + (3 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.5 * Env.perc(0.001, 0.4, curve: -4).ar))
	);
	snd = snd * (1 + (5 * Env.perc(0, 0.04).ar));
	snd = snd + (Env.perc(0.01, 0.03).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 3120, 0.5) * 3.dbamp);
	snd = snd + (Env.perc(0.001, 0.01).ar * BPF.ar(Hasher.ar(Sweep.ar + [2, 3]), 8120, 0.5) * 20.dbamp);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 1.3).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		230
		* [1, 2.3, 3.8, 4.8]
		* (1 + (0.3 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.01 * Env.perc(0.0, 0.1, curve: -4).ar))
	);
	snd = snd * Env.perc(0, [1, 0.3, 0.1, 0.05]).ar;
	snd = snd * [0, -20, -25, -20].dbamp;
	snd = snd.sum;
	snd = snd + (Env.perc(0.02, 0.05).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 2120, 0.5) * 15.dbamp);
	snd = snd * (1 + (5 * Env.perc(0, 0.01).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.001).ar));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3, curve: -2.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\perc, {
	var snd;
	snd = SinOsc.ar(920 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + GVerb.ar(snd * -15.dbamp, 10);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\perc2, {
	var snd;
	snd = SinOsc.ar(420 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd + Latch.ar(GVerb.ar(snd * -15.dbamp, 3), Impulse.ar(8320));
	snd = snd * Env.perc(0.0, 0.5).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\clickRandom, {
	var snd, ratios;
	ratios = ExpRand(1, 8 ! 3);
	snd = SinOsc.ar(XLine.ar(ExpRand(5e3, 16e3) ! 3, ExpRand(400, 1000) ! 3, ExpRand(1e-4, 1e-2) ! 3) * ratios) * Env.perc(0, ExpRand(0.001, 0.02) / ratios).ar;
	snd = snd.sum;
	snd = snd * LPF.ar(PinkNoise.ar * 17.dbamp, 500);
	snd = (snd * Rand(0, 10).dbamp).fold2;
	snd = snd + CombC.ar(snd, 0.2, 1 / ExpRand(50, 300), ExpRand(0.01, 0.03));
	snd = FreqShift.ar(HPF.ar(snd, 20), Rand(-200, 1000));
	snd = snd * Rand(-2, 5).dbamp;
	snd = LPF.ar(snd, ExpRand(1000, 16000));
	snd = Pan2.ar(snd, Rand(-0.8, 0.8)) + GVerb.ar(snd * -5.dbamp, ExpRand(5, 30), ExpRand(1, 3), 0.3);
	3.do {
		snd = snd + PitchShift.ar(snd, ExpRand(0.01, 0.04), ExpRand(0.5, 3));
	};
	snd = snd * Env([0, 1, 0.3, 1, 0], [ExpRand(1e-3, 1e-2), ExpRand(0.001, 0.03), 0.001, ExpRand(0.05, 0.3)], curve: -8).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\fm, {
	var snd;
	snd = SinOsc.ar(ExpRand(1000, 8000)) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd);
	snd = (snd * 10).fold2;
	snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, ExpRand(0.01, 0.5), 0.0, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickHell, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(58 * (1 + (3 * Env.perc(0.001, 0.03).ar) * velocity) * (1 + (0.5 * Env.perc(0.001, 0.3).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareHell, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(228 * (1 + (0.5 * Env.perc(0.003, 0.012).ar)) * [1, 1.6, 3.5, 6.4, 8.8]);
	snd = snd * Env.perc(0, [1, 0.6, 0.3, 0.05, 0.1]).ar;
	snd = snd * [0, -2, -5, -8, -12].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (1.6 * Env.perc(0, 0.07).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(2.0), 2310, 0.3) * Env.perc(0.03, 0.16).ar * -2.dbamp);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16000));
	snd = (snd * -3.dbamp).clip2;
	snd = snd * Env.perc(0.001, \decay.kr(1) * 0.7, curve: -1).ar;
	snd = snd * -5.dbamp;
	snd = snd * velocity;
	snd = snd * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp + GVerb.ar(snd * -15.dbamp, 10, 3);
	snd = snd * Env.perc(0.0, 3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareHell2, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(198 * (1 + (0.5 * Env.perc(0.003, 0.012).ar)) * [1, 1.6, 3.5, 6.4, 8.8]);
	snd = snd * Env.perc(0, [1, 0.6, 0.3, 0.05, 0.1]).ar;
	snd = snd * [0, -2, -5, -8, -12].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (1.6 * Env.perc(0, 0.07).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2310, 0.3) * Env.perc(0.03, 0.16).ar * 5.dbamp * velocity);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16000));
	snd = (snd * -3.dbamp).clip2;
	snd = snd * Env.perc(0.001, 0.7 * velocity, curve: -0.5).ar;
	snd = snd * -8.dbamp;
	snd = snd * velocity;
	snd = snd * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp + GVerb.ar(snd * -15.dbamp, 10, 3);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\metallic, {
	var snd, ratio, velocity;
	velocity = \velocity.kr(1);
	ratio = \transpose.kr(1).midiratio;
	snd = SinOsc.ar(720 * ratio * [1, 1.6, 2.3, 7.8]);
	snd = snd * Env.perc(0.003, [1, 0.3, 0.1, 0.03] * velocity).ar;
	snd = snd.sum * SinOsc.ar(1820 * ratio * [1, 1.4, 2.8, 3.8]).sum;
	snd = snd * (1 + (3 * Env.perc(0.0, 0.03).ar * velocity));
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd + PitchShift.ar(snd, 0.03, 1.3, pitchDispersion: 0.01);
	snd = snd + PitchShift.ar(snd, 0.07, 1.6, pitchDispersion: 0.01);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.01, 0.6, pitchDispersion: 0.01);
	snd = snd * Env.perc(0.001, 0.4 * velocity.sqrt, curve: -2).ar(Done.freeSelf);
	snd = snd * velocity.linlin(0, 1, 0.8, 1);
	snd = snd * \amp.kr(1) * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickThing, {
	var snd, clickDuration, velocity;
	velocity = \velocity.kr(1);
	clickDuration = 2e-3;
	snd = SinOsc.ar(59 * [-1, 1].midiratio * (1 + (7 * Env.perc(0.001, 0.03).ar * velocity)) * (1 + (0.5 * Env.perc(0.001, 0.5).ar * velocity)));
	snd = Select.ar(Sweep.ar > clickDuration, [Hasher.ar(Sweep.ar), DelayC.ar(snd, clickDuration, clickDuration)]);
	snd = (snd * (1 + (3 * Env.perc(0, 0.1).ar * velocity))).tanh;
	snd = snd + (GVerb.ar(snd.sum, 12, 3, damping: 0.3) * -28.dbamp);
	snd = (snd * (1 + (0.3 * Env.perc(0, 0.1).ar))).tanh;
	snd = snd * Env.perc(0.0, 1 * velocity.sqrt).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapThing, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [1320, 1120, 1200], 0.3) * 15.dbamp;
	snd = snd * Env([0, 8, 0.4, 0], [0.001, 0.01, 0.3], curve: -4).delay([0, 2, 1.3] * 17e-3).ar;
	snd = (snd * 3).clip2;
	snd = Splay.ar(snd, spread: 0.4);
	snd = snd + (GVerb.ar(snd.sum, 20, 5, damping: 0.3) * -12.dbamp);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\randomThing, {
	var snd, random, randomState;
	randomState = \seed.kr(0);
	random = {
		randomState = Hasher.kr(randomState);
		randomState;
	};
	snd = SinOsc.ar(random.().linexp(-1, 1, 100, 8000)) * 3000 * Env.perc(0.01, random.()).ar.linexp(-1, 1, 0.03, 0.3);
	snd = SinOsc.ar(random.().linexp(-1, 1, 100, 8000) + snd) * 8000 * Env.perc(0.01, random.()).ar.linexp(-1, 1, 0.03, 0.3);
	snd = SinOsc.ar(random.().linexp(-1, 1, 1200, 3000) + snd);
	snd = snd * Env.linen(0.001, \duration.kr(0.03), 0.01).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1) * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickBreak, {
	var snd;
	snd = SinOsc.ar(60 * [1, 2.3, 3.4, 1.3, 2.5, 3.8] * (1 + (4 * Env.perc(0.01, 0.03).ar)) * (1 + (0.3 * Env.perc(0, 0.3).ar)));
	snd = snd * Env.perc(0.0, ([9, 2, 3, 4, 1, 1, 7] / 9) * 0.5).ar;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8120, 0.5) * Env.perc(0.001, 0.03).ar * -2.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3120, 0.3) * Env.perc(0.03, 0.06).ar * -2.dbamp);
	snd = (snd * 3.dbamp).clip2 + (snd.fold2 * -5.dbamp);
	snd = snd + (GVerb.ar(snd, 10, 3) * -20.dbamp);
	snd = snd * -7.dbamp;
	snd = snd * Env.adsr(0.001, 0.7, 0, 0.01).ar(Done.freeSelf, Impulse.kr(0) + \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareBreak, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(225 * [1, 1.2, 2.1, 3.5, 4.8, 5.2] * \transpose.kr(0).midiratio);
	snd = snd * Env.perc(0.0, ([3, 1, 1, 2, 0.3, 0.1] / 3) * 1 * velocity).ar;
	snd = snd * ([0, -3, -5, -7, -10, -12].dbamp);
	snd = snd * (1 + (SinOsc.ar(610) * Env.perc(0.001, 0.3).ar));
	snd = snd * (1 + (SinOsc.ar(310) * Env.perc(0.001, 0.5).ar));
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.02).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.5) * Env.perc(0.001, 0.03).ar * -2.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2120, 0.3) * Env.perc(0.03, 0.25).ar * 10.dbamp);
	snd = (snd * 3.dbamp).clip2 + (snd.fold2 * -5.dbamp);
	snd = (snd * 3.dbamp).tanh;
	snd = snd + (GVerb.ar(snd, 10, 3) * -20.dbamp);
	snd = snd + PitchShift.ar(snd * 5.dbamp * velocity, 0.03, 1.3);
	snd = snd + PitchShift.ar(snd * 5.dbamp * velocity, 0.02, 0.6);
	snd = snd * -7.dbamp;
	snd = snd * (1 + (2 * Env.perc(0.001, 0.05).ar));
	snd = snd * Env.adsr(0.001, 0.4 * velocity, 0, 0.03, curve: -1).ar(Done.freeSelf, Impulse.kr(0) + \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatBreak, {
	var snd;
	snd = SinOsc.ar(6328 * [1, 1.2, 1.3, 1.5]) * Env.perc(0, 0.1 * [1, 1.3, 0.5, 0.4]).ar;
	snd = snd.sum * (1 + (SinOsc.ar(10328 * [1, 0.6, 1.4, 1.8]) * Env.perc(0, 0.1 * [1, 1.3, 0.5, 0.4]).ar).sum);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = (snd * 3).tanh;
	snd = (snd * -3.dbamp) + (BPF.ar(Hasher.ar(Sweep.ar), 12320, 0.3) * 12.dbamp);
	snd = MoogFF.ar(snd, 12e3, 0) * 5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -5.dbamp;
	snd = snd * Env.adsr(0.001, 0.3, 0, 0.01, curve: -3).ar(Done.freeSelf, Impulse.kr(0) + \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\gabberKick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (5 * Env.perc(0, 0.05).ar)) * ([-1, 1] * 0.1).midiratio * (1 + (0.3 * Env.perc(0, 1.2, curve: -8).ar)));
	snd = snd * (1 + (4 * Env.perc(0, 0.3).ar));
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar + [0, 1]) * -5.dbamp, 3210, 0.3);
	snd = snd + (DelayC.ar(snd, 0.1, SinOsc.ar(0.5, [0, pi]).linlin(-1, 1, 0, 1) * 5e-3));
	snd = (snd * 30).tanh + ((snd * 3.2).fold2 * -5.dbamp);
	snd = snd * Env.asr(0.0, 1, 0.3).ar(Done.none, Impulse.kr(0) + \gate.kr(1));
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = BHiShelf.ar(snd, 3000, 0.3, -5);
	snd = RLPF.ar(snd, XLine.kr(8000, 500, 0.5), 0.5);
	snd = (snd * 10).clip2 + ((snd * 1.1).wrap2 * -5.dbamp);
	snd = BLowShelf.ar(snd, 300, 0.3, 8);
	snd = BHiShelf.ar(snd, 8000, 0.3, 3);
	snd = snd * -5.dbamp;
	snd = snd * Env.adsr(0.001, 0.7, 0.3, 1).ar(Done.freeSelf, Impulse.kr(0) + \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickAlgo, {
	var snd;
	snd = SinOsc.ar(
		60
		* ([-1, 1] * 0.3).midiratio
		* (1 + (3 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.5 * Env.perc(0.001, 0.4, curve: -4).ar))
	);
	snd = snd * (1 + (5 * Env.perc(0, 0.04).ar));
	snd = snd + (Env.perc(0.01, 0.03).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 3120, 0.5) * 3.dbamp);
	snd = snd + (Env.perc(0.001, 0.01).ar * BPF.ar(Hasher.ar(Sweep.ar + [2, 3]), 8120, 0.5) * 20.dbamp);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 1.3).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		230
		* [1, 2.3, 3.8, 4.8]
		* (1 + (0.3 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.01 * Env.perc(0.0, 0.1, curve: -4).ar))
	);
	snd = snd * Env.perc(0, [1, 0.3, 0.1, 0.05]).ar;
	snd = snd * [0, -20, -25, -20].dbamp;
	snd = snd.sum;
	snd = snd + (Env.perc(0.02, 0.05).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 2120, 0.5) * 15.dbamp);
	snd = snd * (1 + (5 * Env.perc(0, 0.01).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.001).ar));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3, curve: -2.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\kickComp, {
	var snd;
	snd = SinOsc.ar(
		60 * (1 + (3 * Env.perc(0.001, 0.1).ar))
		* (1 + (16 * Env.perc(0.0, 0.01).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.fold2;
	snd = snd * Env.perc(0, 0.9).ar;
	snd = snd * (1 - Env.perc(0.001, 0.01).ar);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1);
	snd = snd * Env.perc(0, 1.2).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareComp, {
	var snd;
	snd = SinOsc.ar(
		260 * (1 + (3 * Env.perc(0.001, 0.01).ar))
		* (1 + (1 * Env.perc(0.0, 0.01).ar))
		* [1, 3.4, 7.8, 12.3]
	);
	snd = snd * [0, -9, -12, -14].dbamp;
	snd = snd * Env.perc(0, [1.0, 0.1, 0.05, 0.01]).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.fold2;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2310, 0.3) * Env.perc(0.05, 0.1).ar * 5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd, 0.02, 1.3);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.013, 1.9);
	snd = snd.blend(CombC.ar(snd, 0.2, 1 / 120, 0.3), \comb.kr(0));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = snd * Env.linen(0.001, 0.1, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareComp2, {
	var snd;
	snd = SinOsc.ar(
		290 * (1 + (3 * Env.perc(0.001, 0.01).ar))
		* (1 + (1 * Env.perc(0.0, 0.01).ar))
		* [1, 1.4, 2.8, 6.3]
	);
	snd = snd * [0, -9, -12, -14].dbamp;
	snd = snd * Env.perc(0, [1.0, 0.1, 0.05, 0.01]).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.fold2;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2310, 0.3) * Env.perc(0.05, 0.1).ar * 5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd, 0.02, 1.3);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.013, 1.9);
	snd = snd.blend(CombC.ar(snd, 0.2, 1 / 90, 0.1), \comb.kr(0));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = snd * Env.linen(0.001, 0.5, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatComp, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [6230, 7330, 12310], 0.03) * 8.dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.03)) * Env.perc(0.001, 0.03).ar);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.001, 0.04, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapComp, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1350, 0.3) * 9.dbamp;
	snd = RLPF.ar(snd, XLine.kr(6000, 500, 1.0), 0.3);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 0.5, 1, 0.5, 1, 0], [0.001, 0.02, 0.001, 0.01, 0.001, ExpRand(0.1, 1.0)], curve: -6).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\metalComp, {
	var snd, ratio, duration, velocity;
	velocity = \velocity.kr(1);
	ratio = \ratio.kr(1);
	duration = \duration.kr(1);
	snd = SinOsc.ar(
		2060 * (1 + (3 * Env.perc(0.001, 0.01).ar))
		* [1, 3.4, 6.8, 3.3]
		* ratio;
	);
	snd = snd * Env.perc(0.001, [0.3, 0.1, 0.05, 0.03]).ar;
	snd = snd.sum;
	snd = snd * (1 + (SinOsc.ar(312) * Env.perc(0, 0.3).ar));
	snd = snd * 5.dbamp * velocity;
	snd = snd.tanh;
	snd = snd * (1 + Env.perc(0, 0.03).ar);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 100, 8000));
	snd = snd + PitchShift.ar(snd, 0.03, Hasher.kr(ratio).linexp(0, 1, 0.5, 2));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.0, 1.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickTrance, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.07).ar.linexp(0, 1, 60, 1000) * XLine.kr(1, 0.5, 0.3)) * -2.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(900, 90, 0.03)) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10312, 0.3) * Env.linen(0.01, 0.03, 0.01, curve: -4).ar * -4.dbamp);
	snd = snd * (1 + (2 * Env.perc(0, 0.03).ar));
	snd = snd.fold2 + snd.tanh;
	snd = snd * Env.perc(0.003, 0.9, curve: -8).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatTrance, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12.3e3], 0.1);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.01, 0.02, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatOpenTrance, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12.3e3], 0.05);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.04, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\perc1Trance, {
	var snd;
	snd = SinOsc.ar(420 * [1, 2.4, 2.8, 3.8]);
	snd = snd * [0, -10, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0, [0.1, 0.03, 0.001, 0.03]).ar;
	snd = snd * (1 + (10 * Env.perc(0, 0.001).ar * \velocity.kr(1)));
	snd = snd.clip2;
	snd = snd * \velocity.kr(1).sqrt;
	snd = LPF.ar(snd, \velocity.kr(1).linexp(0, 1, 1000, 16e3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3120, 0.3) * Env.perc(0, 0.01).ar * 8.dbamp);
	snd = snd * Env.perc(0.005, 0.12 * \velocity.kr(1), curve: -9).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

Synth(\perc1Trance, [velocity: 6]);

(
SynthDef(\perc2Trance, {
	var snd;
	snd = SinOsc.ar(820 * [1, 2.4, 2.8, 3.8]);
	snd = snd * [0, -5, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0, [0.1, 0.01, 0.001, 0.03]).ar;
	snd = snd * (1 + (10 * Env.perc(0, 0.001).ar * \velocity.kr(1)));
	snd = snd.clip2;
	snd = snd * \velocity.kr(1).sqrt;
	snd = LPF.ar(snd, \velocity.kr(1).linexp(0, 1, 1000, 16e3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7120, 0.3) * Env.perc(0, 0.003).ar * 8.dbamp);
	snd = snd * Env.perc(0.005, 0.09 * \velocity.kr(1), curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\perc3Trance, {
	var snd;
	snd = SinOsc.ar(1020 * [1, 2.4, 2.8, 3.8]);
	snd = snd * [0, -5, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0, [0.1, 0.01, 0.001, 0.03]).ar;
	snd = snd * (1 + (10 * Env.perc(0, 0.001).ar * \velocity.kr(1)));
	snd = snd.clip2;
	snd = snd * \velocity.kr(1).sqrt;
	snd = LPF.ar(snd, \velocity.kr(1).linexp(0, 1, 1000, 16e3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7120, 0.3) * Env.perc(0, 0.003).ar * 8.dbamp);
	snd = snd * Env.perc(0.005, 0.09 * \velocity.kr(1), curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\subCharli, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (3 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -7.dbamp];
	snd[1] = snd[1] * Env.perc(0, 0.5).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2.0).ar;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * (1 + (6 * Env.perc(0, 0.02).ar));
	snd = snd.tanh;
	// snd = (snd * 8.dbamp).tanh;
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapCharli, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1700, 0.3) * -3.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15], curve: -2).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -25.dbamp, 30, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\glitter, {
	var snd;
	snd = WhiteNoise.ar;
	snd = 10.collect {
		FreqShift.ar(CombC.ar(snd * (1 + (0.5 * LFNoise2.kr(7))) * (1 + (0.3 * LFNoise2.kr(30))), 0.1, 1 / (ExpRand(500, 1000) * (LFNoise2.kr(3) * 0.3).midiratio), 1.0), ExpRand(1000, 5000))
	};
	snd = Splay.ar(snd) * -10.dbamp;
	snd = BPF.ar(snd, 9120, 0.3);
	3.do {
		snd = HPF.ar(snd, 8000);
	};
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickCrescendo, {
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

(
SynthDef(\snareCrescendo, {
	var snd;
	snd = SinOsc.ar(170 * XLine.ar(3, 1, 0.01)) * Env.perc(0.001, 0.1).ar;
	snd = snd + (SinOsc.ar(460 * XLine.ar(3, 1, 0.01)) * Env.perc(0.001, 0.1).ar * -6.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2430 * XLine.ar(1, 0.9, 0.1), 0.3) * Env.perc(0.05, 0.1, curve: -1).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4430 * XLine.ar(0.9, 1, 0.1), 0.3) * Env.perc(0.09, 0.03).ar * 1.dbamp);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * 6.dbamp;
	snd = snd + DelayC.ar(Latch.ar(snd * -10.dbamp, Impulse.ar(1300)), 0.01, 0.01);
	snd = snd + DelayC.ar(Latch.ar(snd * -10.dbamp, Impulse.ar(8300)), 0.02, 0.013);
	snd = snd.tanh;
	snd = snd * Env([0, 1, 0], [0.001, 1.0], curve: -4).ar;
	snd = (snd * -9.dbamp) + HPF.ar(GVerb.ar(snd * -10.dbamp, 40, 3, 0.7), 100);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * Env.linen(0.0, 3, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\rideCrescendo, {
	var snd, freqs, velocity;
	velocity = \velocity.kr(1);
	freqs = ((0..50) ** 0.9).normalize.linexp(0, 1, 4120, 10400);
	snd = Ringz.ar(Hasher.ar(Sweep.ar + freqs) * Env.perc(0.001, 0.01).ar, freqs, 10 * ((freqs.minItem / freqs) ** 1.5) * ExpRand(1, 2 ! freqs.size));
	snd = snd * (freqs.minItem / freqs).squared;
	snd = snd * (1 + LFNoise2.ar(50 * (freqs / freqs.minItem) * (1 + (2 * velocity))));
	snd = snd * (1 + (SinOsc.ar(4000 + (3000 * freqs.sin)) * Env.perc(0, ExpRand(0.5, 2 ! snd.size)).ar));
	snd = snd.sum;
	snd = snd * -35.dbamp;
	snd = snd.tanh;
	snd = snd + (Hasher.ar(Sweep.ar) * Env.perc(0, 0.01).ar * velocity);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -17.dbamp * Env.perc(0.05, 0.5).ar, 3200, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -17.dbamp * Env.perc(0.1, 0.9).ar, 5200, 0.1);
	snd = RHPF.ar(snd, 9120 * ExpRand(0.9, 1.1), 0.4);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 6000, 16200));
	snd = snd + PitchShift.ar(snd, ExpRand(0.05, 0.04), ExpRand(0.7, 0.75));
	snd = snd + PitchShift.ar(snd, 0.1, 0.6);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3);
	snd = snd * velocity;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.01, 0.001), 2.0, curve: -2).ar;
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.03, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickGlitchy, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(60 * (1 + (3 * Env.perc(0, 0.19, curve: -6).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.003).ar));
	snd = snd.tanh;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.001, 0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * Env.perc(0.02, 0.05).ar * -1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7320, 0.3) * Env.perc(0.0, 0.05).ar * 3.dbamp);
	snd = snd * (1 + (2 * Env.perc(0, 0.05).ar));
	snd = snd.clip2;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -17.dbamp, 0.1, [0.045, 0.065]), 100), 3000);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\ghostKickGlitchy, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(60 * (1 + (2 * Env.perc(0, 0.19, curve: -6).ar)) * (1 + (1 * Env.perc(0, 0.01).ar)) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.003).ar));
	snd = snd.tanh;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.001, 0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * Env.perc(0.02, 0.05).ar * -1.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.5).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [0.045, 0.065]), 100), 3000);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareGlitchy, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(220 * XLine.ar(1, 0.9, 0.3) * XLine.ar(2, 1, 0.02));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(1e-3, 0.02).ar);
	snd = snd + (SinOsc.ar(XLine.ar(8000, 1000, 0.02)) * Env.perc(1e-3, 0.02).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2320, 0.3) * Env.perc(0.01, 0.05).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3320, 0.3) * Env.perc(0.07, 0.3).ar * 4.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd + PitchShift.ar(snd, 0.023, 1.5);
	snd = snd + PitchShift.ar(snd, 0.01, 1.2);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.045, [2.3, 2.4]);
	snd = snd + FreqShift.ar(CombC.ar(snd * -1.dbamp, 0.2, 1 / (230 * XLine.kr(1, 0.5, 0.3)), 0.1), 70);
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd.tanh;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [0.035, 0.055]), 200), 3000);
	snd = snd + GVerb.ar(snd.sum * -40.dbamp, 30, damping: 0.1);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatGlitchy, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * 5.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12320, 0.1) * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.1) * -3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 13320, 0.05) * 3.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, 0.1).ar;
	snd = snd + GVerb.ar(snd, 7, 3);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapGlitchy, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [1523, 2230], 0.3).sum * 9.dbamp;
	snd = snd * Env([0, 1, 0, 1, 0, 1, 0], [1e-3, 1e-2, 1e-3, 1e-2, 1e-3, 0.1]).ar;
	snd = snd ! 2;
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)
