// Techno Arps
(
SynthDef(\kick, {
	arg amp=0.8, freq=60, decay=0.5;
	var env, pitchEnv, osc;
	pitchEnv = EnvGen.kr(Env.perc(0.001, 0.12), levelScale: freq*2, levelBias: freq);
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
	osc = SinOsc.ar(pitchEnv) * env * amp;
	// osc = osc.tanh;
	Out.ar(0, osc.dup);
}).add;
SynthDef(\snare, {
	arg amp=0.5, decay=0.15;
	var noise, tone, env;
	env = EnvGen.kr(Env.perc(0.005, decay), doneAction:2);
	noise = WhiteNoise.ar() * 0.5;
	tone = SinOsc.ar(130) * 0.4;
	Out.ar(0, (noise + tone) * env * amp ! 2);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1610);
	snd = snd * Env([0, 1, 0.1, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = snd * (1 + (1.3 * Env.perc(0.001, 0.12, curve: -8).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 7.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hihat, {
	arg amp=0.3, decay=0.12;
	var env, noise, hat;
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction:2);
	noise = WhiteNoise.ar();
	hat = HPF.ar(noise, 6000);
	Out.ar(0, hat * env * amp ! 2);
}).add;
SynthDef(\technoArp, {
	arg freq=440, amp=0.3, gate=1, cutoff=2000, res=0.3, outBus=0;
	var osc, filt, env;
	osc = Saw.ar(freq);
	filt = RLPF.ar(osc, cutoff.clip(400,5000), res.linlin(0,1,0.1,0.9));
	env = EnvGen.kr(
		Env.adsr(0.001, 0.1, 0.6, 0.1),
		gate,
		doneAction:2
	);
	Out.ar(outBus, filt * env * amp ! 2); // output to custom bus
}).add;
SynthDef(\rhythmicDelay, {
	arg inBus, delayTime=0.3, feedback=0.1;
	var sig = In.ar(inBus, 2);
	var delayed = CombC.ar(sig, delayTime, delayTime, feedback);
	Out.ar(0, (sig + delayed).tanh); // mix delayed arp back to main output
}).add;
)


~arpBus = Bus.audio(s, 2);
~arpBus.index;

(
~beat = 0.75;
// Kick Pattern
Pbind(
	\instrument, \kick,
	\dur, Pseq([~beat, Rest(~beat), ~beat, Rest(~beat/2), ~beat/2], inf),
	\freq, 60,
	\amp, 1.3,
).play;

Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.3,
).play;

Pbind(
	\instrument, \clap,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 1.3,
).play;

Pbind(
	\instrument, \hihat,
	\dur, ~beat/8,
	\amp, Pseq([0.2, 0.02, 0.1, 0.02, 0.3, 0.03, 0.1, 0.02], inf)
).play;

Pbind(
	\instrument, \technoArp,
	\degree, Pseq([0,4,7,12,7,4], inf),
	\scale, Scale.phrygian,
	\octave, Pseq([2,3,4], inf),
	\dur, ~beat/2,
	\cutoff, Pseg([1200,4000,1200], [~beat * 4, ~beat * 4], \exp, inf),
	\amp, 0.24,
	\outBus, ~arpBus
).play;

// Delay Synth
Synth(\rhythmicDelay, [\inBus, ~arpBus, \delayTime, ~beat/4, \feedback, 0.2]);
)

