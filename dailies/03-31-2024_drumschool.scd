///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(300);
ServerOptions.outDevices;
Server.default.options.outDevice_("External Headphones");
Server.default.options.outDevice_("MacBook Pro Speakers");
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

// Kick: Drum School...
(
SynthDef(\kickDs, {
	var snd;
	snd = SinOsc.ar(
		60
		* (1 + (3 * Env.perc(0, 0.03).ar))
		* (1 + (0.5 * Env.perc(0, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (HPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.05).ar * 5.dbamp);
	snd = (snd.clip2).tanh;
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).add;
// Snare: Drum School
SynthDef(\snareDs, {
	var snd;
	snd = SinOsc.ar(Env([236, 285, 212], [0.01, 0.3], \exp).ar);
	snd = snd + (SinOsc.ar( Env([2000, 200], [0.03], \exp).ar) * Env.perc(0.001, 0.03).ar * 5.dbamp);
	snd = snd + (SinOsc.ar( Env([1000, 700], [0.03], \exp).ar) * Env.perc(0.001, 0.3).ar * -10.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar + [1, 2], 2060, 0.3) * Env.perc(0.1, 0.3).ar * 10.dbamp);
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\kickDs);
Synth(\snareDs);













// end 