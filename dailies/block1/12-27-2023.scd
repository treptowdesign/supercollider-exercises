(
SynthDef(\synth, {
	var snd;
	snd = VarSaw.ar(\freq.kr(440));
	snd = snd * Env.perc(0.1, 0.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)



(
var s, root, bpm, beat;
s = Server.default;
root = 62;
bpm = 160;
beat = 60 /  bpm;

Routine({
	loop{
		Synth(\synth);
		beat.wait;
	};
}).play;
)