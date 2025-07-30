

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 60, 900) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.5, 0.4));
	snd = snd * Env.perc(0.001, 0.4).ar;
	// snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [1540, 1880], [0.4, 0.6]).sum;
	snd = snd * 16.dbamp;
	snd = snd * (1 + ( 2 * Env.perc(0, 0.1).ar));
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.004, 1e-4, 0.003, 1e-4, 0.08] * 0.9, -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.7));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\metallic, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(\freq.kr(3200) * [0.7, 3.3, 5.44, 7.33, 12.33] * XLine.ar(1.5, 1, 0.001));
	snd = snd * Env.perc(0.001, [0.1, 0.05, 0.03, 0.003, 0.04, 0.01]).ar;
	snd = snd.sum;
	snd = snd * (1 + SinOsc.ar(3420));
	snd = snd * (1 + SinOsc.ar(3430));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3320, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd + PitchShift.ar(snd, 0.03, 1.5);
	snd = snd + PitchShift.ar(snd, 0.004, 2.3);
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd.tanh;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd + GVerb.ar(snd * -15.dbamp, 10, 1);
	snd = snd * Env.linen(0, duration, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp;
	amp = \amp.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030] * amp.linlin(0, 1, 2, 1), 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.06 * amp.linlin(0, 1, 0.7, 1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), amp * 2.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = LFTri.ar(freq * (LFNoise2.ar(10 ! 5) * Line.ar(0, 0.25, 0.3)).midiratio * [1, 2, 1, 2, 1]);
	snd = Splay.ar(snd);
	snd = RLPF.ar(snd, XLine.ar(6000 * ExpRand(0.5, 2), 100, 2.0), 0.1);
	snd = snd * -24.dbamp * \amp.kr(1);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.01, curve: -16).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ping, {
	var snd, freq;
	freq = \freq.kr(220) * (LFNoise2.ar(1) * 0.1).midiratio;
	snd = SinOsc.ar(freq * [1,4,8], pi / [1,2,3]).sum;
	snd = snd + CombC.ar(snd, 0.2, SinOsc.ar(1).range(0, 3e-3), 0);
	snd = snd * Env.perc(0.01, 0.3).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * 0.1 ! 2;
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\bass, {
	var snd, freq, duration;
	freq = \freq.kr(60) * XLine.ar(2, 1, 0.01);
	duration = \duration.kr(0.1);
	snd = SinOsc.ar(freq) + Pulse.ar(freq);
	snd = RLPF.ar(snd, \lpfcutoff.kr(500), 0.25);
	snd = snd + Latch.ar(snd * -10.dbamp, Impulse.ar(4000));
	snd = snd + (GVerb.ar(snd, 20, 1) * -20.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = snd * Env.linen(0, \rel.kr(0.15), 0.1, curve: -8).ar(Done.freeSelf);
	snd = snd * -12.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.9 * Env.perc(0.01, 0.36, curve: -2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~busSidechain = Bus.audio(nil, 2);
)

~busSidechain.index;

(
var s, beat, bar, root, play, seq, noteHz, sidechainFx, duck;
s = Server.default;
beat = 60 / 169 * 1;
bar = beat * 4;
root = 51;

play = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
};
seq = { |synth, dur, args|
	play.(synth, dur, args);
	dur.wait;
};
noteHz = { |deg=0, octave=0|
	(root + deg + (12 * octave)).midicps;
};

sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~busSidechain, out: 0]);
duck = {
	s.bind { sidechainFx.set(\trigger, 1) };
};

// seqKick...bundle pump and kick

Routine({
	loop {
		// chords
		fork {
			'- - - - - - - -'.postln;
			[
				(0 + [0, 3, 7, 10]),
				(3 + [0, 4, 7, 11]),
				(8 + [0, 3, 7, 10 -12]),
				(7 + [0, 3, 7, 10 -12])
			].do { |chord|
				chord.sort.postln.do { |int|
					// play.(\ping, bar, [freq: noteHz.(int, 0)]);
					play.(\pad, bar, [freq: noteHz.(int, 1), amp: 0.3]);
					play.(\pad, bar, [freq: noteHz.(int, 0), out: 0]);
				};
				(bar).wait;
			};
		};
		// bass
		fork {
			[
				[\, 0, \, \, -5, \, \, 0],
				[\, 3, 3, \, \, 3, 3, 3],
				[\, -1, \, -1, \, -1, \, -1],
				[\, -5, \, 5, -5, \, \, -5],
			].do { |phrase|
				phrase.do { |int, index|
					if(int == \, {
						(beat/2).wait;
					}, {
						seq.(\bass, beat/2, [
							freq: noteHz.(int, -1),
							// lpfcutoff: index.linexp(0, 8, 600, 100),
							lpfcutoff: exprand(2, 4) * 100,
							out: 0
						]);
					});
				};
			};
		};
		// hats
		fork {
			4.do {
				[1, 0.3, 0.8, 0.7, 0.5, 0.9, 0.6, 0.8].do { |amp, index|
					seq.(\hat, beat/2, [amp: amp]);
				};
			};
		};
		// bar 1-3
		3.do {
			duck.();
			seq.(\kick, beat);
			duck.();
			seq.(\kick, beat);
			play.(\metallic, beat/2);
			seq.(\clap, beat/2);
			duck.();
			seq.(\kick, beat/4, [amp: 0.5]);
			duck.();
			seq.(\kick, beat/2);
			duck.();
			seq.(\kick, beat/4, [amp: 0.5]);
			duck.();
			seq.(\kick, beat/2);
		};
		// bar 4
		duck.();
		seq.(\kick, beat);
		duck.();
		seq.(\kick, beat);
		play.(\metallic, beat/2);
		seq.(\clap, beat/2);
		duck.();
		seq.(\kick, beat/4, [amp: 0.25]);
		duck.();
		seq.(\kick, beat/4);
		duck.();
		seq.(\kick, beat/4, [amp: 0.5]);
		duck.();
		seq.(\kick, beat/4);
		duck.();
		seq.(\kick, beat/2);
	};
}).play;
)












// endfile