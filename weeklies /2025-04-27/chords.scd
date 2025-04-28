///////////////////////////////////////////////////
// Synths
///////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
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
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
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
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.3 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1600, 0.6) * 2.dbamp;
	snd = LPF.ar(snd, 5200);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.001, 0.01, 0.003, 0.01, 0.003, 0.08, 0.2] * 0.5, curve: -2).ar ** 1.6;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -26.dbamp, 10, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 90);
	snd = BPF.ar(snd, [12240, 6230, 10832, 9830, 8320], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -15.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -26.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.23, 1 / 50, 1);
	snd = FreqShift.ar(snd, -34);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -33.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq, snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 400, 0.3, -5);
	snd = (snd * 2.dbamp).tanh * -3.dbamp;
	snd = BLowShelf.ar(snd, 400, 0.3, 3);
	snd = snd * Env.linen(0.04, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.25, 0.5), [0, pi]).linlin(-1, 1, 0.3, 1);
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\key2, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1) * Rand(0.5, 1.0);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * 2 * ([1, 5.13, 8.1, 12.1] ** Hasher.kr(freq).linlin(0, 1, 1, 1.05)));
	snd = snd * Env.perc(0, [10, 0.3, 0.1, 0.01]).ar;
	snd = snd * [0, -5, -8, -10].dbamp;
	snd = snd * (0.8 + (0.2 * SinOsc.ar([0.3, 0.4, 0.5, 0.6], Rand(0, 2pi ! 4))));
	snd = snd.sum;
	snd = snd + (WhiteNoise.ar * Env.perc(0, 0.05).ar * velocity);
	snd = snd * (1 + (5 * Env.perc(0, 0.02).ar));
	snd = snd * velocity.sqrt;
	snd = snd.clip2;
	snd = snd * velocity.sqrt;
	snd = snd * freq.explin(1000, 3000, 0, -20).dbamp;
	snd = snd * Env.perc(0.01, 3 * velocity, curve: -2).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -29.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var snd, freq, freqs;
	freq = \freq.kr(58);
	snd = SinOsc.ar(freq * [1, 2]);
	snd = snd * [0, -12].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * -16.dbamp;
	snd = snd * Env.linen(0.05, \duration.kr(1.0) - 0.05, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, env;
	env = Env.perc(0.01, 0.2, curve: 4).ar(gate: T2A.ar(\trigger.tr(1)));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.6 * env));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\delayFx, {
	var snd, fb, beat;
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	fb = snd;
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 1.0, (beat * 1.5) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 2e-3));
	fb = fb * -5.dbamp;
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 500);
	LocalOut.ar(fb);
	snd = snd + fb;
	Out.ar(\out.kr(0), snd);
}).add;
)

///////////////////////////////////////////////////
// Busses
///////////////////////////////////////////////////

(
~bassSidechainBus = Bus.audio(nil, 2);
~delayBus = Bus.audio(nil, 2);
)

~bassSidechainBus.index;
~delayBus.index;



///////////////////////////////////////////////////
// Routine
///////////////////////////////////////////////////

Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]

(
var s, root, beat, wait, play, playParallel;
s = Server.default;
root = 58;
beat = 60 / 140;

wait = { |duration|
	(duration * beat).wait;
};

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
	var bassSidechainFx;
	s.bind {
		Synth.tail(nil, \sidechainFx, [in: ~delayBus, out: ~bassSidechainBus, beat: beat]);
		bassSidechainFx = Synth.tail(nil, \sidechainFx, [in: ~bassSidechainBus, out: 0]);
	};
	loop {
		fork {
			[
				// [ 0, 2, 3, 5, 7, 9, 10 ]
				[0, 3, 7, 10 -12], // i
				[2, 5, 9, 12 -12], // ii
				[5, 9, 12 -12, 15 -12], // iv
				[7, 10, 14 -12, 17 -12] // v
			].do { |chord|
				(root.midicps * chord.midiratio).do { |freq|
					playParallel.(\keys, 8, [freq: freq, out: 0], latency: 0);
				};
				wait.(8);
			};
		};
		fork {
			[
				[10, 7, 3, 0],
				[0, 9, 2, 5],
				[9, 5, 0, 3],
				[7, 5, 2],
			].do { |sequence|
				fork {
					sequence.do { |note|
						playParallel.(\key2, 4, [freq: root.midicps * 1 * note.midiratio, out: ~delayBus], latency: 0.005);
						wait.(0.5);
					};
				};
				wait.(8);
			};
		};
		// wait.(32);
		2.do {
			fork {
				4.do {
					wait.(0.5);
					play.(\hat, 0.25, [pan: -0.3], latency: 0);
					play.(\hat, 0.25, [pan: 0.3], latency: 0.01);
					play.(\hat, 0.5, [pan: -0.3], latency: 0);
					play.(\hat, 0.5, [pan: 0], latency: 0);
					wait.(0.5);
					play.(\hatSoft, 0.5, [pan: 0], latency: 0);
					play.(\hat, 0.5, [pan: -0.3], latency: 0.005);
					play.(\hat, 0.5, [pan: 0.3], latency: 0.005);
				};
			};
			fork {
				1.do {
					wait.(2);
					play.(\snare, 2);
					wait.(2);
					play.(\snare, 1);
					play.(\snare, 1, [\velocity: 0.8], latency: 0.005);

					wait.(2);
					play.(\snare, 2);
					wait.(1.5);
					play.(\snare, 0.5, [\velocity: 0.75], latency: 0);
					play.(\snare, 1);
					play.(\snare, 1, [\velocity: 0.8], latency: 0.005);
				};
			};
			fork {
				wait.(2);
				play.(\bass, 0.75, [freq: (root -24).midicps, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
				play.(\bass, 0.75, [freq: (root -24).midicps, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
				wait.(2);
				play.(\bass, 0.75, [freq: (root -24).midicps * 2.midiratio, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
				play.(\bass, 0.75, [freq: (root -24).midicps, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);

				wait.(2);
				play.(\bass, 0.75, [freq: (root -24).midicps, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
				play.(\bass, 0.75, [freq: (root -24).midicps, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
				wait.(2);
				play.(\bass, 0.75, [freq: (root -24).midicps * -5.midiratio, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
				play.(\bass, 0.75, [freq: (root -24).midicps, out: ~bassSidechainBus], latency: 0);
				wait.(0.25);
			};
			play.(\kick, 3.5);
			s.bind { bassSidechainFx.set(\trigger, 1) };
			play.(\kick, 0.5, [velocity: 0.5]);
			s.bind { bassSidechainFx.set(\trigger, 1) };

			play.(\kick, 2.5);
			s.bind { bassSidechainFx.set(\trigger, 1) };
			play.(\kick, 1, [velocity: 0.5], latency: 0.005);
			s.bind { bassSidechainFx.set(\trigger, 1) };
			play.(\kick, 0.5, [velocity: 0.7]);
			s.bind { bassSidechainFx.set(\trigger, 1) };

			play.(\kick, 3.5);
			s.bind { bassSidechainFx.set(\trigger, 1) };
			play.(\kick, 0.5, [velocity: 0.5]);
			s.bind { bassSidechainFx.set(\trigger, 1) };

			play.(\kick, 2.5);
			s.bind { bassSidechainFx.set(\trigger, 1) };
			play.(\kick, 1, [velocity: 0.5], latency: 0.005);
			s.bind { bassSidechainFx.set(\trigger, 1) };
			play.(\kick, 0.5, [velocity: 0.7]);
			s.bind { bassSidechainFx.set(\trigger, 1) };
		};
	};
}).play;


)