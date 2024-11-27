(
SynthDef(\bass1, {
	var snd, duration;
	duration = \duration.kr(0.6);
	snd = Pulse.ar(40);
	snd = FreqShift.ar(snd, 13);
	snd = BPF.ar(snd, XLine.ar(100, 2000, duration), 0.5) * 10.dbamp;
	snd = snd.tanh;
	snd = BPF.ar(snd, (0..20).normalize.linexp(0, 1, 100, 3200), 0.1).sum * 7.dbamp;
	snd = snd + DelayC.ar(snd * -10.dbamp, 0.2, [30e-3, 45e-3]);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(40);
	snd = BPF.ar(snd, XLine.ar(3000, 100, duration), 0.3) * 22.dbamp;
	snd = BPF.ar(snd, (0..20).normalize.linexp(0, 1, 100, 3200), 0.1).sum;
	snd = snd + DelayC.ar(snd * -10.dbamp, 0.2, [30e-3, 45e-3]);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)