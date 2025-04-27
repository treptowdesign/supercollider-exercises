///////////////////////////////////////////////////
// Synths
///////////////////////////////////////////////////

(
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq, snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 2.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.7, 1);
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

///////////////////////////////////////////////////
// Busses
///////////////////////////////////////////////////


///////////////////////////////////////////////////
// Routine
///////////////////////////////////////////////////

(
var s, root, beat, play, playParallel;
s = Server.default;
root = 58;
beat = 60 / 140;

play = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
	(duration * beat).wait;
};

playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
};

Routine({
	loop {
		[

			/*[-4, 0, 3, 7],
			[-2, 2, 7],
			[-7, 0, 7, 8],
			-5 + [0, 8, 12 + 3],*/
			(0 + [-12, 2, 7, 10]),
			(-2 + [-12, 3, 7, 10])
		].do { |chord|
			(root.midicps * chord.midiratio).do { |freq|
				playParallel.(\keys, 8, [freq: freq, out: 0], latency: 0);
			};
			(8 * beat).wait;
		};
	};
}).play;


)