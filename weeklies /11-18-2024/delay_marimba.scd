///////////////////////////////////////////////////////////
// Delay Marimba
///////////////////////////////////////////////////////////

(
SynthDef(\marimba, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 4.9, 9.0, 13.4]);
	snd = snd * Env(
		[0, 10, 0.3, 0],
		[[0.005, 0.002, 0.001, 0.001], [0.1, 0.02, 0.01, 0.01], [0.6, 0.3, 0.01, 0.1] * ExpRand(0.7, 1.2)],
		curve: -4
	).ar;
	snd = snd * [0, -5, -10, 0].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(WhiteNoise.ar, 7120, 0.3) * Env.perc(0.001, 0.02).ar * 5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -40.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fbDelayUnit, {
	var snd, wet, delayTime;
	delayTime = \delayTime.kr(0.1);
	snd = In.ar(\in.kr(0), 2);
	wet = snd + (LocalIn.ar(2) * -2.dbamp);
	wet = DelayC.ar(wet, delayTime, delayTime - ControlDur.ir);
	LocalOut.ar(wet);
	snd = snd + (wet * -2.dbamp);
	snd = snd + GVerb.ar(snd.sum * -30.dbamp, 50, 0.8);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~delayBus = Bus.audio(nil, 2);
)
~delayBus.index;

(
var s, root, scale, beat;
s = Server.default;
root = 32;
scale = Scale.lydian.degrees;
beat = 60 / 120;
Routine({
	var note, delayFx;
	delayFx = Synth(\fbDelayUnit, [in: ~delayBus, delayTime: beat/8]);
	loop {
		note = (root + scale.choose + (12 * [2, 3, 4].choose)).midicps;
		s.bind {Synth(\marimba, [freq: note, pan: rrand(0.7, -0.7), out: ~delayBus]);};
		(beat/2).wait;
	};
}).play;
)



s.makeWindow;