(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 60, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01; // slight DC offset???
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -6.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

