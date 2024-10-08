(
SynthDef(\bass, {
	var freq, dur, snd;
	freq = \freq.kr(90);
	dur = \dur.kr(1);
	snd = SinOsc.ar(freq, 0).cubed;
	snd = snd + (SinOsc.ar(freq, Line.kr(pi, pi/3, dur)).cubed.cubed);
	snd = (snd * 0.dbamp).tanh;
	snd = BLowShelf.ar(snd, 200, 0.4, 6);
	snd = snd * Env.linen(0.1, dur, 0.1).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0) * -6.dbamp;
	Out.ar(0, snd);
}).play;
)

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.aeolian.degrees;

Routine({
	var note, dur;
	dur = beat * 2;
	loop {
		note = (root + scale.choose).midicps;
		Synth(\bass, [freq: note, dur: dur - 0.1]);
		dur.wait;
	}
}).play;
)


