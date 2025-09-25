(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.6]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar * [0, -5, -15].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (6 * Env.perc(0.0, 0.02).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10520, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 160, 1, 4);
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -16.dbamp, 20, 3, 0.9), 600);
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(2.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1620, 0.3) * 16.dbamp;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] * 0.65, curve: -8).ar;
	snd = RLPF.ar(snd, XLine.ar(14000, 1000, 0.3), 0.7);
	// snd = snd + GVerb.ar(snd * -10.dbamp, 20, 3);
	snd = snd * 4.dbamp ! 2;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, duration, freq;
	duration = \duration.kr(2.0);
	snd = SinOsc.ar(225 * [1, 2.34, 3.67]);
	snd = snd * [0, -10, -15].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.tanh;
	snd = snd + (SinOsc.ar(XLine.ar(1200, 100, 0.02)) * Env.perc(0.001, 0.02).ar);
	snd = snd + (SinOsc.ar(XLine.ar(800, 500, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (SinOsc.ar(XLine.ar(2000, 500, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.05).ar, 2520, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.05).ar, 1520, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.001, 0.02).ar, 5520, 0.3);
	snd = snd * (1 + Env.perc(0, 0.03).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.05, 1.5);
	// snd = snd + GVerb.ar(snd * -10.dbamp, 30, 3);
	snd = snd * -6.dbamp ! 2;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp, brightness;
	amp = \amp.kr(1);
	brightness = \brightness.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030] * brightness.linlin(0, 1, 2, 1), 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.06 * brightness.linlin(0, 1, 0.7, 1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), amp * -8.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\crash, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = CombC.ar([snd], 0.2, 1 / [90, 123, 140]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 520);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.5, curve: -4).ar;
	snd = HPF.ar(snd, 930);
	snd = snd + GVerb.ar(snd.sum * -2.dbamp, 30, 20, damping: 0.1);
	snd = LeakDC.ar(snd);
	snd = snd * -20.dbamp;
	snd = snd * Env.perc(0.01, 3.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)


(
SynthDef(\sqr, {
	var freq, duration, snd, env;
	freq = \freq.kr(260);
	duration = \duration.kr(2);
	env = Env.perc(0.001, 4, curve: -4).ar;
	env = env * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = (LFPulse.ar(freq * [1, 2, 4]) * 2) - 1;
	snd = snd + BPF.ar(PinkNoise.ar(1 ! 3), freq);
	snd = snd.product;
	snd = XFade2.ar(snd, CombC.ar(snd, 0.02, SinOsc.ar(0.5, 0).linlin(-1, 1, 0, 1) * 6e-3, 0), \comb.kr(0));
	snd = XFade2.ar(snd, DelayC.ar(snd, 0.2, LFNoise2.ar(3 ! 2).linlin(-1, 1, 0, 1) * 3e-3), \delc.kr(0));
	snd = LPF.ar(snd, 8000);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(0.1) * -4.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\pad, {
	var snd, duration, freq;
	duration = \duration.kr(2.0);
	snd = LFTri.ar(
		\freq.kr(440) * (LFNoise2.ar(60 ! 20) * 0.5).midiratio,
		Rand(0, 4 ! 20)
	);
	snd = Splay.ar(snd);
	snd = snd * -20.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 6).tanh * -5.dbamp, 4000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -8.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 142;
bar = beat * 4;
tatum = beat / 4;
root = 51;

// functions
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;  };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

// scheduling
Routine({
	loop {
		subroutine.(2, {
			// bar 1
			8.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			// bar 2
			8.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			// bar 3
			8.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			// bar 4
			5.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
			seq.(\crash, tatum * 2);
			2.do { seq.(\hat, tatum * 2, [amp: rrand(1.0, 0.7)]); };
		});
		subroutine.(1, {
			// bar 1
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 5);
			// bar 2
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 5);
			// bar 3
			seq.(\kick, tatum * 2);
			seq.(\kick, tatum * 8);
			seq.(\kick, tatum * 6);
			// bar 4
			(tatum * 2).wait;
			seq.(\kick, tatum * 1);
			seq.(\kick, tatum * 7);
			seq.(\kick, tatum * 6);
		});
		subroutine.(1, {
			// bar 1
			(tatum * 4).wait;
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 2);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 1);
			// bar 2
			(tatum * 4).wait;
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 2);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 1);
			// bar 3
			(tatum * 4).wait;
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 2);
			seq.(\snare, tatum * 5);
			seq.(\snare, tatum * 2);
			// bar 4
			(tatum * 1).wait;
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 3);
			seq.(\snare, tatum * 2);
			seq.(\snare, tatum * 5);
			seq.(\snare, tatum * 2);
		});
		subroutine.(4, {
			(0 + [0, 3, 7, 10]).do { |int|
				[0, 1].do { |oct|
					play.(\pad, bar, [freq: noteHz.(int, oct)]);
				};
			};
			(bar).wait;
		});
		subroutine.(1, {
			[
				// Interval, Duration, Octave
				// 1
				[0, 4, -1],
				[7, 2, -1],
				[12, 4, -1],
				[8, 2, -1],
				[8, 2, -1],
				[7, 2, -1],
				// 2
				[0, 4, -1],
				[10, 2, -1],
				[17, 4, -1],
				[3, 2, -1],
				[3, 2, -1],
				[8, 2, -1],
				// 3
				[0, 4, 0],
				[7, 2, 0],
				[12, 4, 0],
				[8, 2, 0],
				[8, 2, 0],
				[7, 2, 0],
				// 4
				[0, 4, 0],
				[10, 2, 0],
				[17, 4, 0],
				[3, 2, 0],
				[3, 2, 0],
				[8, 2, 0],
			].do { | spec |
				var int, dur, oct;
				# int, dur, oct = spec;
				if(int != \, {
					play.(\sub, (dur * tatum), [freq: noteHz.(int, -2)]);
					seq.(\sqr, (dur * tatum), [freq: noteHz.(int, oct)]); // (-1..1).choose
				}, {
					(dur * tatum).wait;
				});
			};
		});
		(bar * 4).wait;
	};
}).play;
)



































// endfile...