
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// Busses
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
~arpBus = Bus.audio(s, 2); // set this bus
~arpBus.index;


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// SynthDefs
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\kick, {
	arg amp=0.8, freq=60, decay=0.5;
	var env, pitchEnv, osc;
	pitchEnv = EnvGen.kr(Env.perc(0.001, 0.08), levelScale: freq*3, levelBias: freq);
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
	osc = SinOsc.ar(pitchEnv) * env * amp;
	Out.ar(0, osc ! 2);
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
	arg amp=0.3, decay=0.09;
	var env, noise, hat;
	// env = EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
	env = Env.perc(0.001, decay).kr(Done.freeSelf);
	noise = WhiteNoise.ar();
	hat = HPF.ar(noise, 6000);
	Out.ar(0, hat * env * amp ! 2);
}).add;
SynthDef(\choirPad, {
	arg freq=220, amp=0.5, gate=1, lfoRate=0.1;
	var osc, pwm, formants, env, lfo, chorus, snd;
	lfo = SinOsc.kr(lfoRate).range(0.3, 0.7);
	pwm = Pulse.ar(freq * [1,1.01,0.995], width: lfo).mean;
	formants = BPF.ar(pwm, [800, 1200, 2500], 0.2).mean; // Formant filtering (band-pass to emulate vowel resonances)
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
SynthDef(\technoArp, {
	arg freq=440, amp=0.3, gate=1, cutoff=2000, res=0.3, outBus=0;
	var osc, filt, env, snd, chorus;
	osc = Saw.ar(freq);
	filt = RLPF.ar(osc, cutoff.clip(400,5000), res.linlin(0,1,0.1,0.9));
	env = EnvGen.kr(
		Env.adsr(0.001, 0.1, 0.6, 0.1),
		gate,
		doneAction:2
	);
	snd = filt * env * amp;
	Out.ar(outBus, snd ! 2); // output to custom bus
}).add;
SynthDef(\technoArpChorus, {
	arg freq=440, amp=0.3, gate=1, cutoff=2000, res=0.3, outBus=0;
	var osc, filt, env, snd, chorus;
	osc = Saw.ar(freq);
	filt = RLPF.ar(osc, cutoff.clip(400,5000), res.linlin(0,1,0.1,0.9));
	env = EnvGen.kr(
		Env.adsr(0.001, 0.1, 0.6, 0.1),
		gate,
		doneAction:2
	);
	snd = filt * env * amp;
	chorus = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.025))
	}).tanh;
	snd = Mix([snd, chorus]);
	Out.ar(outBus, snd ! 2); // output to custom bus
}).add;
SynthDef(\rhythmicDelay, {
	arg inBus, delayTime=0.3, feedback=0.1;
	var sig = In.ar(inBus, 2);
	var delayed = CombC.ar(sig, delayTime, delayTime, feedback);
	Out.ar(0, (sig + delayed).tanh); // mix delayed arp back to main output
}).add;
)

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// PATTERN A
// no pad, slow arp with no arp chorus
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
(
~beat = 0.75;
Pbind(
	\instrument, \kick,
	\dur, Pseq([~beat, Rest(~beat), ~beat, Rest(~beat/2), ~beat/2], inf),
	\freq, 50,
	\decay, 0.4,
	\amp, 0.5,
).play;
Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.1,
).play;
Pbind(
	\instrument, \clap,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.8,
).play;
Pbind(
	\instrument, \hihat,
	\dur, ~beat/8,
	\amp, Pseq([0.4, 0.01, 0.1, 0.02, 0.3, 0.03, 0.1, 0.02], inf)
).play;
Pbind(
	\instrument, \technoArp,
	\degree, Pseq([0,4,7,12,7,4], inf),
	\scale, Scale.phrygian,
	\octave, Pseq([2,3,4], inf),
	\dur, ~beat/2,
	\cutoff, Pseg([1600,4000,1600], [~beat * 4, ~beat * 4], \exp, inf),
	\amp, 0.3,
	\outBus, ~arpBus
).play;
// Synth(\rhythmicDelay, [\inBus, ~arpBus, \delayTime, ~beat/4, \feedback, 0.2]);
Synth(\rhythmicDelay, [\inBus, ~arpBus, \delayTime, ~beat/4, \feedback, 0.8]);
)

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// PATTERN B
// faster bpm, vocal pad added, slower hats
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
(
~beat = 0.5;
Pbind(
	\instrument, \kick,
	\dur, Pseq([~beat, Rest(~beat), ~beat, Rest(~beat/2), ~beat/2], inf),
	\decay, 0.2,
	\freq, 60,
	\amp, 0.5,
).play;
Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.3,
).play;
Pbind(
	\instrument, \clap,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.8,
).play;
Pbind(
	\instrument, \hihat,
	\dur, ~beat/4,
	\amp, Pseq([0.15, 0.015, 0.05, 0.015, 0.15, 0.015, 0.05, 0.015], inf)
).play;
Pbind(
	\instrument, \choirPad,
	\dur, ~beat * 8,
	\amp, 0.3,
	\scale, Scale.phrygian,
	\degree, Pseq([[0,2,4],[5,7,9],[-2,0,3],[4,6,8]], inf),
	\octave, 6,
	\legato, 1.1
).play;
Pbind(
	\instrument, \choirPad,
	\dur, ~beat * 8,
	\amp, 0.1,
	\scale, Scale.phrygian,
	\degree, Pseq([[0,2,4],[5,7,9],[-2,0,3],[4,6,8]], inf),
	\octave, 5,
	\legato, 1.1
).play;
Pbind(
	\instrument, \technoArp,
	\degree, Pseq([0,4,7,12,7,4], inf),
	\scale, Scale.phrygian,
	\octave, Pseq([2,3,4], inf),
	\dur, ~beat/4,
	\cutoff, Pseg([1600,4000,1600], [~beat * 4, ~beat * 4], \exp, inf),
	\amp, 0.2,
	\outBus, ~arpBus
).play;

// Delay Synth
Synth(\rhythmicDelay, [\inBus, ~arpBus, \delayTime, ~beat/4, \feedback, 0.2]);
)

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// PATTERN C
// mid tempo, chorus on arp
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
(
~beat = 0.6;
Pbind(
	\instrument, \kick,
	\dur, Pseq([~beat, Rest(~beat), ~beat, Rest(~beat/2), ~beat/2], inf),
	\decay, 0.2,
	\freq, 60,
	\amp, 0.6,
).play;
Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.3,
).play;
Pbind(
	\instrument, \clap,
	\dur, Pseq([Rest(~beat), ~beat], inf),
	\amp, 0.8,
).play;
Pbind(
	\instrument, \hihat,
	\dur, ~beat/4,
	\amp, Pseq([0.2, 0.1, 0.3, 0.1], inf)
).play;
Pbind(
	\instrument, \choirPad,
	\dur, ~beat * 8,
	\amp, 0.3,
	\scale, Scale.phrygian,
	\degree, Pseq([[0,2,4],[5,7,9],[-2,0,3],[4,6,8]], inf),
	\octave, 6,
	\legato, 1.1
).play;
Pbind(
	\instrument, \choirPad,
	\dur, ~beat * 8,
	\amp, 0.2,
	\scale, Scale.phrygian,
	\degree, Pseq([[0,2,4],[5,7,9],[-2,0,3],[4,6,8]], inf),
	\octave, 5,
	\legato, 1.1
).play;
Pbind(
	\instrument, \technoArpChorus, // chorus fx on this one
	\degree, Pseq([0,4,7,12,7,4], inf),
	\scale, Scale.phrygian,
	\octave, Pseq([2,3,4], inf),
	\dur, ~beat/4,
	\cutoff, Pseg([1600,4000,1600], [~beat * 8, ~beat * 8], \exp, inf),
	\amp, 0.2,
	\outBus, ~arpBus
).play;

// Delay Synth
Synth(\rhythmicDelay, [\inBus, ~arpBus, \delayTime, ~beat/4, \feedback, 0.2]);
)
