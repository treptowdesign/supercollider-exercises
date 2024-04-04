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
// SynthDefs
///////////////////////////////////////////////////////////////

(
SynthDef(\fm, { | carFreq=440, ampAtk=0.002, ampRel=0.8 |
	var snd, car, mod, ampEnv;
	car = SinOsc.ar(carFreq);
	ampEnv = Env.perc(ampAtk, ampRel).ar(Done.freeSelf);
	snd = car;
	snd = snd * ampEnv;
	snd = Pan2.ar(snd, 0, level: -10.dbamp);
	Out.ar(0, snd);
}).add;
)

Synth(\fm);


















///////////////////////////////////////////////////////////////
// End...
///////////////////////////////////////////////////////////////