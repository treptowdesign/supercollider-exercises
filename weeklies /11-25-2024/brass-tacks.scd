// Flanger
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
	var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
	source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

// Chorus
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
	var wet;
    var delay1 = SinOsc.kr(0.3).range(0.02, 0.03);
    var delay2 = SinOsc.kr(0.4, pi).range(0.015, 0.025);
    var modulated1 = DelayC.ar(source, 0.04, delay1);
    var modulated2 = DelayC.ar(source, 0.04, delay2);
	wet = Mix([modulated1, modulated2]);
	source.blend(wet, 1) * 0.5 ! 2;
}.play;
)

// Phaser
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
	var wet;
    var mod = SinOsc.kr(0.1).range(0, 1);  // LFO for modulation
    var feedback = 0.7;
    var phaser = AllpassC.ar(source, 0.05, mod * 0.05, feedback);  // Phaser effect
	wet = phaser;
	source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)




////////////////////////////////////////////////////////////////////////////////////////////
// Messing with Values...
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
    var delayTime = SinOsc.kr(0.02, 0).range(0.001, 0.05);  // LFO for delay time modulation
    var feedback = 0.2;
    wet = CombC.ar(source, 0.05, delayTime, feedback) + source * 0.3;
	source.blend(wet, 1) * 0.5 ! 2;
}.play;
)

// Chorus
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
	var delay1 = SinOsc.kr(LFNoise2.ar(3).range(0.1, 0.2)).range(0.02, 0.03);
    var delay2 = SinOsc.kr(LFNoise2.ar(0.2).range(0.2, 0.4), pi).range(0.015, 0.025);
	var delay3 = SinOsc.kr(LFNoise2.ar(0.8).range(0.15, 0.3), 0.2pi).range(0.02, 0.02);
    var modulated1 = DelayC.ar(source, 0.04, delay1);
    var modulated2 = DelayC.ar(source, 0.04, delay2);
	var modulated3 = DelayC.ar(source, 0.04, delay3);
	wet = Mix.ar([modulated1, modulated2, modulated3]);
	source.blend(wet, 0.5) * 0.2 ! 2;
    // Mix([source, modulated1, modulated2]) * 0.3 ! 2;
}.play;
)


// Flanger with delayTme phase mod
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
	var delayTime = SinOsc.kr(0.2, LFNoise1.ar(0.01).range(0, 2pi)).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
	wet = LPF.ar(CombC.ar(source, 0.01, delayTime, feedback) * 0.5, 2000);
	source.blend(wet, 1) * 0.5 ! 2;
}.play;
)

// Flanger
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(60, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
	var delayTime = SinOsc.kr(0.05, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.1;
	wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
	source = source.blend(wet, 1) * 0.5 ! 2;
	source;
}.play;
)




// Phaser
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
    var mod = SinOsc.kr(0.01).range(0, 1);  // LFO for modulation
    var feedback = 0.1;
	var phaser = AllpassC.ar(source, 0.05, mod * 0.05, feedback);  // Phaser effect
	wet = phaser;
	source.blend(wet, 0.5) * 0.5 ! 2;
    // Mix([source, phaser]) * 0.3 ! 2;
}.play;
)



// Chorus Variable Voices
(
{
	var source = Pulse.ar(440, 0.5, 0.2) ! 2;  // Input signal: Pulse
	var wet;
	var n = 6;

	wet = Mix.fill(n, {
		var speed = 3.0.rand;
		var min = Rand(0.0001, 0.0003);
		var max = min + Rand(0.001, 0.002);
		var delay = SinOsc.kr(speed).range(min, max);
		var modulated = DelayC.ar(source, max, delay);
		Pan2.ar(modulated * 0.4, Rand(-0.5, 0.5));
	});

	// wet = Mix(wet);
	source.blend(wet, 1) * 0.5;
}.play;
)


rrand(0.0001, 0.0003);


( // Phaser w/ 2 Allpasses
{
    var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
    var mod1 = SinOsc.kr(0.01).range(0, 0.05);
    var mod2 = SinOsc.kr(0.15).range(0, 0.03);
    var feedback = 0.7;
    var phaser = source;
    phaser = AllpassC.ar(phaser, 0.05, mod1, feedback);
    phaser = AllpassC.ar(phaser, 0.05, mod2, feedback);
    source.blend(phaser, 0.8) * 0.5 ! 2;
}.play;
)


( // Phaser with Sereo Allpass
{
    var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
    var modL = SinOsc.kr(0.1).range(0, 0.05);  // Left channel modulation
    var modR = SinOsc.kr(0.13).range(0, 0.05); // Right channel modulation
    var feedback = 0.7;
    var phaserL = AllpassC.ar(source, 0.05, modL, feedback);
    var phaserR = AllpassC.ar(source, 0.05, modR, feedback);
    [phaserL, phaserR] * 0.5;
}.play;
)



(// Phaser w/ Modulated Feedback
{
    var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
    var mod = SinOsc.kr(0.1).range(0, 0.05);  // LFO for modulation
    var feedback = SinOsc.kr(0.05).range(0.6, 0.8);  // Modulated feedback
    var phaser = AllpassC.ar(source, 0.05, mod, feedback);
    source.blend(phaser, 0.7) * 0.5 ! 2;
}.play;
)


(// Phaser w/ Modulated Feedback, multiple LFOs
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var mod1 = SinOsc.kr(0.1).range(0, 0.05);
    var mod2 = SinOsc.kr(0.25).range(0, 0.03);
    var feedback = 0.7;
    var phaser = AllpassC.ar(source, 0.05, mod1 + mod2, feedback);
    source.blend(phaser, 0.7) * 0.5 ! 2;
}.play;
)


(// AutoMate Blending
{
    var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
    var mod = SinOsc.kr(0.1).range(0, 0.05);  // LFO for modulation
    var feedback = 0.7;
    var phaser = AllpassC.ar(source, 0.05, mod, feedback);
    var blend = SinOsc.kr(0.2).range(0.3, 0.8);  // LFO for blend
    source.blend(phaser, blend) * 0.5 ! 2;
}.play;
)


{ SinOsc.ar(1, 0.5pi).range(0, 1) }.plot(4);
{ SinOsc.ar(1, 0.5pi).range(0, 1).sqrt }.plot(4);
{ SinOsc.ar(1, 0.5pi).range(0, 1).squared }.plot(4);
{ SinOsc.ar(1, 0.5pi).range(0, 1).cubed }.plot(4);


( // Dynamic LPF on wet signal
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    var dynamicLPF = BLowPass.ar(wet, SinOsc.kr(0.1, 0).range(1000, 5000));  // Dynamic low-pass filter
    source.blend(dynamicLPF, 0.5) * 0.5 ! 2;
}.play;
)

( // Band Limited Delay modulation
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var bandLimited = BPF.ar(source, 2000, 0.5);  // Band-pass filter for wet signal
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    var wet = CombC.ar(bandLimited, 0.01, delayTime, feedback) * 0.5;
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

( // Soft Clip wet signal
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    wet = tanh(wet * 2);  // Soft clipping
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

( // Modulate feedback!!!!
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = SinOsc.kr(0.1, pi).linexp(-1, 1, 0.3, 0.01);  // Modulate feedback
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

{SinOsc.kr(0.1, pi).linexp(-1, 1, 0.3, 0.01)}.plot(2);



( // Modulate feedback Alternate
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = SinOsc.kr(0.1, 0).range(0.01, 0.3);  // Modulate feedback
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

// Main Effect LFO
{SinOsc.kr(0.1, 0).range(0.001, 0.01)}.plot(10);

// Feedback LFO
{SinOsc.kr(0.1, pi).linexp(-1, 1, 0.3, 0.01)}.plot(10);
{SinOsc.kr(0.1, 0).linexp(-1, 1, 0.3, 0.01)}.plot(10);

{SinOsc.kr(0.1, 0).range(0.01, 0.3)}.plot(10);






////////////////////////////////////////////////////////////////////////////////////////////