(
SynthDef(\pad, {
	var snd, freq, duration, env, lfo;
	duration = \duration.kr(1);
	lfo = { |rate|
		(LFNoise2.kr(rate) + (LFNoise2.kr(rate * 2) / 2)).fold2;
	};
	// env = Env.linen(0.001, duration, 0.1).ar(Done.freeSelf);
	env = Env.linen(0.001, duration * 0.7, duration * 0.3).ar(Done.freeSelf);
	// env = Env.perc(0.001, duration, curve: 8).ar(Done.freeSelf);
	// env = Env.asr(0.001, 1, 5, curve: \sin).ar(Done.freeSelf, \gate.kr(1));
	freq = \freq.kr(440);
	freq = freq * [1, 2, 1, 2, 2, 1, 2, 1];
	freq = freq * (({ lfo.(8) } ! freq.size) * 0.2).midiratio;
	snd = SinOsc.ar(freq);
	snd = snd * [0, -10, 0, -10, -10, 0, -10, 0].dbamp;
	snd = snd * (1 + ({ lfo.(5) } ! snd.size));
	snd = Splay.ar(snd);
	snd = snd + BPF.ar({ PinkNoise.ar } ! 2, freq * 2, 0.1);
	snd = snd + Latch.ar(snd * -25.dbamp, Impulse.ar(ExpRand(4e3, 16e3)));
	snd = snd * -18.dbamp;
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
)

//////////////////

( // Midi - Major7
(50 + 0 + [0, 16, 19, 23]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

( // Midi - Major9
(50 + 0 + [0, 16, 14, 23]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

( // Midi - Major9
(50 + 5 + [0, 16, 14, 23]).do { |int|
	Synth(\pad, [freq: (int).midicps]);
};
)

(
SynthDef(\kick, {
	var snd, duration, velocity;
	duration = \duration.kr(1.0);
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.06).ar.linexp(0, 1, 56, velocity.linexp(0, 1, 500, 2320)) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.5, 0.5));
	snd = snd * Env.perc(0.01, 0.5).ar;
	snd = snd + (Env.perc(0.001, 0.03).ar * BPF.ar(Hasher.ar(Sweep.ar), 6520, 0.3));
	snd = snd + (Env.perc(0.03, 0.03).delay(0.01).ar * BPF.ar(Hasher.ar(Sweep.ar), 9520, 0.3) * -15.dbamp);
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
	snd = snd * Env([0, 5, 1, 0], [0.001, 0.01, 0.1]).delay([0.045, 0, 0.024]).ar;
	snd = snd.clip2;
	snd = Splay.ar(snd, 0.5);
	snd = snd + LPF.ar(GVerb.ar(snd.sum * -20.dbamp, 50, 2), 7000);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.13, 0.8);
	snd = snd * 2.dbamp;
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
	snd = snd * -20.dbamp * \amp.kr(1) ! 2;
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
	loop {
		subroutine.(4, {
			1.do {
				seq.(\kick, beat * 3);
				seq.(\kick, beat * 1, [velocity: 0.6], latency: 0.02);
			};
		});
		subroutine.(4, {
			1.do {
				(beat * 2).wait;
				seq.(\clap, beat * 2, latency: 0.02);
			};
		});
		subroutine.(8, {
			[0.1, 1, 0.6, 0.4].do { |vel|
				seq.(\shaker, beat/2, [amp: vel]);
			};
		});
		subroutine.(1, {
			[4, 2, 4, 2, 4, 4, 2, 4, 2, 4].do { |dur|
				(root + [0, 16, 14, 23]).postln.do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps], latency: 0.01);
				};
				(tatum * dur).wait;
			};
			[4, 2, 4, 2, 4, 4, 2, 4, 2].do { |dur|
				(root + 5 + [0, 16, 14, 23]).postln.do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps], latency: 0.01);
				};
				(tatum * dur).wait;
			};
			[4].do { |dur|
				(root + 7 + [0, 16, 19, 23]).postln.do { |note|
					play.(\pad, (tatum * dur), [freq: note.midicps], latency: 0.01);
				};
				(tatum * dur).wait;
			};
		});
		// global wait
		(bar * 4).wait;
	};
}).play;
)

[4, 2, 4, 4, 2].sum;



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