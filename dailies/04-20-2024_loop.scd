///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
ServerOptions.outDevices;
Server.default.options.outDevice_("External Headphones");
// Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)
// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

// Memory Server Stuff
s.options.memSize;
s.options.memSize = 1048576; // (original 8192)
s.options.numWireBufs;
s.options.numWireBufs = 128; // (original 64)

//////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(60 * (1 + (3 * Env.perc(0, 0.19, curve: -6).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.003).ar));
	snd = snd.tanh;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.001, 0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * Env.perc(0.02, 0.05).ar * -1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7320, 0.3) * Env.perc(0.0, 0.05).ar * 3.dbamp);
	snd = snd * (1 + (2 * Env.perc(0, 0.05).ar));
	snd = snd.clip2;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -17.dbamp, 0.1, [0.045, 0.065]), 100), 3000);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ghostKick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(60 * (1 + (2 * Env.perc(0, 0.19, curve: -6).ar)) * (1 + (1 * Env.perc(0, 0.01).ar)) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.003).ar));
	snd = snd.tanh;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.001, 0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * Env.perc(0.02, 0.05).ar * -1.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.5).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [0.045, 0.065]), 100), 3000);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(220 * XLine.ar(1, 0.9, 0.3) * XLine.ar(2, 1, 0.02));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(1e-3, 0.02).ar);
	snd = snd + (SinOsc.ar(XLine.ar(8000, 1000, 0.02)) * Env.perc(1e-3, 0.02).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2320, 0.3) * Env.perc(0.01, 0.05).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3320, 0.3) * Env.perc(0.07, 0.3).ar * 4.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd + PitchShift.ar(snd, 0.023, 1.5);
	snd = snd + PitchShift.ar(snd, 0.01, 1.2);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.045, [2.3, 2.4]);
	snd = snd + FreqShift.ar(CombC.ar(snd * -1.dbamp, 0.2, 1 / (230 * XLine.kr(1, 0.5, 0.3)), 0.1), 70);
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd.tanh;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [0.035, 0.055]), 200), 3000);
	snd = snd + GVerb.ar(snd.sum * -40.dbamp, 30, damping: 0.1);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [1523, 2230], 0.3).sum * 9.dbamp;
	snd = snd * Env([0, 1, 0, 1, 0, 1, 0], [1e-3, 1e-2, 1e-3, 1e-2, 1e-3, 0.1]).ar;
	snd = snd ! 2;
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\swarmHat, {
	var freq = 440;
	var snd;
	snd = Pulse.ar(freq * [1, 1.75, 0.06, 0.75, 1.55].midiratio);
	snd = (WhiteNoise.ar.pow(9.0) * 0.8) + snd.sum;
	snd = BPF.ar(snd, 16e3, 0.3);
	snd = snd * (1 + (6 * Env.perc(0, 0.03).ar));
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).add;
)

Synth(\kick);
Synth(\ghostKick);
Synth(\snare);
Synth(\clap);
Synth(\swarmHat);













//////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////
