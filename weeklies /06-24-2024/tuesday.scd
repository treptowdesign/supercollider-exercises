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
	snd = Pulse.ar(freq * (LFNoise2.ar(16) * 0.1).midiratio * (SinOsc.ar(8) * 0.2).midiratio, pWidth);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = MoogFF.ar(snd, 7000, 0);
	snd = LeakDC.ar(snd);
	// snd = GVerb.ar(snd, 200, 2, 0.1);
	// snd = snd + CombN.ar(snd * -10.dbamp, 0.35, 0.35, 1);
	snd = snd * -18.dbamp * amp.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: 4).ar(Done.freeSelf);
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
	snd = snd * -14.dbamp;
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\kick, { |freq=440|
	var snd;
	snd = LFTri.ar(60 * (1 + (4 * Env.perc(0, 0.2, curve: -8).ar)));
	snd = snd + (Pulse.ar(60 * (1 + (4 * Env.perc(0, 0.2, curve: -8).ar))) * -10.dbamp);
	snd = snd.tanh;
	snd = snd * Env.perc(0, 0.2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -3.dbamp;
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\hat, {
	var snd, bend;
	snd = BPF.ar(WhiteNoise.ar.pow(4), 15000, 0.3) * 0.dbamp;
	snd = snd * Env.perc(0, 0.1, curve: -8).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\triBass, { |freq=110, duration=1, span=1, amp=0|
	var snd;
	snd = LFTri.ar(freq);
	snd = snd * Env.perc(0.01, duration * span).ar;
	snd = LeakDC.ar(snd);
	snd = snd * -8.dbamp * amp.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
SynthDef(\bn, {
	var snd, bend;
	snd = BPF.ar(BrownNoise.ar.pow(8), 1000, 0.1) * 20.dbamp;
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
Synth(\hat);



// scales...
Scale.aeolian.degrees;
//    0,    2,  3,  5,  7,  8,  10
// [ -12, -10, -9, -7, -5, -4, -2 || 0, 2, 3, 5, 7, 8, 10 || 12, 14, 15, 17, 19, 20, 22 ]

//   i: [-12, 0, 3, -5] 0, 3, 7
//  ii: [-10, 2, 5, -4] 2, 5, 8
// iii: [-9, 3, 7, -2] 3, 7, 10
//  iv: [-7, 5, 8, 0 ] 5, 8, 12
//   v: [-5, 7, 10, 2] 7, 10, 14
//  vi: [-4, 8, 12, 3] 8, 12, 15
// vii: [-2, 10, 14, 5] 10, 14, 17


/*
// triads
[-12, 0, 3, -5],
[-7, 5, 8, 0],
[-7, 5, 8, 0],
[-9, 3, 7, -2],
[-12, 0, 3, -5],
[-7, 5, 8, 0],
[-7, 5, 8, 0],
[-5, 7, 10, 2]

// 7ths
[-12, 0, 3, -5, 10],
[-7, 5, 8, 0, 15],
[-7, 5, 8, 0, 15],
[-9, 3, 7, -2, 14],
[-12, 0, 3, -5, 10],
[-7, 5, 8, 0, 15],
[-7, 5, 8, 0, 15],
[-5, 7, 10, 2, 17]
*/


(
var s, root, bpm, beat;
s = Server.default;
root = 42; // F#/Gb
bpm = 130;
beat = 60 / bpm;
Routine({
	var dur, note, octave;
	dur = beat / 4;
	loop {
		[
			\, \, 0, 12, 3, \, 7, \,  \, \, 0, 7, 3, \, 7, \,
			\, \, 0, 12, 2, \, 8, \,  \, \, 0, 8, 2, \, 8, \,
			\, \, 0, 12, 2, \, 8, \,  \, \, 0, 8, 2, \, 8, \,
			\, \, 0, 7, \, 0, 7, \,  \, \, 0, 7, \, 0, 7, \,
		].do { |degree|
			if(degree != \, {
				octave = 1;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulse, [freq: note, pWidth: 0.5, duration: dur, span: 3]); };
			});
			dur.wait;
		};
	};
}).play;
Routine({
	var dur, note, octave;
	dur = beat / 4;
	loop {
		[
			0, \, 0, 0, 0, \, \, \,  0, \, 0, 0, 0, \, \, \,
			5, \, 5, 5, 5, \, \, \,  5, \, 5, 5, 5, \, \, \,
			5, \, 5, 5, 5, \, \, \,  5, \, 5, 5, 5, \, \, \,
			3, \, 3, 3, 3, \, \, \,  3, \, 3, 3, 3, \, \, \,

			0, \, 0, 0, 0, \, \, \,  0, \, 0, 0, 0, \, \, \,
			5, \, 5, 5, 5, \, \, \,  5, \, 5, 5, 5, \, \, \,
			5, \, 5, 5, 5, \, \, \,  5, \, 5, 5, 5, \, \, \,
			7, \, 7, 7, 7, \, \, \,  7, \, 7, 7, 7, \, \, \,

		].do { |degree|
			if(degree != \, {
				octave = -1;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\triBass, [freq: note, pWidth: 0.1, duration: dur, span: 3]); };
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
			[-12, 0, 3, -5, 10],
			[-7, 5, 8, 0, 15],
			[-7, 5, 8, 0, 15],
			[-9, 3, 7, -2, 14],
			[-12, 0, 3, -5, 10],
			[-7, 5, 8, 0, 15],
			[-7, 5, 8, 0, 15],
			[-5, 7, 10, 2, 17]
		].do { |chord|
			chord.do{ | degree|
				octave = 1;
				note = (root + degree + (12 * octave)).midicps;
				s.bind { Synth(\pulseChord, [freq: note, pWidth: 0.3, duration: dur, span: 0.8, amp: -2]); };
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
Routine({
	var dur = beat / 2;
	loop {
		4.do {
			s.bind { Synth(\hat); };
			(dur).wait;
		};
		4.do {
			s.bind { Synth(\hat); };
			(dur/2).wait;
		};
		2.do {
			s.bind { Synth(\hat); };
			(dur).wait;
		};
	};
}).play;
)

