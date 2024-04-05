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
SynthDef(\sine, {
	var freq = 440;
	var snd;
	snd = SinOsc.ar(freq);
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

(
SynthDef(\saw, {
	var freq = 440;
	var snd;
	snd = (1..32).collect({ |harmonic|
		SinOsc.ar(freq * harmonic, 0, (1 / harmonic));
	}).sum;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

(
SynthDef(\sqr, {
	var freq = 440;
	var snd;
	snd = (1..16).select({|x| x % 2 == 1}).collect({ |harmonic|
		SinOsc.ar(freq * harmonic, 0, (1 / harmonic));
	}).sum;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

(
SynthDef(\tri, {
	var freq = 440;
	var snd;
	snd = (1..16).select({|x| x % 2 == 1}).collect({ |harmonic, index|
		var phase = if(index % 2 == 0, { 0 }, { pi });
		SinOsc.ar(freq * harmonic, phase, (1 / harmonic ** 2));
	}).sum;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

(
SynthDef(\saw2, {
	var freq = 440;
	var snd;
	snd = (1..16).collect({ |harmonic, index|
		var phase = if(index % 2 == 0, { 0 }, { pi });
		SinOsc.ar(freq * harmonic, phase, (1 / harmonic));
	}).sum;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)


(
SynthDef(\subtract, {
	var freq = 440;
	var snd;
	snd = WhiteNoise.ar;
	snd = BPF.ar(snd, freq, 0.001) * 35.dbamp;
	snd = BPF.ar(snd, freq, 0.01) * 20.dbamp;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)

(
SynthDef(\subtractStacked, {
	var freq = 440;
	var noise;
	var snd;
	noise = WhiteNoise.ar;
	snd = (1..32).select({|x| x % 2 == 1}).collect({ |harmonic|
		var snd;
		snd = BPF.ar(noise, freq * harmonic, 0.0001) * (40.dbamp * (1/harmonic));
		snd = BPF.ar(noise, freq * harmonic, 0.0001) * (40.dbamp * (1/harmonic));
		snd;
	}).sum;
	snd = LPF.ar(snd, 8e3); // cut super highs
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).play;
)



// notes...


(1..10).select({|x| x % 2 == 1});


// end...