(
SynthDef(\sawBp, {
	var snd;
	snd = Saw.ar(220);
	snd = BPF.ar(snd, [200, 9020, 12056] * XLine.ar(1, 0.6, 0.6), 0.1);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\sawBp, {
	var snd;
	snd = Saw.ar(220);
	snd = BPF.ar(snd, [200, 9020, 17056] * XLine.ar(1, 0.2, 0.3), 0.1);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\sqrBpCmb, {
	var snd;
	snd = Pulse.ar(\freq.kr(220), 0.5);
	snd = BPF.ar(snd, [800, 4020] * XLine.ar(1, 2, 0.3), 0.1);
	snd = snd.sum;
	snd = snd + (DelayC.ar(snd, 0.2, SinOsc.ar(0.3, [0, pi] + Rand(0, 2pi)).linlin(-1, 1, 1, 3) * 0.1e-1) * -8.dbamp);
	snd.sum;
	snd = Pan2.ar(snd, 0) * -10.dbamp;
	snd = snd * Env.perc(0.1, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\sqrBpCmb, {
	var snd;
	snd = Pulse.ar(\freq.kr(220), 0.5);
	snd = BPF.ar(snd, [660, 1072, 4020] * XLine.ar(1, 2, 0.3), 0.1);
	snd = snd.sum;
	snd = snd + (DelayC.ar(snd, 0.2, SinOsc.ar(0.3, [0, pi] + Rand(0, 2pi)).linlin(-1, 1, 1, 3) * 0.1e-1) * -8.dbamp);
	snd = snd.sum;
	snd = Pan2.ar(snd, 0) * -10.dbamp;
	snd = snd * Env.perc(0.1, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\analog5, {
	var snd, freq, duration;
	freq = \freq.kr(440) * Demand.ar(Impulse.ar(10), 0, Dseq([3, 5, 2, 3, 0, -5], inf)).lag(0.01).midiratio;
	snd = Pulse.ar(freq, SinOsc.ar(0.23).linlin(-1, 1, 0.4, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.1).linexp(-1, 1, 200, 6000), SinOsc.ar(0.1).linexp(-1, 1, 3.5, 0)) * 5.dbamp;
	snd = snd + (DelayC.ar(snd, 0.2, SinOsc.ar(0.3, [0, pi] + Rand(0, 2pi)).linlin(-1, 1, 1, 3) * 0.1e-3) * -8.dbamp);
	snd = snd + (DelayC.ar(snd, 0.2, SinOsc.ar(0.25, [0, pi] + Rand(0, 2pi)).linlin(-1, 1, 1, 3) * 0.3e-3) * -8.dbamp);
	snd = snd + (DelayC.ar(snd, 0.2, SinOsc.ar(0.14, [0, pi] + Rand(0, 2pi)).linlin(-1, 1, 1, 2) * 0.5e-2) * -8.dbamp);
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd.sum * -10.dbamp, 20, 4);
	// snd = Pan2.ar(snd, 0);
	snd = snd * -30.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(10.0), 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)