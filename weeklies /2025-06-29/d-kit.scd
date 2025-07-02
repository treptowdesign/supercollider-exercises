(
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(60 * (1 + (4 * Env.perc(0, 0.06).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	wet = snd + 0.1;
	wet = wet.clip2 + (wet.fold2 * -6.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + (DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]) * -14.dbamp);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(270 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.4, 5.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.12).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.15) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -8.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 20, 2, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.1, 1.6);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.06, 2.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.02, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(15e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clap, {
	var snd, wet, scale;
	scale = \scale.kr(1.25);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), [1420, 1320, 1120, 930] * 1.4, 0.2) * 30.dbamp;
	snd = Splay.ar(snd, 0.5);
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] * 0.5, -4).ar;
	wet = snd + 0.1;
	wet = (snd * 2.dbamp).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd + GVerb.ar(snd.mean * -26.dbamp, 10, 1);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
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



//////////////////////////////////////////////////////////////////////
// Notes
//////////////////////////////////////////////////////////////////////

// Drum FX: PitchShifting/thickening, Compression, SlapBack, Reverb, SaturateMids
// SideChain Fx

// Kick + GhostKick (or velocity control)
// Snare + GhostSnare (or velocity control)
// Clap (velocity/scale control)
// Hats, Open Hat(s), Ride/Cymbal
// Toms, Percs, Glitches













//////////////////////////////////////////////////////////////////////
// endfile
//////////////////////////////////////////////////////////////////////