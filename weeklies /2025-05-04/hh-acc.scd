(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [20, 14, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.4, 3.4, 5.3]);
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
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.5 * velocity).ar(Done.freeSelf);
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
	snd = CombC.ar(snd, 0.23, 1 / 120, 1);
	snd = FreqShift.ar(snd, -34);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -33.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\key, {
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

SynthDef(\keyWIP, {
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

SynthDef(\guitar, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pluck.ar(SinOsc.ar(XLine.ar(3000, 50, 0.01) * ExpRand(0.5, 1)) + WhiteNoise.ar, Impulse.ar(0), 0.2, 1 / freq, 20, 0.2);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 53), 0.2, 1 / 150, 0.01), -53);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 53), 0.2, 1 / 240, 0.01), -53);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -35.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\guitarFx, {
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


SynthDef(\sidechainFx, {
	var snd, env;
	env = Env.perc(0.01, 0.2, curve: 4).ar(gate: T2A.ar(\trigger.tr(1)));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.6 * env));
	snd = snd * 3.dbamp;
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
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
	snd = snd * Env.perc(0.01, 7 * velocity, curve: -2).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -29.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keyFm, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.6), 100);
	snd = snd * SinOsc.ar(4, 0, 10, 100) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.1), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 4.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.3, SinOsc.kr(0.1 + (0.2 * i)).range(0.0001, 0.003))
	});
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	snd = snd * -8.dbamp;
	snd = snd * Env.perc(0.01, \rel.kr(4.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~guitarBus = Bus.audio(nil, 2);
~sidechainBus = Bus.audio(nil, 2);
)

~guitarBus.index;
~sidechainBus.index;


(
var s, beat, play, playParallel, wait;
s = Server.default;
beat = 60 / 144;

play = { |synthDef, duration, args = #[], latency = 0.0, randomLatency = 0.0|
	fork {
		(randomLatency * 1.0.rand).wait;
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
	(duration * beat).wait;
};

playParallel = { |synthDef, duration, args = #[], latency = 0.0, randomLatency = 0.0|
	fork {
		(randomLatency * 1.0.rand).wait;
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
};

wait = { |duration|
	(duration * beat).wait;
};

Routine({
	var sidechainFx, pump;
	s.bind {
		Synth.tail(nil, \guitarFx, [in: ~guitarBus, out: ~sidechainBus, beat: beat]);
		sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);
	};
	pump = {
		s.bind { sidechainFx.set(\trigger, 1) };
	};

	loop {
		fork {
			[
				(notes: (5 + [-12, 5, 10, 14]), length: 2, bend: 0),
				(notes: (10 + [-8, -2, 0, 7]), length: 2, bend: 0),
				(notes: (0 + [0, 3, 7, 14]), length: 1.5, bend: 0),
				(notes: (0 + [0, 10, 15, 19]), length: 2, bend: 0),
				(notes: (10 + [-12, 0, 7]), length: 0.5, bend: 0)
			].do { |chord|
				(50.midicps * chord[\notes].midiratio).do { |freq|
					playParallel.(\keyFm, chord[\length] * 4, [freq: freq, out: ~sidechainBus], latency: 0.01);
				};
				wait.(chord[\length] * 4);
			};
		};
		fork {
			[
				[5, 12 + 2, 10, 12 + 5, 7, 12 + 2, 14],
				[2, 5, 10, 7, 3],
				[0, 3, 5],
				[7, 0, 3],
			].do { |sequence|
				fork {
					sequence.do { |note|
						// playParallel.(\key2, 8, [freq: 50.midicps * note.midiratio, out: ~guitarBus], latency: 0.005, randomLatency: 0.01);
						wait.(1 / 2);
					};
				};
				wait.(8);
			};
		};


		fork {
			wait.(16);
			[
				// note, duration in 1/16s, accent
				[3, 6],
				[12, 2],
				[10, 2, \accent],
				[8, 2],
				[7, 2],
				[8, 2],
				[10, 4, \accent],
				[8, 2],
				[7, 2],
				[5, 4, \accent],
				[3, 2],
				[5, 2],

				[7, 4, \accent],
				[7, 2],
				[8, 2, \accent],
				[7, 2],
				[3, 2],
				[10, 2],
				[5, 2],
				[3, 2, \accent],
				[3, 2],
				[2, 2],
				[3, 2],
				[-2, 4],
			].do { |spec|
				/*play.(\guitar, spec[1] / 4, [
					freq: 50.midicps * 1 * spec[0].midiratio,
					out: ~sidechainBus,
					velocity: if(spec.includes(\accent), 1.0, 0.7)
				], latency: 0.01, randomLatency: 0.01);*/
			};
		};

		2.do {
			fork {
				wait.(3 / 2);
				play.(\hatSoft, 1 / 2);
				wait.(1 / 2);
				play.(\hat, 1 / 2, [pan: -0.2], latency: 0.01);
				play.(\hatSoft, 1 / 2);
				play.(\hat, 1 / 4, [pan: 0.2], latency: 0.01);
				play.(\hat, 1 / 4, [pan: -0.2], latency: 0.01);

				wait.(1 / 2);
				play.(\hat, 1 / 2, [pan: -0.2]);
				6.do { |i|
					play.(\hat, 1 / 6, [pan: [-0.2, 0.2].wrapAt(i)]);
				};
				play.(\hatSoft, 1 / 2);
				play.(\hat, 1 / 2, latency: 0.01);
				play.(\hat, 1 / 2, latency: 0.01);
				play.(\hatSoft, 1 / 2);
			};
			pump.();
			play.(\kick, 2);
			pump.();
			play.(\snare, 3 / 2);
			play.(\kick, 1 / 2, [velocity: 0.5]);
			pump.();
			play.(\kick, 1 / 2);
			play.(\kick, 1 / 2, [velocity: 0.6], latency: 0.005);
			pump.();
			play.(\kick, 1, [velocity: 0.7]);
			pump.();
			play.(\snare, 2);


			fork {
				wait.(3 / 2);
				play.(\hatSoft, 1 / 2);
				wait.(1 / 2);
				play.(\hat, 1 / 2, [pan: -0.2], latency: 0.01);
				play.(\hatSoft, 1 / 2);
				play.(\hat, 1 / 2, [pan: 0.2]);

				wait.(1 / 2);
				play.(\hat, 1 / 2, [pan: -0.2]);
				play.(\hat, 1 / 2, [pan: 0.2]);
				play.(\hat, 1 / 2, [pan: -0.2]);
				play.(\hatSoft, 1 / 2);
				play.(\hat, 1 / 2, [pan: 0.2], latency: 0.01);
				play.(\hat, 1 / 2, [pan: -0.2], latency: 0.01);
				play.(\hatSoft, 1 / 2);
			};
			pump.();
			play.(\kick, 2);
			play.(\snare, 3 / 2);
			play.(\kick, 1 / 2, [velocity: 0.5]);
			pump.();
			play.(\kick, 1 / 2);
			play.(\kick, 1 / 2, [velocity: 0.6], latency: 0.005);
			pump.();
			play.(\kick, 1, [velocity: 0.7]);
			pump.();
			play.(\snare, 3 / 2);
			play.(\snare, 1 / 2, [velocity: 0.5], latency: 0.01);
		};
	};
}).play;
)