(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(53 * (1 + (4 * Env.perc(0, 0.13, curve: -5).ar * velocity)) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (3 * Env.perc(0.01, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3320, 0.3) * Env.perc(0.001, 0.03).ar);
	snd = snd.clip2;
	snd = BLowShelf.ar(snd, 200, 0.4, 5);
	snd = snd ! 2;
	snd = snd * -4.dbamp;
	snd = snd * Env.perc(0.01, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kick2, {
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
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(

SynthDef(\snapClap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1420, 0.4) * 25.dbamp;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.3], curve: -12).ar;
	snd = snd + CombN.ar(snd, 0.08, 0.08, 0.3, 0.1);
	snd = snd * -8.dbamp;
	snd = snd ! 2;
	snd = snd * Env.perc(0.0, 1.0).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\sub, {
	var snd;
	snd = SinOsc.ar(60).cubed.cubed;
	snd = snd * Env.linen(0.01, 1, 0.2, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0, 1);
	Out.ar(0, snd);
}).play;
)

(
SynthDef(\deepBass, {
	var snd;
	snd = SinOsc.ar(XLine.ar(500, 50, 0.01) * (LFNoise2.kr(1 ! 16) * 10).midiratio);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 300, 3, 0.8);
	snd = snd.tanh;
	snd = snd * Env([0, 1, 0.1, 1, 0], [0.03, 0.01, 0.03, 5.0], curve: -8).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\rumble, {
	var snd;
	snd = SinOsc.ar(70 * (LFNoise2.kr(1 ! 16) * 10).midiratio);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 300, 3, 0.8);
	snd = (snd * 4.dbamp).tanh;
	snd = LPF.ar(snd, 300) + HPF.ar(snd, 3000);
	snd = snd * Env.perc(0.1, 2, curve: 8).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Saw.ar(\freq.kr(60) * XLine.ar(0.1.midiratio, 1, duration));
	snd = snd + LPF.ar(CombC.ar(snd, 0.2, 1 / XLine.ar(58, 59, duration), 0.3), 600);
	snd = snd * Env.perc(duration / 2, duration / 2, curve: \sin).ar;
	snd = BHiShelf.ar(snd, 1200, 0.3, 2);
	snd = BPF.ar(snd, (0..40).normalize.linexp(0, 1, 70, 3000), 0.01).sum;
	snd = snd * 10.dbamp;
	snd = RLPF.ar(snd, XLine.ar(\startCutoff.kr(100), \endCutoff.kr(8000), duration), 0.9);
	snd = snd.fold2;
	snd = snd * -1.dbamp;
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0], [1, 9, 1].normalizeSum * duration, curve: \sin).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Saw.ar(\freq.kr(60));
	snd = RLPF.ar(snd, [800, 1200] * XLine.ar(1, [0.7, 1.3], duration), 0.2).sum;
	snd = snd * 4.dbamp;
	snd = snd.fold2;
	snd = Latch.ar(snd, Impulse.ar(ExpRand(2000, 8340)));
	snd = snd * -5.dbamp;
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0], [1, 9, 1].normalizeSum * duration, curve: \sin).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


















// endfile