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
	// snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	/*snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 2.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);*/
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
	snd = snd * -20.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.06).ar * [30, 10, 24, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 1.4, 2.4, 3.8]);
	snd = snd * Env.perc(0.0, 0.4 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 5220, 0.4) * Env.perc(0.05, 0.1).ar * -30.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 8.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [0.03, 0.045]) * -26.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.4 * velocity).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
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
	snd = snd * -2.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.16));
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rim, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(240 * [1, 1.2, 3.6, 4.15, 4.5] * XLine.ar(1.8, 1, 0.001));
	snd = snd * Env.perc(0.001, [0.01, 0.06, 0.03, 0.01, 0.004]).ar;
	snd = snd.sum;
	snd = snd * -5.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7120, 0.5) * Env.perc(0, 0.001).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3120, 0.5) * Env.perc(0, 0.01).ar);
	snd = snd * (1 + (10 * Env.perc(0, 0.01).ar));
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd * -16.dbamp, 20, 1, 0.5);
	snd = snd * -25.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
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
	snd = snd + GVerb.ar(snd * -6.dbamp, 10, 4, 0.8);
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

	Synth.tail(nil, \chordFx, [in: ~fxBus, out: 0, beat: beat/2]);
	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0, beat: beat/2]);

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
		// Rims
		/*fork {
			4.do {
				play.(\rim, 0.5, [amp: 0.8, out: ~sidechainBus]);
				play.(\rim, 0.5, [amp: 0.7, out: ~sidechainBus], latency: 0.01);
				play.(\rim, 0.5, [amp: 0.3, out: ~sidechainBus]);
				play.(\rim, 0.5, [amp: 0.2, out: ~sidechainBus], latency: 0.01);

				play.(\rim, 0.5, [amp: 0.7, out: ~sidechainBus]);
				play.(\rim, 0.5, [amp: 0.8, out: ~sidechainBus], latency: 0.01);
				play.(\rim, 0.5, [amp: 0.7, out: ~sidechainBus]);
				play.(\rim, 0.5, [amp: 0.3, out: ~sidechainBus], latency: 0.01);
			};
		};*/
		// Sub
		fork {
			play.(\sub, 2, [freq: (root -12 + 5).midicps, out: ~sidechainBus]);
			play.(\sub, 2, [freq: (root -12 + 2).midicps, out: ~sidechainBus]);
			play.(\sub, 3.5, [freq: (root -12 + 0).midicps, out: ~sidechainBus]);
			play.(\sub, 0.5, [freq: (root -12 + 10).midicps, out: ~sidechainBus]);
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
				playParallel.(\fmKeys, chord[\length], [
					freq: (root + 12 + degree).midicps,
					bend: chord[\bend],
					rel: 3,
					amp: 0.1 * (1 / (index + 1)).sqrt,
					out: ~fxBus
				]);
			};
			wait.(chord[\length]);
		};
	};

}).play;
)











// endfile