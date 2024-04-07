///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
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

(1..16).nthPrime;

// https://www.youtube.com/watch?v=ApegyaNoC2c (3:06)

(
SynthDef(\pad, {
	var snd;
	snd = Saw.ar(\freq.kr(440));
	snd = snd * Env.asr(3, 1, 3).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10).dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + GVerb.ar(snd);
	snd = Limiter.ar(snd);
	snd = BHiShelf.ar(snd, 3000, 1, -10);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
Routine({
	var frequencies;
	frequencies = 50 * (1..16).nthPrime;
	Synth.tail(nil, \fx);
	loop {
		Routine({
			var synth;
			synth = Synth(\pad, [freq: frequencies.choose]);
			rrand(8.0, 16.0).wait;
			synth.set(\gate, 0);
		}).play;
		rrand(1.0, 4.0).wait;
	};
}).play;
)















//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////