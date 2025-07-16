(
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(46 * (1 + (3 * Env.perc(0, 0.1).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	// snd = LPF.ar(snd, 1200);
	wet = snd + 0.1;
	wet = wet.clip2 + (wet.fold2 * -6.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -22.dbamp, 0.1, 0.02)) ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ghostKick, {
	var snd, wet;
	snd = SinOsc.ar(60 * (1 + (4 * Env.perc(0, 0.06).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, 600);
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	wet = snd + 0.1;
	wet = wet.clip2 + (wet.fold2 * -6.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + (DelayC.ar(snd * -16.dbamp, 0.1, [0.03, 0.045]) * -16.dbamp);
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(220 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.2, 4.1] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.04, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.12).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.15) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -8.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 20, 2, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.1, 1.6);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.06, 2.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.02, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(15e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, wet, scale;
	scale = \scale.kr(1.1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), [1420, 1320, 1120, 930] * 1.4, 0.2) * 30.dbamp;
	snd = Splay.ar(snd, 0.5);
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] * 0.35, -4).ar;
	wet = snd + 0.1;
	wet = (snd * 4.dbamp).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd + (DelayC.ar(snd * -15.dbamp, 0.1, 0.02));
	snd = snd + GVerb.ar(snd.mean * -28.dbamp, 10, 1);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 15320, 0.3) * 5.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12320, 0.1) * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.1) * -3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 11320, 0.05) * 3.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, 0.11).ar;
	snd = snd + (DelayC.ar(snd * -25.dbamp, 0.1, 0.02));
	snd = HPF.ar(snd, 900);
	snd = snd + GVerb.ar(snd * -20.dbamp, 4, 3);
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\guitar, {
	var snd, wet, exciter, freq;
	freq = \freq.kr(60);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 60, 2800)
	) * Env.perc(0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, freq.linexp(50, 800, 0.7, 0.3));
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	wet = ((snd + 0.1) * 7.dbamp).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd + HPF.ar(GVerb.ar(snd.mean * -15.dbamp, 30), 300);
	snd = snd * Env.linen(0.001, \duration.kr(4), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\pad, {
	var snd;
	snd = (\freq.kr(220) * (1 * (1..9))).collect { |freq, index|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio, mul: (1 / (1 + index).sqrt));
		snd = snd * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / 2.sqrt; // <= midSides
		snd.size.postln;
		snd;
	};
	snd = snd.sum;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 3e-3);
	snd = snd * Env.perc(0.001, 2.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)









(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 54 - 12;

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
	loop {
		fork {
			2.do {
				[0, 3, -5, 10].do { |deg|
					playParallel.(\pad, beat, [freq: (root + 24 + deg).midicps, amp: 0.1]);
					play.(\pad, beat, [freq: (root + 12 + deg).midicps, amp: 0.8]);
				};
				[1, 5, -4, 12].do { |deg|
					playParallel.(\pad, beat, [freq: (root + 24 + deg).midicps, amp: 0.1]);
					play.(\pad, beat, [freq: (root + 12 + deg).midicps, amp: 0.8]);
				};
			};
		};
		fork {
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 0).midicps]);
			play.(\guitar, (bar / 3) * 2, [freq: (root + 0 + 8).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 1).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 7).midicps]);

			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 0).midicps]);
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 0).midicps]);
			play.(\guitar, (bar / 3) * 2, [freq: (root + 0 + 1).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 8).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 7).midicps]);
		};
		fork {
			16.do {
				wait.((beat/3) * 2);
				play.(\hat, beat/3);

				/*wait.(beat/2);
				play.(\hat, beat/2);*/
			};
		};
		fork {
			4.do {
				/*wait.(beat * 3);.
				wait.(beat/3);
				play.(\clap, (beat/3) * 2); */

				wait.(beat);
				play.(\clap, beat);
				wait.(beat);
				play.(\clap, beat);
			};
		};
		4.do {
			play.(\kick, beat);
			play.(\kick, beat);
			play.(\kick, beat);
			if(0.5.coin, {
				play.(\kick, (beat/3) * 2);
				play.(\ghostKick, beat/3);
			}, {
				play.(\kick, beat);
			});

		};

	};
}).play;
)









(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 98;
bar = beat * 4;
root = 54 - 12;

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
	loop {
		fork {
			play.(\guitar, (bar / 6), [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 6), [freq: (root + 0 + 0).midicps]);
			play.(\guitar, (bar / 6), [freq: (root + 0 + 1).midicps]);
			play.(\guitar, (bar / 6), [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 6), [freq: (root + 0 + 8).midicps]);
			play.(\guitar, (bar / 6), [freq: (root + 0 + 7).midicps]);
		};
		fork {
			4.do {
				// play.(\hat, beat/3);
				// play.(\hat, beat/3);
				wait.((beat/3) * 2);
				play.(\hat, beat/3);
			}
		};
		1.do {
			play.(\kick, beat);
			play.(\clap, beat);
			play.(\kick, beat);
			play.(\clap, beat);
		};

	};
}).play;
)










(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 54 - 12;

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
	loop {
		fork {
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 0).midicps]);
			play.(\guitar, (bar / 3) * 2, [freq: (root + 0 + 1).midicps]);
			play.(\guitar, (bar / 3), [freq: (root + 0 + 12.neg).midicps]);
			play.(\guitar, (bar / 3) * 0.5, [freq: (root + 0 + 8).midicps]);
			play.(\guitar, (bar / 3) * 2, [freq: (root + 0 + 7).midicps]);
		};
		fork {
			8.do {
				// play.(\hat, beat/3);
				// play.(\hat, beat/3);
				wait.((beat/3) * 2);
				play.(\hat, beat/3);
			};
		};
		2.do {
			play.(\kick, beat);
			play.(\clap, beat);
			play.(\kick, beat);
			play.(\clap, (beat/3) * 2);
			play.(\ghostKick, beat/3);

		};

	};
}).play;
)






// endfile