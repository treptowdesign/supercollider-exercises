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
	wet = LPF.ar(wet, 1400);
	snd = snd.blend(wet, 0.35) * 0.3;
	snd = snd * Env.linen(0, 3, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

// Flanger

(
{
	var snd;
	snd = Pulse.ar(110) * Env.perc(0.001, 2).ar;
	snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(0.1, [0, pi]).linlin(-1, 1, 0, 1) * 4e-3);  //4e-3
	snd * 0.05;
}.play;
)

// Harmonizer

(
SynthDef(\delayHarm, {
	var snd, phs, del, env, rate, maxDelay;
	maxDelay = 0.05;
	rate = \n.kr(7).midiratio - 1 / maxDelay;
	snd = SinOsc.ar(440) * Env.perc(0.001, 1).ar ! 2;
	phs = LFSaw.ar(rate.neg, [1, 0]).range(0, maxDelay);
	env = SinOsc.ar(rate, [3pi/2, pi/2]).range(0, 1).sqrt;
	del = DelayC.ar(snd, maxDelay, phs) * env;
	del = snd + del.sum * 0.1;
	Out.ar(0, del);
}).play;
)

// Chorus

(
{
	var source;
	var fx;
	var n = 10;
	source = Saw.ar(\freq.kr(330), 0.3);
	fx = Mix.fill(n, {
		var maxdelaytime= rrand(0.01, 0.06);
		var half= maxdelaytime*0.5;
		// var quarter= maxdelaytime*0.25;
		//%half+(quarter*LPF.ar(WhiteNoise.ar, rrand(1.0, 10)))
		DelayC.ar(source, maxdelaytime, LFNoise1.kr(Rand(0.6, 0.1), 0.01, 0.02) )
	});
	fx * 0.1 ! 2;
}.play
)

( // plugging in the commented out line as the noise signal
{
	var source;
	var fx;
	var n = 10;
	source = Saw.ar(\freq.kr(330), 0.3);
	fx = Mix.fill(n, {
		var maxdelaytime= rrand(0.01, 0.06);
		var half= maxdelaytime*0.5;
		var quarter= maxdelaytime*0.25;
		DelayC.ar(source, maxdelaytime, half+(quarter*LPF.ar(WhiteNoise.ar, rrand(1.0, 10))) )
	});
	fx * 0.1 ! 2;
}.play
)

(
SynthDef(\simpleChorus, {
	var snd, delay, mod, depth, rate, output;
	// Parameters
	rate = \rate.kr(0.25); // LFO rate (Hz)
	depth = \depth.kr(0.01); // Modulation depth (seconds)
	// Base sound
	snd = Saw.ar(\freq.kr(440), 0.3); // Sawtooth wave at specified frequency
	// Modulated delay
	mod = SinOsc.kr(rate, 0).range(0, depth); // LFO for modulating delay
	delay = DelayC.ar(snd, depth + 0.005, mod); // Delayed and modulated version
	// Mix the original signal and the delayed signal
	output = Mix([snd, delay]) * 0.5;
	// Stereo spread
	output = Splay.ar(output);
	output = Limiter.ar(output);
	Out.ar(0, output);
}).play;
)

(
SynthDef(\improvedChorus, {
	var source, fx, n, maxDelayTime, rateRange, depthRange, panSpread;

	n = 12; // Number of voices
	maxDelayTime = \maxDelayTime.kr(0.03); // Maximum delay time (seconds)
	rateRange = \rateRange.kr([5, 10]); // Range of modulation rates (Hz)
	depthRange = \depthRange.kr([0.01, 0.03]); // Range of modulation depths

	// Source signal
	source = Pulse.ar(110, 0.5) * Env.perc(0.1, 6).ar;

	// Create multiple modulated delay lines
	fx = Mix.fill(n, {
		var rate = Rand(rateRange[0], rateRange[1]);
		var depth = Rand(depthRange[0], depthRange[1]);
		var mod = LFNoise1.kr(rate).range(0, depth);
		var delay = DelayC.ar(source, maxDelayTime, mod);
		Pan2.ar(delay, Rand(-0.4, 0.4)) // Stereo panning
	});

	source = source ! 2;
	source = source.blend(fx, 0.25) * 0.2;

	Out.ar(0, source); // Output with gain adjustment
}).add;
)

Synth(\improvedChorus, [\maxDelayTime, 0.04, \rateRange, [0.1, 1], \depthRange, [0.005, 0.01]]);
Synth(\improvedChorus, [\maxDelayTime, 0.04, \rateRange, [1, 3], \depthRange, [0.001, 0.01]]);


// Phaser

(
SynthDef(\phaser, { arg out=0, in=0;
    var input,dsig, mixed;
	input = Pulse.ar(90);
    dsig = AllpassL.ar(input, 0.2, SinOsc.ar(0.2, 0, 0.01, 0.01), 0);
    mixed = input + dsig;
    Out.ar(0, mixed * 0.05 ! 2);
}).play;
)

(
SynthDef(\phaser, { arg out=0, in=0;
    var input,dsig, mixed;
	input = Pulse.ar(110) * Env.perc(0.001, 6).ar;
    dsig = AllpassL.ar(input, 0.1, SinOsc.ar(0.2, 0, 0.002, 0.002), 0);
    mixed = input + dsig;
    Out.ar(0, mixed * 0.05 ! 2);
}).play;
)

(
SynthDef(\phaserMulti, { arg out=0, in=0;
    var input,dsig, mixed;
	input = Pulse.ar(110);
    dsig = AllpassL.ar(input, 0.2, SinOsc.ar(0.3, 0, 0.005, 0.005), 0);
	dsig = AllpassL.ar(dsig, 0.2, SinOsc.ar(0.3, 0, 0.005, 0.005), 0);
	dsig = AllpassL.ar(dsig, 0.2, SinOsc.ar(0.3, 0, 0.005, 0.005), 0);
    mixed = input + dsig;
    Out.ar(0, mixed * 0.05 ! 2);
}).play;
)

(
SynthDef(\fxexamplephasing, {arg freq=0.1;
	var input, effect;
	input = Pulse.ar(110) ! 2; // get two channels of input starting (and ending) on bus 0
	effect = AllpassL.ar(input, 0.04, SinOsc.kr(freq, 0, 0.02, 0.02)); //m ax delay of 20 msec
	Out.ar(0, effect * 0.1); //adds to bus 0 where original signal is already playing
}).play;
)











// Not Delay

(
SynthDef(\pitchChorus, {
	var snd, freq, fx;
	freq = \freq.kr(110);
	snd = Pulse.ar(freq, 0.5, Env.perc(0.001, 2, 0.04).ar(Done.freeSelf)) ! 2;
	fx = snd;
	fx = Mix.fill(6, {
		PitchShift.ar(snd, 0.8, 1 + Rand(-0.01, 0.01));
	});
	snd = snd + fx;
	Out.ar(0, snd);
}).play;
)






// endfile...