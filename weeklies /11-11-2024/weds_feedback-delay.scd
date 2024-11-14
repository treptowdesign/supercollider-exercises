// SynthDef Feedback Delay
// https://www.reddit.com/r/supercollider/comments/10jf7mz/how_to_make_a_basic_echodelay_sound_in/
// https://www.youtube.com/watch?v=7osHcAue7PE&t=928s


// Basic Delay
(
{
	var snd, wet, delayTime;
	delayTime = 0.1;
	snd = SinOsc.ar(440) * Env.perc(0.001, 0.1).ar;
	snd = snd ! 2;
	wet = snd + (LocalIn.ar(2) * -5.dbamp); // <- feedback control
	wet = DelayC.ar(wet, 0.1, delayTime - ControlDur.ir);
	LocalOut.ar(wet);
	snd = snd + (wet * -5.dbamp); // <- wet/dry mix
	snd;
}.play(fadeTime: 0);
)


// Modulated Delay Time for Stereo Effect
(
{
	var snd, wet, maxDelayTime, delayTime;
	maxDelayTime = 0.25;
	delayTime = maxDelayTime + (SinOsc.ar(0.3) * [0.001, 0.0014]);
	snd = SinOsc.ar(440) * Env.perc(0.001, 0.1).ar;
	snd = snd ! 2;
	wet = snd + (LocalIn.ar(2) * -5.dbamp); // <- feedback control
	wet = DelayC.ar(wet, maxDelayTime, delayTime - ControlDur.ir);
	LocalOut.ar(wet);
	snd = snd + (wet * -5.dbamp); // <- wet/dry mix
	snd;
}.play(fadeTime: 0);
)

// Reverse (PingPong)
(
{
	var snd, wet, maxDelayTime, delayTime;
	maxDelayTime = 0.25;
	delayTime = maxDelayTime + (SinOsc.ar(4) * [0.01, 0.012]);
	snd = SinOsc.ar(440) * Env.perc(0.001, 0.1).ar;
	snd = snd ! 2;
	wet = snd + (LocalIn.ar(2) * -5.dbamp); // <- feedback control
	wet = DelayC.ar(wet, maxDelayTime, delayTime - ControlDur.ir);
	LocalOut.ar(wet.reverse);
	snd = snd + (wet * -5.dbamp); // <- wet/dry mix
	snd;
}.play(fadeTime: 0);
)


// Reverse + Allpass (Reverb)
(
{
	var snd, wet, maxDelayTime, delayTime;
	maxDelayTime = 0.1;
	delayTime = maxDelayTime + (SinOsc.ar(0.3) * [0.009, 0.002]);
	snd = SinOsc.ar(440) * Env.perc(0.001, 0.1).ar;
	snd = snd ! 2;
	wet = (LocalIn.ar(2) * -5.dbamp); // <- feedback control
	wet = snd + wet;
	wet = DelayC.ar(wet, maxDelayTime, delayTime - ControlDur.ir);
	wet = AllpassN.ar(wet, 0.056, 0.056 * [1, 1.2], 1);
	wet = AllpassN.ar(wet, 0.011, 0.011 * [1.3, 1], 1);
	wet = snd + wet;
	wet = DelayC.ar(wet, maxDelayTime * 2, delayTime * 2 - ControlDur.ir);
	wet = AllpassN.ar(wet, 0.016, 0.016 * [1.18, 1], 1);
	wet = AllpassN.ar(wet, 0.089, 0.089 * [1, 1.26], 1);
	wet = LPF.ar(HPF.ar(wet, 60), 8000);
	LocalOut.ar(wet.reverse);
	snd = snd + (wet * -5.dbamp); // <- wet/dry mix
	snd;
}.play(fadeTime: 0);
)



