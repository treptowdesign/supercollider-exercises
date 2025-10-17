(
SynthDef(\keys, {
	var snd, fm, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.05, 0, 0.05] * LFNoise2.ar(20 ! 3)).midiratio;
	fm = SinOsc.ar(freq * 1.001) * 200 * (1 + Env.perc(0, 0.01).ar);
	pm = SinOsc.ar(freq * 1.001) * 2 * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq + fm, pm);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-27.dbamp * \amp.kr(1)));
	snd = snd * Env.perc(0.002, \rel.kr(1.2)).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (3 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -7.dbamp];
	snd[1] = snd[1] * Env.perc(0, 0.5).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2.0).ar;
	snd = snd ! 2;
	snd = snd * -5.dbamp * \amp.kr(1);
	snd = snd * (1 + (6 * Env.perc(0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 4, 8] * (LFNoise2.kr(60 ! 4) * 0.12).midiratio);
	snd = snd * Env.perc(0, [10, 8, 2, 2]).ar;
	snd = snd * [0, -4, -9, -16].dbamp;
	snd = snd * (1 + (0.1 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum;
	snd = BLowShelf.ar(snd, 400, 0.3, 4);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 6, damping: 0.2);
	snd = snd * Env.perc(0.001, \rel.kr(1.3), curve: -4).ar;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -30.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\perc, {
	var snd;
	snd = SinOsc.ar(940 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + GVerb.ar(snd * -20.dbamp, 10);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1230);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08] * 0.7, -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.35) ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.15).ar.linexp(0, 1, 50, 300) * XLine.ar(1, 0.5, 0.5));
	snd = snd * (1 + (3 * Env.perc(0, 0.05).ar));
	snd = snd + (BPF.ar(Env.perc(0.001, 0.02).ar * Hasher.ar(Sweep.ar), 3240, 0.3) * 10.dbamp);
	snd = snd.tanh;
	snd = BHiShelf.ar(snd, 3400, 0.3, 4);
	snd = BLowShelf.ar(snd, 100, 0.3, 4);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [30e-3, 45e-3]), 200), 3000);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd * -6.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12.3e3], 0.1);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.01, 0.02, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0));
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
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 120;
bar = beat * 4;
tatum = beat / 4;
root = 50; // 48=C, 50=D, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork {
		latency.wait;
		s.bind { Synth(synth, [duration: dur] ++ args); };
	};
};
seq = { |synth, dur, args=#[], latency=0.0|
	s.bind { Synth(synth, [duration: dur] ++ args); }; (dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	'Start Routine'.postln;
	loop {
		subroutine.(8, { // 8
			(tatum * 1).wait;
			seq.(\hatSoft, (tatum * 3));
			(tatum * 5).wait;
			seq.(\hatSoft, (tatum * 7));
		});
		subroutine.(8, { // 8
			8.do { |index| seq.(\hat, (tatum * 2), [amp: rrand(0.4, 1.0)]); };
		});
		subroutine.(8, { // 8
			(tatum * 3).wait;
			seq.(\perc, (tatum * 1));
			seq.(\clap, (tatum * 4));
			(tatum * 2).wait;
			seq.(\perc, (tatum * 1), [amp: 0.3]);
			seq.(\perc, (tatum * 1));
			seq.(\clap, (tatum * 4));
		});
		subroutine.(1, { // 4
			[7, 9, 7, 3, 6].do { |dur| seq.(\kick, tatum * dur); };
			[7, 9, 7, 6, 3].do { |dur| seq.(\kick, tatum * dur); };
			[7, 9, 7, 3, 3, 3].do { |dur| seq.(\kick, tatum * dur); };
			[7, 9, 7, 6, 3].do { |dur| seq.(\kick, tatum * dur); };
		});
		subroutine.(0, { // 1
			[
				// bar 1-4 //////////////////////////////////////////////////////////////////////////////
				(notes: -5 + [0, 15, 19, 22], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // V7
				(notes: -4 + [0, 11, 16, 19], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // VI7
				(notes: \, length: [1]),
				(notes: 2 + [0, 7 +12, 10, 15], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // ii7
				(notes: 1 + [0, 7 +12, 11, 16], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // bII7
				(notes: \, length: [1]),
				(notes: 0 + [0, 3, 10, 14], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // i9
				(notes: 0 + [0, 10, 15, 19], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // i7
				(notes: \, length: [1]),
				(notes: 0 + [0, 3, 10, 14], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // i9
				(notes: 0 + [0, 10, 15, 19], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // i7
				(notes: \, length: [1]),
				// bar 5-8 //////////////////////////////////////////////////////////////////////////////
				(notes: -5 + [0, 15, 19, 22], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // V7
				(notes: -4 + [0, 11, 16, 19], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // VI7
				(notes: \, length: [1]),
				(notes: -7 + [0, 15, 19, 22], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // iv7
				(notes: -2 + [0, 13, 16, 22], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // bVII7
				(notes: \, length: [1]),
				(notes: 0 + [0, 3, 10, 14], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // i9
				(notes: 0 + [0, 10, 15, 19], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // i7
				(notes: \, length: [1]),
				(notes: 0 + [0, 3, 10, 14], length: [4, 3], amp: [1, 0.9], rel: [1.2, 1.2], late: [0, 0.02]), // i9
				(notes: 0 + [0, 10, 15, 19], length: [3, 3, 2], amp: [1, 0.9, 0.9], rel: [1.2, 1.4, 1.2], late: [0, 0.02, 0.01]), // i7
				(notes: \, length: [1]),
			].do { |chord|
				chord[\length].do { |item, index|
					var dur = item * tatum;
					if(chord[\notes] != \, {
						chord[\notes].sort.postln.do { |int|
							[0,1].do { |oct|
								var vel = chord[\amp][index] * oct.linlin(0, 1, 1, 0.3);
								var rel = chord[\rel][index] * 0.6;
								var late = chord[\late][index];
								play.(\organ, dur, [freq: noteHz.(int, oct), amp: vel, rel: rel, out: 0], latency: late);
							};
						};
					});
					dur.wait;
				};
			};
		});
		(bar * 8).wait;
	};
}).play;
)













// endfile