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
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.3).midiratio;
	snd = Pulse.ar(freq * (( {LFNoise2.kr(0.4)} ! count) * 0.2).midiratio, { Rand(0.01 , 0.99) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.linen(0.02, duration, 0.1).ar(Done.freeSelf);
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
	octave = 2;
	loop {
		[
			(intervals: 0 + [-12, 4, -5], length: 2, bend: 6),
			(intervals: 7 + [-12, 4, -5], length: 2, bend: -6),
			(intervals: 9 + [-12, 3, -5], length: 2, bend: -6),
			(intervals: 5 + [-12, 4, -5], length: 2, bend: 6),
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
	freq = \freq.kr(110) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = Pulse.ar(freq);
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.dbamp);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

Synth(\bendBass, [bend: -12]);




