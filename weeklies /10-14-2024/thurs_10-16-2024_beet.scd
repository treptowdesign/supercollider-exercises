(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 60, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01;
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -26.dbamp;
	snd = BLowShelf.ar(snd, 100, 0.4, 2);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1620, 0.5) * 20.dbamp;
	snd = snd + snd.tanh;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.14], curve: -12).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0) * -30.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
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
	snd = snd * -18.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 0.1, [44e-3, 23e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(34 * [1, 2.23, 3.45, 5.7, 7.8]).sum;
	snd = FreqShift.ar(snd, 41.2);
	snd = snd + (Hasher.ar(Sweep.ar) * -10.dbamp);
	snd = snd * Env.perc(0.001, 0.12, curve: 8).ar;
	snd = BPF.ar(snd, 8923 * [1, 1.5] * XLine.ar(1, 1.4, 0.1), 0.5).sum;
	snd = HPF.ar(snd, 6000);
	snd = snd * -34.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 1, [0.8, 0.6]), 300), 3000);
	snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 0.4);
	snd = snd * Env.linen(0, duration, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [4, 2]) * Env.perc(0, 3).ar * (1 + (3 * Env.perc(0, 0.02).ar));
	snd = SinOsc.ar((freq * [1, 2]) + (80 * snd));
	snd = snd * [0, -8].dbamp * (1 + (LFNoise2.ar(16) * 0.8));
	snd = snd.sum * -5.dbamp;
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * -26.dbamp * \amp.kr(1);
	snd = HPF.ar(snd, 120);
	snd = snd * Env.linen(0.05, duration, 0.4, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\padFx, {
	var snd, fb, scTrig;
	scTrig = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	fb = LocalIn.ar(2);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.1, 0.14] + (SinOsc.ar(0.3, [0, pi]) * 0.3e-3), 0.7);
	fb = AllpassC.ar(fb, 0.054, 0.054 * [1, 1.3], 0.3);
	fb = AllpassC.ar(fb, 0.026, 0.026 * [1.3, 1.2], 0.4);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.13, 0.06] + (SinOsc.ar(0.43, [0.3, 0.3pi]) * 0.2e-4), 0.7);
	fb = AllpassC.ar(fb, 0.018, 0.018 * [1, 1.4], 0.4);
	fb = AllpassC.ar(fb, 0.046, 0.046 * [1.2, 1], 0.8);
	// fb = fb + LPF.ar(PitchShift.ar(fb * -15.dbamp, [0.2, 0.3], 2, 0.001), 1600);
	// fb = fb + PitchShift.ar(fb * -25.dbamp, [0.34, 0.13], 0.5, 0.001);
	fb = LPF.ar(fb, 4000);
	fb = HPF.ar(fb, 60);
	fb = fb * -2.dbamp;
	LocalOut.ar(fb.reverse);
	snd = snd + fb;
	// snd = FreeVerb.ar(snd, 0.6, 0.8, 0.2);
	// snd = BLowShelf.ar(snd, 120, 0.3, -2);
	snd = snd * (1 - (0.9 * Env.perc(0.005, 0.28, curve: 6).ar(gate: scTrig)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = BLowShelf.ar(snd, 600, 0.3, -4);
	snd = BHiShelf.ar(snd, 3400, 0.3, -4);
	snd = (snd * 15.dbamp).tanh;
	snd = BLowShelf.ar(snd, 600, 0.3, 4);
	snd = BHiShelf.ar(snd, 3400, 0.3, 4);
	snd = snd * -8.dbamp;
	snd = snd + GVerb.ar(snd.sum * -30.dbamp, 30, 0.8);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\masterFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * 18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
// Bus.audio(server, numChannels: 1)
~padBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
~masterBus = Bus.audio(nil, 2);
)

~padBus.index;
~drumsBus.index;
~masterBus.index;

(
var s, beat, root, padFx, drumsFx, masterFx;
s = Server.default;
beat = 60 / 108;
root = 42;

// bus routing
padFx = Synth.tail(nil, \padFx, [in: ~padBus, out: ~masterBus]);
drumsFx = Synth.tail(nil, \drumFx, [in: ~drumsBus, out: ~masterBus]);
masterFx = Synth.tail(nil, \masterFx, [in: ~masterBus, out: 0]);

Routine({
	var dur, note;
	dur = beat;
	fork {
		/*16.do {
			s.bind { padFx.set(\trigger, 1); };
			dur.wait;
		};*/
		loop {
			4.do {
				s.bind { padFx.set(\trigger, 1); }; // sidechain...
				s.bind { Synth(\kick, [out: ~drumsBus]); };
				dur.wait;
			};
		};
	};
	fork {
		loop {
			4.do {
				(0 + [-12, 3, 7, 10]).do { |interval|
					note = (root + interval + (12 * 1)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.6, out: ~padBus]); };
					note = (root + interval + (12 * 2)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.25, out: ~padBus]); };
				};
				dur.wait;
			};
			2.do {
				(8 + [0, 3, -5, 10 - 24]).do { |interval|
					note = (root + interval + (12 * 1)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.6, out: ~padBus]); };
					note = (root + interval + (12 * 2)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.25, out: ~padBus]); };
				};
				dur.wait;
			};
			2.do {
				(7 + [0, 3, -5, 10 - 24]).do { |interval|
					note = (root + interval + (12 * 1)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.6, out: ~padBus]); };
					note = (root + interval + (12 * 2)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur/2, amp: 0.25, out: ~padBus]); };
				};
				dur.wait;
			};
			//
			/*[0, 0, 0, 0, 8, 8, 7, 7]. do { |bassnote|
				[-12, 3, 7, 10].do { |interval|
					note = (root + bassnote + interval + (12 * 1)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur, amp: 0.8, out: ~padBus]); };
				};
				dur.wait;
			};*/
		};
	};
	fork {
		// (dur * 16).wait;
		loop {
			// bar ////////////////////////////////////////////
			(dur/2).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			// bar ////////////////////////////////////////////
			(dur/4).wait;
			s.bind { Synth(\hat2, [out: ~drumsBus]); };
			(dur/4).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			// bar ////////////////////////////////////////////
			(dur/2).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			// bar ////////////////////////////////////////////
			(dur/4).wait;
			s.bind { Synth(\hat2, [out: ~drumsBus]); };
			(dur/4).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
			(dur/4).wait;
			s.bind { Synth(\hat2, [out: ~drumsBus]); };
			(dur/4).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
		};
	};
}).play;

)





s.makeWindow;


















// endfile