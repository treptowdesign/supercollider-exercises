


{SinOsc.ar(400) ! 2}.play



(
SynthDef(\k, {
	var snd;
	snd = SinOsc.ar(
		60
		* (1 + (1.5 * Env.perc(0, 0.1).ar))
		* (1 + (2 * Env.perc(0, 0.01).ar))
	);
	snd = (snd).tanh;
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\delKick, {
	var snd;
	snd = SinOsc.ar(60 * (1 + (1.5 * Env.perc(0, 0.1).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (2 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.04).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.25).ar;
	snd = snd + DelayC.ar(snd * -28.dbamp, 0.2, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-22).dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)