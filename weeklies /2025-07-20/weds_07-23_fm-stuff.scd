(
SynthDef(\randomFm, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(ExpRand(100, 8000)) * Rand(1000, 3e3);
	5.do {
		snd = SinOsc.ar(ExpRand(100, 8000) + snd) * Rand(2e3, 8e3) * Line.kr(Rand(0.4, 1), Rand(0.4,1 ), duration);
		snd = Latch.ar(snd, Impulse.ar(ExpRand(8000, 16e3)));
		snd = BPF.ar(snd, ExpRand(100, 8000), ExpRand(0.5, 0.9));
	};
	snd = SinOsc.ar(ExpRand(100, 3000) + snd);
	snd = snd * Line.kr(Rand(0,1), Rand(0, 1), duration);
	snd = MoogFF.ar(snd, 4000, 0);
	snd = snd * Env.asr(0, 1, 0).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)


(
SynthDef(\fm, {
	var snd, snd2, freq, duration;
	duration = \duration.kr(4);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * 3) * 100;
	snd = SinOsc.ar((freq * 1) + snd) * (200 * Line.kr(0.5, 1, duration));
	snd2 = SinOsc.ar((freq * 8) + snd) * (300 * Line.kr(1, 0.25, duration));
	snd = SinOsc.ar(freq + (snd + snd2));
	snd = snd * Env.perc(0.001, duration).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.3);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
)

(
[0, 3, -5, 10].do { |deg|
	var hz = (52 + deg + (12 * 1)).midicps;
	Synth(\fm, [freq: hz]);
};
)


(
var s, beat, root, wait, play;
s = Server.default;
beat = 60 / 130;
root = 52;

wait = { |duration| duration.wait; };
play = { |synth, duration, args|
	s.bind { Synth(synth, [duration: duration] ++ args); };
	// wait.(duration);
};

Routine({
	Synth.tail(nil, \fxReverb, [in: ~reverbBus]);
	loop {
		[
			// b2 major (prygian) =================================
			(notes: (1 + [0, 4, 7, 11]), length: 3),
			(notes: (1 + [0, 4, 7, 11]), length: 1),
			// 2 dim ==============================================
			/*(notes: (2 + [0, 3, 6, 10]), length: 3),
			(notes: (2 + [0, 3, 6, 10]), length: 1),*/
			// 4 min =================================
			/*(notes: (5 + [-2, 0, 3, 7]), length: 3),
			(notes: (5 + [-2, 0, 3, 7]), length: 1),*/
			// 5 min ==============================================
			(notes: (7 + [-5, -2, 0, 3]), length: 3),
			(notes: (7 + [-5, -2, 0, 3]), length: 1),
			// b7 min ===========================================
			/*(notes: (10 + [-9, -5, -2, 0]), length: 3),
			(notes: (10 + [-9, -5, -2, 0]), length: 1),*/
			// 1 sus2 =============================================
			(notes: (0 + [0, 2, 7, 10]), length: 3),
			(notes: (0 + [0, 2, 7, 10]), length: 1),
			// 1 minor ============================================
			(notes: (0 + [0, 3, 7, 10]), length: 3),
			(notes: (0 + [0, 3, 7, 10]), length: 1),
		].do { |chord|
			chord[\notes].sort.do { |deg, index|
				[
					(octave: 2, amp: 0.5)
				].do { |voice|
					play.(\fm, (chord[\length] * beat), [
						freq: (root + (12 * voice[\octave]) + deg).midicps,
						// amp: (1 / (1 + index).cbrt) * voice[\amp],
						amp: 1 * voice[\amp],
						duration: (chord[\length] * beat),
						out: ~reverbBus
					]);
				};
			};
			wait.(chord[\length] * beat);
		};
	};
}).play;
)





