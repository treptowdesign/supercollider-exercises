////////////////////////////////////////////////////////////////////////////////////
// Synths
////////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1230);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08] * 0.7, -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.2) ! 2;
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
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * -10.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12300], 0.1);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.01, 0.02, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keyPluck, {
	var snd, fm, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.04, 0, 0.04] * LFNoise2.ar(20 ! 3)).midiratio;
	fm = SinOsc.ar(freq * 1.001) * 200 * (1 + Env.perc(0, 0.01).ar);
	pm = SinOsc.ar(freq * 0.999) * 5 * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq + fm, pm);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-28.dbamp * \amp.kr(1)));
	snd = snd * Env.perc(0.001, \rel.kr(2.5), curve: -4).ar(Done.freeSelf);
	// snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\dulc, {
	var snd, freq, freqs;
	freq = \freq.kr(220) * XLine.ar(ExpRand(1.1, 1.5 ! 3), 1, ExpRand(0.01, 0.02));
	freqs = freq * [-0.1, 0, 0.1].midiratio;
	snd = Pluck.ar(WhiteNoise.ar, Impulse.ar(0), 1 / 10, 1 / freqs, 9.0, 0.3) * 15.dbamp;
	snd = snd.tanh;
	snd = Splay.ar(snd, 0.5);
	snd = LPF.ar(snd, 3231);
	snd = snd + PitchShift.ar(snd, ExpRand(0.05 ! 2, 0.1), [1.5, 2]);
	snd = BPF.ar([snd], (0..20).normalize.linexp(0, 1, 60, 8000), 0.05).sum * 8.dbamp;
	snd = snd * Env.perc(0.0, 6).ar(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keyChords, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.008) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.3];
	snd = SinOsc.ar(freq, snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 4.dbamp).tanh;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.4, 1);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 3e-3);
	snd = snd * -22.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (3 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -10.dbamp];
	snd[1] = snd[1] * Env.perc(0, 0.4).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2.0).ar;
	snd = snd ! 2;
	snd = snd * -10.dbamp * \amp.kr(1);
	snd = snd * (1 + (6 * Env.perc(0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

////////////////////////////////////////////////////////////////////////////////////
// Pattern
////////////////////////////////////////////////////////////////////////////////////
(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
tatum = beat / 4;
root = 51; // 48=C, 50=D, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork { latency.wait; s.bind { Synth(synth, [duration: dur] ++ args); }; };
};
seq = { |synth, dur, args=#[], latency=0.0|
	play.(synth, dur, args, latency); (dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	'Start Routine'.postln;
	loop {
		// subroutines ////////////////////////////////////////////////
		subroutine.(8, { // 8
			4.do {
				(tatum * 2).wait;
				seq.(\hat, (tatum * 2), [amp: rrand(0.4, 0.8)]);
			};
		});
		subroutine.(8, { // 8
			2.do {
				beat.wait;
				seq.(\clap, beat, latency: 0.02);
			};
		});
		subroutine.(8, { // 8
			4.do { |index| seq.(\kick, beat, [amp: (index % 2).linlin(0, 1, 1, 0.6)]); };
		});
		subroutine.(2, { // 2
			[-3, 2, -5, 0].do { |int|
				4.do {
					(beat * 0.5).wait;
					seq.(\sub, (beat * 0.5), [freq: noteHz.(int, -1)], latency: 0.0);
				};
			};
		});
		subroutine.(1, { // 1
			[
				// [interval, dur (tatums)]
				// bar [ -3, 0, 4, 7 ] /////////////////////////////////
				[9, 4], [7, 2], [4, 4], [9, 2], [4, 4],
				// bar [ 2, 5, 7, 12 ]
				[\, 10], [7, 3], [2, 3],
				// bar [ -5, -2, 0, 5 ]
				[-5, 4], [\, 12],
				// bar [ 0, 3, 7, 10 ]
				[-2, 6], [0, 10],
				// bar [ -3, 0, 4, 7 ] /////////////////////////////////
				[9, 4], [7, 2], [4, 4], [9, 2], [4, 4],
				// bar [ 2, 5, 7, 12 ]
				[\, 10], [7, 3], [2, 3],
				// bar [ -5, -2, 0, 5 ]
				[-5, 4], [\, 12],
				// bar [ 0, 3, 7, 10 ]
				[-2, 6], [0, 6], [-2, 4],
			].do { |spec|
				var int, dur;
				# int, dur = spec;
				if(int != \, {
					var randLate = 0.02; // rrand(0.0, 0.01);
					play.(\dulc, (tatum * dur), [freq: noteHz.(int, 1)], latency: randLate);
					play.(\keyPluck, (tatum * dur), [freq: noteHz.(int, 0), amp: 1], latency: randLate);
					seq.(\keyPluck, (tatum * dur), [freq: noteHz.(int, 1), amp: 1], latency: randLate);
				}, { (tatum * dur).wait; });
			};
		});
		subroutine.(2, { // 2
			[
				(-3 + [0, 15, 19, 22]), // vi7
				(2 + [0, 15, 17, 10]), // ii7 (11th)
				(-5 + [0, 15, 17, 22]), // v7 (11th)
				(0 + [0, 15, 19, 10]), // i7
			].do { |chord|
				chord.sort.postln.do { |int|
					play.(\keyChords, bar, [freq: noteHz.(int, 0)]);
				};
				(bar).wait;
			};
		});
		// global wait ////////////////////////////////////////////////
		(bar * 8).wait;
	};
}).play;
)




//////////////////////////////////////////////////////////////////////
(-3 + ([0, 15, 19, 22] % 12)).sort; // vi7
(2 + ([0, 15, 17, 10] % 12)).sort; // ii7 (11th)
(-5 + ([0, 15, 17, 22] % 12)).sort; // v7 (11th)
(0 + ([0, 15, 19, 10] % 12)).sort; // i7
//////////////////////////////////////////////////////////////////////











// endfile 