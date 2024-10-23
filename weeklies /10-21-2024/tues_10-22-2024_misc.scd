s.boot;

(
{ SinOsc.ar(440, 0, 0.4) * Env.perc(0.01, 0.3).ar(Done.freeSelf) ! 2 }.play;
)

(
SynthDef(\saw, {
	var snd;
	snd = VarSaw.ar(55 * (LFNoise2.ar(3 ! 4) * 0.4).midiratio, SinOsc.ar(8, [0, pi, 0.1pi]).range(0, 0.2pi), 0);
	snd = snd.sum;
	snd = snd + ((snd * 4.dbamp).tanh * 0.6);
	snd = RLPF.ar(snd, Env.perc(0.001, 2).ar.linlin(0, 1, 100, 8000), 0.8);
	snd = BLowShelf.ar(snd, 300, 0.4, 4);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(0, snd * 0.1 ! 2);
}).play;
)

(
SynthDef(\saw, {
	var freq, snd;
	freq = \freq.kr(55);
	snd = VarSaw.ar(freq * (LFNoise2.ar(1 ! 3) * 0.4).midiratio, SinOsc.ar(1, { Rand(0, 2pi) } ! 3).range(0, 0.3pi), 0);
	snd = snd.sum;
	snd = snd + ((snd * 4.dbamp).tanh * 0.6);
	// snd = RLPF.ar(snd, Env.perc(0.001, 2).ar.linlin(0, 1, 60, 5000), 0.2);
	snd = MoogFF.ar(snd, Env.perc(0.001, 2).ar.linlin(0, 1, 100, 3000), 3) * 10.dbamp;
	snd = BLowShelf.ar(snd, 300, 0.4, 4);
	snd = snd + CombN.ar(snd, 0.1, 0.1, 0.3);
	snd = FreeVerb.ar(snd ! 2, 0.1, 0.8, 0.4);
	snd = snd * Env.perc(0.01, 2).ar(Done.freeSelf);
	Out.ar(0, snd * 0.1);
}).play;
)

0.2pi;


(
SynthDef(\pulse, {
	var freq, snd;
	freq = \freq.kr(110);
	snd = Pulse.ar(freq * (LFNoise2.ar(8 ! 4) * 0.2).midiratio);
	snd = snd.sum * -8.dbamp;
	snd = snd + ((snd * 4.dbamp).tanh * 0.6);
	snd = RLPF.ar(snd, Env.perc(0.001, 1, curve: -8).ar.linlin(0, 1, 400, 6000), 0.2);
	// snd = MoogFF.ar(snd, Env.perc(0.001, 2).ar.linlin(0, 1, 600, 4000), 2) * 10.dbamp;
	snd = BLowShelf.ar(snd, 300, 0.4, 4);
	snd = snd * Env.perc(0.01, 1, curve: -8).ar(Done.freeSelf);
	Out.ar(0, snd * 0.1 ! 2);
}).play;
)

//

(1 * 0.3).midiratio

(
{BLowShelf.ar(WhiteNoise.ar * 0.05, 1000, 0.9, 0) ! 2}.play;
)

(
SynthDef(\sinePhase, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(
		freq,
		0,
		0.dbamp
	);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(0, snd * 0.2 ! 2);
}).play;
)


(
SynthDef(\sinePhase, {
	var snd, freq;
	freq = \freq.kr(330);
	snd = SinOsc.ar(
		[freq, freq],
		[0, SinOsc.ar(32).range(0, 0.2pi)],
		[0, -6].dbamp
	);
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(0, snd * 0.2 ! 2);
}).play;
)


[0, -10].dbamp;



(
{SinOsc.ar(440, 0, 0.2) ! 2}.play;
)


(
SynthDef(\fmfm, {
	var freq, snd;
	freq = \freq.kr(330);
	snd = SinOsc.ar(freq * [3, 2, 6]) * (2 * Env.perc(0, 0.1).ar) * (1 - (Env.perc(0, 2).ar));
	snd = SinOsc.ar(freq * [1, 0.5, 4] + (600 * snd));
	snd = snd * [0, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 1).ar(Done.freeSelf);
	Out.ar(0, snd * 0.4 ! 2);
}).play;
)

[0, 1.001, 0.998];

(
SynthDef(\fmfm, {
	var freq, snd;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 1.001, 0.998]);
	snd = snd * [0, -10, -10].dbamp;
	snd = snd.sum * -10.dbamp;
	snd = GVerb.ar(snd, 60, 30, 0.8);
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd * 0.4);
}).play;
)




(
SynthDef(\noisePitch, {
	var snd;
	snd = SinOsc.ar(LFNoise2.ar(3 ! 2).range(100, 1000));
	snd = FreeVerb.ar(snd, 0.33, 0.5, 0.5);
	snd = snd * Env.perc(0.001, 6).ar(Done.freeSelf);
	Out.ar(0, snd * 0.5);
}).play;
)











// endfile 