

(
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(60 * (1 + (5 * Env.perc(0, 0.1).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));

	wet = snd + 0.1;
	wet = (wet.clip2 + (wet.fold2 * 0.dbamp)).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);

	snd = snd * Env.perc(0.001, 0.35).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 4620, 0.2) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -25.dbamp, 0.1, 0.015)) ! 2;

	snd = BHiShelf.ar(snd, 600, 0.5, -4);
	snd = BLowShelf.ar(snd, 120, 0.5, 4);

	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


{ 46 * (1 + (5 * Env.perc(0, 0.1).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)) }.plot(1);


(
var s, beat, wait, play;
s = Server.default;
beat = 60 / 124;
wait = { |dur| dur.wait; };
play = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
	wait.(dur);
};
Routine({
	loop {
		play.(\kick, beat);
	};
}).play;
)











(
SynthDef(\kickFM, {
	var snd, wet, freq;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq) * 80;
	snd = SinOsc.ar((freq + snd) * (1 + (5 * Env.perc(0, 0.1).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));

	wet = snd + 0.1;
	wet = (wet.clip2 + (wet.fold2 * 0.dbamp)).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);

	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.2) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -20.dbamp, 0.1, 0.02)) ! 2;

	snd = BHiShelf.ar(snd, 600, 0.5, -4);
	snd = BLowShelf.ar(snd, 120, 0.5, 4);

	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)












