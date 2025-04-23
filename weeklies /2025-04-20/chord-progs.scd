////////////////////////////////////////////////////////
// Synth
////////////////////////////////////////////////////////


(
SynthDef(\pluck, {
	var snd, duration, click;
	duration = \duration.kr(0.1);
	snd = Impulse.ar(\freq.kr(60) * 2 * (LFNoise2.kr(3) * 0.03).midiratio);
	snd = (ToggleFF.ar(PulseDivider.ar(snd, [1, 2, 4, 8, 16])) / [1, 2.6, 4.5, 5, 10]).sum + snd;
	3.do {
		snd = BRF.ar(snd, ExpRand(100, 4200) * (LFNoise2.kr(9) * 12).midiratio, 0.6);
	};
	snd = snd * Env([1, 0.1, 0.4, 0], [0.01, 0.3, 5], curve: -4).ar * -14.dbamp;
	snd = Pan2.ar(snd, 0) + GVerb.ar(snd, 10, 5);
	snd = snd.tanh;
	snd = snd * Env.linen(0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\blipChord, {|freq=440, amp=1, duration=1|
	var snd, env, lfo;
	lfo = Array.fill(5, { SinOsc.ar(Rand(2.0, 8.0)) * 10 });
	env = Env.perc(1e-3, duration * 4, curve: -4).ar;
	snd = SinOsc.ar(freq * [0.9 ,0.985 , 1, 1.01, 1.2] + lfo.midiratio, mul: [0.03,0.10,1,0.2,0.05]).mean;
	snd = Pan2.ar(snd * env, 0, amp);
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(0, snd);
}).add;
)

{Env.perc(1e-2, 1, curve: 8).ar}.plot(2);

(
SynthDef(\glitterWash, { |duration=2, amp=1, lfoRate=1|
	var snd, lfo;
	lfo = SinOsc.kr(lfoRate);
	snd = WhiteNoise.ar;
	snd = 10.collect {
		FreqShift.ar(
			CombC.ar(snd * (1 + (0.5 * LFNoise2.kr(7))) * (1 + (0.3 * LFNoise2.kr(30))),
				0.1,
				1 / (ExpRand(500, 1000) * (LFNoise2.kr(3) * 0.3).midiratio),
				1.0
			),
			ExpRand(1000, 5000)
		)
	};
	snd = Splay.ar(snd) * -10.dbamp;
	snd = BPF.ar(snd, lfo.range(8200, 9800), 0.3);
	3.do { snd = HPF.ar(snd, 8000); };
	snd = snd * -23.dbamp * amp;
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2100), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1600, 0.6) * -3.dbamp;
	snd = LPF.ar(snd, 6200);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.001, 0.01, 0.003, 0.01, 0.003, 0.08, 0.2] * 0.5, curve: -2).ar ** 1.4;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -26.dbamp, 10, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 90);
	snd = BPF.ar(snd, [12240, 6230, 10832, 9830, 8320], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -18.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -26.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\bass, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), 0.5);
	snd = MoogFF.ar(snd, XLine.kr(420, 120, duration * 2), 0);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd ! 2);
}).add;
)

(
SynthDef(\saw, {
	var snd, count, freq, center;
	count = 10;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(0.5) } ! count) * 0.2).midiratio, { Rand(0, 2pi) } ! count);
	snd = Splay.ar(snd) * -16.dbamp;
	snd = snd + GVerb.ar(snd.mean * -12.dbamp, 20, 10, damping: 0.2);
	snd = snd * Env.perc(0.01, 5, curve: 4).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(-5.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\sawCenter, {
	var snd, count, freq, center, chorus;
	count = 5;
	freq = \freq.kr(440) * 1 * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(4) } ! count) * 0.1).midiratio, { Rand(0, 2pi) } ! count);
	snd = Mix(snd) * -14.dbamp ! 2;
	chorus = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.025))
	}).tanh;
	snd = Mix([snd, chorus]);
	3.do {
		snd = BRF.ar(snd, ExpRand(100, 4200) * (LFNoise2.kr(9) * 12).midiratio, 0.2);
	};
	snd = LPF.ar(HPF.ar(snd, 600), 8500);
	snd = snd + GVerb.ar(snd.mean * -8.dbamp, 20, 10, damping: 0.2);
	snd = snd * Env.perc(0.01, 2, curve: -4).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 4] * (LFNoise2.kr(10 ! 3) * 0.1).midiratio);
	snd = snd * Env.perc(0, [5, 10, 1]).ar;
	snd = snd * [-5, 0, -9].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum ! 2;
	snd = LPF.ar(snd, XLine.ar(8000, 100, 3.0));
	snd = snd + GVerb.ar(snd.mean * -20.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.linen(0.03, duration, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -18.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\piano, {
	var snd, freq, n, knock;
	freq = \freq.kr(440);
	n = (1..16);
	snd = [-0.05, 0, 0.05].collect { |detune|
		var snd, freqs;
		freqs = freq * n * (1 + (n * n * 1e-3)).sqrt * detune.midiratio;
		snd = SinOsc.ar(freqs, n.collect { Rand(0, 2pi) });
		snd = snd * Env.perc(snd.collect { Rand(0, 0.001) } * n, 20 * ((260 / freqs) ** 1.4)).ar;
		snd = snd * (1 + (0.5 * (n / Rand(3, 8)).sin));
		snd = snd * (n ** -1.5);
		snd = snd.sum;
		snd;
	};
	snd = snd.sum * -7.dbamp;
	snd = snd * -9.dbamp;
	snd = snd * (1 + (3 * Env.perc(0.0, 0.1).ar));
	snd = snd * Env.perc(0.01, 10.0).ar;
	knock = PinkNoise.ar;
	knock = BPF.ar(knock, freq * [1, 2.3], 0.7).sum * 4.dbamp;
	knock = knock * Env.perc(0.001, 0.06).ar;
	snd = snd + knock;
	snd = BHiShelf.ar(snd, 1230, 0.3, -3);
	snd = (snd * 2.dbamp).tanh;
	snd = BHiShelf.ar(snd, 3230, 0.3, 5);
	snd = snd * -7.dbamp;
	snd = snd * Env.linen(0, \duration.kr(10.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq, snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 2.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Env.linen(0.01, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), [0, pi]).linlin(-1, 1, 0.7, 1);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\guitar, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pluck.ar(SinOsc.ar(XLine.ar(2000, 40, 0.01) * ExpRand(0.5, 1)) + WhiteNoise.ar, Impulse.ar(0), 0.2, 1 / freq, 20, 0.2);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 53), 0.2, 1 / 150, 0.01), -53);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 53), 0.2, 1 / 240, 0.01), -53);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 53), 0.2, 1 / 310, 0.01), -53);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -24.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\acid, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2] * XLine.ar(2, 1, 0.01)).sum;
	snd = MoogFF.ar(snd, 400 * 2 * (Env.perc(0, duration * 1, curve: -4).ar * 12 * 4).midiratio, 2) * 5.dbamp;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * 5.dbamp;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(0.5);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\padA, {
	var snd;
	snd = (\freq.kr(440) * [0, 1, 2, 3] * \ratio.kr(1)).collect { |freq, index|
		var snd;
		snd = SinOsc.ar(freq * (LFNoise2.kr(8 ! 2) * 0.1).midiratio, Rand(0, 2pi)) * LFNoise2.kr(8 ! 2);
		snd = snd * (1 / (index + 1));
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2);
		snd;
	};
	snd = snd.sum;
	snd = snd * Env.perc(0.1, 3.0).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -8).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).add;
)

(
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [3, 12]) * Env.perc(0.001, 3.0).ar * (1 + (3 * Env.perc(0, 0.3).ar)) * 220 * Hasher.kr(freq).linexp(-1, 1, 1, 1.4);
	snd = snd.sum;
	snd = SinOsc.ar(freq + snd);
	snd = snd * Env([0, 10, 0.5, 1], [0.001, 0.01, 0.01], curve: -4).ar;
	snd = snd.fold2;
	snd = snd * Env.perc(0.1, 4, curve: -8).ar;
	snd = BRF.ar(snd, ((0..20) ** 0.8).normalize.linexp(0, 1, 100, 8000), 0.8);
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr, snd);
}).add;
)



////////////////////////////////////////////////////////
// "Massage Situation" Chords
////////////////////////////////////////////////////////


(
var s, bpm, beat, root;
s = Server.default;
bpm = 93; // 93
beat = 60 / bpm;
root = -2; // offset 0=C, -2=Bb
Routine({
	fork {
		loop {
			s.bind { Synth(\hat); };
			(beat/2).wait;
		}
	};
	fork {
		loop {
			s.bind { Synth(\kick); };
			beat.wait;
			s.bind { Synth(\clap); };
			beat.wait;
			(beat/2).wait;
			s.bind { Synth(\kick); };
			(beat/2).wait;
			s.bind { Synth(\clap); };
			beat.wait;
		};
	};
	fork {
		var octave = 5;
		loop {
			// Synth(\glitterWash, [amp: 0.1, duration: beat * 8, lfoRate: beat]);
			[
				(intervals: (0 + [-12, 2, 7, 10]), length: beat * 4),
				(intervals: (-2 + [-12, 3, 7, 10]), length: beat * 4)
			].do { |chord|
				chord[\intervals].do { |degree|
					var n = (root + (12 * octave) + degree).midicps;
					s.bind{
						// Synth(\blipChord, [freq: n, amp: 0.2, duration: chord[\length]]);
						// Synth(\saw, [freq: n, amp: 0.08, duration: chord[\length]]);
						Synth(\padA, [freq: n, amp: 0.5, duration: chord[\length]]);
					};
				};
				chord[\length].wait;
			};

		};
	};
	fork {
		var octave = 4;
		loop {
			[
				// bar 1
				(interval: 0 + 2 + 12, length: beat * 0.5),
				(interval: 0 + 10, length: beat * 0.75),
				(interval: 0 + 7, length: beat * 0.75),
				(interval: 0 + 7, length: beat * 2),
				// bar 2
				(interval: -2 + 7, length: beat * 0.5),
				(interval: -2 + 7, length: beat * 0.25),
				(interval: -2 + 7, length: beat * 0.25),
				(interval: -2 + 7, length: beat * 0.25),
				(interval: -2 + 7, length: beat * 0.5),
				(interval: -2 + 10, length: beat * 0.25),
				(interval: -2 + 12, length: beat * 0.5),
				(interval: -2 + 7, length: beat * 0.5),
				(interval: -2 + 12, length: beat),
			].do{ |note|
				var n = ( root + (12 * octave) + note[\interval]).midicps;
				s.bind {
					// Synth(\pluck, [freq: n, amp: 0.1, duration: note[\length]]);
					// Synth(\organ, [freq: n, amp: 0.7, duration: note[\length]]);
					// Synth(\guitar, [freq: n, amp: 0.4, duration: note[\length]]);
					// Synth(\acid, [freq: n, amp: 0.2, duration: note[\length]]);
					// Synth(\sawCenter, [freq: n, amp: 0.2, duration: note[\length]]);
					// Synth(\keys, [freq: n, amp: 0.2, duration: note[\length]]);

				};
				note[\length].wait;
			}
		};
	};
	fork {
		var octave = 3;
		loop {
			[
				// bar 1
				(interval: 2, length: beat * 0.5, span: 0.8, amp: 1),
				(interval: 0, length: beat * 0.5, span: 0.8, amp: 1),
				(interval: -5, length: beat * 0.25, span: 0.6, amp: 0.6),
				(interval: -5, length: beat * 0.25, span: 0.6, amp: 0.8),
				(interval: 0, length: beat * 0.5, span: 0.3, amp: 1),
				(interval: 7, length: beat, span: 0.4, amp: 1),
				(interval: 0, length: beat, span: 0.4, amp: 1),
				// bar 2
				(interval: -2, length: beat * 2, span: 0.3, amp: 1),
				(interval: -2, length: beat * 2, span: 0.3, amp: 1),
				// bar 3
				(interval: 2, length: beat * 0.5, span: 0.8, amp: 1),
				(interval: 0, length: beat * 0.5, span: 0.8, amp: 1),
				(interval: -5, length: beat * 0.25, span: 0.6, amp: 0.6),
				(interval: -5, length: beat * 0.25, span: 0.6, amp: 0.8),
				(interval: 0, length: beat * 0.5, span: 0.3, amp: 1),
				(interval: 7, length: beat, span: 0.4, amp: 1),
				(interval: 0, length: beat, span: 0.4, amp: 1),
				// bar 4
				(interval: -2, length: beat * 2, span: 0.3, amp: 1),
				(interval: -2 + 7, length: beat * 2, span: 0.3, amp: 1),
			].do{ |note|
				var n = ( root + (12 * octave) + note[\interval]).midicps;
				s.bind {
					Synth(\bass, [freq: n, duration: note[\length] * note[\span], amp: note[\amp]]);
				};
				note[\length].wait;
			}
		};
	};


}).play;
)

s.makeWindow;
























////////////////////////////////////////////////////////
// Baisc Routine
////////////////////////////////////////////////////////


(
var s, bpm, beat, root;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = -2;
Routine({
	fork {
		loop {
			s.bind { Synth(\hat); };
			(beat/2).wait;
		}
	};
	fork {
		loop {
			s.bind { Synth(\kick); };
			((beat * 2)).wait;
			s.bind { Synth(\clap); };
			((beat * 1.5) - 0.01).wait;
			s.bind { Synth(\kick); };
			((beat * 0.5) + 0.01).wait;
		}
	};
	fork {
		var octave = 5;
		loop {
			// Synth(\glitterWash, [amp: 0.3, duration: beat * 4, lfoRate: beat]);
			[
				(intervals: (0 + [-12, 2, 7, 10]), length: beat * 2),
				(intervals: (1 + [-12, 4, 7, 11]), length: beat),
				(intervals: (-2 + [-12, 3, 7, 10]), length: beat)
			].do { |chord|
				chord[\intervals].do { |degree|
					var note = (root + (12 * octave) + degree).midicps;
					s.bind{
						Synth(\padA, [freq: note, amp: 0.6, duration: chord[\length]]);
					};
				};
				chord[\length].wait;
			};

		};
	};
	fork {
		var octave = 3;
		loop {
			[
				// bar 1
				(interval: 0, length: beat, span: 0.4, amp: 0.8),
				(interval: 0, length: beat, span: 0.4, amp: 0.8),
				(interval: 1, length: beat, span: 0.4, amp: 0.8),
				(interval: -2, length: beat, span: 0.4, amp: 0.8),
			].do{ |note|
				var n = ( root + (12 * octave) + note[\interval]).midicps;
				s.bind {
					Synth(\bass, [freq: n, duration: note[\length] * note[\span], amp: note[\amp]]);
				};
				note[\length].wait;
			}
		};
	};

}).play;
)