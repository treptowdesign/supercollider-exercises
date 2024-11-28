(
SynthDef(\improvedChorus2, {
	var source, fx, n, maxDelayTime, rateRange, depthRange, panSpread;

	n = 12; // Number of voices
	maxDelayTime = \maxDelayTime.kr(0.03); // Maximum delay time (seconds)
	rateRange = \rateRange.kr([5, 10]); // Range of modulation rates (Hz)
	depthRange = \depthRange.kr([0.01, 0.03]); // Range of modulation depths

	// Source signal
	source = Pulse.ar(220, 0.5) * Env.perc(0.1, 6).ar;

	// Create multiple modulated delay lines
	fx = Array.fill(n, {
		var rate = Rand(rateRange[0], rateRange[1]);
		var depth = Rand(depthRange[0], depthRange[1]);
		var mod = LFNoise1.kr(rate).range(0, depth);
		var delay = DelayC.ar(source, maxDelayTime, mod);
		delay;
	});

	fx.size.postln;

	fx = Splay.ar(fx);

	source = source ! 2;
	source = source.blend(fx, \wetAmt.kr(0.15)) * 0.3;

	Out.ar(0, source); // Output with gain adjustment
}).add;
)

Synth(\improvedChorus2, [maxDelayTime: 0.04, rateRange: [0.1, 1], depthRange: [0.005, 0.01], wetAmt: 0.5]);
Synth(\improvedChorus2, [maxDelayTime: 0.04, rateRange: [1.0, 4.0], depthRange: [0.001, 0.01], wetAmt: 0.75]);

(
SynthDef(\pitchChorus, {
	var snd, freq, fx;
	freq = \freq.kr(110);
	snd = Pulse.ar(freq, 0.5, Env.perc(0.001, 4, 0.2).ar(Done.freeSelf)) ! 2;
	fx = Mix.fill(6, {
		PitchShift.ar(snd, 0.8, 1 + Rand(-0.01, 0.01));
	});
	snd = LPF.ar(snd.blend(fx, 0.2), 8e3);
	Out.ar(0, snd);
}).play;
)
