///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\sine, {
	var snd, freq, duration, env;
	freq = \freq.kr(440);
	duration = \duration.kr(1);
	env = EnvGen.kr(
		Env([0, 1, 0.9, 0], duration * [0.001, 0.1, 0.5].normalizeSum, [2, 0, -2]),
		doneAction: 2
	);
	snd = SinOsc.ar(freq);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\square, {
	var snd, freq, env;
	freq = \freq.kr(440);
	env = EnvGen.kr(Env([0, 1, 0.9, 0], [0.01, 0.1, 0.5], [2, 0, -2]), doneAction: 2);
	snd = Pulse.ar(freq);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\saw, {
	var snd, freq, env;
	freq = \freq.kr(440);
	env = EnvGen.kr(Env([0, 1, 0.9, 0], [0.01, 0.1, 0.5], [2, 0, -2]), doneAction: 2);
	snd = Saw.ar(freq);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), snd);
}).play;
)

///////////////////////////////////////////////////////////////////

(
SynthDef(\phsr, {
	var snd, freq, duration, env, lfo, fx;
	freq = \freq.kr(60);
	duration = \duration.kr(8);
	env = Env([0, 1, 0.65, 0], duration * [0.001, 0.2, 0.1].normalizeSum, [2, 0, -2]);
	env = EnvGen.kr(env, doneAction: 2);
	lfo = { |rate=1| LFNoise2.kr(rate).range(0, 8e-3).lag(0.02) };
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 6500);
	// fx = HPF.ar(LPF.ar(snd, 4000), 200);
	fx = (BPF.ar(snd, freq * (1..10) * LFNoise1.kr(4 ! 10, 6).midiratio, 0.2) * 0.dbamp).sum;
	// fx = snd;
	8.do { fx = AllpassL.ar(fx, 1, lfo.(0.5), 0); };
	snd = XFade2.ar(snd, fx, 0);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.2);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

(
SynthDef(\phsr, {
	var snd, freq, duration, env, lfo, fx;
	freq = \freq.kr(60);
	duration = \duration.kr(8);
	env = Env([0, 1, 0.65, 0], duration * [0.001, 0.2, 0.1].normalizeSum, [2, 0, -2]);
	env = EnvGen.kr(env, doneAction: 2);
	lfo = { |rate=1| SinOsc.kr(rate).range(0, 3e-3).lag(0.02) };
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 6500);
	// fx = HPF.ar(LPF.ar(snd, 4000), 200);
	fx = (BPF.ar(snd, freq * (1..10) * LFNoise1.kr(4 ! 10, 6).midiratio, 0.2) * 0.dbamp).sum;
	// fx = snd;
	8.do { fx = AllpassL.ar(fx, 1, lfo.(0.5), 0); };
	snd = XFade2.ar(snd, fx, 0);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.2);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\fm, {
	var snd, freq, duration, env;
	freq = \freq.kr(330) * LFNoise2.ar(8 ! 8, 0.1).midiratio * XLine.ar(2, 1, 0.003);
	duration = \duration.kr(1);
	env = EnvGen.kr(
		Env([0, 1, 0.9, 0], duration * [0.001, 0.4, 0.2].normalizeSum, [2, 0, -2]),
		doneAction: 2
	);
	snd = SinOsc.ar(freq * 4) * 1000;
	snd = SinOsc.ar(freq + snd).sum;
	snd = snd + snd.tanh;
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.1);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)

///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\fm2, {
	var snd, freq, duration, env;
	freq = \freq.kr(330) * LFNoise2.ar(8 ! 8, 0.1).midiratio * XLine.ar(2, 1, 0.003);
	duration = \duration.kr(1);
	env = EnvGen.kr(
		Env([0, 1, 0.9, 0], duration * [0.001, 0.4, 0.2].normalizeSum, [2, 0, -2]),
		doneAction: 2
	);
	snd = SinOsc.ar(freq * 4) * 1200;
	snd = SinOsc.ar(freq + snd).sum;
	snd = snd + snd.tanh;
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.1);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0, 3, 7, 10, 17].do { |int|
	var hz = (51 + int + (12 * 1)).midicps;
	Synth(\fm2, [freq: hz, amp: 0.5]);
};
)

///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\fm3, {
	var snd, freq, duration, env;
	freq = \freq.kr(110) * [-0.03, 0.03].midiratio * XLine.ar(0.1, 1, 0.005);
	duration = \duration.kr(1);
	env = EnvGen.kr(
		Env([0, 1, 0.9, 0], duration * [0.001, 0.4, 0.2].normalizeSum, [2, 0, -2]),
		doneAction: 2
	);
	snd = SinOsc.ar(freq * 4) * 2400;
	snd = SinOsc.ar(freq + snd).sum;
	snd = snd + (snd * 1).tanh;
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.15);
	1.do { snd = HPF.ar(snd, freq/2); };
	snd = BHiShelf.ar(snd, freq * 6, 0.5, -4);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0, 3, 7, 10, 17].do { |int|
	var hz = (51 + int + (12 * 1)).midicps;
	Synth(\fm3, [freq: hz, amp: 0.5, duration: 0.1]);
};
)

///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\fm4, {
	var snd, freq, duration, env;
	freq = \freq.kr(330) * [-0.03, 0.03].midiratio;
	duration = \duration.kr(0.5);
	env = EnvGen.kr(
		Env([0, 1, 0.9, 0], duration * [0.001, 0.4, 0.2].normalizeSum, [2, 0, -2]),
		doneAction: 2
	);
	snd = SinOsc.ar(freq * 4) * 1800;
	snd = SinOsc.ar(freq + snd).sum;
	snd = snd + (snd * 0.dbamp).tanh;
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.15);
	1.do { snd = HPF.ar(snd, freq/2); };
	snd = BHiShelf.ar(snd, freq * 2, 1, -4);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0, 3, 7, 10, 17].do { |int|
	var hz = (51 + int + (12 * 1)).midicps;
	Synth(\fm4, [freq: hz, amp: 0.5, duration: 0.1]);
};
)

///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\sqr, {
	var snd, freq, duration, env;
	freq = \freq.kr(440) * ([-0.1, 0.1] * SinOsc.ar(8, [0, pi], 0.5).unipolar).midiratio;
	duration = \duration.kr(1);
	env = Env([0, 1, 0.9, 0], duration * [0.001, 0.4, 0.2].normalizeSum, [2, 0, -2]);
	env = EnvGen.kr(env, doneAction: 2);
	snd =  Saw.ar(freq).sum;
	snd = LPF.ar(snd, freq * 9);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.15);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).play;
)







(
SynthDef(\saw, {
	var snd, freq, duration, env;
	freq = \freq.kr(330) * ([-0.2, 0.2] * Line.ar(1, 0.2, 0.2)).midiratio;
	freq = freq * XLine.ar(\bend.kr(0).midiratio, 1, 0.12);
	duration = \duration.kr(1);
	env = Env([0, 1, 0.8, 0], duration * [0.001, 0.4, 0.1].normalizeSum, [4, 0, -4]);
	env = EnvGen.kr(env, doneAction: 2);
	snd = Saw.ar(freq).sum + Pulse.ar(freq, mul: 1).sum * 0.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), freq * [1,2,4], 0.3) * Env.perc(0.001, 0.1 * [4,2,1]).ar * (1 / [1,2,4]).dbamp * 4.dbamp).sum;
	snd = snd + snd.tanh * -8.dbamp;
	snd = LPF.ar(snd, freq * 12);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1) * 0.06);
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, beat, bar, tatum, root, noteHz, seq;
s = Server.default;
beat = 60 / 138;
tatum = beat / 4;
bar = beat * 4;
root = 51;
noteHz = { |int=0, oct=0| (root + int + (12 * oct)).midicps; };
seq = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
	dur.wait;
};
Routine({
	loop {
		[
			// int, dur = = = = = = = = = = = = = = =
			[0, 3, -5], // 16 tatums
			[3, 3, 1],
			[7, 3, 0],
			[3, 7, -5],
			[5, 3, 0], // 16 tatums
			[8, 3, -5],
			[12, 3, 1],
			[8, 3, 0],
			[10, 2, -5],
			[14, 2, 0]
		].do { |spec|
			var int, dur, bend;
			# int, dur, bend = spec;
			seq.(\saw, tatum * dur, [freq: noteHz.(int, 1), bend: bend]);
		};
	};
}).play;
)


{([-0.03, 0.03] * SinOsc.ar(1).unipolar).midiratio}.plot(2);

BPF


///////////////////////////////////////////////////////////////////////////////////

[-0.02, 0.02].midiratio;

([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1] * 2 ) -1;






















///////////////////////////////////////////////////////////////////////////////////

