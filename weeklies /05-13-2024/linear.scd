(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(56 * (1 + (2 * Env.perc(0.001, 0.02).ar) * velocity) * (1 + (0.7 * Env.perc(0.001, 0.2).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 14328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.3 * velocity).ar(Done.freeSelf);
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
	snd = snd + DelayL.ar(snd * -15.dbamp, 0.05, [25e-3, 38e-3]);
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
	snd = snd * Env.perc(0.01, 0.5 * [0.8, 0.4, 0.6, 0.1, 0.15, 0.2]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.02, 2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp * \amp.kr(0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 42;
scale = Scale.phrygian.degrees;

Routine({
	loop {
		s.bind{ Synth(\kick, [velocity: 1]); };
		(beat/4).wait;
		s.bind{ Synth(\kick, [velocity: 0.8]); };
		(beat/4).wait;
		s.bind{ Synth(\hat); };
		(beat/4).wait;
		s.bind{ Synth(\hat, [amp: -15]); };
		(beat/4).wait;
		s.bind{ Synth(\clap); };
		(beat/2).wait;
		s.bind{ Synth(\hat); };
		(beat/4).wait;
		s.bind{ Synth(\hat, [amp: -15]); };
		(beat/4).wait;
	};
}).play;

)