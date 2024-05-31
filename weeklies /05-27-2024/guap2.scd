(
SynthDef(\synth, {
	var freq, snd, rel, detunes, spread, vol;
	spread = \spread.kr(1);
	vol = \vol.kr(0);
	detunes = [0.085, 0.06, -0.13, -0.023];
	detunes = [0] ++ (detunes.collect {|val| val + Rand(-0.05, 0.05)});
	freq = \freq.kr(440) * (detunes * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = VarSaw.ar(freq, 0, 0.75);
	snd = HPF.ar(snd, 300);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 8e3, 1) * 5.dbamp;
	snd = snd * (1 + (2 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.14, rel, curve: -2).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -8).ar(Done.freeSelf);
	Out.ar(0, snd * -18.dbamp * vol.dbamp ! 2);
}).add;
SynthDef(\synthSin, {
	var freq, snd, rel, detunes, spread, vol;
	spread = \spread.kr(1);
	vol = \vol.kr(0);
	detunes = [0.075, 0.04, -0.11, -0.013];
	detunes = [0] ++ (detunes.collect {|val| val + Rand(-0.01, 0.01)});
	freq = \freq.kr(440) * (detunes * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = SinOsc.ar(freq);
	snd = HPF.ar(snd, 300);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 12e3, ) * 15.dbamp;
	snd = snd * (1 + (2 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.14, rel, curve: -2).ar;
	snd = snd * Env.linen(0, \duration.kr(1), 0.1, curve: -8).ar(Done.freeSelf);
	Out.ar(0, snd * -10.dbamp * vol.dbamp ! 2);
}).add;
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 4] * (LFNoise2.kr(10 ! 3) * 0.1).midiratio);
	snd = snd * Env.perc(0, [5, 10, 1]).ar;
	snd = snd * [-4, 0, -8].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum;
	snd = LPF.ar(snd, XLine.ar(8000, 100, 3.0));
	snd = snd * Select.ar(Sweep.ar > 0.02, [ToggleFF.ar(Dust.ar(200)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.perc(0.001, duration, curve: -1).ar(Done.freeSelf);
	// snd = snd * Env.linen(0.0, duration, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var freq, snd, rel, vol;
	vol = \vol.kr(0);
	freq = \freq.kr(60);
	rel = \rel.kr(0.8);
	snd = Pulse.ar(freq);
	// snd = RLPF.ar(snd, 800, 0.4);
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.6).kr.linexp(0, 1, 60, 1600), 0.6) * 10.dbamp;
	snd = snd + (snd.tanh * 0.2);
	snd = snd * (1 + (1 * Env.perc(0, 0.4).ar));
	snd = snd * Env.perc(0.008, rel, curve: -6).ar(Done.freeSelf);
	Out.ar(0, snd * -24.dbamp * vol.dbamp ! 2);
}).add;
)

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(58 * (1 + (2 * Env.perc(0.001, 0.024).ar) * velocity) * (1 + (0.7 * Env.perc(0.001, 0.2).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 16328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
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
SynthDef(\hat, {
	var snd, freqs;
	snd = Hasher.ar(Sweep.ar);
	freqs = ((0..20) * 164789).sin.linexp(-1, 1, 200, 3e3);
	snd = CombC.ar(snd, 1 / freqs, 1 / freqs, 0.1);
	snd = snd.sum * -15.dbamp;
	snd = FreqShift.ar(snd, -210);
	snd = HPF.ar(snd, 1560);
	snd = BPF.ar(snd, [8230, 5640, 1230, 6500, 8243], 0.08);
	snd = snd * Env.perc(0.01, 1.0 * [0.8, 0.4, 0.6, 0.1, 0.15, 0.2]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.02, 2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.01, curve: -4).ar(Done.freeSelf);
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
		s.bind { Synth(\kick); };
		(beat).wait;
	};
}).play;

Routine({
	loop {
		(beat - 0.01).wait;
		s.bind { Synth(\clap); };
		(beat + 0.01).wait;
	};
}).play;

Routine({
	loop {
		(beat/2).wait;
		s.bind { Synth(\hat); };
		(beat/2).wait;
	};
}).play;

Routine({
	var dur, octave, notes, note;
	dur = beat;
	loop {
		[
			// Guap
			[0 + [0, 3, -5], 7],
			[1 + [0, 3, -5, -2], 1],
			[0 + [0, 3, -5], 7],
			[1 + [0, 3, -5, -2], 1],
			[0 + [0, 3, -5], 7],
			[1 + [0, 3, -5, -2], 1],
			[0 + [0, 3, -5], 4],
			[7 + [0, 3, -5], 2],
			[1 + [0, 3, -5, -2], 2],
		].do { |chord|
			var notes = chord[0];
			dur = chord[1];
			notes.do {|deg|
				var note = (42 + deg + (12 * 1)).midicps;
				s.bind { Synth(\organ, [freq: note, spread: 1, rel: dur * beat * 5, duration: dur * beat, vol: -16]); };
			};
			(beat * dur).wait
		};
	};
}).play;

Routine({
	var idx = 1, vol = 0;
	loop {
		[
			0, 0, 1, 0,
		].do { |note|
			vol = 2;
			if(idx == 1, { vol = -10; });
			if(idx == 2, { vol = -5; });
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