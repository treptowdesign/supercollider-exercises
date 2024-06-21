(
SynthDef(\synth, { |freq=440|
	var snd;
	snd = SinOsc.ar(
		freq * [1, 2, 5, 7, 10] * (LFNoise2.ar(8 ! 5) * 0.1).midiratio,
		[pi/2, 0, pi, 0, pi/4],
		[1, 1/3, 1/9, 1/24, 1/46]
	).sum;
	snd = snd * Env.perc(0.01, 1.6).ar(Done.freeSelf);
	Out.ar(0, snd * -12.dbamp ! 2);
}).add;
SynthDef(\strings, {
	var snd, freq, detune, rate;
	freq = \freq.kr(440);
	rate = 10;
	detune = ((LFNoise2.kr(3 * rate) * 0.3) + (LFNoise2.kr(8) * 0.1) + Line.kr(10, 0, 0.003)).midiratio;
	snd = SinOsc.ar(
		freq
		* (LFNoise2.kr(3 ! 8 * rate) * 0.7).midiratio * detune)
	    * 200
	    * (1 + Env.perc(0.05 * ExpRand(0.5, 2.0), 0.3 * ExpRand(0.5, 2.0)).ar
	);
	snd = SinOsc.ar((freq * (LFNoise2.kr(3 ! 8 * rate) * 0.1).midiratio * detune) + snd);
	snd = snd * (1 + LFNoise2.ar(3 ! snd.size));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, LFNoise2.kr(3).linexp(0, 1, 600, 800));
	snd = snd * Env.linen(0.01, \duration.kr(2.0), 0.2, curve: -4).ar(Done.freeSelf);
	snd = Limiter.ar(snd);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
SynthDef(\noise, {
	var snd;
	snd = WhiteNoise.ar.pow(4);
	snd = Latch.ar(snd, Impulse.ar(5000));
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	Out.ar(0, snd * -10.dbamp ! 2);
}).play;
)

// C, C#/Db, D, D#/Eb, E, F, F#/Gb, G, G#/Ab, A, A#/Bb, B

// 0      1  2  3      4  5      6  7      8   9  10 11
// D#/Eb, E, F, F#/Gb, G, G#/Ab, A, A#/Bb, Bb, B, C, C#/Db

Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]


Synth(\strings, [freq: (58 + 14).midicps]);
Synth(\strings, [freq: (58 + 10).midicps]);
Synth(\strings, [freq: (58 + 7).midicps]);


Synth(\strings, [freq: (58 + 5).midicps]);
Synth(\strings, [freq: (58 + 8).midicps]);
Synth(\strings, [freq: (58 + 10).midicps]);
Synth(\strings, [freq: (58 + 5).midicps]);
Synth(\strings, [freq: (58 + 10).midicps]);

(
var root;
root = 58;
[-12, 2, 7, 10].do{ |degree| // Bb7 sus2
	Synth(\strings, [freq: (root + degree).midicps]);
};
)

(
var root;
root = 58;
[-14, 1, 5, 8].do{ |degree| // Ab min7
	Synth(\strings, [freq: (root + degree).midicps]);
};
)

Synth(\synth, [freq: (58 + 12.neg).midicps]); // root


Synth(\synth, [freq: (58 + 14).midicps]);
Synth(\synth, [freq: (58 + 10).midicps]);
Synth(\synth, [freq: (58 + 7).midicps]);


Synth(\synth, [freq: (58 + 5).midicps]);
Synth(\synth, [freq: (58 + 8).midicps]);
Synth(\synth, [freq: (58 + 10).midicps]);
Synth(\synth, [freq: (58 + 5).midicps]);
Synth(\synth, [freq: (58 + 10).midicps]);

(
var root;
root = 58;
[-12, 2, 7, 10].do{ |degree| // Bb7 sus2
	Synth(\synth, [freq: (root + degree).midicps]);
};
)

(
var root;
root = 58;
[-14, 1, 5, 8].do{ |degree| // Ab min7
	Synth(\synth, [freq: (root + degree).midicps]);
};
)







(
var root;
root = 58; // Bb7 sus2
[0, 2, 10, 14].do{ |degree|
	Synth(\synth, [freq: (root + degree).midicps]);
};
)

(
var root;
root = 56; // Ab min7
[0, 3, 10].do{ |degree|
	Synth(\synth, [freq: (root + degree).midicps]);
};
)