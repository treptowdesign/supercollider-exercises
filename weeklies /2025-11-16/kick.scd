///////////////////////////////////////////////////
// Kick Dissect
///////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, noise, duration, velocity;
	duration = \duration.kr(1.0);
	velocity = \velocity.kr(1.0);
	noise = Hasher.ar(Sweep.ar);
	snd = SinOsc.ar(Env.perc(0, 0.06).ar.linexp(0, 1, 60, velocity.linexp(0, 1, 500, 3320)) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.5, 0.5));
	snd = snd * Env.perc(0.01, 0.5).ar;
	snd = snd + (Env.perc(0.001, 0.03).ar * BPF.ar(noise, 6520, 0.3));
	snd = snd + (Env.perc(0.03, 0.03).delay(0.01).ar * BPF.ar(noise, 9520, 0.3) * -5.dbamp);
	snd = snd * (1 + (10 * Env.perc(0.001, 0.01).ar));
	snd = snd * 5.dbamp;
	snd = snd * velocity.linlin(0, 1, 0.5, 1);
	snd = BHiShelf.ar(snd, 3000, 0.3, -3);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 5);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.1, [33.3e-3, 41e-3]), 300), 3000);
	snd = snd * -10.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)