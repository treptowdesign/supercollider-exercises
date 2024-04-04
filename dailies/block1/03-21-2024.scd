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
SynthDef(\sine, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15);
    var snd, dur;
	dur = atk + rel;
	snd = SinOsc.ar(440);
    snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
SynthDef(\square, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15);
    var snd, dur;
	dur = atk + rel;
	snd = Pulse.ar(440);
    snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
SynthDef(\saw, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15);
    var snd, dur;
	dur = atk + rel;
	snd = VarSaw.ar(440, 0, 0);
    snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\sine);
Synth(\square);
Synth(\saw);






















///////////////////////////////////////////////////////////////
// End
///////////////////////////////////////////////////////////////