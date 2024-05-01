(
SynthDef(\pluckBass, {
	var snd;
	snd = Pulse.ar(\freq.kr(60) * XLine.ar(2, 1, 0.01));
	snd = MoogFF.ar(snd, Env.perc(0.02, \filtVal.kr(0.35)).ar.linexp(0, 1, 80, 6000), 1) * 6.dbamp;
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -16.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pluckSawBass, {
	var snd;
	snd = VarSaw.ar(\freq.kr(60) * XLine.ar(2, 1, 0.01), 0, 0);
	snd = RLPF.ar(snd, Env.perc(0.01, 0.45).ar.linexp(0, 1, 60, 5000), 0.35);
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.65).ar.linexp(0, 1, 100, 5000), 1) * 6.dbamp;
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -16.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pluckSquareBass, {
	var snd;
	snd = Pulse.ar(\freq.kr(60) * XLine.ar(2, 1, 0.01));
	snd = RLPF.ar(snd, Env.perc(0.01, 0.45).ar.linexp(0, 1, 60, 5000), 0.35);
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.65).ar.linexp(0, 1, 100, 5000), 1) * 6.dbamp;
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -16.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)

// routine
(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.lydian.degrees;

Routine({
	var tatum, dur, note, octave;
	tatum = beat / 4;
	loop {
		dur = tatum  * [2,3,4].choose;
		8.do {
			octave = -1;
			note = (root + scale.choose + (12 * octave)).midicps;
			s.bind { Synth(\pluckSawBass, [freq: note, out: 0]); };
			dur.wait;
		};

	};
}).play;

)