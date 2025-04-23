(
SynthDef(\bassOne, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(600, 100, duration), 0);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bassTwo, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(ExpRand(100, 3000), ExpRand(300, 8000), duration), 2) * 5.dbamp;
	snd = (snd * 10.dbamp).tanh;
	snd = snd * Env.linen(0.05, duration - 0.05, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bassThree, {
	var snd, duration, freq;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [-0.1, 0.1].midiratio);
	snd = snd * SinOsc.ar(2) * Line.kr(1, 0, duration);
	snd = ((snd * 3) + 0.2).fold2 + ((snd.sign - snd) * -10.dbamp);
	snd = HPF.ar(snd, 500);
	snd = snd.tanh;
	snd = snd + (SinOsc.ar(freq) * -3.dbamp);
	snd = BLowShelf.ar(snd, 100, 1, 5);
	snd = Limiter.ar(snd, 1, 0.001);
	snd = snd * Env.linen(0.1, duration - 0.1, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\bass808ish, {
	var snd, freq, dry;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * XLine.kr(2, 1, 0.02));
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 12.dbamp).tanh, 900), 0.2, SinOsc.ar(3, [0, pi]).linlin(-1, 1, 0, 1) * 0.5e-3);
	snd = dry + (snd * -1.dbamp);
	// snd = snd * Env.adsr(0.001, 0.1, 0.9, 0.02).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass, {
	var snd, freq, dry;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * XLine.kr([3, 2], [0.6, 1], [0.02, 0.04]), mul: [0.5, 1]).sum;
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 12.dbamp).tanh, 900), 0.2, SinOsc.ar(3, [0, pi]).linlin(-1, 1, 0, 1) * 0.5e-3);
	snd = dry + (snd * -1.dbamp);
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)











(
SynthDef(\bass2, {
	var snd, freq, dry;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = MoogFF.ar(snd, (Line.kr(0, 1, 0.9) ** 0.6).linexp(0, 1, 200, 4200), 0.9) * 5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.asr(0.1, 1, 0.03).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -8.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)