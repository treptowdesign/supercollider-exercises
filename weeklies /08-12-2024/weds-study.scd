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
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(230 * XLine.ar(1.4, 1, 0.005) * [1, 2.3, 4.5]);
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 830, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.3 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 90);
	snd = BPF.ar(snd, [12240, 6230, 10832, 9830, 8320], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -15.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -26.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.23, 1 / 120, 1);
	snd = FreqShift.ar(snd, -34);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -33.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\analog, {
	var snd, freq, duration;
	freq = \freq.kr(440);
	duration = \duration.kr(0.1);
	snd = SinOsc.ar(freq) * Rand(500, 1000);
	snd = SinOsc.ar(freq + snd);
	snd = snd * -5.dbamp;
	snd = MoogFF.ar(snd, XLine.ar(ExpRand(1000, 8000), ExpRand(100, 800), 0.2), 2) * 5.dbamp;
	snd = snd * (1 + Env.perc(0, 0.3).ar);
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * -12.dbamp;
	snd = snd * Env.perc(0.02, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\analog2, {
	var snd, freq, duration;
	freq = \freq.kr(440 * -3.midiratio) * Demand.ar(Impulse.ar(1 / \noteDuration.kr(0.1)), 0, Dseq([3, 5, 2, 3, 0, -5], inf)).lag(0.01).midiratio;
	snd = Pulse.ar(freq, SinOsc.ar(0.23).linlin(-1, 1, 0.5, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.1).linexp(-1, 1, 200, 3000), 3.4) * 5.dbamp;
	snd = snd.tanh;
	snd = Pan2.ar(snd, -0.5);
	snd = snd * -15.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(10.0), 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\analog3, {
	var snd, freq, duration;
	freq = \freq.kr(440 * -3.midiratio) * Demand.ar(Impulse.ar(1 / \noteDuration.kr(0.1)), 0, Dseq([-5, 0, 2, 3, 5, 7], inf)).lag(0.01).midiratio;
	snd = LFTri.ar(freq * (SinOsc.ar(3) * 0.2).midiratio, SinOsc.ar(0.23).linlin(-1, 1, 0.5, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.15).linexp(-1, 1, 200, 3000), 2);
	snd = snd.tanh;
	snd = Pan2.ar(snd, 0.5);
	snd = snd * -17.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(10.0), 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\analogAeolian, {
	var snd, freq, duration;
	freq = \freq.kr(440) * Demand.ar(Impulse.ar(1 / \noteDuration.kr(0.1)), 0, Dseq([0, 2, 3, 5, 7, 8, 10], inf)).lag(0.01).midiratio;
	snd = LFTri.ar(freq * (SinOsc.ar(3) * 0.2).midiratio, SinOsc.ar(0.23).linlin(-1, 1, 0.5, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.15).linexp(-1, 1, 200, 3000), 2);
	snd = snd.tanh;
	snd = Pan2.ar(snd, 0.5);
	snd = snd * -17.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(10.0), 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

Scale.ionian.degrees;

(
SynthDef(\analogIonian, {
	var snd, freq, duration;
	freq = \freq.kr(440) * Demand.ar(Impulse.ar(1 / \noteDuration.kr(0.1)), 0, Dseq([0, 2, 4, 5, 7, 9, 11 ], inf)).lag(0.01).midiratio;
	snd = LFTri.ar(freq * (SinOsc.ar(3) * 0.2).midiratio, SinOsc.ar(0.23).linlin(-1, 1, 0.5, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.15).linexp(-1, 1, 200, 3000), 2);
	snd = snd.tanh;
	snd = Pan2.ar(snd, 0.5);
	snd = snd * -17.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(10.0), 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

















// end...