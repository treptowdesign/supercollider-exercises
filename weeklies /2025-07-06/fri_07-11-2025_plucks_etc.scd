(
SynthDef(\plkTst, {
	var snd, exciter, trigger, freq;
	freq = \freq.kr(60);
	trigger = Impulse.ar(0);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 60, 1000)
	) * Env.perc(0.0, 0.01).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / (freq), 30.0, 0.9);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 60, 1000)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\basicSine, {
	var snd;
	snd = SinOsc.ar(\freq.kr(50));
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.4));
	snd = snd * Env.linen(0.001, \duration.kr(3), 0.5).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


(
SynthDef(\plkTst, { // BASS
	var snd, exciter, freq;
	freq = \freq.kr(60);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 60, 1300)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0), 4.dbamp * \amp.kr(1));

	// snd = snd + HPF.ar((snd * 8).tanh * -20.dbamp, 200);
	// snd = snd + CombC.ar(snd, 0.2, 1 / 63, 0.03);
	// snd = XFade2.ar(snd, CombC.ar(snd, 0.2, 1 / 63, 0.1), 0);
	// snd = XFade2.ar(snd, CombC.ar(snd, 0.2, 1 / 95, 0.1), 0);

	// snd = ((snd) * 4.dbamp).tanh;
	snd = ((snd + 0.1) * 8.dbamp).tanh;
	snd = LeakDC.ar(snd);

	// snd = BHiShelf.ar(snd, 400, 0.3, -15);
	// snd = BLowShelf.ar(snd, 200, 0.3, 5);
	// snd = BLowShelf.ar(snd, 75, 0.3, 5);


	// snd = BRF.ar(snd, freq * 2, 0.01);

	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)



(
SynthDef(\plkTst, { // TREBLE
	var snd, exciter, freq;
	freq = \freq.kr(220);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 60, 1300)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.7);
	snd = Pan2.ar(snd, \pan.kr(0), 4.dbamp * \amp.kr(1));

	// snd = snd + HPF.ar((snd * 8).tanh * -20.dbamp, 200);
	// snd = snd + CombC.ar(snd, 0.2, 1 / 63, 0.03);
	// snd = XFade2.ar(snd, CombC.ar(snd, 0.2, 1 / 63, 0.1), 0);
	// snd = XFade2.ar(snd, CombC.ar(snd, 0.2, 1 / 95, 0.1), 0);

	// snd = ((snd) * 4.dbamp).tanh;
	snd = ((snd + 0.1) * 8.dbamp).tanh;
	snd = LeakDC.ar(snd);

	// snd = BHiShelf.ar(snd, 400, 0.3, -15);
	// snd = BLowShelf.ar(snd, 200, 0.3, 5);
	// snd = BLowShelf.ar(snd, 75, 0.3, 5);


	// snd = BRF.ar(snd, freq * 2, 0.01);

	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


1/63; // 0.015873015873016
1/95; // 0.010526315789474



// Sine Exciter
(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(110);
	exciter = exciter = SinOsc.ar(freq) * Env.perc(0.001, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.7);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = LeakDC.ar(snd);
	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

// WhiteNoise Exciter
(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = WhiteNoise.ar * Env.perc(0.001, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = LeakDC.ar(snd);
	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

// BrownNoise Exciter
(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = BrownNoise.ar * Env.perc(0.001, 0.1).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 30.0, 0.85);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = LeakDC.ar(snd);
	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)



(
SynthDef(\plkTst, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 10, 400)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = snd * Env.linen(0.001, \duration.kr(30), 0.5).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\vocal, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = SinOsc.ar(
		Env.perc(0, 0.1).ar.linexp(1, 0, 600, 1000)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.8);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = RLPF.ar(snd, Env.perc(0, 0.8).ar.linexp(0, 1, 60, 2000), 0.3);
	snd = Latch.ar(snd, Impulse.ar(2330));
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.5).ar(Done.freeSelf);
	snd = LeakDC.ar(snd) * -6.dbamp;
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

(
SynthDef(\vocal, {
	var snd, exciter, freq;
	freq = \freq.kr(50);
	exciter = SinOsc.ar(
		Env.perc(0.0, 0.1).ar.linexp(1, 0, 600, 1000)
	) * Env.perc(0.0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, 0.8);
	snd = Pan2.ar(snd, \pan.kr(0), 6.dbamp * \amp.kr(1));
	snd = RLPF.ar(snd, Env.perc(0, 0.8).ar.linexp(0, 1, 60, 2000), 0.3);
	snd = Latch.ar(snd, Impulse.ar(2330));
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.5).ar(Done.freeSelf);
	snd = LeakDC.ar(snd) * -6.dbamp;
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)




















// endfile