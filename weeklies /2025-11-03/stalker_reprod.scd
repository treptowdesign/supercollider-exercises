///////////////////////////////////////////////////////////////
// Synths
///////////////////////////////////////////////////////////////


{ (SinOsc.ar(40.midicps) * 2).fold2 * 0.4 * Env.perc(0, 8).ar(Done.freeSelf) ! 2 }.play;

(
SynthDef(\sub, {
	var snd, duration, rel, hi;
	duration = \duration.kr(1.0);
	rel = \rel.kr(1);
	snd = SinOsc.ar(\freq.kr(40.midicps) * (1 + (2 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -10.dbamp];
	snd = snd.sum;
	snd = snd * -14.dbamp ! 2;
	snd = snd * (1 + (4 * Env.perc(0, 0.02).ar));
	snd = (snd * 2.dbamp).tanh + ((snd * 4).fold2 * -10.dbamp);
	snd = LPF.ar(snd, XLine.kr(600, 60, duration));
	hi = HPF.ar((snd * 2).tanh * -5.dbamp, 3400);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 1200, 0.5) * 10.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 10.dbamp;
	snd = snd + hi;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, rel, curve: 2).ar;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		250 * (1 + (4 * Env.perc(0.001, 0.01).ar))
		* (1 + (1 * Env.perc(0.0, 0.02).ar))
		* [1, 1.4, 3.6, 4.2]
	);
	snd = snd * [0, -7, -12, -14].dbamp;
	snd = snd * Env.perc(0, [1.0, 0.1, 0.01, 0.05]).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2110, 0.3) * Env.perc(0.02, 0.3).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4680, 0.2) * Env.perc(0.03, 0.2).ar * 2.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	// snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1, 0.9);
	snd = snd.blend(CombC.ar(snd, 0.2, 1 / 90, 0.1), \comb.kr(0));
	snd = snd + PitchShift.ar(snd, 0.02, 1.2);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.01, 1.8);
	snd = (snd * 5.dbamp).tanh;
	snd = HPF.ar(snd, 200);
	snd = FreqShift.ar(snd, -50);
	snd = snd * Env.perc(0.0, 0.45, curve: -4).ar;
	snd = snd * Env.linen(0.001, 0.5, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
SynthDef(\kick, {
    var snd;
	snd = SinOsc.ar(
		54
		* (1 + (5 * Env.perc(0.001, 0.01).ar))
		* (1 + (0.6 * Env.perc(0.001, 0.2).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 6928, 0.2) * Env.perc(0.01, 0.04).ar * 2.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = BHiShelf.ar(snd, 1200, 0.3, -4);
    snd = (snd * 4.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = BHiShelf.ar(snd, 1200, 0.3, 4);
	snd = snd * Env.perc(0.001, 0.3, curve: -8).ar(Done.freeSelf);
	snd = snd * -10.dbamp * \amp.kr(1) ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1700, 0.3) * -8.dbamp;
	snd = LPF.ar(snd, 9000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15] * 1, curve: -2).ar;
	snd = snd.clip2 * -5.dbamp;
	snd = snd * (1 + (2 * Env.perc(0, 0.03).ar));
	snd = snd + GVerb.ar(snd * -25.dbamp, 30, 10, 0.8);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)



{ (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 1200, 0.5) * 10.dbamp)) }.plot(0.5);


///////////////////////////////////////////////////////////////
// Pattern
///////////////////////////////////////////////////////////////



(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 116;
bar = beat * 4;
tatum = beat / 4;
root = 52; // 42=F#, 48=C, 50=D, 51=D#, 52=E
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
		subroutine.(0, {
			(3 * tatum).wait;
			[9, 4].do { |dur| seq.(\clap, (dur * tatum)); };
		});
		subroutine.(1, {
			(3 * tatum).wait;
			[3, 6, 4].do { |dur| seq.(\snare, (dur * tatum)); };
		});
		subroutine.(1, {
			[
				[5, -1, 0.65],
				[11, -1, 0.9]
				/*[5, -1, 0.7],
				[5, -1, 0.7],
				[6, -2, 0.8],*/
			].do { |spec, index|
				var dur, oct, rel;
				# dur, oct, rel = spec;
				play.(\kick, (dur * tatum));
				seq.(\sub, (dur * tatum), [freq: noteHz.(0, oct), rel: rel]);
			};
		});
		// global wait
		(bar * 1).wait;
	};
}).play;
)