(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 60, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01;
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -20.dbamp;
	snd = BLowShelf.ar(snd, 300, 0.4, 2);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1620, 0.5) * 20.dbamp;
	snd = snd + snd.tanh;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.16], curve: -12).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0) * -26.dbamp;
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
	snd = snd * -16.dbamp;
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
	snd = BPF.ar(snd, 7923 * [1, 1.5] * XLine.ar(1, 1.4, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 6000);
	snd = snd * -14.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 1, [0.8, 0.6]), 300), 3000);
	snd = snd * Env.linen(0, duration, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [3, 1]) * Env.perc(0, 3.0).ar * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = SinOsc.ar((freq * [1, 0.5]) + (40 * snd));
	snd = snd * [0, -12].dbamp;
	snd = snd.sum * -5.dbamp;
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * -24.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.05, duration, 0.1, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\padFx, {
	var snd, fb, scTrig;
	scTrig = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	fb = LocalIn.ar(2);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.1, 0.14] + (SinOsc.ar(0.3, [0, pi]) * 0.3e-3), 0.4);
	fb = AllpassC.ar(fb, 0.034, 0.034 * [1, 1.2], 0.3);
	fb = AllpassC.ar(fb, 0.026, 0.026 * [1.3, 1.2], 0.1);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.13, 0.06] + (SinOsc.ar(0.43, [0.3, 0.3pi]) * 0.2e-3), 0.4);
	fb = AllpassC.ar(fb, 1.0, 0.084 * [1, 1.4], 0.5);
	fb = fb + LPF.ar(PitchShift.ar(fb * -10.dbamp, [0.2, 0.3], 2, 0.001), 1000);
	fb = fb + PitchShift.ar(fb * -8.dbamp, [0.44, 0.13], 0.5, 0.001);
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 50);
	fb = fb * -1.dbamp;
	LocalOut.ar(fb.reverse);
	snd = snd + fb;
	snd = snd * (1 - (0.8 * Env.perc(0.01, 0.3, curve: 4).ar(gate: scTrig)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = BLowShelf.ar(snd, 600, 0.3, -3);
	snd = BHiShelf.ar(snd, 3400, 0.3, -3);
	snd = (snd * 15.dbamp).tanh;
	snd = BLowShelf.ar(snd, 600, 0.3, 3);
	snd = BHiShelf.ar(snd, 3400, 0.3, 3);
	snd = snd * -8.dbamp;
	snd = snd + GVerb.ar(snd.sum * -30.dbamp, 30, 1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
// Bus.audio(server, numChannels: 1)
~padBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
)

~padBus.index;

(
var s, padFx, drumsFx, beat, root;
s = Server.default;
beat = 60 / 108;
root = 42;

padFx = Synth.tail(nil, \padFx, [in: ~padBus, out: 0]);
drumsFx = Synth.tail(nil, \drumFx, [in: ~drumsBus, out: 0]);

Routine({
	var dur, note;
	dur = beat;
	fork {
		16.do {
			s.bind { padFx.set(\trigger, 1); }; // sidechain...
			// s.bind { Synth(\kick, [out: ~drumsBus]); };
			dur.wait;
		};
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
			[0, 0, 0, 0, 8, 8, 7, 7]. do { |bassnote|
				[-12, -5, 0, 3, 7, 10].do { |interval|
					note = (root + bassnote + interval + (12 * 1)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur, amp: 0.3, out: ~padBus]); };
					note = (root + bassnote + interval + (12 * 2)).midicps;
					s.bind { Synth(\pad, [freq: note, duration: dur, amp: 0.7, out: ~padBus]); };
				};
				dur.wait;
			};
		};
	};
	fork {
		(dur * 16).wait;
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
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/4).wait;
			s.bind { Synth(\hat2, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			(dur/2).wait;
			s.bind { Synth(\hat, [out: ~drumsBus]); };
			(dur/2).wait;
		};
	};
}).play;

)





s.makeWindow;


















// endfile