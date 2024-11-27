// Basic Feedback Delay (convert to SynthDef)
(
{
	var snd, wet, delayTime;
	delayTime = 0.2;
	snd = SinOsc.ar(440) * Env.perc(0.001, 0.2).ar ! 2;
	wet = snd + (LocalIn.ar(2) * -5.dbamp); // <- feedback control
	wet = DelayN.ar(wet, delayTime, delayTime - ControlDur.ir);
	LocalOut.ar(wet);
	snd = snd + (wet * -5.dbamp); // <- wet/dry mix
	snd;
}.play(fadeTime: 0);
)


// Comb Filter Delay
(
{
	var snd, delayTime;
	delayTime = 0.2;
	snd = SinOsc.ar(440) * Env.perc(0.001, 0.2).ar ! 2;
	snd = snd + CombN.ar(snd * -5.dbamp, delayTime, delayTime, 3);
	snd;
}.play(fadeTime: 0);
)

// Reverb using Delays and Allpass (add params for values)
(
SynthDef(\delayReverb, {
	var snd, wet, preDelay, decay;
	preDelay = 0.03;
	decay = 3;
	snd = Pan2.ar(SinOsc.ar(440) * Env.perc(0.001, 0.1).ar, 0);
	wet = DelayN.ar(snd, preDelay, preDelay);
	wet = 6.collect({
		CombC.ar(wet, 0.1, LFNoise1.kr(0.02 ! 2).exprange(0.02, 0.1), decay);
	}).sum;
	6.do({
		wet = AllpassC.ar(wet, 0.02, LFNoise1.kr(0.02 ! 2).exprange(0.01, 0.02), decay)
	});
	wet = LPF.ar(wet, 2000);
	snd = snd.blend(wet, 0.15) * 0.3;
	snd = snd * Env.linen(0, 3, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

// Flanger

(
{
	var snd;
	snd = Pulse.ar(440);
	snd = snd * Env.perc(0.001, 3).ar;
	snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(0.1, [0, pi]).linlin(-1, 1, 0, 1) * 4e-3);
	snd * -20.dbamp ! 2;
}.play;
)

// Harmonizer

(
SynthDef(\delayHarm, {
	var snd, phs, del, env, rate, maxDelay;
	maxDelay = 0.05;
	rate = \n.kr(6).midiratio - 1 / maxDelay;
	snd = SinOsc.ar(440) * Env.perc(0.001, 1).ar ! 2;
	phs = LFSaw.ar(rate.neg, [0, 1]).range(0, maxDelay);
	env = SinOsc.ar(rate, [3pi/2, pi/2]).range(0, 1).sqrt;
	del = DelayC.ar(snd, maxDelay, phs) * env;
	del = del.sum ! 2 * 0.3;
	Out.ar(0, del);
}).play;
)


// Chorus


// Phaser
















// endfile...
