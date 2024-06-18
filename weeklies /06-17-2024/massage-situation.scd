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
)


(
SynthDef(\noise, {
	var snd;
	snd = WhiteNoise.ar.pow(4);
	snd = Latch.ar(snd, Impulse.ar(5000));
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	Out.ar(0, snd * -12.dbamp ! 2);
}).play;
)

Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]


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