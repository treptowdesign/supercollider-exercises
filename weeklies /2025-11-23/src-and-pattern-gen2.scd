// ------------------------------------------------------------



(
SynthDef(\src, {
	var snd, freq, amp, env;
	amp = -25.dbamp * \amp.kr(1) * (1 + (2 * Env.perc(0.001, 0.01).ar));
	env = Env.perc(0.03, \rel.kr(2)).ar(Done.freeSelf);
	freq = \freq.kr(260) * (LFNoise2.ar(30 ! 2) * \detune.kr(0.1)).midiratio;
	snd = CombC.ar(Pulse.ar(freq, \pw.kr(0.5)).sum, 0.2, 1 / 65, 0.1);
	snd = snd + BPF.ar(PinkNoise.ar(20.dbamp), freq.mean * 2, 0.1);
	snd = (snd * 2.dbamp).tanh;
	snd = LPF.ar(snd, Env.perc(0.02, 0.3).ar.linexp(0, 1, 500, 9000));
	snd = snd + PitchShift.ar(snd * -5.dbamp, \window.kr(0.1), 2);
	snd = snd + PitchShift.ar(snd * -12.dbamp, 0.001, 0.5);
	snd = Pan2.ar(snd * env, \pan.kr(0), amp);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\srcFx, {
	var snd, fb, beat;
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	snd = BLowShelf.ar(snd, 400, 1, 5);
	// delay
	fb = snd;
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 1.0, (beat * 1) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 2e-3));
	fb = fb * -5.dbamp;
	fb = HPF.ar(LPF.ar(fb, 3000), 500);
	LocalOut.ar(fb);
	snd = snd + fb;
	// reverb
	snd = snd + GVerb.ar(snd * -10.dbamp, 30, 2, 0.1);
	snd = snd * 0.dbamp;
	// stereo widening
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, beat, tatum, root, scale, scaleWeights, noteHz, play, makeStep;
s = Server.default;
s.newBusAllocators; // reset busses
beat = 60 / 72;
tatum = beat / 4;
root = 50;
scale = Scale.phrygian.degrees;
scaleWeights = [3, 1, 2, 3, 3, 1, 2].normalizeSum;
noteHz = { |int=0, oct=0| (root + int + (12 * oct)).midicps; };
play = { |synth, args| s.bind { Synth(synth, args); }; };
makeStep = { (
	note: scale.wchoose(scaleWeights),
	oct: (-2..4).wchoose([0.5, 1, 3, 4, 4, 3, 2].normalizeSum),
	dur: [1, 2, 4].choose
) };
Routine({
	var fxBus, srcFx, playSequence;
	s.bind {
		fxBus = Bus.audio(nil, 2);
		srcFx = Synth.tail(nil, \srcFx, [in: fxBus, out: 0, beat: tatum]);
	};
	playSequence = {
		var steps = [2, 4, 8].choose, repeat = [4, 8, 16].choose;
		var pattern = makeStep ! steps;
		repeat.do {
			pattern.do { |spec|
				var args = [amp: rrand(0.1, 1.0)];
				args = args ++ [pan: spec[\oct].linlin(-1, 3, 0.0, 0.5) * rrand(-1, 1)];
				args = args ++ [rel: beat * rrand(1, 6)];
				args = args ++ [detune: rrand(0.1, 0.4)];
				args = args ++ [pw: [0.1, 0.2, 0.3, 0.4, 0.5].wchoose([1, 2, 3, 4, 5].normalizeSum)];
				args = args ++ [window: [0.1, 0.01, 0.001].choose];
				args = args ++ [out: fxBus];
				play.(\src, [freq: noteHz.(spec[\note], spec[\oct])] ++ args);
				(tatum * spec[\dur]).wait;
			};
		};
	};
	// LOOP ////////////////////////////////////////
	fork { loop { playSequence.(); }; };
	loop { playSequence.(); };
	// LOOP ////////////////////////////////////////
}).play;
)


(-1..3);

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