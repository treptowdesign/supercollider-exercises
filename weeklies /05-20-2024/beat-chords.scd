(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, [0.04, 0.032, 0.02, 0.03, 0.04]).ar.linexp(0, 1, 58, 400) * [1, 1.4, 1.65, 1.3, 1.8]);
	snd = snd * Env.perc(0.001, [0.3, 0.02, 0.003, 0.014, 0.2]).ar;
	snd = snd * [0, -5, -2, -8, -14].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (2.6 * Env.perc(0, 0.01).ar));
	snd = (snd).tanh;
	snd = (snd * -5.dbamp) ! 2;
	snd = snd * Env.linen(0, duration, 0.01, curve: -2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\swarmHat, {
	arg rel=0.2, amp=(-20);
	var snd, freq=455;
	snd = Pulse.ar(freq * [1, 1.75, 0.06, 0.75, 1.55].midiratio);
	snd = (WhiteNoise.ar.pow(9.0) * 0.8) + snd.sum;
	snd = BPF.ar(snd, 16e3, 0.3);
	snd = snd * (1 + (6 * Env.perc(0, 0.03).ar));
	snd = snd * Env.perc(0.001, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * amp.dbamp * -4.dbamp);
}).add;
SynthDef(\clapYcgm, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1510);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = snd * (1 + (1.1 * Env.perc(0.001, 0.01).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1).dbamp * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\synth, {
	var freq, snd, rel, detunes, jitter, spread, vol;
	spread = \spread.kr(1);
	jitter = \jutter.kr(0.08);
	vol = \vol.kr(0);
	detunes = [0.11, 0.075, -0.13, -0.03];
	detunes = [0] ++ (detunes.collect {|val| val + Rand(jitter.neg, jitter)});
	freq = \freq.kr(440) * (detunes * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = VarSaw.ar(freq, 0, 0);
	snd = Splay.ar(snd, 0.8);
	snd = MoogFF.ar(snd, 11e3, 0);
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.2, rel, curve: -5).ar(Done.freeSelf);
	Out.ar(0, snd * -24.dbamp * vol.dbamp ! 2);
}).add;
)

(
SynthDef(\bass, {
	var freq, snd, rel, vol;
	vol = \vol.kr(0);
	freq = \freq.kr(60);
	rel = \rel.kr(0.8);
	snd = Pulse.ar(freq);
	// snd = RLPF.ar(snd, 800, 0.4);
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.8).kr.linexp(0, 1, 20, 1400), 0.6) * 9.dbamp;
	snd = snd + (snd.tanh * 0.4);
	snd = snd * (1 + (1 * Env.perc(0, 0.4).ar));
	snd = snd * Env.perc(0.008, rel, curve: -6).ar(Done.freeSelf);
	Out.ar(0, snd * -22.dbamp * vol.dbamp ! 2);
}).add;
)


(Scale.phrygian.degrees +.x [0, 12] ).sort;
(Scale.aeolian.degrees +.x [0, 12] ).sort;
(Scale.dorian.degrees +.x [0, 12] ).sort;
(Scale.locrian.degrees +.x [0, 12] ).sort;

(Scale.ionian.degrees +.x [0, 12] ).sort;
(Scale.lydian.degrees +.x [0, 12] ).sort;
(Scale.mixolydian.degrees +.x [0, 12] ).sort;

(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.phrygian.degrees;

Routine({
	var dur, octave, notes, note;
	dur = beat;
	loop {
		[
			[[0, 3, 7, 10], 1],    // Cm7: C-Eb-G-Bb
			[[3, 6, 10, 13], 1],   // Ebm7: Eb-Gb-Bb-Db
			[[0, 3, 7, 10], 2],    // Cm7: C-Eb-G-Bb
			[[7, 10, 14, 17], 2],  // G7: G-B-D-F
			[[7, 10, 14, 17], 2],  // G7: G-B-D-F
			[[2, 5, 9, 12], 1],    // Dm7: D-F-A-C
			[[5, 8, 12, 15], 1],   // Fm7: F-Ab-C-Eb
			[[0, 3, 7, 10], 2],    // Cm7: C-Eb-G-Bb
			[[8, 11, 14, 17], 2],  // Abmaj7: Ab-C-Eb-G
			[[2, 5, 8, 11], 2],     // Bdim7: B-D-F-Ab
		].do { |chord|
			var notes = chord[0];
			dur = chord[1];
			notes.do {|deg|
				var note = (41 + deg + (12 * 2)).midicps;
				s.bind { Synth(\synth, [freq: note, spread: 1, jitter: 0.4, rel: 1.8, vol: -2]); };
			};
			(beat * dur).wait
		};
	};
}).play;

Routine({
	var idx = 1, vol = 0;
	loop {
		[
			0, 0, 0, 0, 0, 0, 0, 0,
			3, 3, 3, 3, 3, 3, 3, 3,
			-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3,
			0, 0, 2, 2, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			3, 3, 3, 3, 3, 3, 3, 3,
			-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3,
			0, 0, 2, 2, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0,
		].do { |note |
			vol = 0;
			if(idx == 1, { vol = -6; });
			(idx = (idx % 4) + 1 ).postln;
			if(note != \, {
				s.bind { Synth(\bass, [freq: (root + note + 12.neg).midicps, vol: vol]); };
			});
			(beat/4).wait;
		};

	};
}).play;


Routine({
	loop {
		s.bind { Synth(\swarmHat, [out: 0, amp: -20]); };
		s.bind { Synth(\kick, [out: 0]); };
		(beat/2).wait;
		s.bind { Synth(\swarmHat, [out: 0, amp: -8]); };
		(beat/2).wait;
		s.bind { Synth(\swarmHat, [out: 0, amp: -20]); };
		s.bind { Synth(\kick, [out: 0]); };
		s.bind { Synth(\clapYcgm, [out: 0]); };
		(beat/2).wait;
		s.bind { Synth(\swarmHat, [out: 0, amp: -8]); };
		(beat/2).wait;
	};
}).play;


)