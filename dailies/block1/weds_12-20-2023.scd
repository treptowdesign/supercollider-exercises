// dailt exercise 12/20/2023

(
SynthDef(\inst, {
	var snd, freq=\freq.kr(440);
	snd = Saw.ar(freq);
	snd = snd * Env.perc(0.05, 0.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\inst);

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 146;
beat = 60 / bpm;
root = 52;
scale = Scale.locrian.degrees;

Routine({
	loop {
		var note, octave;
		octave = (0..3).choose;
		note = scale.choose + root + (octave * 12);
		Synth(\inst, [freq: note.midicps]);
		(beat / 2).wait;
	};
}).play;

)
