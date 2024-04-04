///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(250);
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

///////////////////////////////////////////////////////////////
// Basic Synth & Routine
///////////////////////////////////////////////////////////////
(
SynthDef(\synth, {
	arg freq=440;
	var snd;
	snd = Pulse.ar(freq * (1 * Env.perc(0.2, 0.2).ar));
	snd = snd * Env.perc(0.2, 0.2).ar(Done.freeSelf);
	snd = BPF.ar(snd, freq * 2 * (1 + Env.perc(0.1, 0.2).ar));
	snd = (snd * 5.dbamp).tanh;
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\synth);


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 45;
scale = Scale.dorian.degrees;
Routine({
	var note;
	loop {
		note = root + scale.choose + (12 * 2);
		Synth(\synth, [freq: note.midicps]);
		(beat/4).wait;
	};
}).play;
)