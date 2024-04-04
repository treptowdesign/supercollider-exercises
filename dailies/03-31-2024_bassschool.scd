///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(300);
ServerOptions.outDevices;
Server.default.options.outDevice_("External Headphones");
Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)
// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

// Memory Server Stuff
s.options.memSize;
s.options.memSize = 1048576; (original 8192)
s.options.numWireBufs;
s.options.numWireBufs = 128; (original 64)

//////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////

(
SynthDef(\bass1scl, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq);
	// snd = snd * Line.kr(0, 1, 0.1);
	hi = snd * 16;
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar * (1 + (0.5 * LFNoise2.kr(60))) } ! 2, 10230, 0.3) * -25.dbamp));
	hi = hi.tanh + (hi.fold2 * -20.dbamp);
	hi = hi + DelayC.ar(hi, 0.1, SinOsc.ar(0.5, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	hi = HPF.ar(hi, 2200);
	snd = (snd * 1.5).tanh + hi;
	snd = snd * Env.linen(0.0, \duration.kr(0.5) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass2scl, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 200);
	// snd = snd * Line.kr(0, 1, 0.5);
	snd = snd * 5.dbamp;
	snd = snd.tanh + HPF.ar((snd > [0.1, 0.7]), 8000).fold2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass3scl, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = RLPF.ar(snd, XLine.kr([800, 1200], [500, 2000], \duration.kr(0.3)), 0.2).sum * 5.dbamp;
	// snd = snd * Line.kr(0, 1, 0.5);
	snd = BPF.ar(snd, (0..20).normalize.squared.linexp(0, 1, 100, 16000), 0.2).sum;
	snd = snd.fold2;
	snd = LPF.ar(snd, 200) + HPF.ar(snd * -5.dbamp, 3000);
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.3) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\bass1scl);
Synth(\bass2scl);
Synth(\bass3scl);


(
SynthDef(\bassTst, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 200);
	snd = snd * 5.dbamp;
	snd = snd.tanh + HPF.ar((snd > [0.1, 0.7]), 8000).fold2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).add;
)

Synth(\bassTst);







(
SynthDef(\bassChallenge, {
	var snd, auto, freq, trig;
	freq = \freq.kr(40);
	trig = ToggleFF.ar(Dust.ar(8));
	auto = trig.lagud(0.1, 0.3);
	snd = Saw.ar(freq);
	snd = Splay.ar(snd);
	snd = (snd * 3).fold2;
	snd = RLPF.ar(snd, freq * 10, 0.1);
	snd = (snd * 5).fold2;
	snd = RLPF.ar(snd, freq * 8 * TRand.ar(1, 4, trig), 0.5);
	snd = (snd * 5).fold2;
	snd = MoogFF.ar(snd, auto.linexp(0, 1, 100, 4000), 0);
	snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(0.5, [0, pi]).range(0, 0.001));
	snd = (snd * 3.dbamp).tanh;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\bassChallenge);















// end