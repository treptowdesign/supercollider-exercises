////////////////////////////////////////////////////////
// Synth
////////////////////////////////////////////////////////

(
SynthDef(\simpleSin, {|freq=440, amp=1, duration=1|
	var snd, env;
	env = Env.perc(1e-1, duration * 3, curve: -4).ar;
	snd = SinOsc.ar(freq, mul: 0.2);
	snd = Pan2.ar(snd * env, 0, amp);
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(0, snd);
}).add;
)

(
SynthDef(\blipSqr, {|freq=440, amp=1, duration=1|
	var snd, env;
	env = Env.perc(1e-4, 1).ar ** 1;
	snd = Pulse.ar(freq*[0.9,0.988,1,1.01,1.1], mul: [0.03,0.2,1,0.2,0.05]).mean;
	snd = LPF.ar(snd, 12000);
	snd = Pan2.ar(snd * env, 0, amp);
	snd = snd * Env.linen(0, duration, 0.001).ar(Done.freeSelf);
	Out.ar(0, snd);
}).add;
)

(
SynthDef(\blipChord, {|freq=440, amp=1, duration=1|
	var snd, env, lfo;
	lfo = Array.fill(5, { SinOsc.ar(Rand(1.0, 8.0)) * 10 });
	env = Env.perc(1e-3, duration * 4, curve: -4).ar;
	snd = SinOsc.ar(freq * [0.9 ,0.985 , 1, 1.01, 1.2] + lfo.midiratio, mul: [0.05,0.18,1,0.2,0.05]).mean;
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
	// snd = BPF.ar(snd, 9200, 0.3);
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
	snd = snd + GVerb.ar(snd * -28.dbamp, 10, 1, 0.9);
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
	snd = MoogFF.ar(snd, XLine.kr(750, 100, duration * 2), 0);
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.linen(0.01, duration, 0.1, curve: -8).ar(Done.freeSelf);
	snd = snd * -12.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd ! 2);
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
			s.bind { Synth(\kick); };
			((beat * 0.25)).wait;
			s.bind { Synth(\hat); };
			((beat * 0.25)).wait;
			s.bind { Synth(\hat); };
			((beat * 0.5)).wait;
			s.bind { Synth(\hat); };
			((beat * 1)).wait;
			s.bind { Synth(\hat); };
			s.bind { Synth(\clap); };
			((beat * 1)).wait;
			s.bind { Synth(\hat); };
			((beat * 0.5)).wait;
			s.bind { Synth(\kick); };
			((beat * 0.5)).wait;
		}
	};
	fork {
		var octave = 5;
		loop {
			// Synth(\glitterWash, [amp: 0.3, duration: beat * 8, lfoRate: beat]);
			[
				(intervals: (0 + [-12, 2, 7, 10]), length: beat * 4),
				(intervals: (-2 + [-12, 3, 7, 10]), length: beat * 4)
			].do { |chord|
				chord[\intervals].do { |degree|
					var n = (root + (12 * octave) + degree).midicps;
					s.bind{
						Synth(\blipChord, [freq: n, amp: 0.6, duration: chord[\length]]);
					};
					/*n = (root + (12 * (octave + 1)) + degree).midicps;
					s.bind{
						Synth(\blipChord, [freq: n, amp: 0.05, duration: chord[\length]]);
					};*/
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
						Synth(\blipSqr, [freq: n, amp: 0.5, duration: note[\length]]);
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
				(interval: 2, length: beat * 0.5, span: 0.9, amp: 1),
				(interval: 0, length: beat * 0.5, span: 0.9, amp: 0.8),
				(interval: -5, length: beat * 0.25, span: 0.9, amp: 0.6),
				(interval: 0, length: beat * 0.25, span: 0.9, amp: 1),
				(interval: 0, length: beat * 0.5, span: 0.9, amp: 1),
				(interval: 7, length: beat, span: 0.5, amp: 1),
				(interval: 0, length: beat, span: 0.5, amp: 1),
				// bar 2
				(interval: -2, length: beat * 2, span: 0.5, amp: 1),
				(interval: -2, length: beat * 2, span: 0.5, amp: 1),
				// bar 3
				(interval: 2, length: beat * 0.5, span: 0.9, amp: 1),
				(interval: 0, length: beat * 0.5, span: 0.9, amp: 0.8),
				(interval: -5, length: beat * 0.25, span: 0.9, amp: 0.6),
				(interval: 0, length: beat * 0.25, span: 0.9, amp: 1),
				(interval: 0, length: beat * 0.5, span: 0.9, amp: 1),
				(interval: 7, length: beat, span: 0.5, amp: 1),
				(interval: 0, length: beat, span: 0.5, amp: 1),
				// bar 4
				(interval: -2, length: beat * 2, span: 0.5, amp: 1),
				(interval: -2 + 7, length: beat * 2, span: 0.5, amp: 1),
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
						Synth(\blipChord, [freq: note, amp: 0.5, duration: chord[\length]]);
					};
				};
				chord[\length].wait;
			};

		};
	};

}).play;
)