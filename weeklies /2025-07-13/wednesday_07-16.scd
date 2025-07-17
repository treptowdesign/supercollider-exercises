
(
SynthDef(\pad, {
	var snd;
	snd = (\freq.kr(220) * (1 * (1..12))).collect { |freq, index|
		var snd;
		snd = SinOsc.ar((freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) + (WhiteNoise.ar(1 ! 2) * 100));
		snd = snd * (1 / (1 + index).sqrt) * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / 2.sqrt; // <= midSides
		snd;
	};
	snd = snd.sum;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.perc(0.001, \rel.kr(1), curve: -2).ar;
	snd = snd * Env.linen(0, \duration.kr(4), 0.1).ar(Done.freeSelf);
	snd = snd * -12.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)


Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]



(
var s, beat, bar, root;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;
Routine({
	loop {
		[
			(notes: (1 + [0, 4, 7, 11]).postln, length: 3),
			(notes: (1 + [0, 4, 7, 11]).postln, length: 1),
			(notes: (7 + [-5, -2, 0, 3]).postln, length: 3),
			(notes: (7 + [-5, -2, 0, 3]).postln, length: 1),
			(notes: (0 + [0, 2, 7, 10]).postln, length: 3),
			(notes: (0 + [0, 2, 7, 10]).postln, length: 1),
			(notes: (0 + [0, 3, 7, 10]).postln, length: 3),
			(notes: (0 + [0, 3, 7, 10]).postln, length: 1),
		].do { |chord|
			chord[\notes].do { |deg, index|
				Synth(\pad, [freq: (root + (12 * 1) + deg).midicps, amp: (1 / (1 + index).sqrt)]);
			};
			(chord[\length] * beat).wait;
		};
	};
}).play;
)




(
var s, beat, bar, root;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;
Routine({
	loop {
		[
			(notes: (1 + [0, 4, 7, 11]).postln, length: 1),
			(notes: (7 + [-5, -2, 0, 3]).postln, length: 1),
			(notes: (0 + [0, 2, 7, 10]).postln, length: 1),
			(notes: (0 + [0, 3, 7, 10]).postln, length: 1),
		].do { |chord|
			chord[\notes].do { |deg, index|
				Synth(\pad, [freq: (root + (12 * 1) + deg).midicps, amp: (1 / (1 + index).sqrt)]);
			};
			(chord[\length] * beat).wait;
		};
	};
}).play;
)



(
var s, beat, bar, root;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;
Routine({
	loop {
		[
			(notes: [-4, 0, 3, 7], length: 2),
			(notes: [-2, 1, 5, 8], length: 2),
			(notes: [-4, 0, 3], length: 2),
			(notes: [-5, 2, 5], length: 2),
		].do { |chord|
			chord[\notes].do { |deg, index|
				Synth(\pad, [freq: (root + (12 * 1) + deg).midicps, amp: (1 / (1 + index).sqrt)]);
			};
			(chord[\length] * beat).wait;
		};
	};
}).play;
)








(1 / (1 + (0..5)).sqrt);
(1 / (1 + (0..5)));



{WhiteNoise.ar(1 ! 2)}.plot(0.3);



(
var s, beat, bar, root;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;
Routine({
	loop {
		[
			(notes: (0 + [-4, 0, 3, 7]), length: 4),
			(notes: (1 + [-5, 0, 3, 10]), length: 4),
			(notes: (8 + [-5, -2, 0, 3]), length: 4),
			(notes: (7 + [-5, -2, 0, 4]), length: 4),
		].do { |chord|
			chord[\notes].do { |deg, index|
				Synth(\pad, [freq: (root + (12 * 1) + deg).midicps, amp: (1 / (1 + index).sqrt)]);
			};
			(chord[\length] * beat).wait;
		};
	};
}).play;
)















// endfile