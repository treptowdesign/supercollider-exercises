// Tues 11-26-2024


(
SynthDef(\markerFifths, {
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

(3/2 ** [0, 1, 2, 3]);
(1.5 ** [0, 1, 2, 3]);

(4/3 ** [0, 1, 2, 3]);
(1.3333333333333 ** [0, 1, 2, 3]);

(
SynthDef(\markerFourths, {
	var snd;
	snd = (260 * (4/3 ** [0, 1, 2, 3]) * \ratio.kr(1)).collect { |freq|
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