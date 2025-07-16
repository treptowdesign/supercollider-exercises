


(
SynthDef(\sourceFlanger, {
	var snd, wet, env, lfo;
	env = Env.perc(0.001, 4).ar(Done.freeSelf);
	lfo = { |rate=1, min=0, max=1|
		SinOsc.kr(rate, 0).linlin(-1, 1, min, max);
	};
	snd = Saw.ar(\freq.kr(220) * [0, 0.1].midiratio, 0.8).sum * env;
	wet = CombC.ar(snd, 0.03, lfo.(1, 5e-4, 3e-3), 0);
	snd = XFade2.ar(snd, wet, 0);

	snd = Pan2.ar(snd, \pos.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), Limiter.ar(LeakDC.ar(snd)));
}).play;
)



(
SynthDef(\sourceAdd, {
	var freq, snd, wet, env, lfo;
	freq = \freq.kr(440);
	env = Env.perc(0.001, \rel.kr(8)).ar * Env.linen(0, \duration.kr(8), 0.1).ar(Done.freeSelf);
	lfo = { |rate=1, min=0, max=1|
		SinOsc.kr(rate, 0).linlin(-1, 1, min, max).lag(0.02);
	};
	snd = SinOsc.ar(freq * [1, 2, 2.2, 3, 4, 4.98, 6.1, 7], [0, 0.2pi, 0, 0.5pi, 0, 0.2pi, 0, 0.5pi]);
	snd = (snd * [1, 0.75, 0.06, 0.2, 0.2, 0.04, 0.035, 0.02] * ({LFNoise2.ar(1).range(0.6, 1)} ! 8)).sum;
	snd = snd * env;
	// Distortion
	wet = ((snd + 0.1) * 2.dbamp).tanh;
	wet = LeakDC.ar(snd);
	snd = XFade2.ar(snd, wet, 0);
	// Phaser
	wet = snd;
	8.do { wet = AllpassL.ar(wet, 0.03, lfo.(Rand(0.2, 0.8), 0, 1e-3), 0) };
	snd = XFade2.ar(snd, wet, 0);
	// Filtering
	4.do {
		snd = BRF.ar(snd, LFNoise2.ar(4).linexp(-1, 1, 100, 4000), 0.7);
	};

	snd = ( snd + PitchShift.ar(snd, 0.2, 0.5, mul: 1) ) * 4.dbamp;

	snd = Pan2.ar(snd, \pos.kr(0), \amp.kr(0.1));

	// snd = Balance2.ar(snd[0], snd[1], 0);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 3e-4);

	Out.ar(\out.kr(0), Limiter.ar(LeakDC.ar(snd)));
}).add;
)

(
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
	wet = wet.reverse;
	LocalOut.ar(wet);
	// 8) Stereo Reassembly + Final Delay
	wet = [wet[0] + wet[3], wet[1] + wet[2]];
	wet = DelayC.ar(wet, 0.05, 0.05);
	wet = wet * -5.dbamp * \wet.kr(1).lag(0.1);
	snd = snd + wet;

	Out.ar(\out.kr(0), snd);
}).add;
)



440 * 12;

(
var root = 60, octave = 0;
Synth(\reverbFx, [in: ~reverbBus, wet: 1]);
[0, 3, -5, 10].do { |deg|
	Synth(\sourceAdd, [freq: (root + deg + (12 * octave)).midicps, out: ~reverbBus]);
};
)


(
SynthDef(\marker1, {
	var snd;
	snd = (\freq.kr(440) * (1.5 ** [0, 1, 2, 3, 4])).collect { |freq|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.2).midiratio) * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -20.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(1.5 ** [0, 1, 2, 3, 4]);

(1..5)


1 / (1 + (0..4).sqrt);


(1 / (1 + (0..4)).sqrt)
(1 / (1 + (0..4)))


(
SynthDef(\marker1, {
	var snd;
	snd = (\freq.kr(220) * (1.5 ** (0..6))).collect { |freq, index|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio, mul: (1 / (1 + index).sqrt));
		snd = snd * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / 2.sqrt; // <= midSides
		snd.size.postln;
		snd;
	};
	snd.size.postln;
	snd = snd.sum;
	snd.size.postln;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * Env.perc(0.1, 6.0).ar(Done.freeSelf);
	snd = snd * -20.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\marker1hi, {
	var snd;
	snd = (\freq.kr(220) * (1.5 ** (0..6))).collect { |freq, index|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio, mul: (1 / (1 + index).sqrt));
		snd = snd * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / 2.sqrt;
		snd;
	};
	snd = snd.sum;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 4e-4);
	snd = snd * Env.perc(0.1, 6.0).ar(Done.freeSelf);
	snd = snd * -20.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)



{SinOsc.ar(440) * LFNoise2.kr(8 ! 2) }.plot(2);

{SinOsc.ar(440) * LFNoise2.kr(8) }.plot(2);

(
{
	var mod;
	mod = LFNoise2.kr(8);
	[SinOsc.ar(440) * mod, mod];
}.plot(2);
)


(
{
	var mod;
	mod = SinOsc.kr(8);
	[SinOsc.ar(440) * mod, mod];
}.plot(2);
)


~reverbBus.index;


(
var outbus;
outbus = 0;
Synth(\reverbFx, [in: ~reverbBus, wet: 1]);

Synth(\marker1hi, [freq: (60 + 12 + 0).midicps, amp: 0.02, out: outbus]);
Synth(\marker1hi, [freq: (60 + 12 + 4).midicps, amp: 0.02, out: outbus]);
Synth(\marker1hi, [freq: (60 + 12 + 7).midicps, amp: 0.02, out: outbus]);
Synth(\marker1hi, [freq: (60 + 12 + 11).midicps, amp: 0.02, out: outbus]);

Synth(\marker1hi, [freq: (60 + 0 + 0).midicps, amp: 0.2, out: outbus]);
Synth(\marker1hi, [freq: (60 + 0 + 4).midicps, amp: 0.2, out: outbus]);
Synth(\marker1hi, [freq: (60 + 0 + 7).midicps, amp: 0.2, out: outbus]);
Synth(\marker1hi, [freq: (60 + 0 + 11).midicps, amp: 0.2, out: outbus]);

Synth(\marker1, [freq: (60 + -12 + 0).midicps, amp: 0.9, out: outbus]);
Synth(\marker1, [freq: (60 + -12 + 2).midicps, amp: 0.9, out: outbus]);
Synth(\marker1, [freq: (60 + -12 + 7).midicps, amp: 0.9, out: outbus]);
Synth(\marker1, [freq: (60 + -12 + 11).midicps, amp: 0.9, out: outbus]);

Synth(\marker1, [freq: (60 + -24 + 0).midicps, amp: 1.8, out: outbus]);
Synth(\marker1, [freq: (60 + -24 + 7).midicps, amp: 1, out: outbus]);

)


(
var outbus;
outbus = 0;
Synth(\reverbFx, [in: ~reverbBus, wet: 1]);

/*Synth(\marker1hi, [freq: (60 + 12 + 0).midicps, amp: 0.1, out: outbus]);
Synth(\marker1hi, [freq: (60 + 12 + 4).midicps, amp: 0.1, out: outbus]);
Synth(\marker1hi, [freq: (60 + 12 + 7).midicps, amp: 0.1, out: outbus]);
Synth(\marker1hi, [freq: (60 + 12 + 11).midicps, amp: 0.1, out: outbus]);

Synth(\marker1hi, [freq: (60 + 0 + 0).midicps, amp: 0.2, out: outbus]);
Synth(\marker1hi, [freq: (60 + 0 + 4).midicps, amp: 0.2, out: outbus]);
Synth(\marker1hi, [freq: (60 + 0 + 7).midicps, amp: 0.2, out: outbus]);
Synth(\marker1hi, [freq: (60 + 0 + 11).midicps, amp: 0.2, out: outbus]);*/

Synth(\marker1, [freq: (60 + -12 + 0).midicps, amp: 0.9, out: outbus]);
Synth(\marker1, [freq: (60 + -12 + 2).midicps, amp: 0.9, out: outbus]);
Synth(\marker1, [freq: (60 + -12 + 7).midicps, amp: 0.9, out: outbus]);
Synth(\marker1, [freq: (60 + -12 + 11).midicps, amp: 0.9, out: outbus]);

/*Synth(\marker1, [freq: (60 + -24 + 0).midicps, amp: 1.8, out: outbus]);
Synth(\marker1, [freq: (60 + -24 + 7).midicps, amp: 1, out: outbus]);*/

)


(
SynthDef(\marker2, {
	var snd;
	snd = (440 * (1.5 ** [0, 1, 2, 3]) * \ratio.kr(1)).collect { |freq|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(1 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -6.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)


1.5 ** (0..3);
2 ** (0..3);

(
SynthDef(\marker3, {
	var snd, freq;
	freq = 440 * \ratio.kr(1) * Demand.ar(Impulse.ar(20 * XLine.kr(1, 2, 1)), 0, Dseq(1.5 ** (0..3), 5));
	snd = Pulse.ar(freq);
	snd = snd + GVerb.ar(snd, 30);
	snd = snd * Env.perc(0.01, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -20.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\marker4, {
	var snd, freq;
	freq = 260 * (1.5 ** (0..3));
	snd = Saw.ar(freq);
	snd = snd.collect { |snd| LPF.ar(snd, TExpRand.ar(100, 8000, Dust.ar(10)).lag(0.01)); };
	snd = snd.sum;
	3.do {
		snd = snd + DelayC.ar(snd, 0.1, LFNoise2.kr(1 ! 2).linlin(-1, 1, 1e-3, 10e-3));
	};
	snd = snd * Env.perc(0.01, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -20.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)












(
SynthDef(\bitcrush, {
	var snd;
}).play;
)












// endfile