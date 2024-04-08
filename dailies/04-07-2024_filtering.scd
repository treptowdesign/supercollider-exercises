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
s.options.memSize = 1048576; // (original 8192)
s.options.numWireBufs;
s.options.numWireBufs = 128; // (original 64)

// Extensions
Platform.userExtensionDir;
Platform.systemExtensionDir;

//////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////


(
SynthDef(\pluckBass, {
	var snd, freq;
	freq=\freq.kr(110);
	snd = Saw.ar(freq);
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\pluckBass);

(
SynthDef(\pluckBassRlpf, {
	var snd, freq, dur;
	freq=\freq.kr(110);
	dur=\dur.kr(0.6);
	snd = Saw.ar(freq);
	snd = RLPF.ar(snd, XLine.kr(20, 2e4, dur), 0.3);
	snd = snd * Env.perc(0.001, dur).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\pluckBassRlpf);


(
var s, bpm, beat, tatum, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
tatum = beat / 4;
root = 42;
scale = Scale.aeolian.degrees;
Routine({
	var dur;
	dur = tatum;
	loop {
		[
			0,12,0,7, 12,0,0,0,
			\,0,\,12, 19,7,\,0,
			0,12,0,7, 12,0,0,0,
			\,0,\,12, 19,7,\,0,
		].do { |note|
			if(note == \) { dur.wait; } {
				s.bind { Synth(\pluckBassRlpf, [freq: (root + note).midicps, dur: dur]); };
				dur.wait;
			}
		};
	};
}).play;
)
















// end... 