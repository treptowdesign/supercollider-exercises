// Reverb using Delays and Allpass

(
SynthDef(\delayReverb, {
	var snd, wet, preDelay, decay;
	preDelay = 0.03;
	decay = 3;
	snd = Pan2.ar(Pulse.ar(440), 0) * Env.perc(0.01, 1).ar;
	wet = DelayN.ar(snd, preDelay, preDelay);
	wet = 6.collect({
		CombC.ar(wet, 0.1, LFNoise1.kr(0.02 ! 2).exprange(0.02, 0.1), decay);
	}).sum;
	6.do({
		wet = AllpassC.ar(wet, 0.02, LFNoise1.kr(0.02 ! 2).exprange(0.01, 0.2), decay)
	});
	wet = LPF.ar(wet, 6000);
	snd = snd.blend(wet, 0.15) * 0.05;
	snd = snd * Env.linen(0, 3, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)