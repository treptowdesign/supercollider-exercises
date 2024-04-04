///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
ServerOptions.outDevices;
Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)

// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

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
	snd = snd * 5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(32 * (1 + (5 * Env.perc(0, 0.1, curve: -8).ar)) * (1 + (0.4 * Env.perc(0, 0.5, curve: -2).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6130, 0.3) * Env.perc(0.001, 0.02).ar * -12.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.5).ar);
	snd = (snd * 4.dbamp).tanh;
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	snd = snd * 1.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 17210, 0.25);
	snd = snd.sign;
	snd = snd * Env.linen(0.0, \rel.kr(0.02), 0.0).ar(Done.freeSelf);
	snd = snd * \amp.kr(-30.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).add;
SynthDef(\chords, {
	var snd, saw, pls, sub, lfo;
	lfo = SinOsc.ar(Line.kr(0.2, 0.6, \dur.kr(2) * 0.2));
	saw = VarSaw.ar(\freq.kr(440), lfo, 1) * -5.dbamp;
	pls = Pulse.ar(\freq.kr(440), lfo) * -8.dbamp;
	sub = SinOsc.ar(\freq.kr(440)) * -14.dbamp;
	snd = RLPF.ar(saw + pls, XLine.kr(200, 6000, \dur.kr(2) * 0.25));
	snd = sub + snd * -15.dbamp;
	snd = snd * Env.perc(\dur.kr(2) * 0.3, \dur.kr(2) * 0.7).ar(Done.freeSelf);
	snd = Pan2.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\chords);

Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]

(
var  root, scale, bpm, beat;
root = 60;
scale = Scale.dorian.degrees;
bpm = 90;
beat = 60 / bpm;
Routine({
	var note, duration, idx;
	duration = beat/4;
	idx = 0;
	loop {
		// Synth(\hat);
		// note = [7, 2, 10, 0][idx];
		note = scale.choose;
		[0, 3, 7, 10].do { |i|
			Synth(\chords, [freq: (root + note + i).midicps, dur: duration]);
		};
		duration.wait;
		// increment index
		if(idx == 3, {
			idx = 0;
		}, {
			idx = idx + 1;
		});
	};
}).play;
)






















///////////////////////////////////////////////////////////////
// end
///////////////////////////////////////////////////////////////