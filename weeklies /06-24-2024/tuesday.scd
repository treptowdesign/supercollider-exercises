// Tuesday Project - Chiptune

(
SynthDef(\pulse, { |freq=440, pWidth=0.5, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq, pWidth);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = LeakDC.ar(snd);
	snd = snd * -18.dbamp * amp.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\pulseChord, { |freq=440, pWidth=0.5, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * (LFNoise2.ar(8) * 0.1).midiratio, pWidth);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = LeakDC.ar(snd);
	snd = snd * -18.dbamp * amp.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\bend, { |freq=440, scale=4, duration=0.2, span=1|
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
SynthDef(\kick, { |freq=440|
	var snd;
	snd = LFTri.ar(60 * (1 + (4 * Env.perc(0, 0.1, curve: -8).ar)));
	snd = snd + (Pulse.ar(60 * (1 + (4 * Env.perc(0, 0.1, curve: -8).ar))) * -15.dbamp);
	snd = snd.tanh;
	snd = snd * Env.perc(0, 0.3).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -5.dbamp;
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
Synth(\pulse, [freq: 220, pWidth: 0.5]);
Synth(\pulse, [freq: 440, pWidth: 0.2]);
Synth(\bend, [freq: 110, scale: 5]);

Synth(\snare);
Synth(\kick);

(
var root = 42, octave, note;
[-12, 3, -5, 10, 14].do { |degree|
	octave = 2;
	note = (root + degree + (12 * octave)).midicps;
	Synth(\pulseChord, [freq: note, pWidth: 0.1, duration: 2, span: 1, amp: -5]);
};
)

// scales...
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ] - [ 12, 14, 15, 17, 19, 20, 22 ]


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
		[
			\, 0, 7, 3, \, 3, 0, 7,
			\, 0, 7, 3, \, 3, 0, 7,
			\, 5, 12, 8, \, 5, 12, 8,
			\, 5, 12, 8, \, 5, 12, 8,
		].do { |degree|
			if(degree != \, {
				octave = 1;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulse, [freq: note, pWidth: 0.1, duration: dur, span: 3]); };
			});
			dur.wait;
		};
	};
}).play;
Routine({
	var dur, note, octave;
	dur = beat * 4;
	loop {
		[
			[-12, 3, -5, 10, 14],
			[-7, 8, 0, 15, 19]
		].do { |chord|
			chord.do{ | degree|
				octave = 2;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulseChord, [freq: note, pWidth: 0.6, duration: dur, span: 0.5, amp: -5]); };
			};
			dur.wait;
		};
	};
}).play;
Routine({
	var dur = beat / 4;
	loop {
		s.bind { Synth(\kick); };
		(dur * 4).wait;
		s.bind { Synth(\snare); };
		(dur * 4).wait;
	};
}).play;
)

