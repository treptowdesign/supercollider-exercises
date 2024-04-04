// 12/0/2024

(
SynthDef(\synth, {
	var snd;
	snd = VarSaw.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, 0.3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\synth);

(
var s, root, bpm, beat, scale;
s = Server.default;
root = 57;
bpm = 155;
beat = 60 / bpm;
scale = Scale.dorian.degrees;

Routine({
	loop{
		var note = root + scale.choose() + (12 * 2);
		Synth(\synth, [freq: note.midicps]);
		(beat).wait;
	};
}).play;

)