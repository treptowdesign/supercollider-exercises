///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
ServerOptions.outDevices;
Server.default.options.outDevice_("External Headphones");
// Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)
// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

// Memory Server Stuff
s.options.memSize;
s.options.memSize = 1048576; (original 8192)
s.options.numWireBufs;
s.options.numWireBufs = 128; (original 64)

//////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////

{ SinOsc.ar(440, 0, 0.2) ! 2}.scope;
{ Fold.ar(SinOsc.ar(440, 0, 0.2), -0.1, 0.1) ! 2}.scope;

(
SynthDef(\sine, {
	var freq = \freq.kr(440);
	var snd;
	snd = SinOsc.ar(freq);
	snd = Fold.ar(snd, -0.6, 0.6);
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

(
SynthDef(\sine, {
	var freq = \freq.kr(440);
	var drive = \drive.kr(3);
	var snd;
	snd = SinOsc.ar(freq);
	snd = (snd * drive.dbamp).fold2;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

