(
SynthDef(\pad, {
	var snd, freq, duration, env, lfo;
	duration = \duration.kr(1);
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 2) / 2)).fold2;
	};
	// env = Env.linen(0.001, duration, 0.1).ar(Done.freeSelf);
	// env = Env.linen(0.001, duration * 0.6, duration * 0.4).ar(Done.freeSelf);
	env = Env.perc(0.01, duration * 0.7, curve: 16).ar(Done.freeSelf);
	// env = Env.asr(0.001, 1, 5, curve: \sin).ar(Done.freeSelf, \gate.kr(1));
	freq = \freq.kr(440);
	freq = freq * [1, 2, 1, 2, 2, 1, 2, 1];
	freq = freq * (({ lfo.(8) } ! freq.size) * 0.2).midiratio;
	snd = SinOsc.ar(freq);
	snd = snd * [0, -10, 0, -10, -10, 0, -10, 0].dbamp;
	snd = snd * (1 + ({ lfo.(5) } ! snd.size));
	snd = Splay.ar(snd);
	snd.size.postln;
	snd = snd + (BPF.ar({ PinkNoise.ar } ! 2, freq * 4, 0.1) * -34.dbamp).sum;
	snd = snd + (BPF.ar({ PinkNoise.ar } ! 2, freq * 2, 0.1) * -28.dbamp).sum;
	snd.size.postln;
	// snd = snd + Latch.ar(snd * -25.dbamp, Impulse.ar(ExpRand(9e3, 16e3)));
	snd = snd * -18.dbamp;
	// snd = snd * (1 + (1 * Env.perc(0.001, 0.01).ar));
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, duration, velocity;
	duration = \duration.kr(1.0);
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.06).ar.linexp(0, 1, 56, velocity.linexp(0, 1, 500, 2320)) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.5, 0.5));
	snd = snd * Env.perc(0.01, 0.5).ar;
	snd = snd + (Env.perc(0.001, 0.03).ar * BPF.ar(Hasher.ar(Sweep.ar), 5520, 0.3));
	snd = snd + (Env.perc(0.03, 0.03).delay(0.01).ar * BPF.ar(Hasher.ar(Sweep.ar), 8520, 0.3) * -15.dbamp);
	snd = snd * (1 + (10 * Env.perc(0.001, 0.01).ar));
	snd = snd * 5.dbamp;
	snd = snd * velocity.linlin(0, 1, 0.5, 1);
	snd = BHiShelf.ar(snd, 3000, 0.3, -3);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 5);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.1, [33.3e-3, 41e-3]), 300), 3000);
	snd = snd * -14.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), 1232 * [0.95, 1, 1.2], 0.2) * 10.dbamp;
	snd = snd * Env([0, 5, 1, 0], [0.001, 0.01, 0.1]).delay([0.015, 0, 0.034]).ar;
	snd = snd.clip2;
	snd = Splay.ar(snd, 0.5);
	snd = snd + LPF.ar(GVerb.ar(snd.sum * -20.dbamp, 50, 2), 8000);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.13, 1.2);
	snd = snd * 4.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\shaker, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.2, 1 / 80, 1);
	snd = FreqShift.ar(snd, -54);
	snd = BPF.ar(snd, [12240, 5230, 7832] * 1.1 * XLine.ar(0.8, 1.2, 0.1), 0.2).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.02, curve: 4).ar(Done.freeSelf);
	snd = snd * -18.dbamp * \amp.kr(1) ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clank, {
	var snd, duration, velocity;
	duration = \duration.kr(1.0);
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar([2534, 2440, 5520] * 0.7);
	snd = snd * Env.perc(0.001, 0.1 * [1, 0.3, 0.5]).ar;
	snd = snd.sum;
	snd = snd * velocity.linlin(0, 1, 0.5, 1);
	snd = snd * (1 + (Env.perc(0.01, 0.3).ar * SinOsc.ar(4000)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.001, 0.03).ar, 2340, 0.1));
	snd = snd + PitchShift.ar(snd, 0.03, 1.3);
	snd = Pan2.ar(snd * 3.dbamp, \pan.kr(0)) + GVerb.ar(snd * -15.dbamp, 30, 2);
	snd = snd * -13.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.9, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\woodblock, {
	var snd, duration, velocity, tone;
	duration = \duration.kr(1.0);
	velocity = \velocity.kr(1.0);
	tone = \tone.kr(0.4);
	snd = SinOsc.ar([1200, 1934, 3340] * tone * XLine.ar(2.3, 1.0, 0.001));
	snd = snd * [0, 0, -9].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd * velocity.linlin(0, 1, 0.5, 1);
	snd = snd.tanh;
	snd = Pan2.ar(snd * 3.dbamp, \pan.kr(0)) + GVerb.ar(snd * -10.dbamp, 30, 1);
	snd = snd * -10.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(35 * [1, 1.2, 2.4, 3.4, 6.7, 8.9]);
	snd = snd.sum * -10.dbamp;
	snd = LeakDC.ar(snd);
	snd = FreqShift.ar(snd, 135);
	snd = snd + (Hasher.ar(Sweep.ar) * -20.dbamp);
	snd = BPF.ar(snd, (0..3).normalize.linexp(0, 1, 5000, 8000), 0.01).sum;
	3.do { snd = HPF.ar(snd, 3000); };
	snd = snd * 30.dbamp;
	snd = snd + (HPF.ar(SinOsc.ar(XLine.ar(16e3, 1e3, 0.01)) * Env.perc(0.001, 0.01).ar, 200) * -10.dbamp);
	snd = snd * Env.linen(0.001, 0.01, 0.02, curve: -4).ar;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd + GVerb.ar(snd * -10.dbamp, 10, 3);
	snd = snd * -18.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(41 * [1, 1.2, 2.4, 3.4, 6.7, 8.9]);
	snd = snd.sum * -10.dbamp;
	snd = LeakDC.ar(snd);
	snd = FreqShift.ar(snd, 165);
	snd = snd + (Hasher.ar(Sweep.ar) * -20.dbamp);
	snd = BPF.ar(snd, (0..3).normalize.linexp(0, 1, 5000, 9000), 0.02).sum;
	3.do { snd = HPF.ar(snd, 3000); };
	snd = snd * 30.dbamp;
	snd = snd + (HPF.ar(SinOsc.ar(XLine.ar(16e3, 1e3, 0.01)) * Env.perc(0.001, 0.01).ar, 200) * -10.dbamp);
	snd = snd * Env.linen(0.001, 0.01, 0.02, curve: -4).ar;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = Pan2.ar(snd, \pan.kr(0)) + GVerb.ar(snd * -15.dbamp, 90, 6);
	snd = snd * -12.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var snd, duration, freq, lfo;
	duration = \duration.kr(1.0);
	lfo = { |rate| (LFNoise2.kr(rate) + (LFNoise2.kr(rate * 3) / 3)).fold2; };
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * [-0.1, 0.1].midiratio, lfo.(4).linlin(-1, 1, 0.4, 0.6));
	snd = snd * -12.dbamp;
	snd = RLPF.ar(snd, LFNoise2.kr(0.5).linexp(-1, 1, 100, 1000), 0.3);
	snd = LPF.ar(snd, 530);
	// snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * Env.perc(0.001, 8).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, pump;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.9 * Env.perc(0.01, 0.05, curve: 4).ar(gate: T2A.ar(\pump.tr))));
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 146;
bar = beat * 4;
tatum = beat / 4;
root = 50; // 42=F#, 48=C, 50=D, 51=D#, 52=E
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork { latency.wait; s.bind { Synth(synth, [duration: dur] ++ args); }; };
};
seq = { |synth, dur, args=#[], latency=0.0|
	play.(synth, dur, args, latency);
	(dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

Routine({
	var sidechainBus, sidechainFx;
	s.bind {
		sidechainBus = Bus.audio(nil, 2);
		sidechainFx = Synth.tail(nil, \sidechainFx, [in: sidechainBus, out: 0]);
	};

	///////////////////////////////////////////////////////////////////
	~loopChords = {
		subroutine.(1, {
			var padsOut = 0;
			// 4 bars
			[4, 2, 4, 2, 4, 4, 2, 4, 2, 4].do { |dur|
				(root + [0, 16, 14, 23]).do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps, out: padsOut], latency: 0.01);
				};
				(tatum * dur).wait;
			};
			[4, 2, 4, 2, 4, 4, 2, 4, 2, 4].do { |dur|
				(root + 5 + [0, 16, 14, 23]).do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps, out: padsOut], latency: 0.01);
				};
				(tatum * dur).wait;
			};
			// 4 bars
			[4, 2, 4, 2, 4, 4, 2, 4, 2, 4].do { |dur|
				(root + [0, 16, 14, 23]).do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps, out: padsOut], latency: 0.01);
				};
				(tatum * dur).wait;
			};
			[4, 2, 4, 2, 4, 4, 2, 4, 2].do { |dur|
				(root + 5 + [0, 16, 14, 23]).do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps, out: padsOut], latency: 0.01);
				};
				(tatum * dur).wait;
			};
			[4].do { |dur|
				(root + 7 + [0, 16, 19, 23]).do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps, out: padsOut], latency: 0.01);
				};
				(tatum * dur).wait;
			};
		});
	};
	~loopBass = {
		subroutine.(1, {
			var outBus = sidechainBus;
			[
				// basic /////////////////////////////////////
				[0, 32],
				[5, 32],
				[0, 32],
				[5, 28],
				[7, 4],
				// basic /////////////////////////////////////
			].do { |spec|
				var int, dur;
				# int, dur = spec;
				seq.(\bass, tatum * dur, [freq: noteHz.(int, -2), out: outBus]);
			};
		});
	};
	~loopShaker = {
		subroutine.(16, {
			[0.01, 1, 0.4, 0.2].do { |vel| seq.(\shaker, beat/2, [amp: vel]); };
		});
	};
	~loopHat = {
		subroutine.(8, {
			var late = 0.02;
			[\, \, 0.5, \, \, \, \, \, \, \, 0.1, \, 0.8, 0.1, 0.6, \].do { |vel, index|
				if(index % 2 == 1, { late = 0.01; });
				if(vel != \, {
					seq.(\hat, tatum, [amp: vel], latency: late);
				}, { tatum.wait; });
			};
		});
	};
	~loopWoodblock = {
		subroutine.(8, {
			1.do {
				(beat * 1).wait;
				seq.(\woodblock, beat/2, [velocity: 0.4, tone: 0.2], latency: 0.02);
				seq.(\woodblock, beat/2, [velocity: 0.6, tone: 0.6]);
				(beat * 2).wait;
			};
		});
	};
	~loopClap = {
		subroutine.(8, {
			1.do {
				(beat * 2).wait;
				seq.(\clap, beat * 2, latency: 0.02);
			};
		});
	};
	~loopKick = {
		subroutine.(2, {
			3.do {
				s.bind { sidechainFx.set(\pump, 1); };
				seq.(\kick, beat * 3);
				s.bind { sidechainFx.set(\pump, 1); };
				seq.(\kick, beat, [velocity: 0.6], latency: 0.02);
			};
			s.bind { sidechainFx.set(\pump, 1); };
			seq.(\kick, beat * 1.5);
			s.bind { sidechainFx.set(\pump, 1); };
			seq.(\kick, beat * 1.5, [velocity: 0.8], latency: 0);
			s.bind { sidechainFx.set(\pump, 1); };
			seq.(\kick, beat, [velocity: 0.6], latency: 0.02);
		});
	};
	///////////////////////////////////////////////////////////////////
	~loopChords.();
	(bar * 8).wait; // global wait

	loop {
		~loopClap.();
		~loopKick.();
		~loopWoodblock.();
		~loopHat.();
		~loopShaker.();
		~loopBass.();
		~loopChords.();
		(bar * 8).wait; // global wait
	};
	///////////////////////////////////////////////////////////////////
}).play;
)


s.makeWindow;


(
SynthDef(\woodblock, {
	var snd, duration, velocity, tone;
	duration = \duration.kr(1.0);
	velocity = \velocity.kr(1.0);
	tone = \tone.kr(0.4);
	snd = SinOsc.ar([1200, 1934, 3340] * tone * XLine.ar(2.3, 1.0, 0.001));
	snd = snd * [0, 0, -9].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd * velocity.linlin(0, 1, 0.5, 1);
	snd = snd.tanh;
	snd = Pan2.ar(snd * 3.dbamp, \pan.kr(0)) + GVerb.ar(snd * -10.dbamp, 30, 1);
	snd = snd * -10.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)







( // Midi - Major11
(50 + 0 + [0, 16, 18, 23]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)


( // Midi - Minor7
(50 + 0 + [0, 15, 19, 22]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)


( // Midi - Minor9
(50 + 0 + [0, 15, 14, 22]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

( // Midi - Minor11
(50 + 0 + [0, 15, 17, 22]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

( // Midi - Minor13
(50 + 0 + [0, 15, 20, 22]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)


//////////////////


( // Just Intonation - Major7
((50.midicps) * [1, 5/4 * 2, 3/2 * 2, 15/8 * 2 ]).do { |int|
	Synth(\pad, [freq: (int)]);
};
)


( // Just Intonation - Minor7
((50.midicps) * [1, 6/5 * 2, 3/2 * 2, 9/5 * 2 ]).do { |int|
	Synth(\pad, [freq: (int)]);
};
)



( // Just Intonation - Minor7
((50.midicps) * [1, 6/5 * 2, 3/2 * 2, 9/5 * 2 ]).do { |int|
	Synth(\pad, [freq: (int)]);
};
)


( // Just Intonation - Minor9 (drop the 5th for a 9th (2nd)
((50.midicps) * [1, 6/5 * 2, 9/8 * 2, 9/5 * 2 ]).do { |int|
	Synth(\pad, [freq: (int)]);
};
)

( // Just Intonation - Minor11 (drop the 5th for a 11th (4th)
((50.midicps) * [1, 6/5 * 2, 4/3 * 2, 9/5 * 2 ]).do { |int|
	Synth(\pad, [freq: (int)]);
};
)






9, 11, 13


//////////////////







(
(50 + 5 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
(50 + 7 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
(50 + -5 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
(50 + -2 + [0, 16, 19, 11]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)













(
SynthDef(\pad2, {
	var snd, freq, duration, env, lfo;
	duration = \duration.kr(3);
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 2) / 2)).fold2;
	};
	// env =  Env.linen(0.001, duration, 0.1).ar(Done.freeSelf);
	env = Env.asr(0.001, 1, 5, curve: \sin).ar(Done.freeSelf, \gate.kr(1));
	freq = \freq.kr(440);
	freq = freq * [1, 2, 1, 3, 4, 1, 2, 1];
	freq = freq * (({ lfo.(8) } ! freq.size) * 0.2).midiratio;
	snd = LFTri.ar(freq);
	snd = snd * [0, -10, 0, -15, -19, 0, -10, 0].dbamp;
	snd = snd * (1 + ({ lfo.(5) } ! snd.size));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 800);
	snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(1 / 4.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	snd = snd * -23.dbamp;
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
(50 + [0, 15, 19, 22]).do { |int|
	Synth(\pad2, [freq: (int).midicps]);
};
)

(
SynthDef(\bass, {
	var snd, freq, lfo;
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 3) / 3)).fold2;
	};
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * [-0.1, 0.1].midiratio, lfo.(4).linlin(-1, 1, 0.4, 0.6));
	snd = snd * -15.dbamp;
	snd = RLPF.ar(snd, LFNoise2.kr(0.5).linexp(-1, 1, 100, 1000), 0.3);
	snd = LPF.ar(snd, 530);
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
~bass = Synth(\bass, [freq: (50-24).midicps]);
)




(
SynthDef(\ping, {
	var snd, freq, fb;
	freq = \freq.kr(440);
	snd = LFTri.ar(freq);
	snd = snd * freq.explin(440, 1000, 0, -10).dbamp.lag(0.01);
	snd = snd ! 2;
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.none, \gate.kr(1));
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), 1432 * [0.95, 1, 1.2], 0.2) * 10.dbamp;
	snd = snd * Env([0, 5, 1, 0], [0.001, 0.01, 0.1]).delay([0.035, 0, 0.014]).ar;
	snd = snd.clip2;
	snd = Splay.ar(snd, 0.5);
	snd = snd + LPF.ar(GVerb.ar(snd.sum * -20.dbamp, 50, 2), 7000);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.13, 0.8);
	snd = snd * -2.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)











// endfile