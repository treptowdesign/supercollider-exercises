

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
	freq = (\freq.kr(440) * [1, 2]) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	ampEnv = Env.perc(0.001, 1).ar;
	snd = LFTri.ar(freq, 0, [0.4, 0.06]).sum + Pulse.ar(freq, mul: 0.05);
	snd = (snd * 4.dbamp).clip2;
	snd = (snd * ampEnv);
	// snd = LPF.ar(snd, 1e4);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.5));
	snd = snd * Env.linen(0, \duration.kr(2), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


1 / 2.sqrt;

{SinOsc.ar(2, 0).range(0, pi)}.plot(1);
{SinOsc.ar(2, 0).range(0.5, 0.6)}.plot(1);


