(
SynthDef(\swarmHat, {
	arg rel=0.2, amp=(-20);
	var snd, freq=440;
	snd = Pulse.ar(freq * [1, 1.75, 0.06, 0.75, 1.55].midiratio);
	snd = (WhiteNoise.ar.pow(9.0) * 0.8) + snd.sum;
	snd = BPF.ar(snd, 16e3, 0.3);
	snd = snd * (1 + (6 * Env.perc(0, 0.03).ar));
	snd = snd * Env.perc(0.001, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * amp.dbamp);
}).add;
SynthDef(\delKick, {
	var snd;
	snd = SinOsc.ar(58 * (1 + (3 * Env.perc(0, 0.1).ar)) * (1 + (4 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10320, 0.3) * Env.perc(0.01, 0.04).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.2).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(-16).dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\clapYcgm, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1230);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\padMid, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.1, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = Saw.ar((freq * (LFNoise2.kr(3 ! 3) * 0.1).midiratio));
	snd = Splay.ar(snd, 0.5);
	snd = RLPF.ar([snd], env.linexp(0, 1, 100, 700) * [1, 1.3], 0.3).sum * -5.dbamp;
	snd = snd.tanh;
	snd = snd + FreqShift.ar(snd, 0.5);
	snd = BPF.ar([snd], (1..30).normalize.linexp(0, 1, 100, 7000), 0.3).sum;
	snd = snd + CombC.ar(snd * -10.dbamp, 0.2, 1 / 70, 1.0);
	snd = snd * env;
	snd = snd * -32.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.2, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = LFTri.ar(freq * (LFNoise2.kr(3) * 0.1).midiratio);
	snd = snd ! 2;
	snd = snd * env;
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\pad, [duration: 4]);

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;

randomNote = { |octave|
	(root + scale.choose + (12 * octave)).midicps;
};

getNote = { |note=0, octave=0|
	(root + scale.wrapAt(note) + (12 * (note.div(scale.size) + octave))).midicps;
};

wait = { |duration|
	(duration * beat).wait;
};
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	wait.(duration);
};
Routine({ // Hat
	loop {
		[0.4, 0.1, 0.2, 0.2, 0.4, 0.2, 0.1, 0.2].do { |rel, index|
			play.(\swarmHat, 1/4, [amp: index.linlin(1, 8, -16, -6), rel: rel]);
		};
	};
}).play;
Routine({ // Kick & Clap
	loop {
		play.(\delKick, 0.25);
		play.(\delKick, 0.75);
		play.(\clapYcgm, 0.5, [amp: -5]);
		play.(\clapYcgm, 0.5, [amp: -18, filtCutoff: 15e3]);
		play.(\delKick, 0.25);
		play.(\delKick, 0.25);
		play.(\delKick, 0.5);
		play.(\clapYcgm, 0.5, [amp: -5]);
		play.(\clapYcgm, 0.5, [amp: -18, filtCutoff: 15e3]);
	};
}).play;
Routine({ // Hat
	var dur = beat * 8;
	loop {
		Synth(\pad, [freq: (root + 0 + (12 * 1)).midicps, duration: dur]);
		Synth(\pad, [freq: (root + 3 + (12 * 1)).midicps, duration: dur]);
		Synth(\pad, [freq: (root + 7 + (12 * 1)).midicps, duration: dur]);
		Synth(\pad, [freq: (root + 10 + (12 * 1)).midicps, duration: dur]);
		wait.(dur);
	};
}).play;

)