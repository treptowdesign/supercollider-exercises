
(
SynthDef(\hissArca, {
	var snd;
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 20, 0.3);
	snd = BPF.ar(snd, [10120, 14230] * XLine.kr(0.5, 1, 2) * Rand(0.9, 1.1), 0.3).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.1, 0.1, 0.001, 0.01], curve: [2, 0.1, -2]).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\hiss2arca, {
	var snd;
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 200, 0.3);
	snd = BPF.ar(snd, [8120, 9230] * XLine.kr(1.2, 0.7, 0.3), 0.3).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 0.1, 0], [0.08, 0.3, 0.1], curve: -4).ar(Done.freeSelf);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatB, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1500 * [3.1, 6.4, 4.5, 6.7, 7.8, 9.3, 10.3], 0.05) * 15.dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = (snd * 4).clip2;
	snd = RHPF.ar(snd, 6320, 0.3) * 6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareAB, {
	var snd;
	snd = SinOsc.ar(
		319
		* (1 + (0.5 * Env.perc(0.0, 0.1, curve: -9).ar))
		* (1 + (0.3 * Env.perc(0.0, 0.03, curve: -4).ar))
		* [0.56, 1, 2.3, 3.4]
	);
	snd = snd * (Env.perc(0, [0.3, 3.0, 0.2, 0.1]).ar);
	snd = (snd * [-5, 0, -5, -3].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), [2420, 5420, 8329], 0.5)
		* Env.perc(0.05, 0.2).ar * [5, 0, -8].dbamp).sum;
	snd = (snd * 8.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.12, curve: -1).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snareB, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(
		260
		* [1, 2.3, 7.5, 9.8]
		* (1 + (2 * Env.perc(0, 0.03).ar))
	);
	snd = snd * Env.perc(0, [1, 0.2, 0.1, 0.03]).ar * [0, -5, -8, -10].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2130, 0.3) * Env.perc(0.03, 0.1).ar * 8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7130, 0.8) * Env.perc(0.08, 0.2).ar * -1.dbamp);
	snd = (snd * (1 + Env.perc(0, 0.1).ar)).clip2;
	snd = snd + Splay.ar(PitchShift.ar(snd, 0.03, [1.5, 1.8]), 0.6);
	snd = snd * velocity;
	snd = snd * Env.perc(0.001 / (1 + velocity), 0.2).ar(Done.freeSelf);
	snd = snd * -1.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapB, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1200 * [0.9, 1, 1.3], 0.2) * 30.dbamp;
	snd = snd * Env.perc(0.001, 0.2).delay([0, 4, 2] * 1e-2).ar;
	snd = Splay.ar(snd, 0.4);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 12345), 10320, 0.3) * Env.perc(0.03, 0.1).ar * 20.dbamp);
	snd = snd * Env.perc(0.0, 0.6, curve: -7).ar(Done.freeSelf);
	snd = snd.clip2;
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapB2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1300 * [0.9, 1, 1.3], 0.3) * 30.dbamp;
	snd = snd * Env.perc(0.001, 0.2).delay([0, 4, 2] * 1.3e-2).ar;
	snd = Splay.ar(snd, 0.4);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 12345), 10320, 0.3) * Env.perc(0.03, 0.1).ar * 20.dbamp);
	snd = snd * Env([0, 1, 0.1, 0], [0.0, 1, 0.3, 0.6], curve: -7).ar(Done.freeSelf);
	snd = snd.clip2;
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clapCxcx, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1700, 0.3) * -3.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15] * 0.5, curve: -2).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -30.dbamp, 10, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\kickAb, {
	var snd, velocity;
	velocity = \velocity.kr(1).clip(0, 1);
	snd = SinOsc.ar(
		69
		* (1 + (3 * Env.perc(0.0, 0.3, curve: -9).ar * velocity))
		* (1 + (8 * Env.perc(0.0, 0.01, curve: -4).ar * velocity))
		* [1, 2.3, 1.4]
	);
	snd = snd * (Env.perc(0, [3.0, 0.5, 0.1]).ar);
	snd = (snd * [0, -10, -15].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.8 * velocity.sqrt).ar(Done.freeSelf);
	snd = (snd * 5.dbamp * velocity).clip2;
	snd = snd * -7.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kickB, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(
		40
		* ([-1, 0, 1] * 0.3).midiratio
		* (1 + (Env.perc(0, 0.003).ar * 8 * velocity))
		* (1 + (Env.perc(0, 0.06).ar * 3))
		* (1 + (Env.perc(0, 0.2).ar * 1))
	);
	snd = snd * (1 + (10 * Env.perc(0.001, 0.1).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230, 0.3) * Env.perc(0.01, 0.03).ar * 8.dbamp);
	snd = (snd * 4.dbamp).clip2;
	snd = Splay.ar(snd, 0.3);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(0.001, 1.0).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
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










////////////////////////////////////////////
// Non Drums (basses, keys, etc)
////////////////////////////////////////////

(
SynthDef(\bass1B, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(16000, 100, duration), 0);
	snd = (snd * 3.dbamp).tanh;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass2B, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(ExpRand(100, 3000), ExpRand(300, 8000), duration), 2) * 5.dbamp;
	snd = (snd * 10.dbamp).tanh;
	snd = snd * Env.linen(0.05, duration - 0.05, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass3B, {
	var snd, duration, freq;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [-0.1, 0.1].midiratio);
	snd = snd * SinOsc.ar(2) * Line.kr(1, 0, duration);
	snd = ((snd * 3) + 0.2).fold2 + ((snd.sign - snd) * -10.dbamp);
	snd = HPF.ar(snd, 500);
	snd = snd.tanh;
	snd = snd + (SinOsc.ar(freq) * -3.dbamp);
	snd = BLowShelf.ar(snd, 100, 1, 5);
	snd = Limiter.ar(snd, 1, 0.001);
	snd = snd * Env.linen(0.1, duration - 0.1, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass1, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(16000, 100, duration), 0);
	snd = (snd * 3.dbamp).tanh;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\key, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * (LFNoise2.kr(3 ! 8) * 0.3).midiratio);
	snd = Splay.ar(snd);
	snd = Latch.ar(snd, Impulse.ar(XLine.kr(16000, 1000, duration)));
	snd = snd * Env.perc(0.001, duration, curve: -8).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\sub, {
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




























// endfile