// Signal and FX Rack
(
SynthDef(\pulseSynth, {
	var snd, env;
	env = Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Pulse.ar(\freq.kr(110));
	snd = Pan2.ar(snd * env * \amp.kr(0.1) ! 2, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)