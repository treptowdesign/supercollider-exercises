///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
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
// Kick, snare, hat, key, bass, pad
(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(58 * (1 + (3 * Env.perc(0.001, 0.03).ar) * velocity) * (1 + (0.5 * Env.perc(0.001, 0.3).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, bend;
	bend = \bend.kr(0).midiratio;
	snd = SinOsc.ar(Env([420, 260, 230], [0.03, 0.2], \exp).ar * bend);
	snd = snd + (SinOsc.ar(Env([2000, 200], [0.03], \exp).ar * bend) * Env.perc(0.001, 0.03).ar);
	snd = snd + (SinOsc.ar(Env([1000, 790], [0.03], \exp).ar * bend) * Env.perc(0.003, 0.2).ar * -20.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar) + [1, 2], 2050 * bend, 0.3) * Env.perc(0.05, 0.15).ar * 10.dbamp);
	snd = snd + (snd * 2.dbamp).tanh;
	snd = snd * Env.perc(0.0001, 0.2).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.3) * 12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1230);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(0.3);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030], 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.05).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(0.3) * 3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
/////////////////////////////////////////////
// Keys basic FM
/////////////////////////////////////////////
SynthDef(\key, {
	var snd,
	freq = \freq.kr(440),
	atk = \atk.kr(0.001), rel = \rel.kr(1), amp = \amp.kr(-15), pan = \pan.kr(0);
	snd = (
		SinOsc.ar(freq * [3, 16])
		* Env.perc(atk, rel).ar
		* (1 + (5 * Env.perc(0, 0.3).ar))
		* 600
		* Hasher.kr(freq).linexp(-1, 1, 0.9, 1.1)
	);
	snd = snd.sum;
	snd = SinOsc.ar(freq + snd); // main signal
	snd = (snd * 1.dbamp).tanh; // distortion
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, pan)); // out, amp & panning
}).add;
// pads
SynthDef(\pad, {
	var snd;
	snd = (800 * (1.5 ** [0, 1, 2, 3]) * \ratio.kr(1)).collect { |freq|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(8 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midSides
		snd;
	};
	snd = snd.sum;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\pad2, {
	var snd;
	snd = (260 * (1.5 ** [0, 1, 2, 3]) * \ratio.kr(1)).collect { |freq|
		var snd;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio) * LFNoise2.kr(1 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midSides
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (5 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, 3.0).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -6.dbamp;
	Out.ar(\out.kr, snd);
}).add;
// sub
SynthDef(\sub, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(\freq.kr(60) * (1 + (3 * Env.perc(0.0, 0.02, curve: -8).ar)) * [1, 2]);
	snd = snd * [1, -7.dbamp];
	snd[1] = snd[1] * Env.perc(0, 0.5).ar;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, 2.0).ar;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * (1 + (6 * Env.perc(0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
// bass
SynthDef(\bass1, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq);
	snd = snd * Line.kr(0, 1, 0.1);
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
SynthDef(\bass2, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 200);
	snd = snd * Line.kr(0, 1, 0.5);
	snd = snd * 5.dbamp;
	snd = snd.tanh + HPF.ar((snd > [0.1, 0.7]), 8000).fold2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass3, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = RLPF.ar(snd, XLine.kr([800, 1200], [500, 2000], \duration.kr(0.3)), 0.2).sum * 5.dbamp;
	snd = snd * Line.kr(0, 1, 0.5);
	snd = BPF.ar(snd, (0..20).normalize.squared.linexp(0, 1, 100, 16000), 0.2).sum;
	snd = snd.fold2;
	snd = LPF.ar(snd, 200) + HPF.ar(snd * -5.dbamp, 3000);
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.3) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\kick);
Synth(\snare);
Synth(\clap);
Synth(\hat);
Synth(\key);
Synth(\pad);
Synth(\pad2);
Synth(\pad2);
Synth(\bass1);
Synth(\bass2);
Synth(\bass3);



//////////////////////////////////////////////////////
// Workspace
//////////////////////////////////////////////////////

(
SynthDef(\kickWs, {
	var snd, velocity;
	velocity = \vel.kr(1);
	snd = SinOsc.ar(58 * (1 + (3 * Env.perc(0.001, 0.03).ar) * velocity) * (1 + (0.5 * Env.perc(0.001, 0.3).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kickWs2, {
	var snd, velocity;
	velocity = \vel.kr(1);
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0.001, 0.03).ar) * velocity)
		* (1 + (0.5 * Env.perc(0.001, 0.3).ar) * velocity)
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

// Notes: Hasher.ar(Sweep.ar) is roughly equivalent to WhiteNoise.ar
// .pow(amt) will eccentuate the extreme edges of the distribution

// Simplified Basic Kick (annotated)
SynthDef(\kickWs3, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0, 0.03).ar)) // fast rel env
		* (1 + (0.5 * Env.perc(0, 0.3).ar)) // 10x slow rel env
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar)); // quick vol fall (drops from 4x to 1x over 0.3s)
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp); // click
	snd = (snd.clip2).tanh; // distortion
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf); // final vol shape
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1).dbamp, \pan.kr(0))); // amp, pan => out
}).add;

SynthDef(\kickWs4, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0, 0.03).ar))
		* (1 + (0.5 * Env.perc(0, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = (snd.clip2).tanh;
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1).dbamp, \pan.kr(0)));
}).add;

// SNARE
SynthDef(\snareWs, {
	var snd, bend;
	bend = \bend.kr(0).midiratio;
	snd = SinOsc.ar(Env([420, 260, 230], [0.03, 0.2], \exp).ar * bend);
	snd = snd + (SinOsc.ar(Env([2000, 200], [0.03], \exp).ar * bend) * Env.perc(0.001, 0.03).ar);
	snd = snd + (SinOsc.ar(Env([1000, 790], [0.03], \exp).ar * bend) * Env.perc(0.003, 0.2).ar * -20.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar) + [1, 2], 2050 * bend, 0.3) * Env.perc(0.05, 0.15).ar * 10.dbamp);
	snd = snd + (snd * 2.dbamp).tanh;
	snd = snd * Env.perc(0.0001, 0.2).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.3) * 12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

// simplifying
SynthDef(\snareWs2, {
	var snd;
	snd = SinOsc.ar(Env([420, 260, 230], [0.03, 0.2], \exp).ar);
	snd = snd + (SinOsc.ar(Env([2000, 200], [0.03], \exp).ar) * Env.perc(0.001, 0.03).ar);
	snd = snd + (SinOsc.ar(Env([1000, 790], [0.03], \exp).ar) * Env.perc(0.003, 0.2).ar * -20.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar + [1, 2], 2050, 0.3) * Env.perc(0.05, 0.15).ar * 10.dbamp);
	snd = snd + (snd * 2.dbamp).tanh;
	snd = snd * Env.perc(0.0001, 0.2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), (snd * \amp.kr(0.3) * 12.dbamp));
}).add;


// Kick Recreate
SynthDef(\kickRecreate, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0, 0.03).ar)),
		* (1 + (0.5 * Env.perc(0, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = (snd.clip2).tanh;
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * 1.dbamp);
}).add;


)

Synth(\kickRecreate);




Synth(\snareWs2);

Synth(\snareWs);

Synth(\kickWs);
Synth(\kickWs2);
Synth(\kickWs3);
Synth(\kickWs4);






















//////////////////////////////////////////////////////
// end...
//////////////////////////////////////////////////////
