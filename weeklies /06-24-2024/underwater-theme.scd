(
SynthDef(\square8, { |freq=440, pWidth=0.5, cutoff=12000, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * (SinOsc.kr(8) * 0.05).midiratio, pWidth);
	snd = snd * Env.perc(0, 0.3).ar.range(0.6, 1);
	snd = RLPF.ar(snd, cutoff, 1);
	snd = snd * Env.perc(0.01, duration * span, curve: 3).ar(Done.freeSelf);
	// snd = snd * Env.linen(0.01, duration * span, 0.02).ar(Done.freeSelf);
	// snd = snd * AmpComp.ir(freq);
	// snd = LeakDC.ar(snd);
	Out.ar(0, snd * -15.dbamp * amp.dbamp ! 2);
}).add;
)

// Env.perc(0.01, 3, curve: 3).range(0.8, 1.0).plot;

Synth(\square8, [freq: (36 + 13.neg + (12 * 3)).midicps, duration: 0.3]);


(
var root = 36;
( 0 + [-12, -5, 0, 7, 16]).do { |degree|
	Synth(\square8, [freq: (root + degree + (12 * 2)).midicps]);
};
)

(
var root = 36;
( -1 + [-12, -4, 0, 7, 16]).do { |degree|
	Synth(\square8, [freq: (root + degree + (12 * 2)).midicps]);
};
)

(
var root = 36;
( -1 + [-12, 0, 4, 7, 20]).do { |degree|
	Synth(\square8, [freq: (root + degree + (12 * 2)).midicps]);
};
)

(
var s, root, bpm, beat;
s = Server.default;
root = 36; // C
bpm = 72;
beat = 60 / bpm;

Routine({
    loop {
        var totalLength = 0;
        var voices = [
            // treble
			(active: 1, octave: 2, args: [pWidth: 0.5], schedule: [
				/////////////////////////////////////////////////////////
				// measure 1: C
                (notes: [7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 2: B7 (b13)
                (notes: [6, 15], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 3: C
                (notes: [7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 4
				(notes: \, length: 1/6),
				(notes: [7], length: 1/6, span: 0.8),
				(notes: [9], length: 1/6, span: 0.8),
				(notes: [11], length: 1/6, span: 0.8),
				(notes: [12], length: 1/6, span: 0.8),
				(notes: [14], length: 1/6, span: 0.8),

				/////////////////////////////////////////////////////////
				// measure 5: C
                (notes: [7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 6: B7 (b13)
                (notes: [6, 15], length: 1/6, span: 2.8),
				(notes: \, length: 3/6),
				(notes: [9, 17], length: 1/6, span: 2.8),
                (notes: \, length: 1/6),
				// measure 7: C
                (notes: [7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 8
				(notes: \, length: 5/6),
				(notes: [7], length: 1/6, span: 1.2),

				/////////////////////////////////////////////////////////
				// measure 9: G7
				(notes: [5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 10: F#7
				(notes: [4, 13], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 11: G7
				(notes: [5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 12
				(notes: \, length: 1/6),
				(notes: [7], length: 1/6, span: 0.8),
				(notes: [9], length: 1/6, span: 0.8),
				(notes: [11], length: 1/6, span: 0.8),
				(notes: [12], length: 1/6, span: 0.8),
				(notes: [13], length: 1/6, span: 0.8),

				/////////////////////////////////////////////////////////
				// measure 13: G7
				(notes: [5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 14
				(notes: [-1, 7], length: 1/6, span: 2.8),
                (notes: \, length: 3/6),
				(notes: [9, 17], length: 1/6, span: 2.8),
                (notes: \, length: 1/6),
				// measure 15: C
				(notes: [7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 16
				(notes: \, length: 5/6),
				(notes: [7], length: 1/6, span: 1.2),

				/////////////////////////////////////////////////////////
				// measure 17: C
                (notes: [16, 19], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 18: G/B
                (notes: [14, 19], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 19: Bb dim7
                (notes: [13, 19], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 20
				(notes: [19], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				(notes: [21], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				(notes: \, length: 1/6),
				(notes: [19], length: 1/6, span: 0.8),

				/////////////////////////////////////////////////////////
				// measure 21: Dm
                (notes: [14, 17], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 22: Db+
                (notes: [13, 17], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 23: F/C
                (notes: [12, 17], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 24: G7
				(notes: [17], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				(notes: [19], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				(notes: \, length: 1/6),
				(notes: [17], length: 1/6, span: 0.8),

				/////////////////////////////////////////////////////////
				// measure 25: C
                (notes: [12, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 26: G7
                (notes: [5, 9], length: 1/6, span: 1),
                (notes: \, length: 1/6),
				(notes: [7, 11], length: 1/6, span: 1),
                (notes: \, length: 1/6),
				(notes: [11, 17], length: 1/6, span: 1),
                (notes: \, length: 1/6),
				// measure 27: G13/F
                (notes: [11, 16], length: 1/6, span: 0.8),
				(notes: [11, 16], length: 1/6, span: 0.8),
				(notes: [11, 16], length: 2/6, span: 0.8),
				(notes: [5, 11], length: 2/6, span: 0.8),
				// measure 28: C
				(notes: [4, 12], length: 1/6, span: 2.4),
				(notes: \, length: 5/6),

				// end //////////////////////////////////////////////////

			]),
            // bass
			(active: 1, octave: 2, args: [pWidth: 0.2], schedule: [
				/////////////////////////////////////////////////////////
				// measure 1
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 2
                (notes: [-13], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 3
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 4
				(notes: [-8], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),

				/////////////////////////////////////////////////////////
				// measure 5
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 6
                (notes: [-13], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 7
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 8
				(notes: [-8], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),

				/////////////////////////////////////////////////////////
				// measure 9
                (notes: [-10], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 10
                (notes: [-11], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-6], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-2], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 11
                (notes: [-10], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 12
				(notes: [-13], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				(notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),

				/////////////////////////////////////////////////////////
				// measure 13
                (notes: [-10], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 14
                (notes: [-13], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-1], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 15
				(notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 16
				(notes: [-17], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [0], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),

				/////////////////////////////////////////////////////////
				// measure 17
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [4], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 18
                (notes: [-13], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [3], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 19
                (notes: [-14], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [3], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 20
				(notes: [-14], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [4], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),

				/////////////////////////////////////////////////////////
				// measure 21
                (notes: [-10], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 22
                (notes: [-11], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-3], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 23
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-3], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 24
				(notes: [-13], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),

				/////////////////////////////////////////////////////////
				// measure 25
                (notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [4], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 26
                (notes: [-17], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
                (notes: [-5], length: 1/6, span: 0.8),
				(notes: \, length: 1/6),
				// measure 27
                (notes: [-7], length: 5/6, span: 1.1), // 1.8
                (notes: [-13], length: 1/6, span: 0.8),
				// measure 28
				(notes: [-12], length: 1/6, span: 0.8),
				(notes: \, length: 5/6),

				// end //////////////////////////////////////////////////


			])
        ];

        // calculate loop length
        voices.do { |voice|
			voice[\schedule].do { |part|
                totalLength = totalLength + part[\length];
            };
        };

        voices.collect { |voice|
            Routine({
				var octave;
				octave = voice[\octave];
				voice[\schedule].do { |part|
                    var degrees, dur;
                    degrees = part[\notes];
                    dur = part[\length] * beat;
                    degrees.do { |degree|
                        if (degree != \ && voice[\active] == 1) {
                            var note = (root + degree + (12 * octave)).midicps;
							s.bind { Synth(\square8, [freq: note, duration: dur, span: part[\span]] ++ voice[\args]); };
                        };
                    };
                    (dur).wait;
                };
            });
        }.do { |routine|
            routine.play;
        };

		((totalLength / voices.size) * beat).wait;
    };
}).play
)


s.makeWindow;

