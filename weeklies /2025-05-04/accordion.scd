(
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.4), 100);
	snd = snd * SinOsc.ar(4, 0, 10, 180) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.15), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.05));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.perc(0.01, \rel.kr(4.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd * freq.explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 6000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -14.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\saw, {
	var snd, count, freq;
	count = 10;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(0.5) }! count) * 0.3).midiratio, { Rand(0.0, 1.0) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.perc(0.05, 2).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4), 0.1).ar(Done.freeSelf);
	snd = snd * \amp.kr(-22.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.06).ar * [30, 10, 20, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 1.6, 2.4, 3.2]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 5220, 0.4) * Env.perc(0.05, 0.1).ar * -30.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 4.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(220 * XLine.ar(1.1, 1, 0.03) * [1, 2.4, 8.4]);
	snd = snd * Env.perc(0.01, [0.1, 0.02, 0.03] * velocity, curve: -7).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * -4.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2500, 200, 0.02)) * Env.perc(0.001, 0.05).ar);
	snd = snd + (SinOsc.ar(XLine.ar(4100, 100, 0.02)) * Env.perc(0.001, 0.02).ar * -10.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 2234, 0.2) * Env.perc(0.02, 0.07).ar * 5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3234, 0.2) * Env.perc(0.01, 0.05).delay(0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 6234, 0.4) * Env.perc(0.001, 0.05).ar * -15.dbamp);
	snd = snd * velocity;
	snd = snd.tanh;
	snd = LeakDC.ar(snd);
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd * Line.ar(0, 1, velocity.linlin(0, 1, 0.02, 0));
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.2, [30e-3, 45e-3]), 200), 1000);
	snd = snd * \amp.kr(0.32);
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = Pulse.ar(60 * [1, 2.3, 3.4, 4.5, 6.7, 5.8]);
	snd = snd.sum;
	snd = snd + PinkNoise.ar;
	snd = snd * Env.perc(0.01, 0.03).ar;
	snd = BPF.ar(snd, [10234, 7234, 6824], 0.1) * 13.dbamp;
	snd = snd.sum;
	3.do { snd = HPF.ar(snd, 3e3); };
	snd = snd + (SinOsc.ar(XLine.ar(9300, 3000, 0.01)) * Env.perc(0.001, 0.01).ar * -7.dbamp);
	snd = snd * velocity;
	snd = snd * 4.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.16));
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (1 * Env.perc(0.01, 0.2, curve: 2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\reverbFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 20, 3, 0.2);
	Out.ar(\out.kr(0), snd);
}).add;
)

////////////////////////////////////////////////////////////////////
// Bussing
////////////////////////////////////////////////////////////////////

(
~sidechainBus = Bus.audio(nil, 2);
~reverbBus = Bus.audio(nil, 2);
)

~reverbBus.index;
~sidechainBus.index;


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

	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);
	Synth.tail(nil, \reverbFx, [in: ~reverbBus, out: 0]);

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
		// Kick
		fork {
			[4, 0.5, 1, 2, 0.5].do { |length|
				duck.();
				play.(\kick, length);
				// wait.(length);
			};
		};
		// Sub
		fork {
			2.do {
				play.(\sub, 0.5 * 0.75, [freq: (root - 24 + 12).midicps, out: ~sidechainBus]);
				wait.(0.5 * 0.25);
				play.(\sub, 0.5 * 0.75, [freq: (root - 24 + 0).midicps, out: ~sidechainBus]);
				wait.(0.5 * 0.25);
				play.(\sub, 0.5 * 0.75, [freq: (root - 24 + 12).midicps, out: ~sidechainBus]);
				wait.(0.5 * 0.25);
				play.(\sub, 0.5 * 0.75, [freq: (root - 24 + 0).midicps, out: ~sidechainBus]);
				wait.(0.5 * 0.25);
				wait.(2);
			};
		};
		// Lead
		fork {
			[
				(degree: 7, length: 2),
				(degree: 2, length: 2),
				(degree: 2, length: 1.5),
				(degree: 3, length: 2),
				(degree: 5, length: 0.5),
			].do { |note|
				play.(\saw, note[\length], [freq: (root + 0 + note[\degree]).midicps, out: ~reverbBus]);
			};
		};
		// Snare
		fork {
			4.do {
				wait.(1);
				play.(\snare, 1);
			};
		};
		// Hats
		fork {
			4.do {
				wait.(0.5);
				play.(\hat, 0.25);
				play.(\hat, 0.75, [velocity: 0.5], latency: 0.01);
				play.(\hat, 0.5);
			};
		};
		// Chord Progression
		[
			(notes: (5 + [-12, 5, 10, 14]), length: 2, bend: 0), // iv 11/sus4 add9 (root, 4th/11th, 10th, 2nd/9th)
			(notes: (10 + [-8, -2, 0, 7]), length: 2, bend: 0), // VII (3rd, 10th, root, 5th)
			(notes: (0 + [0, 3, 7, 14]), length: 1.5, bend: 0), // i add9 (root, 3rd, 5th & 2nd/9th)
			(notes: (0 + [0, 10, 15, 19]), length: 2, bend: 0), // i7 (regular 7chord, 3rd & 5th shifted up)
			(notes: (10 + [-12, 0, 7]), length: 0.5, bend: 0), // vii (just root and 5th)
		].do { |chord|
			chord[\notes].do { |degree, index|
				playParallel.(\keys, chord[\length], [freq: (root + degree).midicps, bend: chord[\bend], rel: 3, out: ~reverbBus]);
				// playParallel.(\keys, chord[\length], [freq: (root + degree).midicps, bend: 0], latency: index.linlin(0, 3, 0, 0.12));
			};
			wait.(chord[\length]);
		};
	};

}).play;
)


// Chords Breakdown
(5 + [-12, 5, 10, 14]); // -> [ -7, 10, 15, 19 ] => [5, 10, 3, 7]
(10 + [-8, -2, 0, 7]); // -> [ 2, 8, 10, 17 ] => [2, 8, 10, 5]
(0 + [0, 3, 7, 14]); // -> [ 0, 3, 7, 14 ] => [0, 3, 7, 2 ]
(0 + [0, 10, 15, 19]); // -> [ 0, 10, 15, 19] => [ 0, 10, 3, 7]
(10 + [-12, 0, 7]); // -> [ -2, 10, 17 ] => [10, 7]


//////////////////////////////////////////////////////////////////////
// TestArea
//////////////////////////////////////////////////////////////////////

Scale.ionian.degrees; // => [ 0, 2, 4, 5, 7, 9, 11 ]
Scale.lydian.degrees; // => [ 0, 2, 4, 6, 7, 9, 11 ]
Scale.mixolydian.degrees; // => [ 0, 2, 4, 5, 7, 9, 10 ]

Scale.aeolian.degrees; // => [ 0, 2, 3, 5, 7, 8, 10 ];
Scale.dorian.degrees; // => [ 0, 2, 3, 5, 7, 9, 10 ];
Scale.phrygian.degrees; // => [ 0, 1, 3, 5, 7, 8, 10 ]
Scale.locrian.degrees; // => [ 0, 1, 3, 5, 6, 8, 10 ]




// Accordion

"- - - - - - - - - - - - ";
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ];
(5 + [0, 5, 10, 14]) % 12; // [ 5, 10, 3, 7 ]
(10 + [-8, -2, 0, 7]) % 12; // [ 2, 8, 10, 5 ]
(0 + [0, 3, 7, 14]) % 12; // [ 0, 3, 7, 2 ]
(0 + [0, 10, 15, 19]) % 12; // [ 0, 10, 3, 7 ]
(10 + [-12, 0, 7]) % 12; // [ 10, 10, 5 ]

(
~chordRoot = 50; // 50=D
)

((5 + [0, 5, 10, 14]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((10 + [-8, -2, 0, 7]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((0 + [0, 3, 7, 14]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((0 + [0, 10, 15, 19]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((10 + [-12, 0, 7]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})


// Massage Situation

(0 + [-12, 2, 7, 10]) % 12; // => [ 0, 2, 7, 10 ]
(-2 + [-12, 3, 7, 10]) % 12; // => [ 10, 1, 5, 8 ]

(
~chordRoot = 58; // 58=Bb
)

((0 + [-12, 2, 7, 10]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((-2 + [-12, 3, 7, 10]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((0 + [0, 14, 7, 10]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})

((-2 + [0, 15, 7, 10]).do { |degree|
	Synth(\keys, [ freq: (~chordRoot + degree).midicps]);
})





// Etc...

((7 + [-12, 0, 7]).postln.do { |degree|
	Synth(\keyWip, [ freq: (~chordRoot + degree).midicps]);
})





















// endfile...