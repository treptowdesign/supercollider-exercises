////////////////////////////////////////////////////////////////////
// Synths
////////////////////////////////////////////////////////////////////

(
SynthDef(\fmKeys, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.1), 100);
	snd = snd * 200 * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.1), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	snd = snd * Env.perc(0.01, \rel.kr(3.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

)


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

	// sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);


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
					amp: 0.1 * (1 / (index + 1)).sqrt,
					out: 0
				]);
			};
			wait.(chord[\length]);
		};
	};

}).play;
)
















// endfile