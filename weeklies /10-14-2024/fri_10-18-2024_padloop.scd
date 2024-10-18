(
SynthDef(\pad1, {
	var snd, freq, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [2, 3]) * Env.perc(0, 3.0).ar * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = SinOsc.ar((freq * [1, 2]) + (60 * snd));
	snd = snd * [0, -10].dbamp;
	snd = snd.sum * -5.dbamp;
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd ! 2;
	snd = snd * -24.dbamp;
	snd = snd * Env.linen(0, duration, 0.001, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad2, {
	var snd, freq, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (LFNoise2.ar(3 ! 8) * 0.2).midiratio * [1, 2, 1, 2, 2, 1, 2, 1], LFNoise2.ar(3 ! 8).linlin(-1, 1, 0.1, 0.9));
	snd = snd * LFNoise2.ar(32 ! snd.size).linlin(-1, 1, 0.5, 1);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, freq * XLine.ar(1, 3, duration));
	snd = snd.tanh;
	snd = snd + DelayC.ar(snd * -10.dbamp, 0.2, SinOsc.ar(Rand(0.1, 0.3), [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 0.1e-3);
	snd = snd * freq.explin(100, 1000, 0, -10).dbamp;
	snd = snd * -20.dbamp;
	snd = snd * Env.linen(duration * 0.1, duration * 0.8, duration * 0.1, curve: \sin).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\padFx, {
	var snd, beat, fb;
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	fb = LocalIn.ar(2);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.08, 0.05] + (SinOsc.ar(0.3, [0, pi]) * 0.3e-3), 0.6);
	fb = AllpassC.ar(fb, 0.034, 0.034 * [1, 1.2], 0.3);
	fb = AllpassC.ar(fb, 0.026, 0.026 * [1.3, 1.2], 0.1);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.13, 0.06] + (SinOsc.ar(0.43, [0.3, 0.3pi]) * 0.2e-3), 0.6);
	fb = AllpassC.ar(fb, 1.0, 0.084 * [1, 1.4], 0.5);
	fb = AllpassC.ar(fb, 1.0, 0.056 * [1, 1.2], 0.6);
	fb = fb + LPF.ar(PitchShift.ar(fb * -16.dbamp, [0.2, 0.3], 2, 0.001), 1000);
	fb = fb + PitchShift.ar(fb * -16.dbamp, [0.34, 0.13], 0.5, 0.001);
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 50);
	fb = fb * -1.dbamp;
	LocalOut.ar(fb.reverse);
	snd = snd + fb;
	snd = snd * (1 - (0.8 * Env.perc(0.01, 0.5, curve: 4).ar(gate: T2A.ar(\trigger.tr(0)))));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, beat, tatum, playP, noteToFreq, wait;
s = Server.default;
beat = 60 / 190;
tatum = beat / 4;

playP = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};

wait = { |duration|
	(duration * beat).wait;
};

noteToFreq = { |note|
	(68 + note).midicps;
};

Routine({
	var padBus, padFx;
	s.bind {
		padBus = Bus.audio(nil, 2);
		padFx = Synth.tail(nil, \padFx, [in: padBus, out: 0, beat: beat * (3 / 2)]);
	};
	fork {
		var chord;
		chord = { |synthDef, duration, notes|
			notes.do { |note|
				playP.(synthDef, duration, [freq: (42 + note + (12 * 1)).midicps, out: padBus]);
			};
			wait.(duration);
		};
		loop {
			chord.(\pad1, 2, (0 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (0 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (0 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (0 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (8 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (8 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (7 + [-12, -5, 3, 10]));
			chord.(\pad1, 2, (7 + [-12, -5, 3, 10]));
			// chord.(\pad2, 10, [-24, -12, -12 + 7, 0, 2].reverse);
			// chord.(\pad2, 10, [-24, -12, -12 + 10, 0, 2].reverse);
			// chord.(\pad2, 10, [-24, -12, -12 + 8, 0, 2, 3]);
		};
	};
}).play;



)