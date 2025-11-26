// ------------------------------------------------------------



(
SynthDef(\src, {
	var snd, freq, amp, env;
	amp = -20.dbamp * \amp.kr(1) * (1 + (2 * Env.perc(0.001, 0.01).ar));
	env = Env.perc(0.03, 3).ar(Done.freeSelf);
	freq = \freq.kr(260) * (LFNoise2.ar(20) * 0.2).midiratio;
	snd = CombC.ar(Pulse.ar(freq, 0.5), 0.2, 1 / 60, 0.3);
	snd = snd + BPF.ar(PinkNoise.ar(-4.dbamp), freq * 2, 0.2);
	snd = (snd * 2.dbamp).tanh;
	snd = LPF.ar(snd, Env.perc(0.02, 0.3).ar.linexp(0, 1, 500, 6000));
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.001, 2);
	snd = Pan2.ar(snd, \pan.kr(0), amp);
	snd = snd * env;
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, beat, tatum, root, scale, noteHz, play, makeStep;
s = Server.default;
beat = 60 / 72;
tatum = beat / 4;
root = 50;
scale = Scale.lydian.degrees ++ [0];
noteHz = { |int=0, oct=0| (root + int + (12 * oct)).midicps; };
play = { |synth, args| s.bind { Synth(synth, args); }; };
makeStep = {  (note: scale.choose, oct: (-1..3).choose, dur: [1, 2, 4].choose ) };
Routine({
	fork {
		loop {
			var steps = [2, 4, 8, 12].choose, repeat = [2, 4, 8, 12].choose;
			var pattern = makeStep ! steps;
			repeat.do {
				pattern.do { |spec|
					var args = [amp: rrand(0.1, 1.0), pan: spec[\oct].linlin(-1, 3, 0, 0.5) * rrand(-1, 1)];
					play.(\src, [freq: noteHz.(spec[\note], spec[\oct])] ++ args);
					(tatum * spec[\dur]).wait;
				};
			};
		};
	};
	loop {
		var steps = [2, 4, 8, 12].choose, repeat = [2, 4, 8, 12].choose;
		var pattern = makeStep ! steps;
		repeat.do {
			pattern.do { |spec|
				var args = [amp: rrand(0.1, 1.0), pan: spec[\oct].linlin(-1, 3, 0, 0.5) * rrand(-1, 1)];
				play.(\src, [freq: noteHz.(spec[\note], spec[\oct])] ++ args);
				(tatum * spec[\dur]).wait;
			};
		};
	};
}).play;
)


(
(50 + -5 + [0, 16 + 12, 19, 23]).postln.do { |int|
	Synth(\src, [freq: (int + (12 * 0)).midicps]);
};
)


(
(50 + 0 + [0, 16, 19, 23]).postln.do { |int|
	Synth(\src, [freq: (int + (12 * 0)).midicps]);
};
)

// ------------------------------------------------------------