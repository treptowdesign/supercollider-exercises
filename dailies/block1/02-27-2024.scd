///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)

// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

///////////////////////////////////////////////////////////////
// Synths & Routines
///////////////////////////////////////////////////////////////

// Env.perc(attack, release, level, curve).ar

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		60 *
		(1 + (8 * Env.perc(0.001, 0.3).ar))
	);
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	snd = snd * -5.dbamp;
	Out.ar(0, snd);
}).add;
)

Synth(\kick);

(
var bpm, beat;
bpm = 120;
beat = 60 / bpm;
Routine({
	var idx = 0;
	loop {
		(idx + 1).postln;
		Synth(\kick);
		beat.wait;
		idx = (idx + 1) % 4;
	};
}).play;
)




















///////////////////////////////////////////////////////////////
// BEnd...
///////////////////////////////////////////////////////////////