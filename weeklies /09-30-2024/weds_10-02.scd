//
(
SynthDef(\bassRumble, {
	var snd;
	snd = SinOsc.ar(70 * (LFNoise2.kr(1 ! 16) * 10).midiratio);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 300, 3, 0.8);
	snd = (snd * 4.dbamp).tanh;
	snd = LPF.ar(snd, 300) + HPF.ar(snd, 3000);
	snd = snd * Env.linen(0.1, \duration.kr(5.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\test, {
	var snd;
	snd = Saw.ar(100);
	snd = Splay.ar(snd);
	snd = snd.mean;
	snd = Pan2.ar(snd, 0);
	snd = snd * -8.dbamp;
	Out.ar(0, snd);
}).play;
)

(
SynthDef(\pls, {
	var snd;
	snd = Pulse.ar(\freq.kr(440), 0.4);
	snd = BPF.ar(snd, Env.perc(0, 0.6).ar.linlin(0, 1, 6000, 100), 0.3);
	snd = snd * Env.perc(0.1, 0.4).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0, 0.6));
}).play;
)

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
SynthDef(\snapClap, {
	var snd;
	snd = Hasher.ar(Sweep.ar); // noise equivalent
	// snd = WhiteNoise.ar;
	snd = BPF.ar(snd, 1420, 0.4) * 25.dbamp; // band pass
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.3], curve: -12).ar; // volume shape
	snd = Pan2.ar(snd, 0) * -10.dbamp; // 2 channel & global volume adjust
	snd = snd * Env.perc(0.0, 1.0).ar(Done.freeSelf); // final percussive shape
	Out.ar(\out.kr(0), snd);
}).play;
)