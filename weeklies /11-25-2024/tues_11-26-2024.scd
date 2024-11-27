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
SynthDef(\seqMarker, {
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
SynthDef(\seqMarkerBass, {
	var snd, freq;
	freq = 60 * Demand.ar(Impulse.ar(10 * XLine.kr(1, 2, 1)), 0, Dseq((1..4), 20));
	snd = Saw.ar(freq);
	snd = snd + GVerb.ar(snd, 20);
	snd = snd * Env.perc(0.01, 2.0).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\stutterMarker, {
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


(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		60
		* ([-1, 1] * 0.2).midiratio
		* (1 + (2 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.5 * Env.perc(0.001, 0.4, curve: -4).ar))
	);
	snd = snd * (1 + (5 * Env.perc(0, 0.04).ar));
	snd = snd + (Env.perc(0.01, 0.02).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 3120, 0.5) * 2.dbamp);
	snd = snd + (Env.perc(0.001, 0.01).ar * BPF.ar(Hasher.ar(Sweep.ar + [2, 3]), 8120, 0.5) * 10.dbamp);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		230
		* [1, 2.3, 3.8, 4.8]
		* (1 + (0.4 * Env.perc(0.0, 0.05, curve: -4).ar))
		* (1 + (0.01 * Env.perc(0.0, 0.1, curve: -4).ar))
	);
	snd = snd * Env.perc(0, [0.3, 0.1, 0.06, 0.025]).ar;
	snd = snd * [0, -20, -25, -20].dbamp;
	snd = snd.sum;
	snd = snd + (Env.perc(0.02, 0.05).ar * BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 2120, 0.5) * 15.dbamp);
	snd = snd * (1 + (5 * Env.perc(0, 0.01).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.001).ar));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3, curve: -2.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\vocal, {
	var snd, duration;
	duration = 0.1;
	snd = Pulse.ar(50);
	snd = RLPF.ar(snd, XLine.kr([1520, 1820], [620, 3200], duration), 0.05);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd * (1 + (10 * Env.perc(0.001, 0.01).ar));
	snd = snd * Env.linen(0.0, duration, 0.001).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\vocal2, {
	var snd, duration;
	duration = 0.08;
	snd = Pulse.ar(50);
	snd = RLPF.ar(snd, XLine.kr([820, 3200], [1520, 1820], duration), 0.05);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd * (1 + (10 * Env.perc(0.001, 0.01).ar));
	snd = snd * Env.linen(0.0, duration, 0.001).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)



( // LFO
{
	var rate = 1;
	(LFNoise2.ar(rate) + (LFNoise2.ar(rate * 3) / 3) + TRand.ar(-1, 1, Dust.ar(rate))).wrap2
}.plot(2);
)



// endfile...


