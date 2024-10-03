//
(
SynthDef(\bassRumble, {
	var snd;
	snd = SinOsc.ar(70 * (LFNoise2.kr(1 ! 16) * 10).midiratio);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 300, 3, 0.8);
	snd = (snd * 4.dbamp).tanh;
	snd = LPF.ar(snd, 300) + HPF.ar(snd, 3000);
	snd = snd * Env.linen(0.1, \duration.kr(5.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\test, {
	var snd;
	snd = Saw.ar(100);
	snd = Splay.ar(snd);
	snd = snd.mean;
	snd = Pan2.ar(snd, 0);
	snd = snd * -8.dbamp;
	Out.ar(0, snd);
}).play;
)