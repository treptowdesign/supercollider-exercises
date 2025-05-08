////////////////////////////////////////////////////////////////////
// Synths
////////////////////////////////////////////////////////////////////

(
SynthDef(\fmKeys, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(Rand(2.0, 40)) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.1), 100);
	snd = snd * 80 * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.06), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), (\amp.kr(1) * 0.2));
	// snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 2.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	snd = snd * Env.perc(0.01, \rel.kr(3.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.1, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq + snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 2.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.7, 1);
	snd = snd * -23.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
// FX
SynthDef(\chordFx, {
	var snd, trigger, fb, beat;
	trigger = T2A.ar(\trigger.tr(1));
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	// DELAY
	/*fb = snd;
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 1.0, (beat * 1.5) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 2e-3));
	fb = fb * -5.dbamp;
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 500);
	LocalOut.ar(fb);
	snd = snd + fb;*/
	// SIDECHAIN
	snd = snd * (1 - (0.6 * Env.perc(0.01, 0.2, curve: 2).ar(gate: trigger)));
	// STEREO/CHORUS
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	Out.ar(\out.kr(0), snd);
}).add;
)

////////////////////////////////////////////////////////////////////
// Busses
////////////////////////////////////////////////////////////////////

(
~fxBus = Bus.audio(nil, 2);
)

~fxBus.index;


////////////////////////////////////////////////////////////////////
// Routine
////////////////////////////////////////////////////////////////////

(
var s, beat, root;
s = Server.default;
beat = 60 / 96;
root = 50; // D
Routine({
	var wait, playParallel, play;
	var sidechainFx, duck;

	sidechainFx = Synth.tail(nil, \chordFx, [in: ~fxBus, out: 0, beat: beat]);

	duck = {
		s.bind { sidechainFx.set(\trigger, 1) };
	};

	wait = { |duration=1|
		(beat * duration).wait;
	};

	playParallel = { |synthDef, duration, args = #[], latency = 0.0|
		fork {
			latency.wait;
			s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
		};
	};

	play = { |synthDef, duration, args = #[], latency = 0.0|
		playParallel.(synthDef, duration, args, latency);
		wait.(duration);
	};

	loop {
		// Chord Progression
		[
			(notes: (5 + [-12, 5, 10, 14]), length: 2, bend: 0), // iv 11/sus4 add9 (root, 4th/11th, 10th, 2nd/9th)
			(notes: (10 + [-8, -2, 0, 7]), length: 2, bend: 0), // VII (3rd, 10th, root, 5th)
			(notes: (0 + [0, 3, 7, 14]), length: 1.5, bend: 0), // i add9 (root, 3rd, 5th & 2nd/9th)
			(notes: (0 + [0, 10, 15, 19]), length: 2, bend: 0), // i7 (regular 7chord, 3rd & 5th shifted up)
			(notes: (10 + [-12, 0, 7]), length: 0.5, bend: 0), // vii (just root and 5th)
		].do { |chord|
			chord[\notes].do { |degree, index|
				playParallel.(\fmKeys, chord[\length], [
					freq: (root + degree).midicps,
					bend: chord[\bend],
					rel: 3,
					amp: (1 / (index + 1)).sqrt,
					out: ~fxBus
				]);
			};
			wait.(chord[\length]);
		};
	};

}).play;
)











// endfile