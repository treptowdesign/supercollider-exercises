///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
ServerOptions.outDevices;
Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)

// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

///////////////////////////////////////////////////////////////
// Basic Synth & Routine
///////////////////////////////////////////////////////////////

(
SynthDef(\square, {
	arg freq=440, rel=0.3;
	var snd;
	snd = Pulse.ar(freq, Line.kr(1, 0, rel));
	snd = snd * Env.perc(0.01, rel, curve: 2).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\square, [freq: 220]);

(
var root, scale, bpm, beat;
root = 40;
scale = Scale.phrygian.degrees;
bpm = 120;
beat = 60 / bpm;
Routine({
	var note, octave, dur;
	loop {
		dur = beat / [1, 2, 4].choose;
		octave = [0, 1, 2, 3].choose;
		note = root + scale.choose + (12 * octave);
		Synth(\square, [freq: note.midicps, rel: dur]);
		dur.wait;
	};
}).play;
)





///////////////////////////////////////////////////////////////
// End...
///////////////////////////////////////////////////////////////