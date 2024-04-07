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

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0, 0.03).ar))
		* (1 + (0.5 * Env.perc(0, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.06).ar);
	snd = (snd.clip2).tanh;
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\kick);

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		230
		* [1, 2.8, 3.1, 4.2]
		* (1 + (0.3 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.01 * Env.perc(0.0, 0.1, curve: -2).ar))
	);
	snd = snd * Env.perc(0, [1, 0.3, 0.1, 0.05]).ar;
	snd = snd * [0, -20, -25, -15].dbamp;
	snd = snd.sum;
	snd = snd + (Env.perc(0.02, 0.05).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 2120, 0.5) * 15.dbamp);
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.001).ar));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.4, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr, snd);
}).add;
)

(
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 130);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -2).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(0.1);
	Out.ar(\out.kr(0), snd);
}).add;
)
Synth(\clap);

(
SynthDef(\hat, {
	var freq = 440;
	var snd;
	snd = Pulse.ar(freq * [1, 1.72, 0.06, 0.78, 1.51].midiratio);
	snd = (WhiteNoise.ar.pow(9.0) * 0.8) + snd.sum;
	snd = BPF.ar(snd, 17e3, 0.3);
	snd = (snd.fold2).tanh;
	snd = snd * (1 + (2 * Env.perc(0, 0.02).ar));
	snd = snd * Env.perc(0.0001, 0.2).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * \amp.kr(1).dbamp);
}).add;
)

Synth(\kick);
Synth(\snare);
Synth(\hat);

(
var bpm, beat;
bpm = 110;
beat = 60 / bpm;
Routine({
	var dur = (beat / 4), idx = 0;

	loop {
		Synth(\hat, [amp: idx.linlin(1, 4, -10, 1)]);
		dur.wait;
		idx = (idx % 4) + 1;
	};
}).play;
Routine({
	var dur = (beat);
	loop {
		Synth(\kick);
		dur.wait;
	};
}).play;
Routine({
	var dur = (beat);
	loop {
		dur.wait;
		Synth(\clap);
		dur.wait;
	};
}).play;
)


(
SynthDef(\rhh, {
	var snd, freq = \freq.kr(440 * [1, 1.14, 0.98, 0.77, 0.81].midiratio);
	snd = Pulse.ar(freq);
	snd = snd.sum;
	snd = snd * -10.dbamp;
	Out.ar(0, snd ! 2);
}).play;
)













//////////////////////////////////
// end...
//////////////////////////////////