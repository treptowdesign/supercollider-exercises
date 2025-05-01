///////////////////////////////////////////////////////////
// FM Bass
///////////////////////////////////////////////////////////

(
SynthDef(\fmBass, {
	var freq, snd, env, carrier, modulator, modEnv;
	freq = \freq.kr(60);
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).ar;
	modEnv = EnvGen.kr(Env.perc(0.01, 0.4), levelScale: \modIndex.kr(4));
	modulator = SinOsc.ar(freq * \modRatio.kr(2), 0, freq * modEnv);
	carrier = SinOsc.ar(freq + modulator);
	carrier = Pan2.ar(carrier * env, 0, \amp.kr(1.0));
	carrier = (carrier * 6.dbamp).tanh;
	// carrier = MoogFF.ar(carrier, Env.perc(0.001, 0.6).kr.range(100, 000), 1);
	carrier = carrier * Env.linen(0, \duration.kr(1), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), carrier);
}).play;
)



(
SynthDef(\fmBass, {
	var freq, snd, env, carrier, modulator, modEnv;
	freq = \freq.kr(50);
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).ar;
	modEnv = EnvGen.kr(Env.perc(0.01, 0.8), levelScale: \modIndex.kr(5));
	modulator = SinOsc.ar(freq * \modRatio.kr(4), 0, freq * modEnv);
	carrier = SinOsc.ar(freq + modulator);
	carrier = Pan2.ar(carrier * env, 0, \amp.kr(1.0));
	carrier = (carrier * 4.dbamp).tanh;
	// carrier = MoogFF.ar(carrier, Env.perc(0.001, 0.6).kr.range(100, 000), 1);
	carrier = carrier * Env.linen(0, \duration.kr(1), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), carrier);
}).play;
)


(
SynthDef(\fmBass, {
	var freq, snd, env, modEnv;
	freq = \freq.kr(50);
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).ar;
	modEnv = EnvGen.kr(Env.perc(0.01, 0.8), levelScale: \modIndex.kr(5));
	snd = SinOsc.ar(freq * \modRatio.kr(4), 0, freq * modEnv);
	snd = SinOsc.ar(freq + snd);
	snd = Pan2.ar(snd * env, 0, \amp.kr(1.0));
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.linen(0, \duration.kr(1), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


32.midicps;




