
(
SynthDef(\pad2, {
	var snd;
	snd = (\freq.kr(220) * (1.5 * (1..8))).collect { |freq, index|
		var snd;
		snd = SinOsc.ar((freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) + (WhiteNoise.ar(1 ! 2) * 50));
		snd = snd * (1 / (1 + index).sqrt) * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / 2.sqrt; // <= midSides
		snd;
	};
	snd = snd.sum;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.perc(0.001, \rel.kr(1), curve: -4).ar;
	snd = snd * Env.linen(0, \duration.kr(4), 0.1).ar(Done.freeSelf);
	snd = snd * -8.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq, fb, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (LFNoise2.ar(3 ! 8) * 0.2).midiratio * [1, 2, 1, 2, 2, 1, 2, 1], LFNoise2.ar(3 ! 8).linlin(-1, 1, 0.1, 0.9));
	snd = snd * LFNoise2.ar(8 ! snd.size).linlin(-1, 1, 0.5, 1);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, freq * XLine.ar(1, 3, duration));
	snd = ((snd + 0.1) * 4.dbamp).tanh;
	snd = LeakDC.ar(snd);
	snd = snd + DelayC.ar(snd * -8.dbamp, 0.2, SinOsc.ar(Rand(0.1, 0.3), [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-4);
	snd = snd * freq.explin(100, 3000, 0, -8).dbamp;
	snd = snd * -14.dbamp;
	snd = snd * Env.linen(0.001, duration * 0.9, duration * 0.1, curve: -8).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
// REVERB FROM NATHAN HO SYNTHDEF - DECONSTRUCTING
SynthDef(\reverbFx, {
	var snd, wet;
	snd = In.ar(\in.kr(0), 2);
	wet = snd;
	// 1) Early Reflection Smear
	wet = AllpassC.ar(wet, 0.2, [0.0344, 0.05], 0.1);
	// 2) Feedback Loop Preparation
	wet = [wet[0], wet[1], wet[0], wet[1]] + LocalIn.ar(4);
	// 3) Multi-tap Delay: Diffusion
	wet = DelayC.ar(wet, 1.0, [0.2, 0.343, 0.4335, 0.5242] * 0.2);
	// 4) Modulated Allpass: Dense, Evolving Texture
	wet = AllpassC.ar(wet, 0.2, ([0.12, 0.445, 0.31, 0.38] * 0.03) + (LFNoise2.ar(3 ! 4) * 0.0001), [0.3, 0.5, 0.6, 0.7]);
	// 5) Second Allpass Layer
	wet = AllpassC.ar(wet, 0.2, [0.42, 0.245, 0.11, 0.78] * 0.01, [0.3, 0.5, 0.6, 0.7]);
	// 6) Tone Shaping (EQ)
	wet = wet * -2.dbamp;
	wet = LPF.ar(wet, 3000);
	wet = HPF.ar(wet, 100);
	// 7) Hadamard Matrix: Feedback Mixing
	wet = wet * ([
		[1, 1, 1, 1],
		[1, -1, 1, -1],
		[1, 1, -1, -1],
		[1, -1, -1, 1],
	] / 2);
	wet = wet.sum;
	LocalOut.ar(wet);
	// 8) Stereo Reassembly + Final Delay
	wet = [wet[0] + wet[3], wet[1] + wet[2]];
	wet = DelayC.ar(wet, 0.05, 0.05);
	wet = wet * -5.dbamp * \wet.kr(1).lag(0.1);
	snd = snd + wet;

	Out.ar(\out.kr(0), snd);
}).add;
)


(
~reverbBus = Bus.audio(nil, 2);
)
~reverbBus.index;


Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]


//////////////////////////////////////////////////////////
// 2-5-1
//////////////////////////////////////////////////////////
(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;

wait = { |duration=1|
	(duration).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	playParallel.(synthDef, duration, [duration: duration] ++ args, latency);
	wait.(duration);
};

Routine({
	Synth(\reverbFx, [in: ~reverbBus, wet: 0.5]);
	loop {
		[
			// b2 major (prygian) =================================
			/*(notes: (1 + [0, 4, 7, 11]), length: 3),
			(notes: (1 + [0, 4, 7, 11]), length: 1),*/
			// 2 dim ==============================================
			(notes: (2 + [0, 3, 6, 10]), length: 3),
			(notes: (2 + [0, 3, 6, 10]), length: 1),
			// 4 min =================================
			/*(notes: (5 + [-2, 0, 3, 7]), length: 3),
			(notes: (5 + [-2, 0, 3, 7]), length: 1),*/
			// 5 min ==============================================
			(notes: (7 + [-5, -2, 0, 3]), length: 3),
			(notes: (7 + [-5, -2, 0, 3]), length: 1),
			// b7 min ===========================================
			/*(notes: (10 + [-9, -5, -2, 0]), length: 3),
			(notes: (10 + [-9, -5, -2, 0]), length: 1),*/
			// 1 sus2 =============================================
			(notes: (0 + [0, 2, 7, 10]), length: 3),
			(notes: (0 + [0, 2, 7, 10]), length: 1),
			// 1 minor ============================================
			(notes: (0 + [0, 3, 7, 10]), length: 3),
			(notes: (0 + [0, 3, 7, 10]), length: 1),
		].do { |chord|
			chord[\notes].do { |deg, index|
				[
					(octave: 2, amp: 0.5),
					(octave: 1, amp: 1),
					// (octave: 0, amp: 1)
				].do { |voice|
					playParallel.(\pad, (chord[\length] * beat), [
						freq: (root + (12 * voice[\octave]) + deg).midicps,
						amp: (1 / (1 + index).sqrt) * voice[\amp],
						// amp: 1 * voice[\amp],
						duration: (chord[\length] * beat),
						out: ~reverbBus
						// out: 0
					]);
				};
			};
			wait.(chord[\length] * beat);
		};
	};
}).play;
)




//////////////////////////////////////////////////////////
// 2-5-1 Arpeggio
//////////////////////////////////////////////////////////
(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;

wait = { |duration=1|
	(duration).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	playParallel.(synthDef, duration, [duration: duration] ++ args, latency);
	wait.(duration);
};

Routine({
	Synth(\reverbFx, [in: ~reverbBus, wet: 0.25]);
	loop {
		[
			// b2 major (prygian) =================================
			(notes: (1 + [0, 4, 7, 11]), length: 3),
			(notes: (1 + [0, 4, 7, 11]), length: 1),
			// 2 dim ==============================================
			/*(notes: (2 + [0, 3, 6, 10]), length: 3),
			(notes: (2 + [0, 3, 6, 10]), length: 1),*/
			// 4 min =================================
			/*(notes: (5 + [-2, 0, 3, 7]), length: 3),
			(notes: (5 + [-2, 0, 3, 7]), length: 1),*/
			// 5 min ==============================================
			(notes: (7 + [-5, -2, 0, 3]), length: 3),
			(notes: (7 + [-5, -2, 0, 3]), length: 1),
			// b7 major ===========================================
			/*(notes: (10 + [-8, -5, -1, 0]), length: 3),
			(notes: (10 + [-8, -5, -1, 0]), length: 1),*/
			// 1 sus2 =============================================
			(notes: (0 + [0, 2, 7, 10]), length: 3),
			(notes: (0 + [0, 2, 7, 10]), length: 1),
			// 1 minor ============================================
			(notes: (0 + [0, 3, 7, 10]), length: 3),
			(notes: (0 + [0, 3, 7, 10]), length: 1),
		].do { |chord|
			chord[\notes].do { |deg, index|
				[
					// (octave: 2, amp: 0.1),
					(octave: 1, amp: 0.4),
					(octave: 0, amp: 1)
				].do { |voice|
					playParallel.(\pad, (chord[\length] * beat * 0.25), [
						freq: (root + (12 * voice[\octave]) + deg).midicps,
						amp: (1 / (1 + index).sqrt) * voice[\amp],
						duration: (chord[\length] * beat),
						out: ~reverbBus
					]);
				};
				wait.(chord[\length] * beat * 0.25);
			};
			// wait.(chord[\length] * beat);
		};
	};
}).play;
)

//////////////////////////////////////////////////////////
// Standard Rock
//////////////////////////////////////////////////////////

(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 42;

wait = { |duration=1|
	(duration).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	playParallel.(synthDef, duration, [duration: duration] ++ args, latency);
	wait.(duration);
};

Routine({
	Synth(\reverbFx, [in: ~reverbBus, wet: 0.2]);
	loop {
		[
			// rock IV–V–I ========================================
			/*(notes: (5 + [-5, 0, 4]), length: 2),
			(notes: (7 + [-5, 0, 4]), length: 2),
			(notes: (0 + [0, 4, 7]), length: 4),*/
			// I–♭VII–IV ==========================================
			/*(notes: (0 + [0, 4, 7]), length: 2),
			(notes: (10 + [-8, -5, 0]), length: 2),
			(notes: (5 + [-5, 0, 4]), length: 4),*/
			// I–V–vi–IV ==========================================
			(notes: (0 + [0, 4, 7]), length: 2),
			(notes: (7 + [-5, 0, 4]), length: 2),
			(notes: (9 + [-9, -5, 0]), length: 2),
			(notes: (5 + [-5, 0, 4]), length: 2),

		].do { |chord|
			chord[\notes].do { |deg, index|
				[
					(octave: 2, amp: 0.1),
					(octave: 1, amp: 0.3),
					(octave: 0, amp: 1)
				].do { |voice|
					playParallel.(\pad, (chord[\length] * beat), [
						freq: (root + (12 * voice[\octave]) + deg).midicps,
						amp: (1 / (1 + index).sqrt) * voice[\amp],
						duration: (chord[\length] * beat),
						out: ~reverbBus
					]);
				};
			};
			(chord[\length] * beat).wait;
		};
	};
}).play;
)



//////////////////////////////////////////////////////////
// end
//////////////////////////////////////////////////////////

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