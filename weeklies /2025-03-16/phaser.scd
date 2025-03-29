// Audio Check

(
SynthDef(\test, {
	arg freq=440;
	var snd;
	snd = SinOsc.ar(freq, 0);
	snd = snd * Env.perc(0.01, 0.4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)

// Phaser Effect (Basic)

(
SynthDef(\phaser, { |out=0, in=0, rate=0.1, depth=0.5, feedback=0.7, mix=0.5|
    var input, phased, lfo, output;
    input = In.ar(in, 2);
	lfo = SinOsc.kr(rate, 0, depth, 1);
    phased = input;
    4.do { |i|
		phased = AllpassC.ar(phased, 0.05, lfo * (i + 1) * 0.01, feedback);
    };
    output = XFade2.ar(input, phased, mix * 2 - 1);
    Out.ar(out, output);
}).add;

SynthDef(\src, { |out=0, freq=330|
    var sig = Saw.ar(freq) * 0.3;
    Out.ar(out, sig ! 2);
}).add;
)

// Phaser Effect (RAND)

(
SynthDef(\phaser, { |out=0, in=0, rate=0.1, depth=0.5, feedback=0.7, mix=0.5|
    var input, phased, lfo, output;
    input = In.ar(in, 2);
	lfo = SinOsc.kr(rate, 0, depth, 1);
    phased = input;
    4.do { |i|
		var iLfo, iNoise;
		iNoise = (LFNoise1.kr(1) * 0.1).midiratio;
		iLfo = SinOsc.kr(rate * iNoise, Rand(0, 2pi), depth, 1).lag(Rand(0.01, 0.1));
		phased = AllpassC.ar(phased, 0.05, iLfo * (i + 1) * 0.01, feedback);
    };
    output = XFade2.ar(input, phased, mix * 2 - 1);
    Out.ar(out, output);
}).add;

SynthDef(\src, { |out=0, freq=330|
    var sig = Saw.ar(freq) * 0.3;
    Out.ar(out, sig ! 2);
}).add;
)


(0 * 0.1 * pi);
(1 * 0.1 * pi);
(2 * 0.1 * pi);
(3 * 0.1 * pi);
(0).midiratio -1;
(1).midiratio -1;
(2).midiratio -1;
(3).midiratio -1;
(-1 * 0.1).midiratio;
(1 * 0.1).midiratio;

rrand(0, 2pi);

// Phaser Effect

(
SynthDef(\phaser, { |out=0, in=0, rate=0.1, depth=0.5, feedback=0.7, mix=0.5|
    var input, phased, lfo, output;
    input = In.ar(in, 2);
	lfo = SinOsc.kr(rate, 0, depth, 1);
    phased = input;
    4.do { |i|
		var iLfo, iNoise;
		iNoise = (LFNoise1.kr(1) * 0.2).midiratio;
		iLfo = SinOsc.kr(rate * iNoise, (i * 0.2pi), depth, 1).lag((i).midiratio -1);
		phased = AllpassC.ar(phased, 0.05, iLfo * (i + 1) * 0.01, feedback);
    };
    output = XFade2.ar(input, phased, mix * 2 - 1);
    Out.ar(out, output);
}).add;
SynthDef(\src, { |out=0, freq=330|
	var sig = Pulse.ar(freq) * 0.4;
    Out.ar(out, sig ! 2);
}).add;
)


////////////////////////////////////
// Phaser Effect

(
SynthDef(\phaser, { |out=0, in=0, rate=0.1, depth=0.5, feedback=0.7, mix=0.5|
    var input, phased, output;
    input = In.ar(in, 2);
    phased = input;
    4.do { |i|
		var iLfo, iNoise;
		iNoise = (LFNoise1.kr(1) * 0.2).midiratio;
		iLfo = SinOsc.kr(rate * iNoise, (i * 0.2pi), depth, 1).lag((i).midiratio -1);
		phased = AllpassC.ar(phased, 0.05, iLfo * (i + 1) * 0.01, feedback);
    };
    output = XFade2.ar(input, phased, mix * 2 - 1);
    Out.ar(out, output);
}).add;
SynthDef(\src, { |out=0, freq=330|
	var sig = Pulse.ar(freq) * 0.4;
    Out.ar(out, sig ! 2);
}).add;
)

// fx bus
~phaserBus = Bus.audio(s, 2);
~phaserBus.index;
~phaserBus.free;

( // phased
~phaser = Synth(\phaser, [in: ~phaserBus, out: 0, rate: 0.06, mix: 0.8, feedback: 0.8]);
~source = Synth(\src, [out: ~phaserBus, freq: 220]);
)

( // dry Saw
~source = Synth(\src, [\out, 0, freq: 220]);
)

// set params
~phaser.set(\rate, 0.01);
~phaser.set(\depth, 0.9);
~phaser.set(\feedback, 0.7);
~phaser.set(\mix, 0.7);


s.reboot;

// lag
(
SynthDef(\lagPitch, {
	var snd;
	snd = SinOsc.ar(SinOsc.kr(4).range(60, 1200).lag(0.midiratio -1), 0, 0.1);
	snd = snd + SinOsc.ar(SinOsc.kr(4).range(60, 1200).lag(1.midiratio -1), 0, 0.1);
	snd = snd + SinOsc.ar(SinOsc.kr(4).range(60, 1200).lag(2.midiratio -1), 0, 0.1);
	snd = snd + SinOsc.ar(SinOsc.kr(4).range(60, 1200).lag(3.midiratio -1), 0, 0.1);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)


(
SynthDef(\lagPitch, {
	var snd;
	snd = 0;
	4.do { |i|
		snd = snd + SinOsc.ar(SinOsc.kr(4).range(60, 1200).lag(i.midiratio -1), 0, 0.1);
	};
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)

// noiseFreq
(
SynthDef(\noiseFreq, {
	var snd, freq, speed;
	speed = LFNoise2.kr(0.25).range(0.25, 20);
	freq = LFNoise0.kr(speed).range(40, 2000);
	snd = SinOsc.ar(freq, 0, 0.3);
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).play;
)




















