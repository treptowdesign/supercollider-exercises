
(
~hatBus = Bus.audio(s, 2); // set this bus
)
~hatBus.index;


(
SynthDef(\kick, {
	arg amp=0.8, freq=60, decay=0.5;
	var env, pitchEnv, osc;
	pitchEnv = EnvGen.kr(Env.perc(0.001, 0.08), levelScale: freq*4, levelBias: freq);
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
	osc = SinOsc.ar(pitchEnv) * env * amp;
	Out.ar(0, osc ! 2);
}).add;
SynthDef(\snare, {
	arg amp=0.5, decay=0.15, lagTime=0;
	var snd, noise, tone, env;
	env = EnvGen.kr(Env.perc(0.005, decay), doneAction:2);
	noise = WhiteNoise.ar() * 0.5;
	tone = SinOsc.ar(130) * 0.4;
	snd = (noise + tone) * env * amp;
	snd = DelayN.ar(snd, lagTime, lagTime);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\clap, { |lagTime=0|
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1610);
	snd = snd * Env([0, 1, 0.1, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = snd * (1 + (1.3 * Env.perc(0.001, 0.12, curve: -8).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 7.dbamp;
	snd = snd * \amp.kr(1);
	snd = DelayN.ar(snd, lagTime, lagTime);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hihat, { |amp=0.3, decay=0.03, out=0|
	var env, noise, hat;
	env = Env.perc(0.001, decay, curve: -4).kr(Done.freeSelf);
	noise = WhiteNoise.ar();
	hat = HPF.ar(noise, 6300);
	Out.ar(out, hat * env * amp ! 2);
}).add;
SynthDef(\swingLag, { |inBus=0, lagTime=0|
	var snd, delayed;
	snd = In.ar(inBus, 2);
	delayed = DelayN.ar(snd, lagTime, lagTime) * 1;
	snd = snd + delayed;
	snd = FreeVerb.ar(snd, 0.1, 0.8, 0.6);
	Out.ar(0, snd);
}).add;
SynthDef(\junoPad, {
	arg freq=440, amp=0.5, gate=1, cutoff=1200, res=0.2, chorusMix=0.3;
	var osc, filt, env, chorus;
	osc = Saw.ar(freq * [1,1.005,0.997]).mean;
	filt = RLPF.ar(osc, cutoff.clip(300,8000), res.linexp(0,1,0.5,0.99));
	env = EnvGen.kr(
		Env.adsr(attackTime:2.5, decayTime:1.5, sustainLevel:0.8, releaseTime:3.5),
		gate,
		doneAction:2
	);
	chorus = Mix.fill(2, { |i|
		DelayC.ar(filt, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.025))
	}).tanh;
	Out.ar(0, XFade2.ar(filt, chorus, chorusMix) * env * amp ! 2);
}).add;
SynthDef(\choirPad, {
	arg freq=220, amp=0.5, gate=1, lfoRate=0.1;
	var osc, pwm, formants, env, lfo, chorus, snd;
	lfo = SinOsc.kr(lfoRate).range(0.3, 0.7);
	pwm = Pulse.ar(freq * [1,1.01,0.995], width: lfo).mean;
	formants = BPF.ar(pwm, [800, 1200, 2500], 0.2).mean;
	env = EnvGen.kr(
		Env.adsr(attackTime: 2.0, decayTime: 1.0, sustainLevel: 0.8, releaseTime: 3.0),
		gate,
		doneAction:2
	);
	snd = formants * env * amp;
	chorus = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.025))
	}).tanh;
	snd = Mix([snd, chorus]);
	Out.ar(0, snd ! 2);
}).add;
SynthDef(\fmBass, {
	arg freq=50, amp=0.6, modIndex=3, modRatio=2, gate=1;
	var carrier, modulator, env, modEnv;
	env = EnvGen.kr(
		Env.adsr(attackTime: 0.001, decayTime: 0.2, sustainLevel: 0.7, releaseTime: 0.3),
		gate,
		doneAction: 2
	);
	modEnv = EnvGen.kr(Env.perc(0.01, 0.2), levelScale: modIndex);
	modulator = SinOsc.ar(freq * modRatio, 0, freq * modEnv);
	carrier = SinOsc.ar(freq + modulator);
	Out.ar(0, carrier * env * amp ! 2);
}).add;
SynthDef(\vinylCrackle, { | amp=0.2, density=5 |
	var noise, clicks, crackle;
	noise = WhiteNoise.ar(0.01);
	clicks = Dust.ar(density);
	crackle = clicks * Decay.ar(clicks, 0.01, WhiteNoise.ar(0.5));
	crackle = HPF.ar(crackle, 1000);
	Out.ar(0, (noise + crackle) * amp ! 2);
}).add;
)



(
~beat = 0.9;
Pbind(
	\instrument, \choirPad,
	\dur, ~beat * 4,
	\amp, 0.2,
	\scale, Scale.aeolian,
	\degree, Pseq([[0,2,4,6],[1,3,5,7]], inf),
	\octave, 5,
	\legato, 1
).play;
Pbind(
	\instrument, \junoPad,
	\dur, ~beat * 4,
	\amp, 0.15,
	\scale, Scale.aeolian,
	\degree, Pseq([[0,2,4,6],[1,3,5,7]], inf),
	\octave, 4,
	\cutoff, Pseq([1500, 1200, 1400, 1300], inf),
	\legato, 1
).play;
Pbind(
	\instrument, \fmBass,
	\degree, Pseq([0, 0, 0, -3, 0, 0], inf),
	\scale, Scale.aeolian,
	\octave, 4,
	\dur, Pseq([
		Rest(~beat), ~beat/4, ~beat/4, ~beat/2, Rest(~beat), ~beat/2, Rest(~beat/2),
		Rest(~beat), Rest(~beat/4), ~beat/4, ~beat/2, Rest(~beat), Rest(~beat/2), Rest(~beat/2)
	], inf),
	\modIndex, 2,
	\modRatio, 2,
	\amp, 0.24,
	\legato, 1
).play;
Pbind(
	\instrument, \kick,
	\dur, Pseq([~beat, Rest(~beat), ~beat, Rest(~beat/2), ~beat/2], inf),
	\freq, 50,
	\decay, ~beat,
	\amp, 0.6,
).play;
Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.3,
	\lagTime, 0
).play;
Pbind(
	\instrument, \clap,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.8,
	\lagTime, 0.018
).play;
Pbind(
	\instrument, \hihat,
	\dur, Pseq([~beat/2, ~beat/2, ~beat/2, ~beat/2, ~beat/2, ~beat/2, ~beat/2, ~beat/8, ~beat/8, ~beat/8, ~beat/8], inf),
	\amp, Pseq([0.65, 0.5, 0.55, 0.6] * 0.21, inf),
	\out, ~hatBus
).play;
Synth(\vinylCrackle, [\amp, 0.2, \density, 10]);
Synth(\swingLag, [\inBus, ~hatBus, \lagTime, ~beat/4.1]);
)



