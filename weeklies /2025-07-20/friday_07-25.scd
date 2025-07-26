


///////////////////////////////////////////////////////////////////////

(
SynthDef(\sineKey, {
	var snd, freq, velocity, duration;
	freq = \freq.kr(440) ;
	duration = \duration.kr(3);
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(freq * 1) * 200;
	snd = SinOsc.ar((freq + snd) * ((LFNoise2.kr(3) * 0.1).midiratio) * XLine.ar(1.1, 1.0, 0.01));
	snd = snd * Env.perc(0.001, \rel.kr(6.0)).ar;
	snd = snd * (1 + (0.5 * Env.perc(0, 0.25).ar));
	snd = snd * (1 + (0.3 * SinOsc.ar(2.5, [0, pi] + Rand(0, pi))));
	snd = (snd * 2.dbamp).tanh;
	snd = snd * -15.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.005, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\mid, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = LFTri.ar(freq);
	snd = LPF.ar(snd, XLine.ar(6000, 100, 0.3));
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd * -12.dbamp;
	snd = snd ! 2;
	snd = snd * Env.perc(0.005, 1.0).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drone, {
	var snd, freq, duration, env;
	freq = \freq.kr(60);
	duration = \duration.kr(10.0);
	env = Env.linen(0.001, duration * 0.99, 0.01, curve: \sin).ar(Done.freeSelf);
	snd = Saw.ar(freq * (LFNoise2.ar(1 ! 8) * 0.2 * env).midiratio * [1, 2, 1, 2, 2, 1, 2, 1]);
	snd = RLPF.ar(snd, LFNoise2.ar(1 ! snd.size).linexp(-1, 1, 100, 800) * env.linexp(0, 1, 0.5, 1), 0.3) * 5.dbamp;
	snd = snd * (1 + env);
	snd = snd.tanh;
	snd = Splay.ar(snd);
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = snd * -14.dbamp * \amp.kr(1);
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(100));
	snd = snd * \freq.kr(100).explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 5000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -3.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration * 0.98, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
/*SynthDef(\sub, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq);
	snd = (snd * 2.dbamp).tanh;
	snd = snd ! 2;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -8.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;*/
SynthDef(\lead, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (LFNoise2.ar(5 ! 5) * 0.2).midiratio, [0.2, 0.3, 0.5, 0.2, 0.9]);
	snd = Splay.ar(snd);
	snd = snd + (SinOsc.ar(freq / 2) * -8.dbamp);
	snd = snd + ({ PinkNoise.ar * -15.dbamp } ! 2);
	snd = RLPF.ar(snd, (LFNoise2.ar(5) + Env.perc(0.05, 0.3).ar).linexp(-1, 1, 500, 4000), 0.6);
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.23, 0.5);
	snd = snd * -13.dbamp;
	snd = snd * Env.perc(0.01, 0.5 * (500 / freq)).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq, env;
	// env = Env([0, 1, 0], [0.1, \duration.kr(3.0)], curve: \sin).ar(Done.freeSelf);
	env = Env.linen(0.005, \duration.kr(3.0), 0.01).ar(Done.freeSelf);
	freq = \freq.kr(440) * (LFNoise2.kr(8 ! 8) * 0.2).midiratio * [1, 0.5, 1, 2, 1, 1, 0.5, 1];
	snd = SinOsc.ar(freq) * Rand(100, 1000 ! freq.size) * env;
	snd = SinOsc.ar(freq + snd);
	snd = snd * (1 + LFNoise2.kr(3 ! snd.size));
	snd = snd * [0, -5, 0, -5, -5, 0, -5, 0].dbamp;
	snd = Splay.ar(snd);
	snd = snd * env;
	snd = snd * -20.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(42 * (1 + (4 * Env.perc(0, 0.09).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	// snd = LPF.ar(snd, 1200);
	wet = snd;
	wet = (wet * 4.dbamp).clip2 + (wet.fold2 * -4.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -24.dbamp, 0.1, 0.02)) ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(220 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.2, 4.1] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.04, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.12).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.15) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -8.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 20, 2, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.1, 1.6);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.06, 2.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.02, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(15e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(720 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015] * 0.4).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -8.dbamp;
	snd = snd * Env.perc(0.0, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.9 * Env.perc(0, 0.2, curve: -4).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
)


(
~busSidechain = Bus.audio(nil, 2);
~reverbBus = Bus.audio(nil, 2);
)

~busSidechain.index;
~reverbBus.index;


(
var s, beat, bar, root, wait, play, seq, sidechainFx, duck;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
root = 54;
wait = { |dur| dur.wait; };
play = { |synth, dur, args| s.bind { Synth(synth, [duration: dur] ++ args);  }; };
seq = { |synth, dur, args| play.(synth, dur, args); wait.(dur); };

sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~busSidechain, out: 0]);
duck = {
	s.bind { sidechainFx.set(\trigger, 1) };
};

Routine({
	loop {
		/*fork {
			1.do {
				[
					[0, 5, 7, 14 - 12],
					[0, 3, 7, 17 - 12],
					[0, 2, 10, 14 -12],
					[0, 3, -4, 15 -12]
				].do { |notes|
					2.do {
						notes.scramble.do { |deg|
							var freq = (root + deg + (12 * 1)).midicps;
							seq.(\mid, beat/2, [freq: freq, amp: 1]);
						};
					};
				};
			};
		};*/
		fork {
			4.do {
				duck.();
				seq.(\kick, beat * 1.5);
				duck.();
				seq.(\kick, beat * 0.5);
				seq.(\rim, beat * 1.5);
				duck.();
				seq.(\kick, beat * 0.5);

			};
		};
		'--------'.postln;
		[
			(notes: (0 + [0, 5, 7, 14]), length: beat * 4),
			(notes: (0 + [0, 3, 7, 17]), length: beat * 4),
			(notes: (0 + [0, 2, 10, 14]), length: beat * 4),
			(notes: (0 + [0, 3, 8, 15]), length: beat * 4),
		].do { |chord|
			1.do { |index|
				var freq, amp = 1, outBus = ~busSidechain;
				chord[\notes].sort.postln.do { |deg|
					freq = (root + deg + (12 * 0)).midicps;
					amp = 1.2; // (1 / (index + 1).sqrt);
					play.(\sineKey, chord[\length], [freq: freq, rel: 4, amp: amp, out: 0]);
					freq = (root + deg + (12 * 1)).midicps;
					amp = 0.1;
					play.(\pad, chord[\length], [freq: freq, rel: 4, amp: amp, out: 0]);
					freq = (root + deg + (12 * 2)).midicps;
					amp = 0.1;
					play.(\sineKey, chord[\length], [freq: freq, rel: 4, amp: amp, out: 0]);
				};
				amp = 1;
				freq = (root + chord[\notes].sort[0] + (12 * -1)).midicps;
				play.(\drone, chord[\length], [freq: freq, rel: 4, amp: amp * 0.5, out: outBus]);
				freq = (root + chord[\notes].sort[0] + (12 * -2)).midicps;
				play.(\sub, chord[\length], [freq: freq, rel: 4, amp: amp * 1, out: outBus]);
				wait.(chord[\length]);
			};

		};
	};
}).play;
)

///////////////////////////////////////////////////////////////////////


(
var s, beat, bar, root, wait, play;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
root = 53;
wait = { |duration| duration.wait; };
play = { |synth, duration, args| s.bind { Synth(synth, [duration: duration] ++ args);  }; };

Routine({
	loop {
		'--------'.postln;
		[
			(notes: (2 + [12, 3, 10, 17]), length: beat),
			(notes: (4 + [0, 4 + 12, 7, 11]), length: beat),
			(notes: (7 + [12, 4, 7 - 12, 14 - 12]), length: beat),
			(notes: (0 + [0, 3 + 12, 10, 17 - 12]), length: beat),
		].do { |chord|
			4.do { |index|
				chord[\notes].sort.postln.do { |deg|
					var freq = (root + deg + (12 * 0)).midicps;
					play.(\sineKey, chord[\length], [freq: freq, rel: 6, amp: (1 / (index + 1).sqrt), duration: chord[\length]]);
				};
				wait.(chord[\length]);
			};

		};
	};
}).play;
)


Scale.aeolian.degrees;    // [ 0, 2, 3, 5, 7, 8, 10 ] Standard Minor
Scale.phrygian.degrees;   // [ 0, 1, 3, 5, 7, 8, 10 ] Aeolian w/ flat 2nd
Scale.dorian.degrees;     // [ 0, 2, 3, 5, 7, 9, 10 ] Aeolian w/ raised 6th
Scale.locrian.degrees;    // [ 0, 1, 3, 5, 6, 8, 10 ] Phrygoan w/ flat 5th (tritone)

Scale.ionian.degrees;     // [ 0, 2, 4, 5, 7, 9, 11 ] Standard Major
Scale.lydian.degrees;     // [ 0, 2, 4, 6, 7, 9, 11 ] Ionian w/ sharp 4th (tritone)
Scale.mixolydian.degrees; // [ 0, 2, 4, 5, 7, 9, 10 ] Ionian w/ flat 7th



( // Aeolian
[0, 3, 7, 10, 14, 17, 20].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

( // Phrygian
[0, 3, 7, 10, 13, 17, 20].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

( // Dorian
[0, 3, 7, 10, 14, 17, 21].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

( // Locian
[0, 3, 6, 10, 13, 17, 20].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

( // Ionian
[0, 4, 7, 11, 14, 17, 21].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

( // Lydian
[0, 4, 7, 11, 14, 18, 21].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

( // Mixolydian
[0, 4, 7, 10, 14, 17, 21].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)


( // harmonic minor
[0, 3, 7, 11, 14, 17, 20].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)


















(
[0, 3, 10, 17].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)



(
[0, 3, 10, 20].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)


(
[0, 4, 11, 14].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

(
[0, 4, 10, 21].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)

(
[0, 4, 11, 21].do { |deg|
	Synth(\sineKey, [freq: (53 + deg + (12 * 0)).midicps]);
};
)


















// endfile

