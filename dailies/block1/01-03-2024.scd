(
SynthDef(\xxx, {
	var snd;
	snd = VarSaw.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, 0.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\xxx, [\freq, 530]);


(
var s, root, bpm, beat, scale;
s = Server.default;
root = 52;
bpm = 160;
beat = 60 / bpm;
scale = Scale.aeolian.degrees;

Routine({
	loop{
		var note = root + scale.choose + (12 * 2);
		Synth(\xxx, [\freq, note.midicps]);
		beat.wait;
	}
}).play;
)