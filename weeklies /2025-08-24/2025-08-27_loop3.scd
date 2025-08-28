/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\hasherPerc, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(60)) + [0, 1]);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * Env.perc(0.001, 0.1, curve: 0).ar;
	snd = snd + GVerb.ar(snd.sum * -10.dbamp, 13, 3);
	2.do { snd = HPF.ar(snd, 460); };
	2.do { snd = LPF.ar(snd, 1e4); };
	snd = snd * Env.linen(0.0, 10.0, 3.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fmMid, {
	var snd, freq, env;
	freq = \freq.kr(260) * [-0.1, 0.1].midiratio;
	env = Env.perc(0.001, 3, curve: -4).ar;
	env = env * Env.linen(0, \duration.kr(1), 0.1).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 2) * Env.perc(0, 0.1).ar.linlin(0, 1, 400, 900);
	snd = SinOsc.ar(freq + snd).sum;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * -12.dbamp);
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freqs;
	freqs = \freq.kr(260) * Line.kr(\bend.kr(-12), 0, 0.2).midiratio;
	freqs = freqs * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30 ! freqs.size).linlin(-1, 1, 0, 2pi) * 0.2);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -30.dbamp, 60, 4, 0.8);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.perc(0.02, 4, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	// snd = snd * freq.explin(50, 100, 0, -5).dbamp;
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
	snd = snd * Env.linen(0.0, duration * 0.9, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.6, 3.2]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar;
	snd = snd * [0, -5, -15].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (10 * Env.perc(0.0, 0.02).ar));
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 1, 4);
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd + LPF.ar(GVerb.ar(snd * -10.dbamp, 10, 3, 0.8), 600);
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	// snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [1540, 1880], [0.4, 0.6]).sum;
	snd = snd * 16.dbamp;
	snd = snd * (1 + ( 3 * Env.perc(0, 0.1).ar));
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.004, 1e-4, 0.003, 1e-4, 0.08] * 0.9, -4).ar(Done.freeSelf);
	// snd = snd + DelayN.ar(FreqShift.ar(snd * -15.dbamp, 500), 0.05, 0.03);
	// snd = snd * Env.linen(0, \duration.kr(1), 0.1).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.45);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp;
	amp = \amp.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030] * amp.linlin(0, 1, 2, 1), 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.06 * amp.linlin(0, 1, 0.7, 1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), amp * 0.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\crash, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = CombC.ar([snd], 0.2, 1 / [90, 123, 140]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 320);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 1.0, curve: -4).ar;
	snd = HPF.ar(snd, 930);
	snd = snd + GVerb.ar(snd.sum * -2.dbamp, 30, 20, damping: 0.1);
	snd = LeakDC.ar(snd);
	snd = snd * -25.dbamp;
	snd = snd * Env.perc(0.01, 10.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\fm, {
	var snd;
	snd = SinOsc.ar(ExpRand(1000, 8000)) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd);
	snd = (snd * 10).fold2;
	snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, ExpRand(0.01, 0.5), 0.0, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [60, 230, 345], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 10342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Splay.ar(snd, 0.3);
	snd = snd * -23.dbamp;
	snd = snd * Env.perc(0.02, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\blip, {
	var snd;
	snd = SinOsc.ar(Env([2300, 6520, 9930], [0.05, 0.05, 0.05], \hold).ar);
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, 0.15, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 128;
bar = beat * 4;
tatum = beat / 4;
root = 51;
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; };
seq = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait; };
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };

Routine({
	loop {
		// kick+clap /////////////////////////////////////////////////////
		subroutine.(1, {
			// bar
			// if(0.5.coin, { play.(\crash, beat); });
			seq.(\kick, beat * 1, [amp: 1]);
			seq.(\kick, beat * 1, [amp: 0.6]);
			play.(\rim, beat * 0.5, [amp: 1]);
			seq.(\clap, beat * 0.5, [amp: 1]);
			seq.(\kick, beat * 1, [amp: 0.7]);
			seq.(\kick, beat * 0.5, [amp: 0.9]);
			// bar
			seq.(\kick, beat * 2, [amp: 1]);
			// if(0.5.coin, { play.(\blip, beat); });
			play.(\rim, beat * 0.5, [amp: 1]);
			seq.(\clap, beat * 0.5, [amp: 1]);
			// if(0.5.coin, { play.(\blip, beat); });
			seq.(\kick, beat * 1, [amp: 0.7]);
			seq.(\kick, beat * 0.25, [amp: 0.3]);
			seq.(\kick, beat * 0.25, [amp: 0.9]);
		});
		// hat /////////////////////////////////////////////////////
		subroutine.(4, {
			[1, 0.6, 0.7, 0.5].do { |amp| seq.(\hat, beat/2, [amp: amp]); };
		});
		// perc /////////////////////////////////////////////////////
		subroutine.(4, {
			beat.wait;
			seq.(\hasherPerc, beat);
		});
		// pad+sub ////////////////////////////////////////////////////
		subroutine.(1, {
			(0 + [0, 3, 7, 10]).do { |int|
				play.(\pad, bar, [freq: noteHz.(int, 1)]);
				play.(\pad, bar, [freq: noteHz.(int, 0)]);
			};
			play.(\sub, bar, [freq: noteHz.(0, -1)]);
			bar.wait;
			(0 + [-2, 5, 8, 12]).do { |int|
				play.(\pad, bar, [freq: noteHz.(int, 1)]);
				play.(\pad, bar, [freq: noteHz.(int, 0)]);
			};
			play.(\sub, bar, [freq: noteHz.(-2, -1)]);
			bar.wait;
		});
		// fmMid ////////////////////////////////////////////////////
		subroutine.(1, {
			[
				// bar
				[0, 3],
				[12, 3],
				[-5, 6],
				[8, 2],
				[7, 2],
				// bar
				[5, 3],
				[12, 3],
				[-4, 6],
				[10, 2],
				[7, 2],
			].do { |spec|
				var int, dur;
				# int, dur = spec;
				[1, -1].do { |oct|
					play.(\fmMid, (dur * tatum), [freq: noteHz.(int, oct)]);
				};
				(dur * tatum).wait;
			};
		});
		// LoopWait /////////////////////////////////////////////////////
		(bar * 2).wait;
	};
}).play;
)




(
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(1220 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	// snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	// snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -15.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.0, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\breathe1, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [800, 1320] * XLine.ar(1, 1.1, 0.3), 0.05);
	snd = snd.sum;
	snd = snd ! 2;
	snd = snd * Env.perc(0.1, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)



// endfile