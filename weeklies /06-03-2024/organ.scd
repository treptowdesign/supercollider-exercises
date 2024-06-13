(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 6] * (LFNoise2.kr(7 ! 3) * 0.2).midiratio);
	snd = snd * Env.perc(0, [5.5, 7, 4]).ar;
	snd = snd * [-2, 0, -10].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -5.dbamp, 16, 4, damping: 0.2);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.8).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 16020, 0.3) * 4.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10820, 0.1) * 2.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7890, 0.08) * -5.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, 0.1).ar;
	snd = snd + GVerb.ar(snd, 8, 0.3);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(58 * (1 + (2 * Env.perc(0.001, 0.024).ar) * velocity) * (1 + (0.7 * Env.perc(0.001, 0.2).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.4 * velocity).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1310);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = snd * (1 + (1.1 * Env.perc(0.001, 0.01).ar));
	snd = snd + DelayN.ar(snd * -15.dbamp, 0.05, [25e-3, 38e-3]);
	snd = snd * \amp.kr(1).dbamp * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatOpen, {
	var snd, freqs;
	snd = Hasher.ar(Sweep.ar);
	freqs = ((0..20) * 164789).sin.linexp(-1, 1, 200, 3e3);
	snd = CombC.ar(snd, 1 / freqs, 1 / freqs, 0.1);
	snd = snd.sum * -15.dbamp;
	snd = FreqShift.ar(snd, -210);
	snd = HPF.ar(snd, 1680);
	snd = BPF.ar(snd, [8220, 5660, 1390, 6500, 8953], 0.08);
	snd = snd * Env.perc(0.01, 1.0 * [0.8, 0.15, 0.4, 0.1, 0.2, 0.5]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.02, 2);
	snd = (snd * -5.dbamp) + GVerb.ar(snd * -10.dbamp, 10, 0.2);
	snd = snd * Env.linen(0, \duration.kr(0.25), 0.01, curve: -8).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.phrygian.degrees;

Routine({
	loop {
		(beat * (2/3)).wait;
		s.bind { Synth(\hat); };
		(beat * (1/3)).wait;
		s.bind { Synth(\hat); };
		(beat * (2/3)).wait;
		s.bind { Synth(\hat); };
		(beat * (1/3)).wait;
		s.bind { Synth(\hat); };
		(beat * 0.25).wait;
		s.bind { Synth(\hat); };
		(beat * 0.25).wait;
		s.bind { Synth(\hat); };
		(beat * 0.25).wait;
		s.bind { Synth(\hat); };
		(beat * 0.25).wait;
		s.bind { Synth(\hat); };
		(beat * 0.5).wait;
		s.bind { Synth(\hat); };
		(beat * 0.5).wait;
		s.bind { Synth(\hat); };
		s.bind { Synth(\hatOpen); };
	};
}).play;

Routine({
	loop {
		s.bind { Synth(\kick); };
		(beat * 2/3).wait;
		s.bind { Synth(\kick); };
		(beat * 1/3).wait;
		s.bind { Synth(\kick); };
		(beat * 1).wait;
		s.bind { Synth(\clap); };
		(beat * 2).wait;
	};
}).play;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			(notes: 0 + [0, 2, 9], length: 2/3),
			(notes: 0 + [0, 2, 9], length: 1/3),
			(notes: 0 + [0, 3, 7], length: 3),
			(notes: -2 + [0, 4, 9], length: 2/3),
			(notes: -2 + [0, 4, 9], length: 1/3),
			(notes: 7 + [0, 3, -5, -2], length: 3),
		].do { |chord|
			notes = chord[\notes].sort;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.1).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)


s.makeWindow;