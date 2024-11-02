// Friday 11-01-2024 Exercise

(
SynthDef(\kick, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(XLine.ar(200, 58, 0.05) * XLine.ar(10, 1, 0.001) * XLine.ar(1, 0.5, 0.3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3310, 0.3) * Env.perc(0, 0.01).ar);
	snd = snd + 0.01;
	snd = snd * Env.perc(0.001, 0.7).ar;
	snd = snd.tanh;
	snd = snd * -8.dbamp * \amp.kr(1);
	snd = BLowShelf.ar(snd, 300, 0.4, 5);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [34e-3, 63e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1540, 0.3) * 30.dbamp;
	snd = snd + (snd * 2.dbamp).tanh;
	snd = snd + DelayC.ar(snd * -35.dbamp, 0.1, [34e-3, 63e-3]);
	snd = Splay.ar(snd);
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.13], curve: -12).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd * -20.dbamp);
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
	snd = snd * -8.dbamp;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -27.dbamp, 0.1, [44e-3, 23e-3]), 200), 3000);
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\partials, {
	var snd, freq, duration, amp;
	freq = \freq.kr(440);
	duration = \duration.kr(1);
	amp = \amp.kr(-32);
	snd = SinOsc.ar(
		freq * [1, 2, 3, 4, 5] * (LFNoise2.ar(10) ! 5 * 0.2).midiratio,
		[0, 0.4pi, pi, 0.3pi, 0],
		[1, 0.4, 0.2, 0.02, 0.01]
	);
	snd = snd.sum;
	snd = snd + LPF.ar(GVerb.ar(snd, 20, 3, 0.6), 1000);
	snd = Splay.ar(snd);
	snd = snd * Env.perc(0.1, 3).ar;
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	snd = snd * amp.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var snd, freq, span;
	span = \span.kr(1);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * [0.1, -0.1].midiratio, 0.4).sum;
	snd = RLPF.ar(snd, 500, 0.8) * 10.dbamp;
	snd = BLowShelf.ar(snd, 400, 0.4, 2);
	snd = Pan2.ar(snd, 0) * -16.dbamp;
	snd = snd * Env.perc(0.01, 1.4).ar;
	snd = snd * Env.linen(0, span, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * -12.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, -4);
	snd = BHiShelf.ar(snd, 3200, 0.3, -4);
	snd = (snd * 12.dbamp).tanh;
	snd = BLowShelf.ar(snd, 500, 0.3, 4);
	snd = BHiShelf.ar(snd, 3200, 0.3, 4);
	snd = snd + GVerb.ar(snd.sum * -30.dbamp, 15, 0.8);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechain, {
	var snd, fb, scTrig;
	scTrig = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.8 * Env.perc(0.005, 0.2, curve: 4).ar(gate: scTrig)));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~drumsBus = Bus.audio(nil, 2);
~sidechainBus = Bus.audio(nil, 2);
)



(
var s, root, beat, drumFX, sidechainFX;
s = Server.default;
root = 42;
beat = 60 / 128;

drumFX = Synth(\drumFx, [in: ~drumsBus]);
sidechainFX = Synth(\sidechain, [in: ~sidechainBus]);

Routine({
	var dur, note, chordBass, chordIntervals;
	dur = beat * 2;
	fork {
		loop {
			[
				(intervals: 0 + [0, 2, 7, 10], length: 4), // sus2 min7
				(intervals: -2 + [0, 16, 9, 5], length: 4), // maj 3rd + maj 6th + 11th
			].do { |chord|
				chordIntervals = chord[\intervals];
				chordIntervals.do { |interval|
					note = (root + interval + (12 * 1)).midicps;
					s.bind { Synth(\partials, [freq: note, duration: beat * chord[\length], out: ~sidechainBus]); };
					note = (root + interval + (12 * 2)).midicps;
					s.bind { Synth(\partials, [freq: note, duration: beat * chord[\length], out: ~sidechainBus]); };
				};
				(beat * chord[\length]).wait;
			};
		};
	};
	fork {
		loop {
			2.do {
				[0, 0, 12, 7].do { |interval|
					if(interval != \, {
						note = (root + interval + (12 * -1)).midicps;
						s.bind { Synth(\bass, [freq: note, span: beat/2, out: ~sidechainBus]); };
					});
					(beat/2).wait;
				};
			};
			2.do {
				[-2, -2, 10, 5].do { |interval|
					if(interval != \, {
						note = (root + interval + (12 * -1)).midicps;
						s.bind { Synth(\bass, [freq: note, span: beat/2, out: ~sidechainBus]); };
					});
					(beat/2).wait;
				};
			};
		};
	};
	fork {
		loop {
			s.bind { sidechainFX.set(\trigger, 1); }; // sidechain...
			s.bind { Synth(\kick, [out: ~drumsBus]); };
			(beat * 3.5).wait;
			s.bind { sidechainFX.set(\trigger, 1); }; // sidechain...
			s.bind { Synth(\kick, [out: ~drumsBus, amp: 0.8]); };
			(beat * 0.5).wait;
		};
	};
	fork {
		loop {
			// bar //////////////////////
			(beat * 2).wait;
			s.bind { Synth(\clap, [out: ~drumsBus]); };
			(beat * 2).wait;
		};
	};
	fork {
		loop {
			4.do {
				s.bind { Synth(\hat, [out: ~drumsBus]); };
				(beat/4).wait;
			};
			4.do {
				s.bind { Synth(\hat, [out: ~drumsBus]); };
				(beat/2).wait;
			};
			2.do {
				s.bind { Synth(\hat, [out: ~drumsBus]); };
				(beat).wait;
			};
		};
	};

}).play;
)

(
var s, root, beat;
s = Server.default;
root = 42;
beat = 60 / 110;
Routine({
	var dur, note, octave, chordBass, chordIntervals;
	dur = beat;
	octave = 1;
	loop {
		[
			(intervals: 0 + [-12, 3, -5, 10, 17], length: 4), // min 7th + 11th
			(intervals: -2 + [-12, 4, -5, 9, 14], length: 4), // maj 6th + 9th
			(intervals: 1 + [-12, 3, -5, 10, 14], length: 4),
			(intervals: 7 + [-12, 3, -5, 9, 5], length: 4),
		].do { |chord|
			chordIntervals = chord[\intervals];
			dur = beat * chord[\length];
			chordIntervals.do { |interval|
				note = (root + interval + (12 * octave)).midicps;
				s.bind { Synth(\partials, [freq: note, duration: dur]); };
			};
			dur.wait;
		};
	};
}).play;
)











