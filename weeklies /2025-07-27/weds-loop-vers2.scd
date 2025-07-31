

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 60, 1020) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.5, 0.4));
	snd = snd.tanh + (snd.clip2 * -6.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 5020, 0.3) * Env.perc(0.001, 0.02).ar);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = BLowShelf.ar(snd, 200, 1, 4);
	snd = BHiShelf.ar(snd, 500, 1, -2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -10.dbamp;
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
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp;
	amp = \amp.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030] * amp.linlin(0, 1, 2, 1), 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.06 * amp.linlin(0, 1, 0.7, 1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), amp * -2.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\shaker, {
	var snd, amp;
	amp = \amp.kr(0.9);
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 50, 0.2);
	snd = BPF.ar(snd, [8120, 12230] * XLine.kr(0.5, 2, 2) * (2 * amp), 0.2).sum;
	snd = HPF.ar(snd, 2000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.1, 0.1, 0.001, 0.01] * 0.4 * amp, curve: [1, 0.5, -4]).ar(Done.freeSelf);
	snd = snd * -24.dbamp * amp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = LFTri.ar(freq * (LFNoise2.ar(10 ! 5) * Line.ar(0, 0.25, 0.3)).midiratio * [1, 2, 1, 2, 1]);
	snd = Splay.ar(snd);
	snd = RLPF.ar(snd, XLine.ar(8000 * ExpRand(0.5, 2), 100, 2.0), 0.1);
	snd = snd * -24.dbamp * \amp.kr(1);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.01, curve: -16).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\padReverse, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = LFTri.ar(freq * (LFNoise2.ar(10 ! 5) * Line.ar(0, 0.25, 0.3)).midiratio * [1, 2, 1, 2, 1]);
	snd = Splay.ar(snd);
	snd = RLPF.ar(snd, XLine.ar(100, 8000 * ExpRand(0.5, 2), 2.0), 0.1);
	snd = snd * -24.dbamp * \amp.kr(1);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
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
	snd = snd + Latch.ar(snd * -10.dbamp, Impulse.ar(5000));
	snd = snd + (GVerb.ar(snd, 20, 1) * -20.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = snd * Env.linen(0, \rel.kr(0.1), 0.1, curve: -8).ar(Done.freeSelf);
	snd = snd * -12.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = BLowShelf.ar(snd, 160, 0.5, (8 * Env.perc(0.01, 0.3, curve: 4).ar(gate: trigger)).neg);
	snd = snd * (1 - (0.2 * Env.perc(0.01, 0.15, curve: 2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\masterFx, {
	var snd, trigger;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * -4.dbamp;
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

{(8 * Env.perc(0.01, 0.3, curve: 4).ar).neg}.plot(1);
{0 - (8 * Env.perc(0.01, 0.3, curve: 4).ar)}.plot(1);

{1 - (0.9 * Env.perc(0.01, 0.2, curve: 4).ar)}.plot(1);
{(4 * Env.perc(0.01, 0.15, curve: 4).ar).neg}.plot(1);

-12.dbamp;
4.dbamp;

(
~busMaster = Bus.audio(nil, 2);
~busSidechain = Bus.audio(nil, 2);
)

~busSidechain.index;
~busMaster.index;

(
var s, beat, bar, root, play, seq, noteHz, sidechainFx, duck, seqKick;

s = Server.default;
beat = 60 / 169 * 1;
bar = beat * 4;
root = 51;

play = { |synth, dur, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synth, [duration: dur] ++ args); };
	};
};
seq = { |synth, dur, args = #[], latency = 0.0|
	play.(synth, dur, args, latency);
	dur.wait;
};
noteHz = { |deg=0, octave=0|
	(root + deg + (12 * octave)).midicps;
};

sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~busSidechain, out: ~busMaster]);
Synth.tail(nil, \masterFx, [in: ~busMaster, out: 0]);

duck = { |latency = 0.0|
	latency.wait;
	s.bind { sidechainFx.set(\trigger, 1) };
};

seqKick = { |dur, args = #[], latency = 0.0|
	duck.(latency);
	seq.(\kick, dur, args ++ [out: ~busMaster], latency);
};

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
					play.(\padReverse, bar, [freq: noteHz.(int, 1), amp: 0.75, out: ~busMaster]);
					play.(\padReverse, bar, [freq: noteHz.(int, 0), out: ~busMaster]);
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
				[\, -5, \, 5, -5, \, \, -5]
			].do { |phrase|
				phrase.do { |int, index|
					if(int == \, {
						(beat/2).wait;
					}, {
						seq.(\bass, beat/2, [
							freq: noteHz.(int, -1),
							// lpfcutoff: index.linexp(0, 8, 900, 100),
							lpfcutoff: exprand(1, 5) * 100,
							out: ~busSidechain
						]);
					});
				};
			};
		};
		// hats
		fork {
			var panVals = [0.5, -0.7, 0.3, -0.6, 0.3, -0.3, 0.5, -0.7];
			4.do {
				[1, 0.3, 0.8, 0.7, 0.5, 0.9, 0.6, 0.8].do { |amp, index|
					seq.(\hat, beat/2, [amp: amp, pan: panVals[index], out: ~busMaster]);
				};
			};
		};
		// shaker
		/*fork {
			8.do {
				[1, 0.7, 0.9, 0.8].do { |amp, index|
					seq.(\shaker, beat/2, [amp: amp, out: ~busMaster]);
				};
			};
		};*/
		// bar 1-3
		3.do {
			seqKick.(beat);
			seqKick.(beat);
			play.(\metallic, beat/2, [out: ~busMaster], latency: 0.025);
			seq.(\clap, beat/2, [out: ~busMaster]);
			seqKick.(beat/4, [amp: 0.5]);
			seqKick.(beat/2);
			seqKick.(beat/4, [amp: 0.5]);
			seqKick.(beat/2);
		};
		// bar 4
		seqKick.(beat);
		seqKick.(beat);
		play.(\metallic, beat/2, [out: ~busMaster], latency: 0.025);
		seq.(\clap, beat/2, [out: ~busMaster]);
		seqKick.(beat/4, [amp: 0.25]);
		seqKick.(beat/4);
		seqKick.(beat/4, [amp: 0.5]);
		seqKick.(beat/4);
		seqKick.(beat/2);
	};
}).play;
)

s.makeWindow;



// endfile