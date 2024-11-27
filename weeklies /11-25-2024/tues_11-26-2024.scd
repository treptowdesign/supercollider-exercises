// Tues 11-26-2024


(
SynthDef(\markerHarmonics, {
	var snd;
	snd = (260 * [1, 2, 3, 4]).collect { |freq|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(1 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midsides
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(260 * [1, 2, 3, 4]);
260 * (1.5 ** [0, 1, 2, 3]);

(
SynthDef(\markerFifths, {
	var snd;
	snd = (260 * (1.5 ** [0, 1, 2, 3])).collect { |freq|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(1 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midsides
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(3/2 ** [0, 1, 2, 3]);
(1.5 ** [0, 1, 2, 3]);

(4/3 ** [0, 1, 2, 3]);
(1.3333333333333 ** [0, 1, 2, 3]);

(
SynthDef(\markerFourths, {
	var snd;
	snd = (260 * (4/3 ** [0, 1, 2, 3])).collect { |freq|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(1 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midsides
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)


(
SynthDef(\markerSixths, {
	var snd;
	snd = (260 * (5/3 ** [0, 1, 2, 3])).collect { |freq|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(1 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midsides
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)


// Just Intonation Degrees
// 00: Octave    1:1
// 01: b 2nd     16:15
// 02: 2nd       9:8
// 03: b 3rd     6:5
// 04: 3rd       5:4
// 05: 4th       4:3
// 06: Tritone   45:32
// 07: 5th       3:2
// 08: b 6th     8:5
// 09: 6th       5:3
// 10: b 7th     9:5
// 11: 7th       15:8
// 12: octave    2:1





(
SynthDef(\marker3, {
	var snd, freq;
	freq = 440 * Demand.ar(Impulse.ar(10 * XLine.kr(1, 2, 1)), 0, Dseq(1.5 ** (0..3), 20));
	snd = Pulse.ar(freq);
	snd = snd + GVerb.ar(snd, 20);
	snd = snd * Env.perc(0.01, 2.0).ar(Done.freeSelf);
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
	3.do { snd = snd + DelayC.ar(snd, 0.1, LFNoise2.kr(0.5 ! 2).linlin(-1, 1, 1e-3, 8e-3)); };
	snd = snd * Env.perc(0.01, 3.0).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -20.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)






// endfile...


