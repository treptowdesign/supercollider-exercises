// Glitchy
// https://www.youtube.com/watch?v=y9igrFPzTTQ


(
SynthDef(\b1, {
	var snd, dur;
	dur = \dur.kr(0.5);
	snd = Pulse.ar(40);
	snd = BPF.ar(snd, XLine.ar(200, 900, dur), 0.2) * 20.dbamp;
	snd = (snd * 2.dbamp).tanh;
	snd = Latch.ar(snd, Impulse.ar(6200));
	snd = snd + GVerb.ar(snd * -10.dbamp, 20, 8, 1) * -8.dbamp;
	// snd = Pan2.ar(snd, 0);
	snd = snd * Env.linen(0, dur, 0.005, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd);
}).play;
)



(
SynthDef(\b2, {
	var snd, dur;
	dur = \dur.kr(2);
	snd = SinOsc.ar(440);
	snd = snd * VarSaw.kr(16, 0, 0).range(0, 1);
	snd = snd.tanh;
	snd = snd + Latch.ar(snd, Impulse.ar(500));
	snd = MoogFF.ar(snd, Saw.kr(7).range(200, 3000), 3.2) * 10.dbamp;
	snd = snd + GVerb.ar(snd * -10.dbamp, 5, 8, 0.8) * -8.dbamp;
	// snd = Pan2.ar(snd, 0);
	snd = snd * Env.linen(0.2, dur, 0.005, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd);
}).play;
)



(
SynthDef(\lead, {
	var snd, freq, duration;
	freq = \freq.kr(440).cpsmidi.lag(0.05).midicps;
	snd = Saw.ar(freq * [-0.1, -12, 0.1].midiratio * (SinOsc.ar(3, [0, 0.5pi, 1pi]) * 0.3).midiratio);
	snd = Splay.ar(snd);
	snd = BPeakEQ.ar(snd, 3120, 0.1, 3.3);
	snd = BPeakEQ.ar(snd, 6120, 0.1, 5.3);
	snd = BPeakEQ.ar(snd, 4120, 0.1, 7.3);
	snd = BPeakEQ.ar(snd, 1120, 0.1, 8.3);
	snd = (snd * 5).tanh;
	snd = CombC.ar(snd, 0.2, 1 / [60, 63], 1);
	snd = LPF.ar(snd, 3000) + HPF.ar(snd, 8e3);
	snd = snd * Env.asr(0.1, 1, 3, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\xylo, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * (LFNoise2.kr(3) * 0.2).midiratio;
	snd = SinOsc.ar(freq * [6, 11, 13]) * 2000 * (1 + Env.perc(0, 1).ar);
	snd = SinOsc.ar(freq + snd).sum * -8.dbamp;
	snd = snd + GVerb.ar(snd * -10.dbamp);
	snd = snd * Env.perc(0.001, duration, curve: -8).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)