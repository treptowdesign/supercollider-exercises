(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 58, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01;
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -16.dbamp * \amp.kr(1);
	snd = BLowShelf.ar(snd, 300, 0.4, 5);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1440, 0.3) * 30.dbamp;
	snd = snd + (snd * 2.dbamp).tanh;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.18], curve: -12).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd, 0) * -28.dbamp);
}).add;
SynthDef(\hat, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(34 * [1, 2.23, 3.45, 5.7, 7.8]).sum;
	snd = FreqShift.ar(snd, 41.2);
	snd = snd + (Hasher.ar(Sweep.ar) * -8.dbamp);
	snd = snd * Env.perc(0.005, 0.03).ar;
	snd = BPF.ar(snd, 7923 * [1, 1.5] * XLine.ar(1, 1.3, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 5000);
	snd = snd * -12.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 0.1, [44e-3, 23e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(24 * [1, 2.23, 3.45, 5.7, 7.8]).sum;
	snd = FreqShift.ar(snd, 41.2);
	snd = snd + (Hasher.ar(Sweep.ar) * -8.dbamp);
	snd = snd * Env.perc(0.001, 0.09).ar;
	snd = BPF.ar(snd, 8923 * [1, 1.5] * XLine.ar(1, 1.4, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 6000);
	snd = snd * -9.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 1, [0.8, 0.6]), 300), 3000);
	snd = snd * Env.linen(0, duration, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
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
	fb = DelayC.ar(fb, 1.0, [0.1, 0.14] + (SinOsc.ar(0.3, [0, pi]) * 0.3e-3));
	fb = AllpassC.ar(fb, 0.034, 0.034 * [1, 1.2], 0.3);
	fb = AllpassC.ar(fb, 0.026, 0.026 * [1.3, 1.2], 0.1);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.13, 0.06] + (SinOsc.ar(0.43, [0.3, 0.3pi]) * 0.2e-3));
	fb = AllpassC.ar(fb, 1.0, 0.084 * [1, 1.4], 0.5);
	fb = AllpassC.ar(fb, 1.0, 0.056 * [1, 1.2], 0.6);
	fb = fb + LPF.ar(PitchShift.ar(fb * -16.dbamp, [0.2, 0.3], 2, 0.001), 1000);
	fb = fb + PitchShift.ar(fb * -16.dbamp, [0.34, 0.13], 0.5, 0.001);
	fb = LPF.ar(fb, 8000);
	fb = HPF.ar(fb, 60);
	fb = fb * -1.dbamp;
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
	// KICK+SIDECHAIN FORK //////////////////////////////////////////////////////
	fork {
		loop {
			// bar //////////////////////
			4.do {
				s.bind { Synth(\kick); };
				dur.wait;
			};
			// bar //////////////////////
			/*s.bind { Synth(\kick); };
			(dur/2 - 0.02).wait;
			s.bind { Synth(\kick, [amp: 0.8]); };
			(dur/2 + 0.02).wait;

			3.do {
				s.bind { Synth(\kick); };
				dur.wait;
			};
			// bar //////////////////////
			4.do {
				s.bind { Synth(\kick); };
				dur.wait;
			};
			// bar //////////////////////
			s.bind { Synth(\kick); };
			(dur/3).wait;
			s.bind { Synth(\kick, [amp: 0.6]); };
			(dur/3 - 0.025).wait;
			s.bind { Synth(\kick, [amp: 0.9]); };
			(dur/3 + 0.025).wait;

			3.do {
				s.bind { Synth(\kick); };
				dur.wait;
			};*/

		};
	};
	// PAD FORK //////////////////////////////////////////////////////
	fork {
		loop {
			s.bind { padFx.set(\trigger, 1); }; // sidechain
			[-12, 0, 3, 7, 10].do { |interval|
				note = (42 + interval + (12 * 1)).midicps;
				s.bind { Synth(\pad, [freq: note, duration: dur, amp: 0.5, out: ~padBus]); };
				note = (42 + interval + (12 * 2)).midicps;
				s.bind { Synth(\pad, [freq: note, duration: dur, amp: 0.07, out: ~padBus]); };
				note = (42 + interval + (12 * 3)).midicps;
				s.bind { Synth(\pad, [freq: note, duration: dur, amp: 0.05, out: ~padBus]); };
			};
			dur.wait;
		};
	};
	// CLAP+HAT FORK //////////////////////////////////////////////////////
	fork {
		loop {
			// bar //////////////////////
			(dur/2).wait;
			s.bind { Synth(\hat); };
			(dur/2).wait;
			s.bind { Synth(\clap); };
			(dur/2).wait;
			s.bind { Synth(\hat); };
			(dur/2).wait;
			// bar //////////////////////
			(dur/4).wait;
			s.bind { Synth(\hat); };
			(dur/4).wait;
			s.bind { Synth(\hat2); };
			(dur/2).wait;
			s.bind { Synth(\clap); };
			(dur/2).wait;
			s.bind { Synth(\hat); };
			(dur/2).wait;
			// bar //////////////////////
			(dur/2).wait;
			s.bind { Synth(\hat); };
			(dur/2).wait;
			s.bind { Synth(\clap); };
			(dur/2).wait;
			s.bind { Synth(\hat); };
			(dur/2).wait;
			// bar //////////////////////
			(dur/4).wait;
			s.bind { Synth(\hat); };
			(dur/4).wait;
			s.bind { Synth(\hat2); };
			(dur/2).wait;
			s.bind { Synth(\clap); };
			(dur/4).wait;
			s.bind { Synth(\hat); };
			(dur/4).wait;
			s.bind { Synth(\hat2); };
			(dur/2).wait;

		};
	};
}).play;

)
























// endfile