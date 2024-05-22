// synth...

(
SynthDef(\synth, {
	var freq, snd;
	freq = \freq.kr(440) * [0, 0.1, 0.03, -0.13, -0.01].midiratio;
	snd = VarSaw.ar(freq, 0, 0);
	snd = snd.sum;
	snd = MoogFF.ar(snd, 12000, 0);
	snd = snd * Env.perc(0.05, 1.2).ar(Done.freeSelf);
	Out.ar(0, snd * -15.dbamp ! 2);
}).play;
)

Synth(\synth);

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.dorian.degrees;
Routine({
	var dur, octave, note;
	dur = beat / 2;
	loop {
		octave = 2;
		note = (root + scale.choose + (12 * octave)).midicps;
		Synth(\synth, [freq: note]);
		dur.wait;
	};
}).play;
)



(
SynthDef(\voiceSynth, {
	var freq, voices, spread, snd;
	freq = \freq.kr(440);
	voices = \voices.kr(10);
	spread = \spread.kr(0.15);
	snd = VarSaw.ar(freq, 0, 0, 1/voices);
	voices.do {
		snd = snd + VarSaw.ar(freq * Rand(spread.neg, spread).midiratio, 0, 0, 1/voices);
	};
	// snd = snd.sum;
	snd = MoogFF.ar(snd, 16000, 0);
	snd = snd * Env.perc(0.05, 1.2).ar(Done.freeSelf);
	Out.ar(0, snd * 0.dbamp ! 2);
}).play;
)



(
SynthDef(\unisonSpread, {
	var freq, snd, spread;
	spread = \spread.kr(0.65);
	freq = \freq.kr(440) * ([0, 0.1, 0.03, 0.075, -0.13, -0.01, -0.045] * spread).midiratio;
	snd = VarSaw.ar(freq, 0, 0);
	snd = snd.sum;
	snd = MoogFF.ar(snd, 16e3, 0);
	snd = snd * Env.perc(0.05, 1.2).ar(Done.freeSelf);
	Out.ar(0, snd * -18.dbamp ! 2);
}).play;
)




(
SynthDef(\unisonSpreadMod, {
	var freq, snd, spread;
	spread = SinOsc.kr(5).range(0, 3);
	freq = \freq.kr(440) * ([0, 0.1, 0.03, 0.075, -0.13, -0.01, -0.045] * spread).midiratio;
	snd = VarSaw.ar(freq, 0, 0);
	snd = snd.sum;
	snd = MoogFF.ar(snd, 15000, 0);
	snd = snd * Env.perc(0.05, 1.2).ar(Done.freeSelf);
	Out.ar(0, snd * -18.dbamp ! 2);
}).play;
)



// ...