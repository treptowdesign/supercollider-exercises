////////////////////////////////////////////////////////////////////
// Synths
////////////////////////////////////////////////////////////////////

(
SynthDef(\fmKeys, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(Rand(2.0, 40)) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(1), 200);
	snd = snd * 150 * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.2), 200), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), (\amp.kr(1) * 0.2));
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
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd * freq.explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 6.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 6000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -16.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.06).ar * [30, 10, 15, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 1.4, 2.4, 3.8]);
	snd = snd * Env.perc(0.0, 0.4 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 5220, 0.4) * Env.perc(0.05, 0.1).ar * -30.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 6.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [0.03, 0.045]) * -20.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(230 * XLine.ar(1.4, 1, 0.005) * [1, 2.3, 4.5]);
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 830, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.2 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = Pulse.ar(60 * [1, 2.3, 3.4, 4.5, 5.8, 6.7]);
	snd = snd.sum;
	snd = snd + PinkNoise.ar;
	snd = snd * Env.perc(0.01, 0.03).ar;
	snd = BPF.ar(snd, [10234, 7234, 6824], 0.1) * 13.dbamp;
	snd = snd.sum;
	3.do { snd = HPF.ar(snd, 3e3); };
	snd = snd + (SinOsc.ar(XLine.ar(8300, 3000, 0.01)) * Env.perc(0.001, 0.01).ar * -7.dbamp);
	snd = snd * velocity;
	snd = snd * -2.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.2, 1 / 80, 1);
	snd = FreqShift.ar(snd, -34);
	snd = BPF.ar(snd, [10240, 3230, 6832] * XLine.ar(0.9, 1.2, 0.1), 0.2).sum;
	snd = HPF.ar(snd, 5e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -42.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
// FX
SynthDef(\chordFx, {
	var snd, trigger, fb, beat;
	trigger = T2A.ar(\trigger.tr(1));
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	// DELAY
	fb = snd;
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 1.0, (beat * 1.5) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 1e-3));
	fb = fb * -5.dbamp;
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 500);
	LocalOut.ar(fb);
	snd = snd + fb;
	// STEREO/CHORUS
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 4e-3);
	// REVERB
	snd = snd + GVerb.ar(snd * -6.dbamp, 20, 2, 0.8);
	// SIDECHAIN
	snd = snd * (1 - (0.6 * Env.perc(0.01, 0.2, curve: 2).ar(gate: trigger)));
	// CHORUS
	/*snd = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.03, SinOsc.kr(0.1 + (0.1 * i)).range(0.001,0.003))
	}).tanh;*/

	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.8 * Env.perc(0.01, 0.2, curve: 2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
)

////////////////////////////////////////////////////////////////////
// Busses
////////////////////////////////////////////////////////////////////

(
~fxBus = Bus.audio(nil, 2);
~sidechainBus = Bus.audio(nil, 2);
)



~fxBus.index;
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

	Synth.tail(nil, \chordFx, [in: ~fxBus, out: 0, beat: beat/4]);
	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);

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
			[
				(length: 4, velocity: 1, latency: 0),
				(length: 1, velocity: 0.9, latency: 0),
				(length: 0.5, velocity: 0.8, latency: 0.01),
				(length: 2, velocity: 1, latency: 0),
				(length: 0.5, velocity: 0.9, latency: 0.01),
			].do { |hit|
				duck.();
				play.(\kick, hit[\length], [velocity: hit[\velocity]], latency: hit[\latency]);
				// wait.(length);
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
				play.(\hat, 1, [out: 0]);
				wait.(1);
				play.(\hat, 1, [out: 0]);
				wait.(1);
			};
		};
		// SoftHat
		fork {
			4.do {
				wait.(0.5);
				play.(\hatSoft, 0.5, [out: ~fxBus]);
				wait.(0.5);
				play.(\hatSoft, 0.5, [out: ~fxBus]);
				wait.(0.5);
				play.(\hatSoft, 0.5, [out: ~fxBus]);
				wait.(0.5);
				play.(\hatSoft, 0.5, [out: ~fxBus]);
			};
		};
		// Sub
		fork {
			// [ 5, 10, 3, 7 ]
			// [ 2, 8, 10, 5 ]
			// [ 0, 3, 7, 2 ]
			// [ 0, 10, 3, 7 ]
			// [ 10, 10, 5 ]
			play.(\sub, 2, [freq: (root -12 + 5).midicps, out: ~sidechainBus]);
			play.(\sub, 2, [freq: (root -12 + 2).midicps, out: ~sidechainBus]);
			play.(\sub, 3.5, [freq: (root -12 + 0).midicps, out: ~sidechainBus]);
			play.(\sub, 0.5, [freq: (root -12 + 10).midicps, out: ~sidechainBus]);
		};
		// Chord Progression
		[
			(notes: (5 + [-12, 5, 10, 14]), length: 2, bend: -5), // iv 11/sus4 add9 (root, 4th/11th, 10th, 2nd/9th)
			(notes: (10 + [-8, -2, 0, 7]), length: 2, bend: 5), // VII (3rd, 10th, root, 5th)
			(notes: (0 + [0, 3, 7, 14]), length: 1.5, bend: 0), // i add9 (root, 3rd, 5th & 2nd/9th)
			(notes: (0 + [0, 10, 15, 19]), length: 2, bend: -5), // i7 (regular 7chord, 3rd & 5th shifted up)
			(notes: (10 + [-12, 0, 7]), length: 0.5, bend: 5), // vii (just root and 5th)
		].do { |chord|
			chord[\notes].do { |degree, index|
				playParallel.(\fmKeys, chord[\length], [
					freq: (root + 12 + degree).midicps,
					bend: chord[\bend],
					rel: 3,
					amp: 0.12 * (1 / (index + 1)).sqrt,
					// amp: 0.12,
					out: ~fxBus
				]);
			};
			wait.(chord[\length]);
		};
	};

}).play;
)


'- - - - - - - - - -'.postln;
(5 + [-12, 5, 10, 14])  % 12;
(10 + [-8, -2, 0, 7]) % 12;
(0 + [0, 3, 7, 14]) % 12;
(0 + [0, 10, 15, 19]) % 12;
(10 + [-12, 0, 7])% 12;



(1 / (1..4)).sqrt;
((1..4)).sqrt;






// endfile