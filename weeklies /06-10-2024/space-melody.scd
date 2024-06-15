(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(2);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 7] * (LFNoise2.kr(7 ! 3) * 0.3).midiratio);
	snd = snd * Env.perc(0, [5, 7, 4]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -15.dbamp, 10, 4, damping: 0.2);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.6).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp * \velocity.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\organ2, {
	var snd, duration;
	duration = \duration.kr(2);
	snd = SinOsc.ar(\freq.kr(440) * [1, 3, 7] * (LFNoise2.kr(7 ! 3) * 0.2).midiratio);
	snd = snd * Env.perc(0, [5.5, 7, 4]).ar;
	snd = snd * [-2, 0, -10].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -15.dbamp, 10, 4, damping: 0.2);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.6).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp * \velocity.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\strings, {
	var snd, freq, detune, rate;
	freq = \freq.kr(440);
	rate = 1;
	detune = ((LFNoise2.kr(3 * rate) * 0.3) + (LFNoise2.kr(8) * 0.1) + Line.kr(10, 0, 0.003)).midiratio;
	snd = SinOsc.ar(freq * IRand(1, 3 ! 8) * (LFNoise2.kr(3 ! 8 * rate) * 0.7).midiratio * detune) * 800 * (1 + Env.perc(0.05 * ExpRand(0.5, 2.0), 0.3 * ExpRand(0.5, 2.0)).ar);
	snd = SinOsc.ar((freq * (LFNoise2.kr(3 ! 8 * rate) * 0.8).midiratio * detune) + snd);
	snd = snd * (1 + LFNoise2.ar(3 ! snd.size));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, LFNoise2.kr(3).linexp(0, 1, 400, 600));
	snd = snd * Env.linen(0.2, \duration.kr(5.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Scale.aeolian.degrees;
// [ 0, 2, 3, 5, 7, 8, 10 ]

// 0: [0, 2], [0, 3], [0, 5], [0, 7], [0, 8]


// vi (3rd)
( [5, -4].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); }; )

// iii (3rd)
( [3, 7].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); }; )

// vii (3rd) inverted
( [2, -2].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); }; )

// i (3rd)
( [0, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); }; )





(
// vi (octave)
[-4, 8].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)



(
// vi (5th)
[-4, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// iii (3rd)
[3, 7].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// i (5th)
[0, 7].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// i (5th)
[0, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// vii (3rd) inverted
[2, -2].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// vi (5th)
[-4, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)









(
// vi (5th)
[-4, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)





(
// iii
[3, 7].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// vii (3rd) inverted
[2, -2].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// i (5th)
[0, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)










(
// iv (3rd) inverted
[5, -4].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)


(
// vi
[-4, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)






(
// diad
[2, -2].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// vi  (octave)
[-4, 8].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)



(
// iii
[3, 7].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// ii
[2, 5].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// iv (3rd)
[5, 8].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// iv (5th)
[5, 0].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)



(
// 7th (3rd) inverted
[-2, 2].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)
(
// 7th (5th) inverted
[-2, 5].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)
(
// 7th (7th) inverted
[-2, 8].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)
(
// root (3rd)
[0, 3].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)
(
// root (5th)
[0, 7].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)
(
// root (7th) inverted
[0, -2].do {|degree| Synth(\organ, [freq: (66 + degree).midicps]); };
)

(
// root & 3rd
Synth(\organ, [freq: (66 + 0).midicps]);
Synth(\organ, [freq: (66 + 3).midicps]);
)

(
// root & 4th
Synth(\organ, [freq: (66 + 0).midicps]);
Synth(\organ, [freq: (66 + 5).midicps]);
)

(
// root & 5th
Synth(\organ, [freq: (66 + 0).midicps]);
Synth(\organ, [freq: (66 + 7).midicps]);
)

(
// root & 6th
Synth(\organ, [freq: (66 + 0).midicps]);
Synth(\organ, [freq: (66 + 8).midicps]);
)

(
// root & 7th
Synth(\organ, [freq: (66 + 0).midicps]);
Synth(\organ, [freq: (66 + 10).midicps]);
)

(
// root & octave
Synth(\organ, [freq: (66 + 0).midicps]);
Synth(\organ, [freq: (66 + 12).midicps]);
)

(
// 2nd & its 3rd
Synth(\organ, [freq: (66 + 2).midicps]);
Synth(\organ, [freq: (66 + 5).midicps]);
)

(
// 2nd & its 4th
Synth(\organ, [freq: (66 + 2).midicps]);
Synth(\organ, [freq: (66 + 7).midicps]);
)

(
// 2nd & its 5th (dim)
Synth(\organ, [freq: (66 + 2).midicps]);
Synth(\organ, [freq: (66 + 8).midicps]);
)

(
// 2nd & its 7th (dim)
Synth(\organ, [freq: (66 + 2).midicps]);
Synth(\organ, [freq: (66 + 10).midicps]);
)

(
// 2nd & its 7th (dim)
Synth(\organ, [freq: (66 + 2).midicps]);
Synth(\organ, [freq: (66 + 14).midicps]);
)


//////////////////////////////////////////////////////
// SPACE
(
var s, root, bpm, beat;
s = Server.default;
root = 60 + 6 + (12 * 1);
bpm = 128;
beat = 60 / bpm;
Routine({

	Routine({

		[
			[
				7, \, \, 8, 7, \, \, \,
				5, \, \, \, \, \, \, 2,
				8, \, \, \, \, \, \, 8,
				7, \, \, \, 2, \, \, \,

				5, \, \, \, \, \, \, \,
				5, \, \, \, \, \, \, \,
				3, \, \, \, 5, \, 8, \,
				7, \, \, \, \, \, \, \,
			],
			[
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-4, \, \, \, \, \, \, \,
				-5, \, \, \, -1, \, \, \,

				1, \, \, \, \, \, 1, 8,
				3, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,
				-1, \, \, \, -4, \, \, \,
			],

			-12 + [
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-4, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,

				1, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			],
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.03).wait;
								s.bind { Synth(\organ, [freq: (root + note).midicps]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;

	Routine({
		[
			-12 + [
				\, \, \, \, \, 3, -4, \,
				7, \, 8, 5, 8, 7, \, \,
				\, \, \, \, \, \, \, \,
				\, \, \, 7, 7, \, \, 8,
			],
			[
				\, 3, 7, \, \, \, \, \,
				\, \, \, \, \, \, \, \,
				\, 5, 2, 7, \, \, 2, 7,
				\, \, \, \, \, \, \, \,
			],
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.03).wait;
								// s.bind { Synth(\organ2, [freq: (root + note).midicps, velocity: 0.7 * rrand(0.5, 1.0)]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;

	Routine({
		loop {
			(beat * 2).wait;
			s.bind { Synth(\deepBass) };
			s.bind { Synth(\hiss) };
			(beat * 2).wait;
			s.bind { Synth(\hiss2) };
			(beat * 4).wait;

			s.bind { Synth(\deepBass) };
			(beat * 2).wait;
			s.bind { Synth(\hiss) };
			(beat * 2).wait;
			s.bind { Synth(\hiss2) };
			(beat * 2).wait;

			(beat * 2).wait;
		};
	}).play;

	Routine({
		loop {
			[0, 3, 2, -4, 1, 3, 2, -5].do { |note|
				s.bind { Synth(\strings, [freq: (root + note).midicps * (2 ** -2), duration: beat * 4]) };
				s.bind { Synth(\strings, [freq: (root + note).midicps * (2 ** -3), duration: beat * 4]) };
				(beat * 4).wait;
			};
		};
	}).play;

}).play;
)







// CURRENT
(
var s, root, bpm, beat;
s = Server.default;
root = 60 + 6 + (12 * 1);
bpm = 128;
beat = 60 / bpm;
Routine({

	Routine({

		[
			[
				7, 3, 8, 3, \, 5, \, \,
				3, \, \, \, \, \, \, 3,
				8, \, \, \, 5, \, \, \,
				-2, \, \, \, 2, \, \, \,

				7, \, \, 8, 3, \, 7, \,
				3, \, \, \, \, \, \, 3,
				8, \, \, \, 5, \, \, \,
				7, \, \, \, 2, \, \, \,
			],
			[
				2, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				2, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,

				2, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				2, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
			],
			-12 + [
				2, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				2, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,

				2, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				2, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
			],
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.02).wait;
								s.bind { Synth(\organ, [freq: (root + note).midicps]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;
}).play;
)





//////////////////////////////////////////////////////////////
// Saunter
//////////////////////////////////////////////////////////////


(
var s, root, bpm, beat;
s = Server.default;

root = 60 + 6 + (12 * 1);

bpm = 128;
beat = 60 / bpm;

Routine({


	Routine({
		[
			[
				8, \, \, \, \, 2, 5, 2,
				3, \, \, \, \, \, \, 3,
				7, \, \, \, \, \, \, 3,
				7, \, \, \, 5, \, \, \,

				7, \, \, \, \, \, \, \,
				3, \, \, \, 5, \, \, \,
				7, \, \, \, \, \, \, \,
				7, \, \, \, \, \, \, \,
			],
			[
				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,

				0, \, \, \, \, \, \, \,
				0, \, \, \, 2, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			],
			-12 + [
				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,

				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			]
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.02).wait;
								s.bind { Synth(\organ, [freq: (root + note).midicps]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;

	Routine({
		[
			-12 + [
				12 + 7, \, 12 + 3, \, \, \, \, \,
				\, 7, 8, 7, 0, \, \, \,
				\, \, \, 3, 3, \, \, 5,
				5, \, \, 3, 3, 2, 5, \,
			],
			[
				\, \, \, \, \, \, \, \,
				\, \, \, \, \, \, \, \,
				\, 2, 3, 7, 12, 12, 7, 3,
				7, \, \, \, \, \, \, \,
			],
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.03).wait;
								// s.bind { Synth(\organ2, [freq: (root + note).midicps, velocity: 0.9 * rrand(0.5, 1.0)]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;

}).play;
)








//////////////////////////////////////////////////////////////
// Saunter 2
//////////////////////////////////////////////////////////////


(
var s, root, bpm, beat;
s = Server.default;
root = 60 + 6 + (12 * 1);
bpm = 128;
beat = 60 / bpm;

Routine({
	Routine({
		[
			[
				8, \, \, \, \, 2, 5, 2,
				3, \, \, \, \, \, \, 3,
				7, \, \, \, \, \, \, 3,
				7, \, \, \, 5, \, \, \,

				7, \, \, \, \, \, \, \,
				3, \, \, \, 5, \, \, \,
				7, \, \, \, \, \, \, \,
				7, \, \, \, \, \, \, \,
			],
			[
				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,

				0, \, \, \, \, \, \, \,
				0, \, \, \, 2, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			],
			-12 + [
				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,

				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			]
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.02).wait;
								s.bind { Synth(\organ, [freq: (root + note).midicps]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;

	/*Routine({
		[
			-12 + [
				12 + 7, \, 12 + 3, \, \, \, \, \,
				\, 7, 8, 7, 0, \, \, \,
				\, \, \, 3, 3, \, \, 5,
				5, \, \, 3, 3, 2, 5, \,
			],
			[
				\, \, \, \, \, \, \, \,
				\, \, \, \, \, \, \, \,
				\, 2, 3, 7, 12, 12, 7, 3,
				7, \, \, \, \, \, \, \,
			],
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.03).wait;
								s.bind { Synth(\organ2, [freq: (root + note).midicps, velocity: 0.9 * rrand(0.5, 1.0)]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;*/

}).play;
)





//////////////////////////////////////////////////////////////
// Saunter 2
//////////////////////////////////////////////////////////////

Scale.aeolian.degrees;
// [ 0, 1, 3, 5, 7, 8, 10 ] // prygian
// [ 0, 2, 3, 5, 7, 8, 10 ] // aeolian
// [ 0, 2, 3, 5, 7, 8, 11 ] // harmonic minor
(
var s, root, bpm, beat;
s = Server.default;
root = 60 + 6 + (12 * 1);
bpm = 128;
beat = 60 / bpm;

Routine({
	Routine({
		[
			[
				7, \, \, \, \, \, \, \,
				7, \, \, \, \, \, \, \,
				5, \, \, \, \, \, \, \,
				7, \, \, \, \, \, \, \,

				5, \, \, \, \, \, \, \,
				2, \, \, \, \, \, \, \,
				8, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
			],
			[
				-5, \, \, \, \, \, \, \,
				3, \, \, \, 2, \, \, \,
				-1, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,

				-1, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			],
			-12 + [
				-5, \, \, \, \, \, \, \,
				3, \, \, \, 2, \, \, \,
				-1, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,

				-1, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			]
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.02).wait;
								s.bind { Synth(\organ, [freq: (root + note).midicps]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;
}).play;
)

