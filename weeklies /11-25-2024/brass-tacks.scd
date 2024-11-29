// Flanger
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
	var wet;
	var delayTime = SinOsc.kr(0.2, 0).range(0.001, 0.01);  // LFO for delay time modulation
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
    // Mix([source, modulated1, modulated2]) * 0.3 ! 2;
}.play;
)

// Phaser
(
{
    // var source = WhiteNoise.ar(0.2);  // Input signal: WhiteNoise
	// var source = Saw.ar(220, 0.2);  // Input signal: Saw
	var source = Pulse.ar(110, 0.5, 0.2);  // Input signal: Pulse
	var wet;
    var mod = SinOsc.kr(0.2).range(0, 1);  // LFO for modulation
    var feedback = 0.7;
    var phaser = AllpassC.ar(source, 0.05, mod * 0.05, feedback);  // Phaser effect
	wet = phaser;
	source.blend(wet, 0.5) * 0.5 ! 2;
    // Mix([source, phaser]) * 0.3 ! 2;
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
    var feedback = 0.7;
	var phaser = AllpassC.ar(source, 0.05, mod * 0.05, feedback);  // Phaser effect
	wet = phaser;
	source.blend(wet, 1) * 0.5 ! 2;
    // Mix([source, phaser]) * 0.3 ! 2;
}.play;
)



// Chorus Variable Voices
(
{
	var source = Pulse.ar(60, 0.5, 0.2) ! 2;  // Input signal: Pulse
	var wet;
	var n = 6;

	wet = Mix.fill(n, {
		var speed = 3.0.rand;
		var min = Rand(0.0001, 0.0003);
		var max = min + Rand(0.001, 0.003);
		var delay = SinOsc.kr(speed).range(min, max);
		var modulated = DelayC.ar(source, max, delay);
		Pan2.ar(modulated * 0.3, Rand(-0.5, 0.5));
	});

	// wet = Mix(wet);
	source.blend(wet, 1) * 0.5;
}.play;
)


rrand(0.0001, 0.0003);









////////////////////////////////////////////////////////////////////////////////////////////