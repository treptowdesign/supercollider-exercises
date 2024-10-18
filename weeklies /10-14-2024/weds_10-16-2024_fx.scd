(
SynthDef(\pad, {
	var snd, freq, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [2, 1]) * Env.perc(0, 3.0).ar * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = SinOsc.ar((freq * [1, 0.5]) + (60 * snd));
	snd = snd * [0, -10].dbamp;
	snd = snd.sum * -5.dbamp;
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * -24.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0, duration, 0.001, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\padFx, {
	var snd, fb, scTrig;
	scTrig = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	fb = LocalIn.ar(2);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.1, 0.11] + (SinOsc.ar(0.3, [0, pi]) * 0.3e-3));
	fb = AllpassC.ar(fb, 0.034, 0.03 * [1, 0.8], 0.4);
	// fb = AllpassC.ar(fb, 0.026, 0.026 * [1.3, 1.2], 0.1);
	fb = fb + snd;
	// fb = DelayC.ar(fb, 1.0, [0.13, 0.06] + (SinOsc.ar(0.43, [0.3, 0.3pi]) * 0.2e-3));
	// fb = AllpassC.ar(fb, 1.0, 0.084 * [1, 1.4], 0.5);
	// fb = AllpassC.ar(fb, 1.0, 0.056 * [1, 1.2], 0.6);
	// fb = fb + LPF.ar(PitchShift.ar(fb * -16.dbamp, [0.2, 0.3], 2, 0.001), 1000);
	// fb = fb + PitchShift.ar(fb * -16.dbamp, [0.34, 0.13], 0.5, 0.001);
	// fb = LPF.ar(fb, 8000);
	// fb = HPF.ar(fb, 60);
	// fb = fb * -1.dbamp;
	LocalOut.ar(fb.reverse);
	snd = snd + fb;
	snd = snd * (1 - (0.8 * Env.perc(0.01, 0.3, curve: 8).ar(gate: scTrig)));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~padBus = Bus.audio(nil, 2); // Bus.audio(server, numChannels: 1)
)

~padBus.index;


(
var s, padFx, beat;
s = Server.default;
beat = 60 / 110;

padFx = Synth.tail(nil, \padFx, [in: ~padBus, out: 0]);

Routine({
	var dur, note;
	dur = beat;
	fork {
		loop {
			// s.bind { padFx.set(\trigger, 1); }; // sidechain...
			[-12, 0, 3, 7, 10].do { |interval|
				note = (42 + interval + (12 * 1)).midicps;
				s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.6, out: ~padBus]); };
				note = (42 + interval + (12 * 2)).midicps;
				s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.1, out: ~padBus]); };
				note = (42 + interval + (12 * 3)).midicps;
				s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.1, out: ~padBus]); };
			};
			dur.wait;
		};
	};
}).play;

)

