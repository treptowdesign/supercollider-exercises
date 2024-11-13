// Trip back to LA

(
SynthDef(\detSaw, {
	var snd, count, freq, duration;
	count = 10;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (( {LFNoise2.kr(0.4)} ! count) * 0.2).midiratio, { Rand(0 , 2pi) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.linen(0.01, duration, 0.1).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\detPulse, {
	var snd, count, freq, duration;
	count = 10;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = Pulse.ar(freq * (( {LFNoise2.kr(0.4)} ! count) * 0.1).midiratio, { Rand(0.01 , 0.99) } ! count);
	snd = Splay.ar(snd) * -20.dbamp;
	snd = snd * Env.linen(0.05, duration, 0.1).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
var s, beat, root;
s = Server.default;
beat = 60 / 110;
root = 42;

Routine({
	var dur, note, octave, chordBass, chordIntervals;
	octave = 1;
	loop {
		[
			(intervals: 0 + [-12, 4, -5, 11], length: 2, bend: 0),
			(intervals: 7 + [-12, 4, -5, 10], length: 2, bend: -6),
			(intervals: 9 + [-12, 3, -5, 10], length: 2, bend: -6),
			(intervals: 5 + [-12, 4, -5, 11], length: 2, bend: 6),
		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\detPulse, [freq: note , duration: dur, bend: chord[\bend]]); };
			};
			dur.wait;
		};


	};
}).play;
)


(
var s, beat, root;
s = Server.default;
beat = 60 / 110;
root = 42;

Routine({
	var dur, note, octave, chordBass, chordIntervals;
	octave = 1;
	loop {
		[
			(intervals: 0 + [0, 4, 7, 11], length: 2, bend: 0),
			(intervals: 7 + [0, 4, 7, 10], length: 2, bend: -6),
			(intervals: 9 + [0, 3, 7, 10], length: 2, bend: -6),
			(intervals: 5 + [0, 4, 7, 11], length: 2, bend: 6),
		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\detPulse, [freq: note , duration: dur, bend: chord[\bend]]); };
			};
			dur.wait;
		};


	};
}).play;
)


(
SynthDef(\bendBass, {
	var snd, freq;
	freq = \freq.kr(110) * Line.kr(\bend.kr(0), 0, 0.4).midiratio;
	snd = Pulse.ar(freq);
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	snd = snd * \amp.kr(-6.dbamp);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

Synth(\bendBass, [bend: -5]);



(
SynthDef(\fmTest5, {
	var snd, rangeL, rangeH;
	rangeL = \rangeL.kr(80);
	rangeH = \rangeH.kr(8000);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH)) * Env.perc(0.001, ExpRand(0.001, 1), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH) + snd) * Env.perc(0.001, ExpRand(0.001, 1), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	// snd = SinOsc.ar(ExpRand(rangeL, rangeH) + snd) * Env.perc(0.001, ExpRand(0.001, 1), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	// snd = SinOsc.ar(ExpRand(rangeL, rangeH) + snd) * Env.perc(0.001, ExpRand(0.001, 1), curve: Rand(-8, 8)).ar * Rand(rangeL, rangeH);
	snd = SinOsc.ar(ExpRand(rangeL, rangeH));
	snd = (snd * 8).tanh;
	// snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, \duration.kr(1), 0.0, 0.001).ar;
	snd = snd * \amp.kr(-20.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.1).ar(Done.freeSelf);
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
			s.bind { Synth(\fmTest5, [duration: (beat / speed), pan: rrand(-0.5, 0.5)]); };
			(beat / speed).wait;
		}
	};
}).play;
)


(
SynthDef(\fmThing, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(90);
	snd = SinOsc.ar(freq * [4, 3, 2]) * Env.perc(0, 5).ar * (1 + (2 * Env.perc(0, 0.02).ar));
	snd = SinOsc.ar((freq * [1, 2, 1]) + (600 * snd * (LFNoise2.ar(0.2) * 0.1).midiratio));
	snd = snd * [0, -10, -20].dbamp * (1 + ( { LFNoise2.ar(0.2) } ! snd.size * 0.1));
	snd = snd.sum * -5.dbamp;
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * -5.dbamp * \amp.kr(1);
	snd = LPF.ar(snd, 10000);
	snd = snd * Env.linen(0.05, duration, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)











