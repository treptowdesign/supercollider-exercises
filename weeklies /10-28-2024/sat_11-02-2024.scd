(
SynthDef(\bass, {
	var snd, freq, span;
	span = \span.kr(3);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * [0.1, -0.1].midiratio, 0.6).sum;
	snd = RLPF.ar(snd, 400, 0.8) * 10.dbamp;
	snd = BLowShelf.ar(snd, 400, 0.4, 2);
	snd = Pan2.ar(snd, 0) * -22.dbamp;
	snd = snd * Env.perc(0.01, 3).ar;
	snd = snd * Env.linen(0, span, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

{SinOsc.ar(110 * [1, 2, 3, 4], 0, [1, 0.6, 0.1, 0.05]).sum * -10.dbamp ! 2}.play;



(
SynthDef(\test, {
	var snd;
	snd = SinOsc.ar(220 * [1, 2, 3, 4], 0, [1, 0.6, 0.1, 0.05]).sum;
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd * -10.dbamp ! 2);
}).play;
)

(
SynthDef(\pulseTest, {
	var snd;
	snd = Pulse.ar(110, Env.perc(0.01, 0.1).ar.range(0.1, 0.9));
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd * -10.dbamp ! 2);
}).play;
)

(
SynthDef(\sawDetune, {
	var snd;
	snd = VarSaw.ar(220 * [0.2, -0.2].midiratio, 0, 0.1);
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd * -10.dbamp ! 2);
}).play;
)


(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 58, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01;
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -10.dbamp * \amp.kr(1);
	snd = BLowShelf.ar(snd, 300, 0.4, 5);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)