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
	snd = SinOsc.ar(freq * 3) * Env.perc(0, 0.1).ar.linlin(0, 1, 400, 900);
	snd = SinOsc.ar(freq + snd).sum;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * -16.dbamp);
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freqs;
	freqs = \freq.kr(260) * Line.kr(\bend.kr(-7), 0, 0.3).midiratio;
	freqs = freqs * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30 ! freqs.size).linlin(-1, 1, 0, 2pi) * 0.06);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -30.dbamp, 60, 4, 0.8);
	snd = snd * Env.perc(0.02, 4, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.2, 2.8]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar;
	snd = snd * [0, -5, -13].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (10 * Env.perc(0.0, 0.02).ar));
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 1, 4);
	snd = snd * \amp.kr(1) * 0.dbamp;
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [1540, 1880], [0.4, 0.6]).sum;
	snd = snd * 16.dbamp;
	snd = snd * (1 + ( 2 * Env.perc(0, 0.1).ar));
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.004, 1e-4, 0.003, 1e-4, 0.08] * 0.9, -4).ar(Done.freeSelf);
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
)

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 128;
bar = beat * 4;
tatum = beat / 4;
root = 51;
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
};
seq = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
	(dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	loop {
		// kick+clap /////////////////////////////////////////////////////
		subroutine.(1, {
			// bar
			seq.(\kick, beat * 1, [amp: 1]);
			seq.(\kick, beat * 1, [amp: 0.6]);
			seq.(\clap, beat * 0.5, [amp: 1]);
			seq.(\kick, beat * 1, [amp: 0.7]);
			seq.(\kick, beat * 0.5, [amp: 0.9]);
			// bar
			seq.(\kick, beat * 2, [amp: 1]);
			seq.(\clap, beat * 0.5, [amp: 1]);
			seq.(\kick, beat * 1, [amp: 0.7]);
			seq.(\kick, beat * 0.25, [amp: 0.3]);
			seq.(\kick, beat * 0.25, [amp: 0.9]);
		});
		// hat /////////////////////////////////////////////////////
		subroutine.(4, {
			4.do { |index|
				seq.(\hat, beat/2, [amp: index.linlin(0, 3, 1, 0.6)]);
			};
		});
		// perc /////////////////////////////////////////////////////
		subroutine.(4, {
			beat.wait;
			seq.(\hasherPerc, beat);
		});
		// pad ////////////////////////////////////////////////////
		subroutine.(1, {
			(0 + [0, 3, 7, 10]).do { |int|
				play.(\pad, bar, [freq: noteHz.(int, 1)]);
				play.(\pad, bar, [freq: noteHz.(int, 0)]);
			};
			bar.wait;
			(0 + [5, 8, 12, -2]).do { |int|
				play.(\pad, bar, [freq: noteHz.(int, 1)]);
				play.(\pad, bar, [freq: noteHz.(int, 0)]);
			};
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
					play.(\fmMid, dur * tatum, [freq: noteHz.(int, oct)]);
				};
				(dur * tatum).wait;
			};
		});
		// LoopWait /////////////////////////////////////////////////////
		(bar * 2).wait;
	};
}).play;
)
