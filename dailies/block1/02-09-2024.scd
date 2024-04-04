///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(250);
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

///////////////////////////////////////////////////////////////
// Basic Synth & Routine
///////////////////////////////////////////////////////////////
(
SynthDef(\clap, {
	var snd, env;
	env = Env([0, 1, 0.3, 1, 0.3, 1, 0], [0.001, 0.01, 0.001, 0.015, 0.001, 0.1], -4).ar(Done.freeSelf);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1240, 0.3) * 12.dbamp;
	snd = snd * env;
	snd = snd * -2.5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(45 * (1 + (5 * Env.perc(0, 0.1, curve: -8).ar)) * (1 + (0.4 * Env.perc(0, 0.5, curve: -2).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6130, 0.3) * Env.perc(0.001, 0.02).ar * -12.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.5).ar);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 17210, 0.25);
	snd = snd.sign;
	snd = snd * Env.linen(0.0, 0.02, 0.0).ar(Done.freeSelf);
	snd = snd * \amp.kr(-20.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	arg freq=440;
	var snd, sub, mid;
	sub = SinOsc.ar(freq);
	mid = Pulse.ar(freq * 2);
	snd = (sub * 1.dbamp) + (mid * -20.dbamp);
	snd = snd * Env.perc(0.05, 0.3).ar(Done.freeSelf);
	snd = (snd * 4.dbamp).tanh;
	snd = snd * -2.dbamp;
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
SynthDef(\synth, {
	arg freq=440, vel=1, rel=0.3, atk=0.01;
	var snd, sub, mid, high;
	sub = SinOsc.ar(freq / 2);
	mid = VarSaw.ar(freq);
	high = Pulse.ar(freq * 2);
	snd = (sub * -5.dbamp) + (mid * 2.dbamp) + (high * 1.dbamp);
	snd = snd * Env.perc(atk, (rel - atk)).ar(Done.freeSelf);
	snd = snd * vel.clip(-10, 1).dbamp;
	snd = snd * -15.dbamp; // general
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)

Synth(\clap);
Synth(\kick);
Synth(\hat);
Synth(\synth, [freq: 540, rel: 0.8, vel: 1]);
Synth(\bass, [freq: 110]);

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 92;
beat = 60 / bpm;
root = 54;
//    C     D     E  F     G     A     B
//1:  36 37 38 39 40 41 42 43 44 45 46 47
//2:  48 49 50 51 52 53 54 55 56 57 58 59
scale = Scale.dorian.degrees;

Routine({
	var i, note, octave, rel, vel;
	i = 1;
	loop {
		// hat
		Synth(\hat);
		// bass & kick
		if(i == 1 || (i == 2 && [true, false].wchoose([0.35, 0.65]))){
			octave = -1;
			note = root + scale.choose+ (12 * octave);
			Synth(\bass, [freq: note.midicps]);
			Synth(\kick);
		};
		// clap
		if(i == 3 || (i == 4 && [true, false].wchoose([0.2, 0.8]))) {
			Synth(\clap);
		};
		// melody
		if([true, false].wchoose([8.5, 1.5])){
			octave = [1, 2, 2, 3].choose;
			note = root + scale.choose + (12 * octave);
			rel = [beat/2, beat, beat * 2].choose;
			vel = [-10, -5, -7.5, -7.5, 1].choose;
			Synth(\synth, [freq: note.midicps, rel: rel, vel: vel]);
		};
		// increment
		if(i == 4, { i = 1;
		} , { i = i + 1; });
		(beat/4).wait;
	};
}).play;
)

///////////////////////////////////////////////////////////////
// Next...
///////////////////////////////////////////////////////////////