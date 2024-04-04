//

(
SynthDef(\synth, {
	var sig;
	sig = VarSaw.ar(\freq.kr(440));
	sig = sig * Env.perc(0.01, 0.5).ar(Done.freeSelf);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;
)

Synth(\synth);

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (8 * Env.perc(0, 0.15, curve: -8).ar)) * XLine.ar(1, 0.3, 1));
	snd = snd + (SinOsc.ar(XLine.ar(4000, 50, 0.01)) * Env.perc(0.001, 0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 10120, 0.5) * Env.perc(0.001, 0.03).ar * -8.dbamp);
	snd = (snd * 4.dbamp).tanh;
	snd = snd * Env.perc(0.001, 1.3, curve: -8).ar(Done.freeSelf); // added curve...
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 140;
beat = 60 / bpm;
root = 42;
scale = Scale.phrygian.degrees;

// melody
Routine({
	loop {
		var note = root + (scale.choose) + (12 * 2);
		Synth(\synth, [freq: note.midicps, pan: rrand(-1.0, 1.0)]);
		(beat/2).wait;
	}
}).play;

// bass
Routine({
	loop {
		var note = root + (scale.choose) + (12 * 1);
		Synth(\synth, [freq: note.midicps, pan: 0]);
		Synth(\kick);
		(beat).wait;
	}
}).play;

)