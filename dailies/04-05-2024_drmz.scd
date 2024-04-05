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

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0, 0.03).ar))
		* (1 + (0.5 * Env.perc(0, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.03).ar);
	snd = (snd.clip2).tanh;
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		230
		* [1, 2.3, 3.8, 4.8]
		* (1 + (0.3 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.01 * Env.perc(0.0, 0.1, curve: -4).ar))
	);
	snd = snd * Env.perc(0, [1, 0.3, 0.1, 0.05]).ar;
	snd = snd * [0, -20, -25, -20].dbamp;
	snd = snd.sum;
	snd = snd + (Env.perc(0.02, 0.05).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 2120, 0.5) * 15.dbamp);
	snd = snd * (1 + (5 * Env.perc(0, 0.01).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.001).ar));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3, curve: -2.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)


// end...