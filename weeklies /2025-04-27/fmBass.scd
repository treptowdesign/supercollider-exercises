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

32.midicps;


(
SynthDef(\fmBass, {
	var freq, snd, env, modEnv;
	freq = \freq.kr(50);
	env = Env.perc(\atk.kr(0.01), \rel.kr(0.8), curve: -4).ar;
	modEnv = EnvGen.kr(Env.perc(0.01, 0.6), levelScale: \modIndex.kr(4));
	snd = SinOsc.ar(freq * \modRatio.kr(1), 0, freq * modEnv);
	snd = SinOsc.ar(freq + snd);
	snd = Pan2.ar(snd * env, 0, \amp.kr(0.2));
	snd = XFade2.ar(snd, (snd * 6.dbamp).tanh, 0.25);
	snd = snd * (1 + (0.25 * Env.perc(0, 0.03).ar)) * SinOsc.ar(10, 0, 0.2, 0.8);
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

{SinOsc.ar(8, 0, 0.2, 0.8)}.plot(1);


(
var s, beat, root;
s = Server.default;
beat = 60 / 130;
root = 32;
Routine({
	loop {
		[0, -5, 2, 0, -4, 0, 2, 0].do { |degree|
			s.bind {
				Synth(\fmBass, [
					freq: (root + degree).midicps,
					duration: beat/2
				]);
			};
			(beat/2).wait;
		};
	};
}).play;
)




