//////////////////////////////////////////////////////////////////
// Drum Kit - IDM
//////////////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar().linexp(0, 1, 56, 600) * XLine.ar(2, 1, 0.005) * XLine.ar(1, 0.8, 0.1));
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar * -3.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -45.dbamp, 0.1, [60e-3, 40e-3]), 200), 3000);
	snd = snd * Env.linen(0.0, 0.3, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd, ring, duration;
	duration = \duration.kr(1.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), 10320 * [0.7, 1.0, 1.2], 0.1);
	snd = snd.sum;
	ring = SinOsc.ar(3230);
	ring = ring * SinOsc.ar(9440);
	ring = ring * Env.perc(0.001, 0.01).ar * 3.dbamp;
	snd = snd + ring;
	snd = snd.clip2;
	snd = HPF.ar(snd, 7000);
	snd = snd * 5.dbamp;
	snd = snd * Env.perc(0.01, 0.3, curve: -7).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [60e-3, 40e-3]), 1000), 8000);
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, { // Closed
	var snd, ring;
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), 10320 * [0.7, 1.0, 1.2], 0.1);
	snd = snd.sum;
	ring = SinOsc.ar(3230);
	ring = ring * SinOsc.ar(9440);
	ring = ring * Env.perc(0.001, 0.02).ar * 5.dbamp;
	snd = snd + ring;
	snd = snd.clip2;
	snd = HPF.ar(snd, 6000);
	snd = snd * 5.dbamp;
	snd = snd * Env.perc(0.005, 0.03).ar(Done.freeSelf);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [60e-3, 40e-3]), 1000), 8000);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\splash, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 520, 0.1) * 10.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 1520, 0.5) * -5.dbamp * Env.perc(0.02, 0.5).ar);
	snd = snd * Env.perc(0.01, 3.0).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

//////////////////////////////////////////////////////////////////
// Drum Kit - DNB
//////////////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.5]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar;
	snd = snd * [0, -8, -13].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4230, 0.3) * Env.perc(0.07, 0.15).ar * -15.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230, 0.3) * Env.perc(0.05, 0.07).ar * -12.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1230, 0.3) * Env.perc(0.01, 0.03).ar * -5.dbamp);
	snd = snd * (1 + (10 * Env.perc(0.0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * 5.dbamp;
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(920 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -7.dbamp;
	snd = snd * Env.perc(0.0, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [60, 230, 345], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 10342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Splay.ar(snd, 0.3);
	snd = snd * -23.dbamp;
	snd = snd * Env.perc(0.02, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [70, 330, 445], 0.3);
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = BPF.ar(snd, [5430, 7342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -20.dbamp;
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [90, 430, 145], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 9342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0.3));
	snd = snd * -20.dbamp;
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

//////////////////////////////////////////////////////////////////
// Drum Kit - Noise
//////////////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.25).ar.linexp(0, 1, 60, 320) * XLine.ar(1, 0.8, 0.7));
	snd = snd * Env.perc(0, 0.8).ar;
	snd = snd * (1 + Env.perc(0, 0.03).ar);
	snd = snd.clip2;
	snd = snd * 10.dbamp;
	snd = snd.tanh;
	snd = snd + HPF.ar((snd * 10.dbamp).fold2, 1200);
	snd = snd + HPF.ar((snd * 5.dbamp).wrap2, 923);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(260 * [1, 3.2, 5.6] * XLine.ar(1.5, 1, 0.003));
	snd = snd * Env.perc(0.001, [0.1, 0.02, 0.01]).ar;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2320, 0.3) * Env.perc(0.03, 0.1).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4320, 0.1) * Env.perc(0.01, 0.05).delay(0.005).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 320, 0.4) * Env.perc(0.024, 0.01).delay(0.0023).ar * 10.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.1) * Env.perc(0.001, 0.01).delay(0.01).ar * 6.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 520, 0.1) * Env.perc(0.001, 0.01).delay(0.03).ar * 6.dbamp);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd.clip2;
	snd = snd * 20.dbamp;
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.01, 1.7);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.024, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.014, 1.3);
	snd = snd + CombC.ar(snd * -23.dbamp, 0.2, 1 / 46, 0.24);
	snd = snd + CombC.ar(snd * -23.dbamp, 0.2, 1 / 30, 0.1);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = BPeakEQ.ar(snd, XLine.ar(3000, 500, 0.3), 0.3, 5);
	snd = snd * 25.dbamp;
	snd = LeakDC.ar(snd);
	snd = snd.tanh;
	snd = snd + ((snd * 30.dbamp).clip2 * -1.dbamp);
	snd = snd * (1 + (0.7 * Env.perc(0, 0.12).ar));
	snd = snd * Env.linen(0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [230, 240, 642, 720], 0.7);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 320);
	snd = BPF.ar(snd, [1020, 3200, 4370], 0.3).sum + HPF.ar(snd, 5230);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * (1 + (5 * Env.perc(0, 0.02).ar));
	snd = (snd * 2.dbamp).clip2;
	snd = snd * (1 + (1 * Env.perc(0, 0.02).ar));
	snd = HPF.ar(snd, 4220);
	snd = snd * Env.perc(0, 0.2).ar;
	snd = snd * Env.linen(0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1420 * [0.8, 1, 1.2], 0.3);
	snd = snd * Env([0, 2, 1, 0], [0.001, 0.01, 0.18], -4).delay([0.01, 0, 0.023]).ar * 8.dbamp;
	snd = snd.sum;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -7.dbamp, 60, 0.5);
	snd = snd * Env.perc(0, 0.4, curve: -8).ar; // toggle...
	snd = snd * Env.linen(0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
)

//////////////////////////////////////////////////////////////////
// Drum Kit - abstract
//////////////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1, curve: -7).ar.linexp(0, 1, 60, 500 * ExpRand(0.5, 2)) * XLine.ar(1, 0.7, 0.1));
	snd = snd * (1 + (10 * Env.perc(0.0, 0.1 * ExpRand(0.5, 2)).ar * ExpRand(0.5, 2)));
	snd = snd.tanh;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.3).ar * -10.dbamp, 7520, 0.2);
	snd = snd + (Latch.ar(snd, Impulse.ar(8e3) * ExpRand(0.5, 2)) * -10.dbamp);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.05, [15e-3, 38e-3]);
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1, curve: -7).ar.linexp(0, 1, 200, 390));
	snd = snd * Env.perc(0.001, 0.1 * ExpRand(0.5, 2)).ar;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.04).ar, 2520, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.01, 0.05).ar, 3520, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.001, 0.1).ar, 1520, 0.3);
	snd = snd + PitchShift.ar(snd * 5.dbamp, 0.02, 1.5 * ExpRand(0.5, 2));
	snd = snd + PitchShift.ar(snd * 1.dbamp, 0.025, 1.4 * ExpRand(0.5, 2));
	snd = snd * (1 + (5 * Env.perc(0.0, 0.05).ar));
	snd = snd.clip2;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.05, [25e-3, 38e-3]);
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd, freqs;
	snd = Hasher.ar(Sweep.ar);
	freqs = ((0..20) * 134789).sin.linexp(-1, 1, 100, 3e3);
	snd = CombC.ar(snd, 1 / freqs, 1 / freqs, 0.1);
	snd = snd.sum * -15.dbamp;
	snd = FreqShift.ar(snd, -230);
	snd = HPF.ar(snd, 1000);
	snd = BPF.ar(snd, [8230, 5240, 1230, 6.5e3, 7243], 0.05);
	snd = snd * Env.perc(0.01, 2.0 * [1, 0.5, 0.9, 0.1, 0.2, 0.3]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.02, 2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\perc, {
	var snd;
	snd = SinOsc.ar(920 * [1, 1.6] * \ratio.kr(1)).sum;
	snd = snd * Env.perc(0.001, 0.02).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



//////////////////////////////////////////////////////////////////
// FX Units
//////////////////////////////////////////////////////////////////

(
SynthDef(\drumFx, {
	var snd, trigger, fxChance;
	fxChance = \fxChance.kr(0);
	trigger = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);

	snd = (snd + LPF.ar(HPF.ar(GVerb.ar(snd.sum * -40.dbamp, 10, 1), 100), 3000)) * -2.dbamp;

	snd = SelectX.ar(((1 - (fxChance * TRand.ar(0, 1, trigger))) < 0.5).lag(0.01), [snd, CombC.ar(snd, 0.1, 1 / TExpRand.ar(60, 120, trigger), -0.2) * -3.dbamp]);
	snd = SelectX.ar(((1 - (fxChance * TRand.ar(0, 1, trigger))) < 0.3).lag(0.01), [snd, PitchShift.ar(snd * 3.dbamp, 0.03, 1.3)]);
	snd = SelectX.ar(((1 - (fxChance * TRand.ar(0, 1, trigger))) < 0.3).lag(0.01), [snd, PitchShift.ar(snd * 3.dbamp, 0.01, 1.6)]);
	snd = SelectX.ar(((1 - (fxChance * TRand.ar(0, 1, trigger))) < 0.3).lag(0.01), [snd, RLPF.ar(snd, LFNoise2.ar(3).linexp(-1, 1, 800, 3000), 0.3)]);

	snd = BLowShelf.ar(snd, 200, 0.3, -3);
	snd = BHiShelf.ar(snd, 3200, 0.3, -3);
	snd = (snd * 10.dbamp).tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 3);
	snd = BHiShelf.ar(snd, 3200, 0.3, 3);
	snd = snd * -5.dbamp;

	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\drumFx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = LeakDC.ar(snd);
	snd = SelectX.ar(\comb.ar(0, 0.02), [snd, CombC.ar(snd, 0.01, 60.reciprocal, 0.3)]);
	snd = SelectX.ar(\pitch.ar(0, 0.02), [snd, PitchShift.ar(snd, 0.034, LFNoise2.kr(0.3).exprange(0.5, 4)) * 1.dbamp]);
	snd = SelectX.ar(\freq.ar(0, 0.02), [snd, FreqShift.ar(snd, LFNoise2.kr(0.3).range(10, 100))]);
	snd = SelectX.ar(\filter.ar(0, 0.02), [snd, RHPF.ar(snd, LFNoise2.kr(5).exprange(100, 4000), 0.3)]);
	snd = SelectX.ar(\dec.ar(0, 0.02), [snd, Latch.ar(snd, Impulse.ar(LFNoise2.kr(3).exprange(4000, 16e3)))]);
	snd = snd + LPF.ar(GVerb.ar(snd.sum * -36.dbamp, 100, 1, damping: 0.9), 6e3);
	// snd = snd + (NHHall.ar(LPF.ar(snd * \rev.ar(0, 0.02), 4000), 2, earlyDiffusion: 0.9) * -15.dbamp);
	snd = BPeakEQ.ar(snd, 10200, 1, -3);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\drumFx, { // icarus nine fresian...
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 + (0.5 * LFNoise2.kr(16)));
	snd = snd + GVerb.ar(snd.sum * -40.dbamp, 90, 1, 0.9);
	snd = snd + PitchShift.ar(snd * ToggleFF.ar(Dust.ar(6)).lag(0.1) * -10.dbamp, 0.13, 0.7, 0.1, 0.1);
	snd = snd * (1 + (0.5 * LFNoise2.kr(16 ! 2)));
	snd = snd + PitchShift.ar(snd * ToggleFF.ar(Dust.ar(5)).lag(0.1) * -10.dbamp, 0.1, 1, 0.1, 0.1);
	snd = snd + PitchShift.ar(snd * -10.dbamp * Amplitude.ar(snd, 0.01, 0.1), 0.2, 1, 0.3, 0.3);
	snd = snd + PitchShift.ar(DelayC.ar(snd, 0.2, LFNoise2.kr(3).linlin(-1, 1, 0, 0.2)) * ToggleFF.ar(Dust.ar(5)).lag(0.1) * -10.dbamp, 0.1, 1, 0.1, 0.1);
	snd = snd + PitchShift.ar(DelayC.ar(snd, 1, LFNoise2.kr(3).linlin(-1, 1, 0.5, 1.0)) * ToggleFF.ar(Dust.ar(5)).lag(0.1) * -10.dbamp, 0.1, 2, 0.1, 0.1);
	snd = snd * (1 + (0.5 * LFNoise2.kr(16)));
	snd = LeakDC.ar(snd);
	snd = snd * 5.dbamp;
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\drumFx, { // noise
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = LeakDC.ar(snd);
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.02, 0.5);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.023, 2);
	snd = snd + PitchShift.ar(snd * -15.dbamp, 0.033, 2.3);
	snd = snd + HPF.ar(Latch.ar(snd, Impulse.ar(16e3)) * -10.dbamp, 2e3);
	snd = (snd * 10.dbamp).clip2 + (snd * 3.dbamp).fold2;
	snd = (snd * 4).round / 4;
	snd = BHiShelf.ar(snd, 1200, 0.3, 2);
	snd = BLowShelf.ar(snd, 300, 0.3, 3);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)





//////////////////////////////////////////////////////////////////
// Non Drums
//////////////////////////////////////////////////////////////////


(
SynthDef(\acid, {
	var snd, freq, trigger, velocity, introLength;
	introLength = \introLength.kr(0);
	velocity = \velocity.kr(1) * LFNoise2.ar(3).linlin(-1, 1, 0.2, 2).min(1);
	trigger = T2A.ar(\trigger.tr(1));
	freq = \freq.kr(60);
	snd = Pulse.ar(freq, 0.5);
	snd = MoogFF.ar(snd, Env.perc(0.01, velocity.linlin(0, 1, 0.05, 0.4)).ar(gate: trigger).linexp(0, 1, 20, velocity.linexp(0, 1, 500, 3000)) * LFNoise2.ar(0.3).linexp(-1, 1, 0.5, 2), LFNoise2.ar(0.3).linexp(-1, 1, 1, 3.5));
	snd = snd * velocity.linlin(0, 1, -5, 0).dbamp;
	snd = snd * Env.perc(0.001, velocity.linlin(0, 1, 0.25, 1.0)).ar(gate: trigger);
	snd = snd * 15.dbamp;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = BHiShelf.ar(snd, 3000, 0.3, -5);
	snd = snd.tanh + (snd.fold2 * -7.dbamp);
	snd = BLowShelf.ar(snd, 400, 0.3, 5);
	snd = snd * -3.dbamp;
	snd = snd * Line.ar(-5.dbamp, 1, introLength);
	snd = LPF.ar(snd, XLine.ar(1000, 16e3, introLength));
	snd = HPF.ar(snd, XLine.ar(8000, 10, introLength)) + HPF.ar(GVerb.ar(snd * XLine.ar(-10.dbamp, -25.dbamp, introLength), 20, 3), 200);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\lead, {
	var snd, freq, trigger, velocity, timeSinceTrigger;
	velocity = \velocity.kr(1) * LFNoise2.ar(3).linlin(-1, 1, 0.2, 2).min(1);
	trigger = T2A.ar(\trigger.tr(0));
	timeSinceTrigger = Sweep.ar(trigger);
	freq = \freq.kr(440).cpsmidi.lag(0.1).midicps;
	freq = freq * (SinOsc.ar(timeSinceTrigger.linlin(0, 1, 3, 6)) * timeSinceTrigger.min(0.5) * 0.6).lag(0.01).midiratio;
	snd = LFTri.ar(freq);
	snd = snd.tanh;
	snd = RLPF.ar(snd, SinOsc.ar(0.5).linexp(-1, 1, 300, 1000), 0.4);
	snd = snd * freq.explin(440, 1000, 0, -5).dbamp;
	snd = snd * Env.asr(0.1, 1.0, 0.3, curve: -4).ar(Done.none, \gate.kr(1));
	snd = snd + HPF.ar(GVerb.ar(snd * -15.dbamp, 20, 3), 1000);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\pad, {
	var snd, freq, duration;
	freq = \freq.kr(440);
	duration = \duration.kr(1.0);
	snd = Saw.ar(freq * (LFNoise2.ar(5 ! 10) * 0.3).midiratio * [1, 2, 0.5, 1, 1, 1, 1, 0.5, 2, 1]);
	snd = RLPF.ar(snd, LFNoise2.ar(4 ! snd.size).linexp(-1, 1, 1000, 4000), 0.3);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd * -5.dbamp, 1000) + HPF.ar(snd * 0.dbamp, 4230);
	snd = LPF.ar(snd, XLine.ar(\startFreq.kr(1000), \endFreq.kr(16e3), duration));
	snd = snd * Env.linen(0.1, duration, 0.3, curve: -4).ar(Done.freeSelf);
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0, 15, 19, 22]).do { |int|
	Synth(\pad, [freq: (50 + int + (12 * 0)).midicps]);
};
)

(
SynthDef(\chime, {
	var snd, freq;
	freq = \freq.kr(440);
	// snd = SinOsc.ar(freq * [3.04, 10.02, 34]) * Env.perc(0, [0.3, 0.5, 1.0]).ar * 3000;
	snd = SinOsc.ar((freq * [1.002, 2, 1]) + snd).sum;
	snd = snd * Env.perc(0.01, 3.0, curve: -4).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1, curve: -4).ar);
	snd = snd * -10.dbamp;
	snd = snd.clip2;
	snd = snd * 0.dbamp;
	snd = snd + PitchShift.ar(snd * -10.dbamp, ExpRand(0.1, 0.3), 2);
	snd = snd + LPF.ar(HPF.ar(GVerb.ar(snd * -10.dbamp, 30, 10), 300), 6000);
	snd = snd * Env.perc(0.001, 10.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0, 15, 19, 22]).do { |int|
	Synth(\chime, [freq: (50 + int + (12 * 1)).midicps]);
};
)

(
SynthDef(\sub, {
	var snd, freq, freqs;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [1, 2]);
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * -6.dbamp;
	snd = snd * Env.linen(0.05, \duration.kr(1.0) - 0.05, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)















//////////////////////////////////////////////////////////////////
// endfile...
//////////////////////////////////////////////////////////////////