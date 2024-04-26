// gen some values in an array

([-0.1, -0.15, 1, 0.1, 0.15] * 1e-2).midiratio;

(
SynthDef(\chorSaw, {
	var snd;
	snd = VarSaw.ar(\freq.kr(220) * ([-0.1, -0.13, 1, 0.1, 0.17] * 1e-3).midiratio, 0, 0.5);
	snd = Splay.ar(snd, 1);
	snd = snd * Env.perc(0.1, 1.4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\chorSin, {
	var snd;
	snd = SinOsc.ar(\freq.kr(220) * ((-1..2) * 1e-2).midiratio);
	snd = snd.sum;
	snd = snd * Env.perc(0.1, 1.4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\bassSin, {
	var snd;
	snd = SinOsc.ar(\freq.kr(50));
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.perc(0.1, 1.4).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)
