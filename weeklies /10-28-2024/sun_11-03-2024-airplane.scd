// Messing around on airplane to Mexico

(
SynthDef(\sin, {
	var snd;
	snd = SinOsc.ar(440);
	snd = snd * Env.perc(0.01, 0.4).ar(Done.freeSelf);
	Out.ar(0, snd * -10.dbamp ! 2);
}).play;
)

(
SynthDef(\fm, {
	var snd;
	snd = SinOsc.ar(ExpRand(1000, 8000)) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd);
	snd = (snd * 10).fold2;
	snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, ExpRand(0.01, 0.5), 0.0, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\fmTest, {
	var snd;
	snd = SinOsc.ar(ExpRand(1000, 8000)) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd);
	snd = (snd * 10).tanh;
	snd = snd * Env.adsr(0.001, ExpRand(0.01, 0.5), 0.0, 0.001).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\fmTest2, {
	var snd;
	snd = SinOsc.ar(ExpRand(100, 8000)) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(100, 8000);
	snd = SinOsc.ar(ExpRand(100, 8000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(100, 8000);
	snd = SinOsc.ar(ExpRand(100, 8000) + snd);
	snd = (snd * 10).tanh;
	// snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, \duration.kr(0.4), 0.0, 0.001).ar;
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.001, \duration.kr(0.4), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
var s, beat, tatum;
s = Server.default;
beat = 60 / 110;
tatum = beat / 4;

Routine({
	var speed;
	loop {
		speed = [1, 2, 4, 8].choose;
		speed.do {
			s.bind { Synth(\fmTest2, [duration: beat / speed, pan: rrand(-0.5, 0.5)]); };
			(beat / speed).wait;
		}
	};
}).play;
)





(
SynthDef(\fmTest3, {
	var snd, rangeL, rangeH;
	rangeL = \rangeL.kr(100);
	rangeH = \rangeH.kr(8000);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH)) * Env.perc(0.001, ExpRand(0.001, 0.5), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH) + snd);
	snd = (snd * 12).tanh;
	snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, \duration.kr(0.4), 0.0, 0.001).ar;
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.001, \duration.kr(0.4), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
var s, beat, tatum;
s = Server.default;
beat = 60 / 110;
tatum = beat / 4;
Routine({
	var speed;
	loop {
		speed = [1, 2, 4, 8, 16].choose;
		speed.do {
			s.bind { Synth(\fmTest4, [duration: (beat / speed) * 2, pan: rrand(-0.5, 0.5)]); };
			(beat / speed).wait;
		}
	};
}).play;
)


(
SynthDef(\fmTest4, {
	var snd, rangeL, rangeH;
	rangeL = \rangeL.kr(60);
	rangeH = \rangeH.kr(16000);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH)) * Env.perc(0.001, ExpRand(0.001, 1), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH) + snd) * Env.perc(0.001, ExpRand(0.001, 1), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH));
	snd = (snd * 8).tanh;
	snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, \duration.kr(1), 0.0, 0.001).ar;
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)





////////////////
// Supersaw
////////////////

(
SynthDef(\detSaw, {
	var snd, count, freq, duration;
	count = 10;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * Line.kr(\bend.kr(-6), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (( {LFNoise2.kr(0.4)} ! count) * 0.3).midiratio, { Rand(0 , 2pi) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	// snd = snd * Env.perc(0.01, 4).ar(Done.freeSelf);
	snd = snd * Env.linen(0.01, duration, 0.1).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
Synth(\detSaw, [freq: (42 + 0 + (12 * 4)).midiratio]);
Synth(\detSaw, [freq: (42 + 3 + (12 * 4)).midiratio]);
Synth(\detSaw, [freq: (42 + 7 + (12 * 4)).midiratio]);
)

(
SynthDef(\detPulse, {
	var snd, count, freq, duration;
	count = 10;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * Line.kr(\bend.kr(-6), 0, 0.2).midiratio;
	snd = Pulse.ar(freq * (( {LFNoise2.kr(0.4)} ! count) * 0.2).midiratio, { Rand(0.01 , 0.99) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.1).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
Synth(\detPulse, [freq: (42 + 0 + (12 * 4)).midiratio]);
Synth(\detPulse, [freq: (42 + 3 + (12 * 4)).midiratio]);
Synth(\detPulse, [freq: (42 + 7 + (12 * 4)).midiratio]);
)

(
SynthDef(\detSin, {
	var snd, count, freq, duration;
	count = 5;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * Line.kr(\bend.kr(-6), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq * (( {LFNoise2.kr(0.4)} ! count) * 0.4).midiratio, { Rand(0 , 2pi) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.1).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
Synth(\detSin, [freq: (42 + 0 + (12 * 5)).midiratio]);
Synth(\detSin, [freq: (42 + 3 + (12 * 5)).midiratio]);
Synth(\detSin, [freq: (42 + 7 + (12 * 5)).midiratio]);
)













