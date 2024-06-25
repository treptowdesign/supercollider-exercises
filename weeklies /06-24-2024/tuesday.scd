// Tuesday Project - Chiptune

(
SynthDef(\pulse, { |freq=440, pWidth=0.5, duration=1, span=1|
	var snd;
	snd = Pulse.ar(freq, pWidth);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
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
)

(
SynthDef(\nz, { |freq=440|
	var snd, bend;
	bend = Pulse.ar(160 * (1 + (4 * Env.perc(0, 0.03).ar)) * XLine.ar(1, 0.8, 0.3));
	snd = BPF.ar(WhiteNoise.ar.pow(6), [900, 1100], 0.2) * 20.dbamp;
	snd = snd.sum + bend;
	// snd = bend;
	snd = snd * Env.perc(0, 0.1).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	Out.ar(0, snd ! 2);
}).play;
)

Synth(\pulse, [freq: 110, pWidth: 0.8]);
Synth(\pulse, [freq: 440, pWidth: 0.2]);
Synth(\bend, [freq: 110, scale: 5]);

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
		[ 0, 3, 7, 10, 0, 2, 5, 8].do { |degree|
			if(degree != \, {
				octave = 1;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulse, [freq: note, pWidth: 0.8, duration: dur, span: 3]); };
			});
			dur.wait;
		};
	};
}).play;
)

