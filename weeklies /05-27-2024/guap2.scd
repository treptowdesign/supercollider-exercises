(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 4, 6] * (LFNoise2.kr(10 ! 3) * 0.1).midiratio);
	snd = snd * Env.perc(0, [5, 7, 4, 1]).ar;
	snd = snd * [-6, 0, -8, -26].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum;
	snd = LPF.ar(snd, XLine.kr(8000, 600, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(200)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -14.dbamp, 20, 3, damping: 0.4);
	// snd = snd * Env.perc(0.001, duration, curve: 2).ar(Done.freeSelf);
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.6).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var freq, snd, rel, vol;
	vol = \vol.kr(0);
	freq = \freq.kr(60);
	rel = \rel.kr(0.6);
	snd = Pulse.ar(freq);
	// snd = RLPF.ar(snd, 800, 0.4);
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.6).kr.linexp(0, 1, 80, 1500), 0.8) * 10.dbamp;
	snd = snd + (snd.tanh * 0.5);
	snd = snd * (1 + (1 * Env.perc(0, 0.4).ar));
	snd = snd * Env.perc(0.05, rel, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd * -24.dbamp * vol.dbamp ! 2);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(58 * (1 + (2 * Env.perc(0.001, 0.024).ar) * velocity) * (1 + (0.7 * Env.perc(0.001, 0.2).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
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
	snd = snd * \amp.kr(1).dbamp * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, freqs;
	snd = Hasher.ar(Sweep.ar);
	freqs = ((0..20) * 164789).sin.linexp(-1, 1, 200, 3e3);
	snd = CombC.ar(snd, 1 / freqs, 1 / freqs, 0.1);
	snd = snd.sum * -15.dbamp;
	snd = FreqShift.ar(snd, -210);
	snd = HPF.ar(snd, 1880);
	snd = BPF.ar(snd, [8230, 5640, 1390, 6500, 8943], 0.1);
	snd = snd * Env.perc(0.01, 1.0 * [0.8, 0.3, 0.4, 0.1, 0.2, 0.5]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.02, 2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatGlitch, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 16020, 0.3) * 4.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 14820, 0.1) * 2.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9890, 0.08) * -5.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, 0.1).ar;
	snd = snd + GVerb.ar(snd, 8, 0.2);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -30.dbamp;
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
		s.bind { Synth(\kick); };
		(beat).wait;
	};
}).play;

Routine({
	loop {
		(beat - 0.02).wait;
		s.bind { Synth(\clap); };
		(beat + 0.02).wait;
	};
}).play;

Routine({
	loop {
		(beat/2 - 0.01).wait;
		s.bind { Synth(\hat); };
		(beat/2).wait;
		(beat/2 + 0.01).wait;
		s.bind { Synth(\hat); };
		(beat/2).wait;
	};
}).play;

/*Routine({
	loop {
		s.bind { Synth(\hatGlitch); };
		(beat/4).wait;
	};
}).play;*/

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			(notes: 0 + [0, 3, -5], length: 7),
			(notes: 1 + [0, 3, -5, -2], length: 1),
			(notes: 0 + [0, 3, -5], length: 7),
			(notes: 1 + [0, 3, -5, -2], length: 1),
			(notes: 0 + [0, 3, -5], length: 7),
			(notes: 1 + [0, 3, -5, -2], length: 1),
			(notes: 0 + [0, 3, -5], length: 4),
			(notes: 7 + [0, 3, -5], length: 2),
			(notes: 1 + [0, 3, -5, -2], length: 2),
		].do { |chord|
			notes = chord[\notes].scramble;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.12).wait; });
					s.bind { Synth(\organ, [freq: note, spread: 1, rel: dur * 8, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;

Routine({
	var idx = 1, vol = 0;
	loop {
		[ -5, 0, 0, 0 ].do { |note|
			vol = 2;
			if(idx == 1, { vol = -12; });
			if(idx == 2, { vol = -8; });
			(idx = (idx % 4) + 1 );
			s.bind { Synth(\bass, [freq: (42 + note + (12 * 1.neg)).midicps, vol: vol ]); };
			(beat / 4).wait
		};
	};
}).play;

)

Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ] - 0, 8, 14 (root, 6th, 9th)
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]






// end...