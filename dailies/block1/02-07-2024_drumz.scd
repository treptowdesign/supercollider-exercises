// scopes/plots
s.plotTree;
s.scope;
s.meter;
FreqScope.new(250);

// Devices
ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices; // output devices
// Server.default.options.inDevice("MacBook Pro Microphone");
// Server.default.options.outDevice("MacBook Pro Speakers");
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		Line.kr(30, 40, 0.4) *
		(1 + (8 * Env.perc(0.001, 0.3).ar)) *
		(1 + (8 * Env.perc(0.002, 0.03).ar)) *
		(1 + (8 * Env.perc(0.0005, 0.01).ar))
	);
	snd = (snd * Line.kr(5, 12, 0.3).dbamp).tanh;
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\kick);

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		Line.kr(30, 50, 0.8) *
		(1 + (6 * Env.perc(0.001, 0.3).ar)) *
		(1 + (12 * Env.perc(0.002, 0.03).ar)) *
		(1 + (8 * Env.perc(0.0005, 0.02).ar))
	);
	snd = (snd * Line.kr(5, 16, 0.3).dbamp).tanh;
	snd = snd * Env.perc(0.005, 0.8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\kick);


(
SynthDef(\synth, {
	var snd = SinOsc.ar(440);
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = (snd * 16.dbamp).tanh;
	Out.ar(0, snd);
}).add;
)


Synth(\synth);



