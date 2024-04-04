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


Why do these two implementations sound different, shouldnt they be identical?

(
SynthDef(\sqr1, { | freq=440, atk=0.01, rel=0.5, out=0, pan=0 |
	var snd, lfo;
	lfo = Pulse.kr(4, add: 1 + Line.kr(1, 3, rel)) * Line.kr(1, 3, rel);
	// lfo = Pulse.kr(4, mul: Line.kr(1, 3, rel), add: 1 + Line.kr(1, 3, rel));
	snd = Pulse.ar((freq * lfo.round(0.5)).clip(20, 2e4));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\sqr2, { | freq=440, atk=0.01, rel=0.5, out=0, pan=0 |
	var snd, lfo;
	lfo = (Pulse.kr(4) + (0 + Line.kr(1, 3, rel))) * Line.kr(1, 3, rel);
	// lfo = Pulse.kr(4, mul: Line.kr(1, 3, rel), add: 1 + Line.kr(1, 3, rel));
	snd = Pulse.ar((freq * lfo.round(0.5)).clip(20, 2e4));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\sqr3, { | freq=440, atk=0.01, rel=0.5, out=0, pan=0 |
	var snd, lfo;
	// lfo = Pulse.kr(4, add: 1 + Line.kr(1, 3, rel)) * Line.kr(1, 3, rel);
	lfo = Pulse.kr(4, mul: Line.kr(1, 3, rel), add: 1 + Line.kr(1, 3, rel));
	snd = Pulse.ar((freq * lfo.round(0.5)).clip(20, 2e4));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\sqr4, { | freq=440, atk=0.01, rel=0.5, out=0, pan=0 |
	var snd, lfo;
	lfo = (Pulse.kr(4) * Line.kr(1, 3, rel)) + (1 + Line.kr(1, 3, rel));
	// lfo = Pulse.kr(4, mul: Line.kr(1, 3, rel), add: 1 + Line.kr(1, 3, rel));
	snd = Pulse.ar((freq * lfo.round(0.5)).clip(20, 2e4));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\sqr5, { | freq=440, atk=0.01, rel=0.5, out=0, pan=0 |
	var snd, lfo;
	lfo = (Pulse.kr(4, width: Line.kr(1, 0, rel)) + (1 + Line.kr(1, 3, rel))) * Line.kr(1, 3, rel);
	snd = Pulse.ar((freq * lfo.round(0.5)).clip(20, 2e4));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
)

Synth(\sqr1);
Synth(\sqr2);
Synth(\sqr3);
Synth(\sqr4);
Synth(\sqr5, [freq: 110, rel: 0.6]);















///////////////////////////////////////////////////////////////
// end...
///////////////////////////////////////////////////////////////