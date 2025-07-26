(
SynthDef(\sineKey, {
	var snd, velocity, duration;
	duration = \duration.kr(3);
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440) * XLine.ar(1.1, 1.0, 0.02));
	snd = snd * Env.perc(0.001, 6.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 0.15).ar));
	snd = snd * (1 + (0.15 * SinOsc.ar(3, [0, pi] + Rand(0, pi))));
	snd = snd.tanh;
	snd = snd * -13.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var snd, freq, duration;
	duration = \duration.kr(3.0);
	freq = \freq.kr(87);
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 500);
	snd = snd * Env.perc(0.01, \rel.kr(4)).ar;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.5);
	Out.ar(\out.kr(0), snd );
}).add;
SynthDef(\sub, {
	var snd, duration, hi;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(100));
	snd = snd * \freq.kr(100).explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 7000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -8.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
// drums
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(42 * (1 + (4 * Env.perc(0, 0.09).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	// snd = LPF.ar(snd, 1200);
	wet = snd;
	wet = (wet * 4.dbamp).clip2 + (wet.fold2 * -4.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -24.dbamp, 0.1, 0.02)) ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
SynthDef(\hiss, {
	var snd;
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 60, 0.1);
	snd = BPF.ar(snd, [15120, 16230] * XLine.kr(0.5, 1, 1) * Rand(0.95, 1.15), 0.2).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.05, 0.06, 0.001, 0.005] * 0.55, curve: [2, 0.1, -2]).ar(Done.freeSelf);
	snd = snd * -22.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1500, 0.3) * -3.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15] * 0.5, curve: -2).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -15.dbamp, 20, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(1020 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015] * 0.4).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -8.dbamp;
	snd = snd * Env.perc(0.0, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 600 * [3.1, 6.4, 4.5, 6.7, 7.8, 9.3, 10.3], 0.06) * 15.dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = (snd * 4).clip2;
	snd = RHPF.ar(snd, 9320, 0.3) * 4.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.1).ar(Done.freeSelf);
	snd = snd * -6.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
// FX
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (1 * Env.perc(0, 0.5, curve: 2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\reverbFx, {
	var snd, wet;
	snd = In.ar(\in.kr(0), 2);
	wet = snd;
	// 1) Early Reflection Smear
	wet = AllpassC.ar(wet, 0.2, [0.0344, 0.05], 0.1);
	// 2) Feedback Loop Preparation
	wet = [wet[0], wet[1], wet[0], wet[1]] + LocalIn.ar(4);
	// 3) Multi-tap Delay: Diffusion
	wet = DelayC.ar(wet, 1.0, [0.2, 0.343, 0.4335, 0.5242] * 0.2);
	// 4) Modulated Allpass: Dense, Evolving Texture
	wet = AllpassC.ar(wet, 0.2, ([0.12, 0.445, 0.31, 0.38] * 0.03) + (LFNoise2.ar(3 ! 4) * 0.0001), [0.3, 0.5, 0.6, 0.7]);
	// 5) Second Allpass Layer
	wet = AllpassC.ar(wet, 0.2, [0.42, 0.245, 0.11, 0.78] * 0.01, [0.3, 0.5, 0.6, 0.7]);
	// 6) Tone Shaping (EQ)
	wet = wet * -2.dbamp;
	wet = LPF.ar(wet, 3000);
	wet = HPF.ar(wet, 100);
	// 7) Hadamard Matrix: Feedback Mixing
	wet = wet * ([
		[1, 1, 1, 1],
		[1, -1, 1, -1],
		[1, 1, -1, -1],
		[1, -1, -1, 1],
	] / 2);
	wet = wet.sum;
	LocalOut.ar(wet);
	// 8) Stereo Reassembly + Final Delay
	wet = [wet[0] + wet[3], wet[1] + wet[2]];
	wet = DelayC.ar(wet, 0.05, 0.05);
	wet = wet * -5.dbamp * \wet.kr(1).lag(0.1);
	snd = snd + wet;

	Out.ar(\out.kr(0), snd);
}).add;
)

(
~busSidechain = Bus.audio(nil, 2);
~reverbBus = Bus.audio(nil, 2);
)

~busSidechain.index;
~reverbBus.index;

(
var s, beat, root, play, duck, sidechainFx;
s = Server.default;
beat = 60 / 118;
root = 53;

play = { |synth, duration, args|
	s.bind {
		Synth(synth, [duration: duration] ++ args);
	};
};


sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~busSidechain, out: ~reverbBus]);
Synth.tail(nil, \reverbFx, [in: ~reverbBus, wet: 0.25]);

duck = {
	s.bind { sidechainFx.set(\trigger, 1) };
};

Routine({
	'- - - - - - - - - -'.postln;
	loop {
		fork {
			4.do {
				(beat * 2).wait;
				play.(\clap, beat * 2);
				play.(\rim, beat * 2);
				(beat * 2).wait;
			};
		};
		fork {
			8.do {
				(beat/2).wait;
				play.(\hat, beat/2, [out: 0, amp: 0.25]);
				(beat/2).wait;
				play.(\hat, beat/2, [out: 0, amp: 1]);
				(beat/2).wait;
				play.(\hat, beat/2, [out: 0, amp: 0.45]);
				(beat/2).wait;
			};
		};
		fork {
			4.do {
				duck.();
				play.(\kick, beat * 1, [out: 0]);
				(beat * 1.5).wait;
				duck.();
				play.(\kick, beat/3, [out: 0]);
				(beat * 0.5).wait;
				(beat * 1.5).wait;
				duck.();
				play.(\kick, beat * 0.5, [out: 0]);
				(beat * 0.5).wait;
			};
		};
		fork {
			16.do {
				[1, 0.5, 0.7, 0.6].do { |amp|
					play.(\hiss, beat, [\amp: amp]);
					(beat/4).wait;
				};
			};
		};
		[
			(notes: (2 + [0 + 12, 3 + 12, 10, 7]).sort.postln, length: beat * 3),
			(notes: (2 + [0 + 12, 3 + 12, 10, 7]).sort.postln, length: beat * 1),
			(notes: (9 + [0, 3, 10 - 12, 7]).sort.postln, length: beat * 3),
			(notes: (9 + [0, 3, 10 - 12, 7]).sort.postln, length: beat * 1),
			(notes: (7 + [0, 7, 11 -12, 4]).sort.postln, length: beat * 3),
			(notes: (7 + [0, 7, 11 -12, 4]).sort.postln, length: beat * 1),
			(notes: (0 + [0, 3, 10, 7]).sort.postln, length: beat * 3),
			(notes: (0 + [0, 3, 10, 7]).sort.postln, length: beat * 1),
		].do { |chord|
			chord[\notes].do { |deg, index|
				//
				play.(\sineKey, chord[\length], [freq: (root + deg + (12 * 1)).midicps, amp: 0.25 * (1 / (index + 1).sqrt), out: ~busSidechain]);
				play.(\sineKey, chord[\length], [freq: (root + deg + (12 * 0)).midicps, amp:  1, out: ~busSidechain]);
			};
			play.(\bass, chord[\length], [freq: (root + chord[\notes][0] + (12 * -1)).midicps, out: ~busSidechain, amp: 0.5]);
			play.(\sub, chord[\length], [freq: (root + chord[\notes][0] + (12 * -2)).midicps, out: ~busSidechain]);
			(chord[\length]).wait;
		};
	};
}).play;

)

(53 + 0 + (12 * -1)).midicps;





// endfile