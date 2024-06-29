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
			(active: 1, octave: 2, schedule: [
				/////////////////////////////////////////////////////////
				// measure 1: C
                (notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 2: B7 (b13)
				(notes: [-13, 6, 15], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 3: C
                (notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 4: C
                (notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),

				/////////////////////////////////////////////////////////
				// measure 5: C
                (notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 6: B7 (b13)
				(notes: [-13, 6, 15], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 7: C
                (notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 8: C
                (notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),

				/////////////////////////////////////////////////////////
				// measure 9: G7
				(notes: [-10, 5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 10: F#7
				(notes: [-11, 4, 13], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 11: G7
				(notes: [-10, 5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 12
				(notes: [-10, 5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),

				/////////////////////////////////////////////////////////
				// measure 13: G7
				(notes: [-10, 5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 14
				(notes: [-10, 5, 14], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 15: C
				(notes: [-12, 7, 16], length: 1/6, span: 2.8),
                (notes: \, length: 5/6),
				// measure 16
				(notes: [-12, 7, 16], length: 1/6, span: 2.8),
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
							s.bind { Synth(\square8, [freq: note, duration: dur, span: part[\span]]); };
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

