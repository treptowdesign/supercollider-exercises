
(
SynthDef(\synth, {
	var snd;
	snd = VarSaw.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, 0.3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(0, snd);
}).add;
)

Synth(\synth);

(
var s, bpm, beat, scale, root;
s = Server.default;
bpm = 160;
beat = 60 / bpm;
scale = Scale.locrian.degrees;
root = 52;
Routine({
	var note, pan;
	loop {
		note = (root + scale.choose() + (12 * 1)).midicps;
		pan = rrand(-1.0, 1.0);
		Synth(\synth, [\freq: note, \pan: pan]);
		(beat / 4).wait;
	};
}).play;
)

