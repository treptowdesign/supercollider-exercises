
// saw
(
SynthDef(\add, {
	var snd;
	snd = SinOsc.ar(440 * [1,2,3,4,5,6,7]) * [1,1/2,1/3,1/4,1/5,1/6,1/7];
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

// square
(
SynthDef(\add, {
	var snd;
	snd = SinOsc.ar(440 * [1,3,5,7]) * [1,1/3,1/5,1/7];
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\add, {
	var snd;
	snd = SinOsc.ar(440 * [1,3,4,5,7]) * [1,1/3,1/2,1/5,1/7];
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\add, {
	var snd;
	snd = SinOsc.ar(440 * (1..20)) * (1 / (1..20));
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\add, {
	var snd;
	snd = SinOsc.ar(440 * [1,2,5,6,9]) * [1,0.75,0.3,0.2,0.1] * Env.perc([0.01, 0.02, 0.03, 0.04, 0.05], 0.3).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\blp, {
	var snd;
	snd = Blip.ar(440, 7);
	snd = snd * Env.perc(0.01, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)













