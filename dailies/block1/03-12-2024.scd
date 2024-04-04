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
SynthDef(\synth, {
	var snd, dry;
	snd = SinOsc.ar(\freq.kr(440)) * [1, 0.5, 0.3, 0.2].dbamp;
	dry = snd;
	snd = FreqShift.ar(snd, [1, -3, 5, -9]);
	snd = snd.sum;
	snd = (dry * 5.dbamp + snd) * -5.dbamp;
	snd = snd * Env.perc(0.1, \rel.kr(0.5)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\synth, [freq: 440, rel: 1.2]);


(
SynthDef(\synth, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.1, \rel.kr(0.5)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)



Synth(\synth, [freq: 440, rel: 1.2]);

(
SynthDef(\pulseWave, { |freq = 440, pulseWidth = 0.5, out = 0, pan = 0|
	var x = Phasor.ar(0, freq / SampleRate.ir(), 0, 1);
	var snd = (x < pulseWidth) * 2 - 1; // Pulse phase 0 with adjustable pulse width
	snd = LPF.ar(snd, 4000);
	snd = snd * Env.perc(0.1, \rel.kr(0.5)).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
)

Synth(\pulseWave);

(
SynthDef(\pulse, { |freq = 440, pulseWidth = 0.5, out = 0, pan = 0|
	var snd = Pulse.ar(440, pulseWidth);
	snd = snd * Env.perc(0.1, \rel.kr(0.5)).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
)

Synth(\pulse);

(
SynthDef(\sine, { |freq = 440, out = 0, pan = 0|
	var snd = SinOsc.ar(freq);
	snd = snd * Env.perc(0.1, \rel.kr(0.5)).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
)

Synth(\sine);

(
SynthDef(\modifiedSine, { |freq = 110, out = 0, pan = 0, rel=0.8|
    var snd, foldx, foldy;
	foldx = Env.new([0.7, 0.3, 0.7], [(rel * 0.01), (rel * 0.5)], curve: 1).kr;
	foldy = Env.new([0.2, 0.45, 0.2], [(rel * 0.25), (rel * 0.75)], curve: 4).kr;
    snd = SinOsc.ar(freq);
	snd = (snd * Line.kr(5, 0.25, rel).dbamp) + (snd.fold2(-1 * foldx, foldx) * 1.5) * 1.dbamp;
	snd = (snd * Line.kr(2, 0.5, rel).dbamp) + (snd.fold2(-1 * foldy, foldy) * 0.95) * 1.dbamp;
	snd = LeakDC.ar(snd);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * -10.dbamp;
	snd = LeakDC.ar(snd);
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd, pan);
    Out.ar(out, snd);
}).add;
)

Synth(\modifiedSine);

(
var bpm, beat, root, scale;
bpm = 119;
beat = 60 / bpm;
root = 42;
scale = Scale.choose(8).degrees;
Routine({
	var note, octave, dur;
	loop {
		dur = beat / [1, 2].choose;
		octave = [-1, 0].choose;
		note = (root + scale.choose + (12 * octave));
		Synth(\modifiedSine, [freq: note.midicps, rel: dur]);
		// Synth(\sine, [freq: note.midicps, rel: dur]);
		dur.wait;
	};
}).play;
)










///////////////////////////////////////////////////////////////
// End...
///////////////////////////////////////////////////////////////