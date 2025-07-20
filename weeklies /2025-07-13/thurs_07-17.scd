
{Env.perc(0.1, 0.5).kr.linexp(0, 1, 100, 3e4)}.plot(1);
{Env.perc(0.1, 0.5).kr.linexp(0, 1, 100, 3e4)}.plot(1);

3e4

(
SynthDef(\sqr, {
	var snd, wet, freq, ampEnv, lfo;
	lfo = { |rate=1, min=0, max=1| SinOsc.ar(rate, 0).range(min, max).lag(0.02) };
	freq = \freq.kr(440) * Line.kr(\bend.kr(-2), 0, 0.1).midiratio;
	ampEnv = Env.perc(0.001, \rel.kr(1)).ar;
	snd = SinOsc.ar(freq, 0.5pi, 0.4) + Pulse.ar(freq, lfo.(1, 0.5, 0.52), 0.6);
	// snd = Saw.ar(freq, 0.4) + Pulse.ar(freq, lfo.(0.52, 0.5), 0.3);
	snd = (snd * ampEnv);

	// snd = LPF.ar(snd, freq.expexp(100, 2000, 2e3, 8e3));
	// snd = LPF.ar(snd, Env.perc(0.05, 0.5).kr.linlin(0, 1, 100, 8e3));
	// snd = RLPF.ar(snd, Env.perc(0, 2).ar.linexp(0, 1, 100, freq.expexp(100, 2000, 3e3, 4e3)), 0.4);

	snd = RLPF.ar(snd, Env.perc(0.05, 0.5).kr.linlin(0, 1, 100, 8e3), 0.8);

	/*wet = DelayC.ar(snd, 0.03, lfo.(1, 0, 3e-3));
	snd = XFade2.ar(snd, wet, -0.6);*/

	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.5));
	snd = snd * Env.linen(0, \duration.kr(2), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\tri, {
	var snd, wet, freq, ampEnv, lfo;
	lfo = { |rate=1, min=0, max=1| SinOsc.ar(rate, 0).range(min, max).lag(0.02) };
	freq = (\freq.kr(330) * [0, 0.1].midiratio) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	ampEnv = Env.perc(0.001, 1).ar;
	snd = LFTri.ar(freq, Rand(0, pi), 0.4).sum;
	// snd = Saw.ar(freq, 0.4) + Pulse.ar(freq, lfo.(0.52, 0.5), 0.3);
	snd = (snd * ampEnv);
	// snd = LPF.ar(snd, freq.expexp(100, 2000, 2e3, 5e3));

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
	var snd, wet, freq, ampEnv, lfo;
	lfo = { |rate=1, min=0, max=1| SinOsc.ar(rate).range(min, max)};
	freq = (\freq.kr(330)) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	ampEnv = Env.perc(\atl.kr(1e-3), \rel.kr(1)).ar;
	snd = SinOsc.ar(freq * [1, 2, 4, 13]) * [700, 1000, 1400, 500];
	snd = SinOsc.ar(freq + snd, [0, 0.5pi, 0, 0.25pi], 0.2).sum;



	/*wet = Latch.ar(snd, Impulse.ar(9850));
	wet = LPF.ar(wet, 3000);
	snd = XFade2.ar(snd, wet, 0);*/
	// snd = RLPF.ar(snd, freq * 3, 0.3);

	snd = snd + 0.1;
	snd = (snd * 4.dbamp).tanh;
	snd = LeakDC.ar(snd);

	// snd = Latch.ar(snd, Impulse.ar(XLine.kr(16000, 1000, \duration.kr(2))));

	// wet = DelayC.ar(snd, 0.03, lfo.(1, 0, 1e-3));
	// snd = XFade2.ar(snd, wet, -0.5);

	snd = Pan2.ar((snd * ampEnv), \pan.kr(0), \amp.kr(1));
	snd = snd * Env.linen(0, \duration.kr(2), 0.1).ar(Done.freeSelf);

	// snd = BLowShelf.ar(snd, 60, 1, -16);
	// 2.do { snd = HPF.ar(snd, 60); };

	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
)


1 / 2.sqrt;
2.sqrt.reciprocal;

1e-3;

{SinOsc.ar(2, 0).range(0, pi)}.plot(1);
{SinOsc.ar(2, 0).range(0.5, 0.6)}.plot(1);



(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 45;

wait = { |duration=1|
	(duration * beat).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	playParallel.(synthDef, duration, [duration: duration] ++ args, latency);
	wait.(duration);
};

Routine({
	loop {
		[
			(deg: 0, length: (beat * 2) / 3, bend: 0, rel: 0.5),
			(deg: 5, length: (beat * 2) / 3, bend: 0, rel: 0.5),
			(deg: 10, length: (beat * 2) / 3, bend: 0, rel: 0.5),

			(deg: -2, length: (beat * 2) / 3, bend: 0, rel: 0.5),
			(deg: 0, length: (beat * 2) / 3, bend: 0, rel: 0.5),
			(deg: 8, length: (beat * 2) / 3, bend: 0, rel: 0.5),

			(deg: 7, length: (beat * 2), bend: 0, rel: 1),
			(deg: 0, length: (beat * 2), bend: 7, rel: 1),



		].do { | note |
			var noteHz = (root + note[\deg] + (12 * 1)).midicps;
			play.(\fmPing, note[\length], [
				freq: noteHz,
				bend: note[\bend],
				rel: note[\rel]
			]);
		};
	};
}).play;
)















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
			(deg: 0, length: 1, bend: 0, rel: 1),
			(deg: 12, length: 0.5, bend: -2, rel: 0.5),
			(deg: 12, length: 0.5, bend: 0, rel: 0.5),
			(deg: 8, length: 1, bend: 0, rel: 1),
			(deg: 7, length: 1, bend: 2, rel: 1),
			(deg: 7, length: 1, bend: 0, rel: 1),
			(deg: 8, length: 1, bend: 0, rel: 1),
			(deg: 5, length: 1, bend: 0, rel: 1),
			(deg: 7, length: 1, bend: 2, rel: 1),
		].do { | note |
			var noteHz = (root + note[\deg] + (12 * 1)).midicps;
			play.(\sqr, note[\length], [
				freq: noteHz,
				bend: note[\bend],
				rel: note[\rel]
			]);
		};
	};
}).play;
)

















// endfile