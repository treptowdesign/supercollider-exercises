(
SynthDef(\saw, {
	var snd;
	snd = Pulse.ar(\freq.kr(440));
	snd = snd * Env.perc(0.1, 0.3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

(
SynthDef(\bass, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.1, 0.3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (8 * Env.perc(0, 0.3, curve: -8).ar)));
	snd = snd + (SinOsc.ar(XLine.ar(4000, 50, 0.01)) * Env.perc(0.001, 0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 10120, 0.5) * Env.perc(0.001, 0.03).ar * -8.dbamp);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = snd * -2.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)


Synth(\kick);
Synth(\saw, [freq: 550]);

(
var s, bpm, beat, scale, root;
s = Server.default;
bpm = 160;
beat = 60 / bpm;
scale = Scale.dorian.degrees;
root = 44;

Routine({
	var note;
	loop {
		note = (root + scale.choose() + (12 * 1)).midicps;
		Synth(\bass, [freq: note]);
		Synth(\kick);
		(beat).wait;
	};
}).play;

Routine({
	var note;
	loop {
		note = (root + scale.choose() + (12 * 2)).midicps;
		Synth(\saw, [freq: note]);
		(beat/4).wait;
	};
}).play;
)