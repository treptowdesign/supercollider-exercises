

(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 65, 1500) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.5, 0.5));
	snd = snd * Env.perc(0.001, 0.5).ar;
	snd = snd ! 2;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [1640, 1880], [0.3, 0.6]).sum;
	snd = snd * 18.dbamp;
	snd = snd * (1 + ( 2 * Env.perc(0, 0.1).ar));
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.004, 1e-4, 0.003, 1e-4, 0.08] * 0.8, -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.5));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, amp;
	amp = \amp.kr(1);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [9420, 14030] * amp.linlin(0, 1, 1.5, 1), 0.3).sum;
	snd = snd * Env.perc(0.0001, 0.06 * amp.linlin(0, 1, 0.7, 1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), amp);
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, bar, seq;
s = Server.default;
beat = 60 / 169;
bar = beat * 4;

seq = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
	dur.wait;
};

Routine({
	loop {
		fork {
			4.do {
				[1, 0.3, 0.8, 0.7, 0.5, 0.9, 0.6, 0.8].do { |amp|
					seq.(\hat, beat/2, [amp: amp]);
				};
			};
		};
		// bar 1
		3.do {
			seq.(\kick, beat);
			seq.(\kick, beat);
			seq.(\clap, beat/2);
			seq.(\kick, beat/4, [amp: 0.5]);
			seq.(\kick, beat/2);
			seq.(\kick, beat/4, [amp: 0.5]);
			seq.(\kick, beat/2);
		};
		// bar 2
		seq.(\kick, beat);
		seq.(\kick, beat);
		seq.(\clap, beat/2);
		seq.(\kick, beat/4, [amp: 0.25]);
		seq.(\kick, beat/4);
		seq.(\kick, beat/4, [amp: 0.5]);
		seq.(\kick, beat/4);
		seq.(\kick, beat/2);
	};
}).play;
)






(
SynthDef(\bassRandom, {
	var snd, freq, duration;
	freq = \freq.kr(60) * XLine.ar(2, 1, 0.01);
	duration = \duration.kr(0.1);
	snd = SinOsc.ar(freq) + Pulse.ar(freq);
	// snd = RLPF.ar(snd, ExpRand(100, 600), 0.3);
	snd = RLPF.ar(snd, 300, 0.3);
	snd = snd + Latch.ar(snd * -20.dbamp, Impulse.ar(3000));
	snd = snd + (GVerb.ar(snd, 30, 1) * -7.dbamp);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)









// endfile