
(
SynthDef(\sqr2, {
	var snd, freq;
	freq = \freq.kr(220);
	// snd = Pulse.ar(\freq.kr(330) * [1, 2], [0.4, 0.5], [0.3, 0.2]);
	snd = Pulse.ar(freq, 0.3, 0.2);
	// snd = snd.sum;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\sinSaw, {
	var snd, freq;
	freq = \freq.kr(220);
	// snd = Pulse.ar(\freq.kr(330) * [1, 2], [0.4, 0.5], [0.3, 0.2]);
	snd = LPF.ar(Pulse.ar(freq, 0.5, 0.3), freq) + HPF.ar(Saw.ar(freq, 0.2), freq/2);
	snd = MoogFF.ar((snd * 12.dbamp).tanh, 3000, 1.5);
	// snd = snd.sum;
	// snd = Latch.ar(snd, Impulse.ar(9750));
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
	snd = snd * Env.linen(0.001, 0.2, 0.2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


(
SynthDef(\sinSaw, {
	var snd, freq;
	freq = \freq.kr(330) * ;
	// snd = Pulse.ar(\freq.kr(330) * [1, 2], [0.4, 0.5], [0.3, 0.2]);
	snd = SinOsc.ar(freq, 0, 0.4) + HPF.ar(Saw.ar(freq, 0.3), freq/2);
	snd = LPF.ar((snd * 8.dbamp).tanh, 3200);
	// snd = snd.sum;
	// snd = Latch.ar(snd, Impulse.ar(9750));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.005, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


(
SynthDef(\saw, {
	var snd, freq;
	freq = \freq.kr(110);
	// snd = Pulse.ar(\freq.kr(330) * [1, 2], [0.4, 0.5], [0.3, 0.2]);
	snd = Saw.ar(freq, 0.3);
	// snd = snd.sum;
	snd = Latch.ar(snd, Impulse.ar(9750));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\sqr2, {
	var snd, freq;
	freq = \freq.kr(220);
	// snd = Pulse.ar(\freq.kr(330) * [1, 2], [0.4, 0.5], [0.3, 0.2]);
	snd = Saw.ar(freq, 0.2) + Pulse.ar(freq, 0.5, 0.2);
	snd = (snd * 6.dbamp).tanh;
	snd = LPF.ar(snd, 4000);
	snd = BHiShelf.ar(snd, 500, 1, -6);
	snd = BLowShelf.ar(snd, 500, 1, 4);
	// snd = snd.sum;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\sqr2, {
	var snd, freq;
	freq = \freq.kr(220);

	snd = SinOsc.ar(freq * [1, 2, 3]) * [1300, 1200, 2000];
	snd = SinOsc.ar(freq + snd).sum;
	// snd = (snd * 6.dbamp).tanh;
	// snd = LPF.ar(snd, XLine.ar(8000, 60, 1));
	// snd = snd.sum;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.3));
	snd = snd * Env.perc(0.01, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)