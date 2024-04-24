(
SynthDef(\padFqShift, {
	var root, snd, freq, env, lfo;
	env = Env([0, 1, 0], [0.1, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	root = SinOsc.ar(freq) * -15.dbamp ! 2;
	snd = Pulse.ar((freq * (LFNoise2.kr(3 ! 3) * 0.1).midiratio) + 10);
	snd = Splay.ar(snd, 0.3);
	snd = FreqShift.ar(snd, -10);
	snd = (BPF.ar([snd], [630, 1340, 2200], 0.6) * [0, -5, -10].dbamp).sum;
	snd = LPF.ar(snd, 1600);
	snd = snd + DelayC.ar(snd,  0.2,  SinOsc.ar(0.1, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3); // l/r phasing
	snd = root + snd;
	snd = Splay.ar(snd, 0.9);
	snd = snd * env;
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
Synth(\padFqShift, [freq: 220, duration: 2]);
)

(
SynthDef(\sawFqSft, {
	var snd;
	snd = Saw.ar(\freq.kr(440) + 10);
	snd = FreqShift.ar(snd, -10);
	snd = snd + CombC.ar(snd, 0.2, 0.2, 4);
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\nHarm, {
	var snd, n;
	snd = SinOsc.ar(\freq.kr(220) * [1,2,3,5,9], mul: (1 / [1,2,3,5,9].sqrt));
	snd = snd.sum * -10.dbamp;
	snd = PitchShift.ar(snd, 0.2, 1.0 + {Rand(-0.1, 0.1) ! 4});
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)


// Chord Progressions in Phrygian
(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
Routine({
	loop {
		[
			// i - iv - bII - VII
			[0, 3, 7, 10],
			[5, 8, 0, 3],
			[2, 5, 9, 0],
			[7, 10, 2, 5]
		].do { |chord|
			chord.do { |deg|
				Synth(\padFqShift, [freq: (root + deg + (12 * 2)).midicps, duration: (beat * 4)]);
			};
			(beat * 4).wait;
		};
	};
}).play;
)


(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
Routine({
	loop {
		[
			// i - bII - i - VII
			[0, 3, 7, 10],
			[2, 5, 9, 0],
			[0, 3, 7, 10],
			[7, 10, 2, 5]
		].do { |chord|
			chord.do { |deg|
				Synth(\padFqShift, [freq: (root + deg + (12 * 2)).midicps, duration: (beat * 4)]);
			};
			(beat * 4).wait;
		};
	};
}).play;
)

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
Routine({
	loop {
		[
			// bII - i - VII - iv
			[2, 5, 9, 0],
			[0, 3, 7, 10],
			[7, 10, 2, 5],
			[5, 8, 0, 3]
		].do { |chord|
			chord.do { |deg|
				Synth(\padFqShift, [freq: (root + deg + (12 * 2)).midicps, duration: (beat * 4)]);
			};
			(beat * 4).wait;
		};
	};
}).play;
)


(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
Routine({
	loop {
		[
			// i - VII - bII - i
			[0, 3, 7, 10],
			[7, 10, 2, 5],
			[2, 5, 9, 0],
			[0, 3, 7, 10]
		].do { |chord|
			chord.do { |deg|
				Synth(\padFqShift, [freq: (root + deg + (12 * 2)).midicps, duration: (beat * 4)]);
			};
			(beat * 4).wait;
		};
	};
}).play;
)


//

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
Routine({
	loop {
		[
			// VII - bII - i - iv
			[7, 10, 2, 5],
			[2, 5, 9, 0],
			[0, 3, 7, 10],
			[5, 8, 0, 3]
		].do { |chord|
			chord.do { |deg|
				Synth(\padFqShift, [freq: (root + deg + (12 * 2)).midicps, duration: (beat * 4)]);
			};
			(beat * 4).wait;
		};
	};
}).play;
)















// end...