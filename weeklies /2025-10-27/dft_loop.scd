(
SynthDef(\kick, {
    var snd;
	snd = SinOsc.ar(
		54
		* (1 + (4 * Env.perc(0.001, 0.03).ar))
		* (1 + (0.5 * Env.perc(0.001, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 6328, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = BHiShelf.ar(snd, 1200, 0.3, -4);
    snd = (snd * 4.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = BHiShelf.ar(snd, 1200, 0.3, 4);
	// snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(0.001, 0.5, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp * \amp.kr(1) ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(220 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.4, 4.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.19).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.001, 0.11).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare2, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(260 * XLine.ar(1.4, 1, 0.005) * [1, 2.3, 4.5]);
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 930, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.2 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(700 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2130 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -6.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.0, 0.2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 4530);
	snd = snd * 18.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08] * 1, -4).ar;
	snd = snd * Env.perc(0, 0.4, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp * \amp.kr(0.2) ! 2;
	Out.ar(\out.kr(0), snd);
}).play;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.2, 1 / 60, 2);
	snd = FreqShift.ar(snd, -14);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.08), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.01, 0.06, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -16.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd, freqs;
	snd = Hasher.ar(Sweep.ar);
	freqs = ((0..20) * 134789).sin.linexp(-1, 1, 100, 3e3);
	snd = CombC.ar(snd, 1 / freqs, 1 / freqs, 0.1);
	snd = snd.sum * -15.dbamp;
	snd = FreqShift.ar(snd, -230);
	snd = HPF.ar(snd, 1000);
	snd = BPF.ar(snd, [8230, 5240, 1230, 6.5e3, 7243], 0.05);
	snd = snd * Env.perc(0.01, 2.0 * [1, 0.5, 0.9, 0.1, 0.2, 0.3]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.02, 2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat3, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.2, 1 / 90, 1);
	snd = BPF.ar(snd, [ 6230, 8320, 9820, 10830, 12250 ], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -15.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -18.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\tom, {
	var snd;
	snd = LPF.ar(BPF.ar(Hasher.ar(Sweep.ar), 110, 0.4), XLine.kr(1000, 200, 0.01)) * 25.dbamp;
	snd = snd ! 2;
	snd = snd * \amp.kr(1);
	snd = snd * Env.perc(0.001, 0.04).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(87) * (1 + (2 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2, 3]);
	snd = snd * [1, -14.dbamp, -30.dbamp];
	snd[1] = snd[1] * Env.perc(0, 0.5).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 3.0).ar;
	snd = snd ! 2;
	snd = snd * -8.dbamp;
	snd = snd * (1 + (2 * Env.perc(0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub2, {
	var snd, duration, hi, freq;
	freq = \freq.kr(65);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	snd = (snd * 4.dbamp).tanh;
	hi = HPF.ar((snd * 4).tanh * -10.dbamp, 2400);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -20.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.01, duration * 12, curve: -4).ar;
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\reverbFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + GVerb.ar(snd * -10.dbamp, 30, 15, 0.6);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

///////////////////////////////////////////////////////////////
// Busses
///////////////////////////////////////////////////////////////


(
~reverbBus = Bus.audio(nil, 2);
)

~reverbBus.index;


///////////////////////////////////////////////////////////////
// Pattern
///////////////////////////////////////////////////////////////


(53 -12).midicps;

(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 218;
bar = beat * 4;
tatum = beat / 4;
root = 53; // 42=F#, 48=C, 50=D, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork { latency.wait; s.bind { Synth(synth, [duration: dur] ++ args); }; };
};
seq = { |synth, dur, args=#[], latency=0.0|
	play.(synth, dur, args, latency); (dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	var loopIndex = 0;
	'Start Routine'.postln;
	Synth(\reverbFx, [in: ~reverbBus]);
	loop {
		loopIndex.postln;
		subroutine.(1, {
			[
				// bar 1
				\, \, 0.1, \, 1, \, 0.6, \,    0.6, \, 0.1, \, 1, \, \, \,
				// bar 2
				0.3, \, 0.1, \, 1, \, 0.6, \,    0.6, \, 0.2, \, 1, \, 0.4, \,
			].do { |spec|
				if(spec != \, {
					play.(\hat, beat, [amp: spec], latency: 0.0);
				});
				tatum.wait;
			};
		});
		subroutine.(1, {
			[
				[10, 0, -1],
				[22, 0, -1],
				// [12, 0, -2],
			].do { |spec, index|
				var dur, late, oct;
				# dur, late, oct = spec;
				play.(\sub, (dur * tatum), [freq: noteHz.(0, oct)], latency: late);
				// play.(\tom, (dur * tatum), latency: late);
				seq.(\kick, (dur * tatum), latency: late);
			};
		});
		subroutine.(1, {
			[
				// bar 1
				\, \, \, \, \, \, 1, \,    \, \, \, \, \, \, \, \,
				// bar 2
				\, \, \, \, \, \, \, \,    1, \, \, \, \, \, \, \,
			].do { |spec|
				if(spec != \, {
					play.(\clap, beat, [out: ~reverbBus], latency: 0.0);
				});
				tatum.wait;
			};
		});
		subroutine.(1, {
			[
				// bar 1
				\, \, \, \, \, \, 1, \,    \, \, \, \, 1, \, \, \,
				// bar 2
				\, \, \, \, \, \, \, \,    1, \, \, \, \, \, \, \,
			].do { |spec|
				if(spec != \, {
					play.(\snare2, beat, latency: 0.0);
					// play.(\rim, beat, [amp: 0.3], latency: 0.0);
				});
				tatum.wait;
			};
		});
		// global wait //
		loopIndex = loopIndex +1;
		(bar * 2).wait;
	};
}).play;
)
