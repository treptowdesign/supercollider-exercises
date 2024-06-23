(
SynthDef(\organ, {
	var snd, duration, freq;
	freq = \freq.kr(440);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq * [1, 3, 5] * (LFNoise2.kr(7 ! 3) * 0.2).midiratio);
	snd = snd * Env.perc(0, [5.5, 7, 4]).ar;
	snd = snd * [-2, 0, -10].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -5.dbamp, 16, 4, damping: 0.2);
	snd = snd * AmpComp.ir(freq);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.8).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

)

// scales
Scale.aeolian.degrees; // [0, 2, 3, 5, 7, 8, 10]
Scale.dorian.degrees; // [0, 2, 3, 5, 7, 9, 10]
Scale.phrygian.degrees; // [0, 1, 3, 5, 7, 8, 10]

Scale.harmonicMinor.degrees; // [ 0, 2, 3, 5, 7, 8, 11 ]


// Quartal Phrygian
// [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17, 19, 20, 22, 24, 25, 27, 29, 31, 32, 34 ]

(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 44; //
scale = Scale.aeolian.degrees;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[

			(notes:  [0, 5, 10, 15], length: 4),
			(notes:  [1, 7, 12, 17], length: 4),
			(notes:  [3, 8, 13, 19], length: 4),
			(notes:  [5, 10, 15, 20], length: 4),

		].do { |chord|
			notes = chord[\notes].sort;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.1).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)




// basic
(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 44; //
scale = Scale.aeolian.degrees;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			// (notes:  0 + [0, 7, 9, 2], length: 4), // root, 5th, 13th (6th), 9th (2nd)
			(notes:  0 + [0, 5, 7, 14], length: 4),

		].do { |chord|
			notes = chord[\notes].sort;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.1).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)






(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 44; //
scale = Scale.aeolian.degrees;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			// i (sus2) -> vii
			(notes:  0 + [0, 2, 7, 12], length: 4),
			(notes: -2 + [0, 3, 7, 12], length: 4),

		].do { |chord|
			notes = chord[\notes].sort;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.2).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)


// Explicit interval numbers
(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42; // 42 = F# / Gb
scale = Scale.aeolian.degrees;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			// iv - bii - v - i
			(notes: [5 - 12, 5, 8, 12, 15], length: 4),
			(notes: [1 - 12, 1, 5, 8, 12], length: 4),
			(notes: [7 - 12, 7, 10, 14, 17], length: 4),
			(notes: [0 - 12, 0, 3, 7, 10], length: 4),

		].do { |chord|
			notes = chord[\notes].sort;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.2).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)
