// Tuesday Project - Chiptune

(
SynthDef(\pulse, { |freq=440, pWidth=0.5, duration=1, span=1|
	var snd;
	snd = Pulse.ar(freq, pWidth);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = LeakDC.ar(snd);
	snd = snd * -12.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\bend, { |freq=440, scale=4, duration=1, span=1|
	var snd;
	snd = Pulse.ar(freq * (1 + (scale * Env.perc(0, duration * span).ar)));
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\snare, { |freq=440|
	var snd, bend;
	bend = LFTri.ar(350 * (1 + (3 * Env.perc(0, 0.01, curve: -8).ar)) * XLine.ar(1, 0.9, 0.3));
	snd = BPF.ar(WhiteNoise.ar, 2600, 0.3) * 15.dbamp;
	snd = snd + bend;
	snd = snd * Env.perc(0, 0.12).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -7.dbamp;
	Out.ar(0, snd ! 2);
}).add;
)

(
SynthDef(\bn, {
	var snd, bend;
	snd = BPF.ar(BrownNoise.ar.pow(8), 1000, 0.1) * 25.dbamp;
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0, 1).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	Out.ar(0, snd ! 2);
}).play;
)

Synth(\pulse, [freq: 110, pWidth: 0.8]);
Synth(\pulse, [freq: 440, pWidth: 0.2]);
Synth(\bend, [freq: 110, scale: 5]);

Synth(\snare);

// scales...
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]

(
var s, root, bpm, beat;
s = Server.default;
root = 42;
bpm = 120;
beat = 60 / bpm;
Routine({
	var dur, note, octave;
	dur = beat / 4;
	loop {
		[0, 3, 7, 10, 0, 2, 5, 8].do { |degree|
			if(degree != \, {
				octave = -1;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulse, [freq: note, pWidth: 0.5, duration: dur, span: 3]); };
			});
			dur.wait;
		};
	};
}).play;
Routine({
	var dur = beat / 4;
	loop {
		(dur * 4).wait;
		s.bind { Synth(\snare); };
		(dur * 4).wait;
	};
}).play;
)

