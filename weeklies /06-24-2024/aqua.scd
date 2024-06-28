(
SynthDef(\square8, { |freq=440, pWidth=0.5, cutoff=12000, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * (SinOsc.kr(8) * 0.1).midiratio, pWidth);
	snd = snd * Env.perc(0, 0.3).ar.range(1.2, 0.8);
	snd = RLPF.ar(snd, cutoff, 1);
	snd = snd * Env.linen(0.02, duration * span, 0.02).ar(Done.freeSelf);
	snd = snd * AmpComp.ir(freq);
	// snd = LeakDC.ar(snd);
	Out.ar(0, snd * -15.dbamp * amp.dbamp ! 2);
}).add;
)

Scale.major.degrees;

[  0,  2,  4,  5,  7,  9, 11 ]
[ 12, 14, 16, 17, 19, 21, 23 ]

(
var root;
root = 35;
( [0, 4, 7, 12, 16]).do { |degree|
	var note = (root + degree + (12 * 3)).midicps;
	Synth(\square8, [freq: note]);
};
)

(
var root;
root = 36;
( -1 + [0, 4, 7, 11, 20]).do { |degree|
	var note = (root + degree + (12 * 3)).midicps;
	Synth(\square8, [freq: note]);
};
)





(
var s, root, bpm, beat;
s = Server.default;
root = 36; // C
bpm = 56;
beat = 60 / bpm;

Routine({
	loop {

		[
			// treble
			[
				(notes: [7, 4 + 12], length: 1/3),
				(notes: \, length: 1/3),
				(notes: \, length: 1/3),
				(notes: (-1 + [7, 4 + 12]), length: 1/3),
				(notes: \, length: 1/3),
				(notes: \, length: 1/3),
				(notes: [7, 4 + 12], length: 1/3),
				(notes: \, length: 1/3),
				(notes: \, length: 1/3),
			],
			// bass
			[
				(notes: [0 -12], length: 1/3),
				(notes: [7 -12], length: 1/3),
				(notes: [12 -12], length: 1/3),
				(notes: (-1 + [0 -12]), length: 1/3),
				(notes: (-1 + [8 -12]), length: 1/3),
				(notes: (-1 + [12 -12]), length: 1/3),
				(notes: [0 -12], length: 1/3),
				(notes: [7 -12], length: 1/3),
				(notes: [12 -12], length: 1/3),
			]

		].do { |voice|
			voice.do { |part|
				var degrees, dur;
				degrees = part[\notes];
				dur = part[\length];
				Routine({
					degrees.do { |degree|
						var note = (root + degree + (12 * 2)).midicps;
						s.bind { Synth(\square8, [freq: note, duration: dur * beat, span: 0.6]); };
					};
					(dur * beat).wait;
				}).play;
				(dur.sum * beat).wait;
			};
		};
	};
}).play

)





(
var root;
root = 36;
( [0, 4, 7, 12, 16]).do { |degree|
	var note = (root + degree + (12 * 3)).midicps;
	Synth(\square8, [freq: note]);
};
)

(
var root;
root = 35;
( 0 + [0, 4, 7, 10, 20]).do { |degree|
	var note = (root + degree + (12 * 3)).midicps;
	Synth(\square8, [freq: note]);
};
)


(
var s, root, bpm, beat;
s = Server.default;
root = 36; // C
bpm = 56;
beat = 60 / bpm;

Routine({
    loop {
        var totalLength = 0;
        var voices = [
            // treble
			[
				// measure 1
                (notes: [7, 4 + 12], length: 1/6),
                (notes: \, length: 5/6),
				// measure 2
                (notes: [ 6, 15 ], length: 1/6),
                (notes: \, length: 5/6),
				// measure 3
                (notes: [7, 4 + 12], length: 1/6),
                (notes: \, length: 5/6),
				// measure 4
				(notes: \, length: 1/6),
				(notes: [7], length: 1/6),
				(notes: [9], length: 1/6),
				(notes: [11], length: 1/6),
				(notes: [12], length: 1/6),
				(notes: [14], length: 1/6),

				// measure 5
                (notes: [7, 4 + 12], length: 1/6),
                (notes: \, length: 5/6),
				// measure 6
                (notes: [ 6, 15 ], length: 1/6),
				(notes: \, length: 3/6),
				(notes: [ 9, 17 ], length: 1/6),
                (notes: \, length: 1/6),
				// measure 7
                (notes: [7, 4 + 12], length: 1/6),
                (notes: \, length: 5/6),
				// measure 8
				(notes: \, length: 5/6),
				(notes: [18], length: 1/6),

            ],
            // bass
            [
				// measure 1
                (notes: [0 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [7 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [12 -12], length: 1/6),
				(notes: \, length: 1/6),
				// measure 2
                (notes: [ -13 ], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [ -5 ], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [ -1 ], length: 1/6),
				(notes: \, length: 1/6),
				// measure 3
                (notes: [0 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [7 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [12 -12], length: 1/6),
				(notes: \, length: 1/6),
				// measure 4
				(notes: [4 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [7 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [12 -12], length: 1/6),
				(notes: \, length: 1/6),

				// measure 5
                (notes: [0 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [7 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [12 -12], length: 1/6),
				(notes: \, length: 1/6),
				// measure 6
                (notes: [ -13 ], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [ -5 ], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [ -1 ], length: 1/6),
				(notes: \, length: 1/6),
				// measure 7
                (notes: [0 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [7 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [12 -12], length: 1/6),
				(notes: \, length: 1/6),
				// measure 8
				(notes: [4 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [7 -12], length: 1/6),
				(notes: \, length: 1/6),
                (notes: [12 -12], length: 1/6),
				(notes: \, length: 1/6),
            ]
        ];

        // Calculate the total length of the loop
        voices.do { |voice|
            voice.do { |part|
                totalLength = totalLength + part[\length];
            };
        };

        voices.collect { |voice|
            Routine({
                voice.do { |part|
                    var degrees, dur;
                    degrees = part[\notes];
                    dur = part[\length];
                    degrees.do { |degree|
                        if (degree != \,) {
                            var note = (root + degree + (12 * 2)).midicps;
                            s.bind { Synth(\square8, [freq: note, duration: dur * beat, span: 1]); };
                        };
                    };
                    (dur * beat).wait;
                };
            });
        }.do { |routine|
            routine.play;
        };

		((totalLength / voices.size) * beat).wait; // Wait for the total length of the loop
    };
}).play
)

