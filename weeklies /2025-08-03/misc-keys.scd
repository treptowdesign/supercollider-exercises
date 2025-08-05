(
SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(2, 1, 0.004);
	snd = SinOsc.ar(freq * 2) * Env.perc(0.01, 0.6).ar * 900;
	snd = SinOsc.ar(freq + snd);
	snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 5e-3) * LFNoise2.kr(12 ! 2) * 0.dbamp);
	snd = Pan2.ar(snd.sum, 0, 1);
	snd = snd * Env.perc(0.01, 10, curve: -10).ar(Done.freeSelf);
	snd = snd * -24.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0, 4, 7, 11].do { |int|
	Synth(\key, [freq: (51 + int + (12 * 1)).midicps]);
};
)


(
SynthDef(\pow, {
	var snd, freq, duration;
	freq = \freq.kr(110);
	duration = \duration.kr(4);
	snd = SinOsc.ar(freq * 3) * (300 * (LFNoise2.ar(2) * 10).midiratio);
	snd = SinOsc.ar(freq * (LFNoise2.ar(4 ! 8) * 0.2).midiratio + snd).pow(Line.ar(5, 2, duration)).fold2(Line.ar(0.8, 0.3, duration)) * 0.3;
	snd = (snd * 1.dbamp).tanh;
	snd = Splay.ar(snd, \spread.kr(1), \amp.kr(1));
	snd = snd * Env.perc(0.01, 6).ar;
	snd = snd * Env.linen(0, duration, 0.2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
[0, 4, 7, 11].do { |int|
	Synth(\pow, [freq: (51 + int + (12 * 1)).midicps]);
};
)


(
var s, beat, root, bar, play, noteHz;
s = Server.default;
beat = 60 / 169 * 1;
bar = beat * 4;
root = 51;

play = { |synth, dur, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synth, [duration: dur] ++ args); };
	};
};

noteHz = { |deg=0, octave=0|
	(root + deg + (12 * octave)).midicps;
};

Routine({
	loop {
		'- - - - - - - -'.postln;
		[
			(0 + [0, 3, 7, 10]),
			(3 + [0, 4, 7, 11]),
			(8 + [0, 3, 7, 10 -12]),
			(7 + [0, 3, 7, 10 -12])
		].do { |chord|
			chord.sort.postln.do { |int, index|
				play.(\pow, bar, [freq: noteHz.(int, 0)]);
			};
			(bar).wait;
		};
	};
}).play;
)

2 ** (1..4);


(
SynthDef(\tstLead, {
	var snd, freq;
	freq = \freq.kr(110);
	snd = SinOsc.ar(freq * 1) * (1000 * Env.perc(0.1, 1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = BPF.ar(snd, freq * (2 ** (1..4)), 0.3).sum * 6.dbamp;
	// snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 1e-3) * LFNoise2.kr(12 ! 3) * -4.dbamp) * 0.3;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.3);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\tstLead, {
	var snd, freq;
	freq = \freq.kr(110);
	snd = SinOsc.ar(freq).sign;
	snd = BPF.ar(snd, freq * (2 ** (1..4)), 0.3).sum * 6.dbamp;
	// snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 1e-3) * LFNoise2.kr(12 ! 3) * -4.dbamp) * 0.3;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.3);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\tstLead, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = LFTri.ar(freq);
	snd = BPF.ar(snd, freq * (2 ** (1..8)), 0.3).sum * 6.dbamp;
	// snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 1e-3) * LFNoise2.kr(12 ! 3) * -4.dbamp) * 0.3;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.6);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\tstLead, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = SinOsc.ar(freq).sign;
	snd = BPF.ar(snd, freq * [1, 2, 4, 6, 8, 10], 0.3).sum * 3.dbamp;
	// snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 1e-3) * LFNoise2.kr(12 ! 3) * -4.dbamp) * 0.3;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.3);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\tstLead, {
	var snd, freq;
	freq = \freq.kr(180);
	snd = SinOsc.ar(freq).sign;
	snd = BPF.ar(snd, freq * (1..12), 0.3).sum * -2.dbamp;
	// snd = Latch.ar(snd, Impulse.ar(3500));
	snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(9 ! 3).linlin(-1, 1, 0, 1) * 1e-3) * LFNoise2.kr(12 ! 3) * -4.dbamp) * 0.3;
	snd = Pan2.ar(snd.sum, \pan.kr(0), \amp.kr(1) * 0.3);

	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\tstLead, {
	var snd, freq;
	freq = \freq.kr(110);
	snd = Pulse.ar(freq);
	snd = BPF.ar(snd, freq * (1..10), 0.35).sum;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.1);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


{  * 0.1 ! 2}.play;




{ SinOsc.ar(220).sign * 0.1 ! 2}.play;

{ BPF.ar(SinOsc.ar(220).sign, 220 * (1..6), 0.3).sum * 0.1 ! 2}.play;

{ Pulse.ar(220) * 0.1 ! 2}.play;








