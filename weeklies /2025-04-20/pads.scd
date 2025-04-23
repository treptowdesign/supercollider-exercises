(
SynthDef(\pad1, {
	var snd;
	snd = (800 * (1.5 ** [0, 1, 2, 3]) * \ratio.kr(1)).collect { |freq|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\pad2, {
	var snd;
	snd = (260 * (1.5 ** [0, 1, 2, 3]) * \ratio.kr(1)).collect { |freq|
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

(
SynthDef(\pad3, {
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
SynthDef(\pad4, {
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


// Harmonic

(
SynthDef(\pad2, {
	var snd;
	snd = (\freq.kr(440) * [0, 1, 2, 3]).collect { |freq, index|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio, Rand(0, 2pi)) * LFNoise2.kr(1 ! 2);
		snd = snd * (1 / (index + 1));
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd.mean * -20.dbamp, 10, 10, damping: 0.8);
	snd = snd * Env.perc(0.3, 6, curve: -4).ar;
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = LPF.ar(HPF.ar(snd, 600), 9000);
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -8).ar(Done.freeSelf);
	snd = snd * -6.dbamp * \amp.kr(1);
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\padA, {
	var snd;
	snd = (\freq.kr(440) * [0, 1, 2, 3] * \ratio.kr(1)).collect { |freq, index|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(8 ! 2);
		snd = snd * (1 / (index + 1));
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = snd * Env.perc(0.1, 3.0).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -8).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).add;
)

(
[-12, 4, 7, 11].do { |degree|
	Synth(\padA, [freq: (60 + degree).midicps]);
};
)





