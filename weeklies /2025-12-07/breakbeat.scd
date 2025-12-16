(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.15, curve: -4).ar.linexp(0, 1, 60, 400) * XLine.ar(1.5, 1, 0.01) * XLine.ar(1, 0.7, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar(Impulse.ar(60))), 7240, 0.3) * Env.perc(0.01, 0.05).ar * -10.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar(Impulse.ar(231))), 9240, 0.3) * Env.perc(0.001, 0.01).ar * -10.dbamp);
	snd = snd * (1 + (7 * Env.perc(0, 0.05).ar));
	snd = snd * Env.perc(0.001, 0.6).ar;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 4);
	snd = snd ! 2;
	snd = snd + HPF.ar(LPF.ar(DelayN.ar(snd * -32.dbamp, 0.05, [92e-3, 74e-3]), 2000), 200);
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(Env.perc(0, 0.1, curve: -6).ar.linexp(0, 1, 250, 260) * XLine.ar(2, 1, 0.01) * [1, 2.32, 4.24, 6.62]);
	snd = snd * Env.perc(0.001, [0.07, 0.07, 0.03, 0.05]).ar;
	snd = snd * [0, -5, -6, -6].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd + (SinOsc.ar([830, 1234] * XLine.ar(1.3, 1, 0.01)).sum * Env.perc(0.001, 0.05).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2540, 0.2) * Env.perc(0.05, 0.08, curve: -3).ar * 8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 2540, 0.2) * Env.perc(0.02, 0.05).ar * 8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 6540, 0.5) * Env.perc(0.01, 0.09).ar * 4.dbamp);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd * -20.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.005, 1.2);
	snd = snd + PitchShift.ar(snd * -1.dbamp, 0.01, 1.2);
	snd = snd * (1 + (1.3 * Env.perc(0, 0.01).ar));
	snd = snd + HPF.ar(LPF.ar(DelayN.ar(snd * -30.dbamp, 0.05, [62e-3, 34e-3]), 2000), 200);
	snd = snd * \amp.kr(1);
	snd = snd * -14.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ghostSnare, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(250 * [1, 2.32, 4.24, 6.62]);
	snd = snd * Env.perc(0.001, [0.07, 0.05, 0.02, 0.01]).ar;
	snd = snd * [0, -5, -6, -6].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * -3.dbamp;
	snd = snd + (SinOsc.ar([830, 1234] * XLine.ar(1.3, 1, 0.01)).sum * Env.perc(0.001, 0.05).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2540, 0.2) * Env.perc(0.03, 0.05, curve: -3).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 2540, 0.2) * Env.perc(0.02, 0.04).ar * 9.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 6540, 0.5) * Env.perc(0.01, 0.03).ar * 12.dbamp);
	snd = snd * (1 + (1 * Env.perc(0, 0.03).ar));
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd * -25.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.005, 1.2);
	snd = snd + PitchShift.ar(snd * -1.dbamp, 0.01, 1.2);
	snd = LPF.ar(snd, 3000);
	snd = snd * Line.ar(0, 1, 0.01);
	snd = snd + HPF.ar(LPF.ar(DelayN.ar(snd * -30.dbamp, 0.05, [62e-3, 34e-3]), 2000), 200);
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare2, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(Env.perc(0, 0.02, curve: -6).ar.linexp(0, 1, 230, 270) * XLine.ar(2, 1, 0.01) * [1, 3.32, 5.24, 7.62]);
	snd = snd * Env.perc(0.01, [0.07, 0.05, 0.03, 0.01] * 5).ar;
	snd = snd * [0, -5, -6, -6].dbamp;
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd * (1 + (SinOsc.ar(920) * Env.perc(0, 0.05).ar));
	snd = snd + (SinOsc.ar([630, 1334] * XLine.ar(1.3, 1, 0.01)).sum * Env.perc(0.001, 0.05).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3040, 0.2) * Env.perc(0.05, 0.1, curve: -3).ar * 8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 2140, 0.2) * Env.perc(0.02, 0.3).ar * 8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 9540, 0.5) * Env.perc(0.01, 0.1).ar * 4.dbamp);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd.tanh;
	snd = snd + CombC.ar(snd * -5.dbamp, 0.1, 1 / 122, 0.1);
	snd = snd + GVerb.ar(snd * -10.dbamp, 10, 1);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.03, 1.2);
	snd = snd + PitchShift.ar(snd * -1.dbamp, 0.02, 0.7);
	snd = snd * (1 + (0.3 * Env.perc(0, 0.01).ar));
	snd = snd + HPF.ar(LPF.ar(DelayN.ar(snd * -30.dbamp, 0.05, [32e-3, 54e-3]), 2000), 200);
	snd = snd * Env.linen(0.0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = Hasher.ar(Sweep.ar(Impulse.ar([50, 72, 82] * 0.5)));
	snd = snd.sum;
	snd = BPF.ar(snd, (0..10).normalize.linexp(0, 1, 3000, 16e3), 0.05).sum * -2.dbamp;
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.perc(0.001, 0.09).ar;
	snd = LPF.ar(snd, XLine.ar(16e3, 6e3, 0.1));
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = Hasher.ar(Sweep.ar(Impulse.ar([50, 72, 82] * 1.3)));
	snd = snd.sum;
	snd = BPF.ar(snd, (0..10).normalize.linexp(0, 1, 2000, 16e3), 0.1).sum * -5.dbamp;
	snd = HPF.ar(snd, 5e3);
	snd = snd * Env.perc(0.01, 0.06).ar;
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatLong, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = Hasher.ar(Sweep.ar(Impulse.ar([50, 72, 82] * 1.3)));
	snd = snd.sum;
	snd = BPF.ar(snd, (0..10).normalize.linexp(0, 1, 3000, 13e3), 0.3).sum * 1.dbamp;
	snd = snd * Env.perc(0.03, 0.1).ar;
	snd = BHiShelf.ar(snd, 8000, 0.3, -3);
	snd = (snd * -5.dbamp) + GVerb.ar(snd * -15.dbamp, 50, 0.5);
	snd = HPF.ar(snd, 6e3);
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.linen(0.0, duration, 0.05).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatRand, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = Hasher.ar(Sweep.ar(Impulse.ar([50, 72, 82] * ExpRand(1, 1.5))));
	snd = snd.sum;
	snd = BPF.ar(snd, (0..10).normalize.linexp(0, 1, ExpRand(1000, 3000), ExpRand(12e3, 16e3)), 0.1).sum * -5.dbamp;
	snd = HPF.ar(snd, ExpRand(5e3, 8e3));
	snd = snd * Env.linen(ExpRand(0.002, 0.006), ExpRand(0.005, 0.02), 0.002).ar;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sine, {
	var snd, duration, freq;
	duration = \duration.kr(1.0);
	freq = \freq.kr(440) * (LFNoise2.ar(3 ! 8) * 0.1).midiratio;
	snd = SinOsc.ar([freq] * [1, 3]);
	snd = snd * [1, Env.perc(0, 0.1).ar * -8.dbamp];
	snd = snd.sum;
	snd = snd * (1 + LFNoise2.ar(3 ! 8));
	snd = Splay.ar(snd);
	snd = snd * (1 + Env.perc(0, 0.1).ar);
	snd = snd * Env.perc(0.01, 3.0, curve: -4).ar(Done.freeSelf);
	snd = snd.tanh;
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [2, 3]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq, snd.sum.mod(2pi));
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 1.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0) * 0.9, \duration.kr(1.0) * 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.7, 1);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, freq, freqs;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [1, 2]);
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = (snd * 2.dbamp).tanh;
	snd = snd ! 2;
	snd = snd * -8.dbamp;
	snd = snd * Env.linen(0.05, \duration.kr(1.0) - 0.05, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
// fx ////////////////////////////////////////////////////////////////////////////
SynthDef(\sidechainFx, {
	var snd, gate;
	gate = T2A.ar(\pump.tr);
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (Env.perc(0.01, 0.1, curve: 4).ar(gate: gate) * 0.5));
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
s.newBusAllocators; // reset busses
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 50;
// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
// scheduling
Routine({
	var sidechainBus, sidechainFx, pump;
	s.bind {
		sidechainBus = Bus.audio(nil, 2);
		sidechainFx = Synth.tail(nil, \sidechainFx, [in: sidechainBus, out: 0]);
	};
	sidechainBus.index.postln;
	pump = {
		s.bind { sidechainFx.set(\pump, 1); };
	};
	loop {
		subroutine.(1, { // 4 bars (enter 1)
			var hatSynth = \hat;
			// bar 1
			8.do { seq.(hatSynth, tatum * 2); };
			// bar 2
			8.do { seq.(hatSynth, tatum * 2); };
			// bar 3
			8.do { seq.(hatSynth, tatum * 2); };
			// bar 4
			5.do { seq.(hatSynth, tatum * 2); };
			seq.(\hatLong, tatum * 2);
			2.do { seq.(hatSynth, tatum * 2); };
		});
		subroutine.(1, {
			[
				2, 8, 1, 5,
				2, 8, 1, 5,
				2, 8, 1, 5,
				2, 8, 1, 4, 1
			].do { |dur|
				pump.();
				seq.(\kick, tatum * dur);
			};
		});
		subroutine.(4, {
			(tatum * 4).wait;
			[3, 2, 3, 3, 1].do { |dur|
				seq.(\snare, tatum * dur);
			};
		});
		subroutine.(1, {
			var outBus = sidechainBus;
			[2, -3, 7, 0].do { |int|
				seq.(\sub, bar, [freq: noteHz.(int, -2), out: outBus]);
			};
		});
		subroutine.(1, {
			var outBus = sidechainBus;
			// var outBus = 0;
			[
				(2 + [0, 16, 19, 23]),
				(9 + [0, 16, 19, 11]),
				(7 + [0, 16, 19, 11]),
				(0 + [0, 16, 19, 23])
			].do { |chord|
				chord.do { |int|
					play.(\key, bar, [freq: noteHz.(int, 0), out: outBus]);
				};
				bar.wait;
			};
		});
		(bar * 4).wait;
	};
}).play;
)





























// endfile...