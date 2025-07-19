

(
SynthDef(\sqr, {
	var snd, freq, ampEnv, lfo;
	lfo = { |min=0, max=1| SinOsc.ar(1, 0).range(min, max)};
	freq = \freq.kr(330) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	ampEnv = Env.perc(0.001, 1).ar;
	snd = SinOsc.ar(freq, lfo.(0, pi), 0.3) + Pulse.ar(freq, lfo.(0.51, 0.5), 0.5);
	// snd = Saw.ar(freq, 0.4) + Pulse.ar(freq, lfo.(0.52, 0.5), 0.3);
	snd = (snd * ampEnv);
	snd = LPF.ar(snd, 1e4);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.5));
	snd = snd * Env.linen(0, \duration.kr(2), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\sin, {
	var snd, freq, ampEnv, lfo;
	lfo = { |min=0, max=1| SinOsc.ar(1, 0).range(min, max)};
	freq = (\freq.kr(330) * [1, 2]) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	ampEnv = Env.perc(0.01, 1).ar;
	snd = LFTri.ar(freq, 0, [0.4, 0.02]).sum + Pulse.ar(freq, mul: 0.05);
	snd = (snd * 4.dbamp).clip2;
	snd = (snd * ampEnv);
	// snd = LPF.ar(snd, 1e4);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.5));
	snd = snd * Env.linen(0, \duration.kr(2), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\fmPing, {
	var snd, freq, ampEnv, lfo;
	lfo = { |min=0, max=1| SinOsc.ar(1, 0).range(min, max)};
	freq = (\freq.kr(330)) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	ampEnv = Env.perc(\atl.kr(1e-3), \rel.kr(1)).ar;
	snd = SinOsc.ar(freq * [1, 2, 6, 14]) * [700, 300, 600, 300];
	snd = SinOsc.ar(freq + snd, 0, 0.2).sum;
	snd = (snd * 2.dbamp).tanh;
	snd = BLowShelf.ar(snd, 60, 1, -16);
	2.do { snd = HPF.ar(snd, 60); };

	snd = Pan2.ar((snd * ampEnv), \pan.kr(0), \amp.kr(1));
	snd = snd * Env.linen(0, \duration.kr(2), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
)


1 / 2.sqrt;
2.sqrt.reciprocal;

1e-3;

{SinOsc.ar(2, 0).range(0, pi)}.plot(1);
{SinOsc.ar(2, 0).range(0.5, 0.6)}.plot(1);


(
var s, beat, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 130;
root = 45;

wait = { |duration=1|
	(duration * beat).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	playParallel.(synthDef, duration, [duration: duration] ++ args, latency);
	wait.(duration * beat);
};

Routine({
	loop {
		[
			(deg: 0, length: 1, bend: 0),
			(deg: 12, length: 1, bend: -1),
			(deg: 8, length: 0.5, bend: 0),
			(deg: 7, length: 0.5, bend: 1),
			(deg: 1, length: 1, bend: 0),
		].do { | note |
			var noteHz = (root + note[\deg] + (12 * 1)).midicps;
			play.(\fmPing, note[\length], [freq: noteHz, bend: note[\bend]]);
		};
	};
}).play;
)

















// endfile