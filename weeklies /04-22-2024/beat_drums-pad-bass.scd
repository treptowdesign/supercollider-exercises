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
	snd = SinOsc.ar(60 * (1 + (3 * Env.perc(0, 0.1).ar)) * (1 + (4 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10320, 0.3) * Env.perc(0.01, 0.04).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.2).ar;
	snd = snd + DelayC.ar(snd * -24.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(-14).dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\clapYcgm, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1610);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\percAlgoB, {
	var snd;
	snd = SinOsc.ar(920 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + GVerb.ar(snd * -15.dbamp, 10);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\perc2AlgoB, {
	var snd;
	snd = SinOsc.ar(310 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd + Latch.ar(GVerb.ar(snd * -15.dbamp, 4), Impulse.ar(8320));
	snd = snd * Env.perc(0.0, 0.5).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\padLow, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.1, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = LFTri.ar(freq * (LFNoise2.kr(3) * 0.1).midiratio);
	snd = snd ! 2;
	snd = snd * env;
	snd = snd * -16.dbamp;
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
	snd = snd * -28.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\padHigh, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.1, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = Pulse.ar((freq * (LFNoise2.kr(3 ! 3) * 0.1).midiratio) + 20);
	snd = Splay.ar(snd, 0.5);
	snd = FreqShift.ar(snd, -20);
	snd = (BPF.ar([snd], [730, 1440, 3200], 0.3) * [0, -5, -10].dbamp).sum;
	snd = LPF.ar(snd, 1200);
	snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	snd = snd * env;
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxSidechain, { | trigger=0 |
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = FreeVerb.ar(snd, 0.6, 0.9);
	snd = snd * EnvGen.kr(Env([1,0,0,1], [0.0001, 0.1, 0.1]), trigger, doneAction: 0);
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\padLow, [freq: 440, duration: 4]);
Synth(\padMid, [freq: 440, duration: 4]);
Synth(\padHigh, [freq: 440, duration: 4]);
Synth(\percAlgoB);
Synth(\perc2AlgoB);

Scale.dorian.degrees;

~fxBus.index;

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

Routine({
	var fx;
	~fxBus = Bus.audio(s, 2);
	fx = Synth.tail(nil, \fxSidechain, [in: ~fxBus, out: 0]);

	Routine({ // Hat
		loop {
			[
				0.8, 0.1, 0.2, 0.2, 0.6, 0.2, 0.1, 0.2,
				0.5, 0.2, 0.2, 0.1, 0.4, 0.1, 0.2, 0.2
			].do { |rel, index|
				play.(\swarmHat, 1/4, [amp: (index % 8).linlin(1, 8, -16, -8), rel: rel]);
			};
		};
	}).play;
	Routine({ // Hat
		loop {
			play.(\perc2AlgoB, 0.25);
			play.(\perc2AlgoB, 0.75);
			play.(\percAlgoB, 1);
		};
	}).play;
	Routine({ // fx sidechain
		loop {
			fx.set(\trigger, 1);
			wait.(0.25);
			fx.set(\trigger, 0);
			wait.(0.75);
			fx.set(\trigger, 1);
			wait.(1);
			fx.set(\trigger, 0);
			wait.(1);

		};
	}).play;
	Routine({ // Kick & Clap
		loop {
			play.(\delKick, 0.25);
			play.(\delKick, 0.75);
			play.(\clapYcgm, 1, [amp: -5]);
			play.(\delKick, 0.25);
			play.(\delKick, 0.25);
			play.(\delKick, 0.5);
			play.(\clapYcgm, 0.75, [amp: -5]);
			play.(\clapYcgm, 0.25, [amp: -18, filtCutoff: 15e3]);


			play.(\delKick, 0.25);
			play.(\delKick, 0.75);
			play.(\clapYcgm, 0.5, [amp: -5]);
			play.(\clapYcgm, 0.5, [amp: -18, filtCutoff: 15e3]);
			play.(\delKick, 0.25);
			play.(\delKick, 0.25);
			play.(\delKick, 0.5);
			play.(\clapYcgm, 0.75, [amp: -5]);
			play.(\clapYcgm, 0.25, [amp: -18, filtCutoff: 15e3]);
		};
	}).play;
	Routine({ // Pad
		var dur;
		dur = beat * 4;
		loop {
			[
				[0, 3, 7, 10, 2], // i9
				[5, 9, 0, 2, 4], // bVI9
				[9, 1, 4, 7], // V7
				[8, 0, 3, 5], // IVMaj7
			].do { |chord, index|
				// Synth(\padLow, [freq: (root + chord[0] + (12 * 0)).midicps, duration: dur * 1.5]);
				chord.do { |deg|
					Synth(\padLow, [freq: (root + deg + (12 * 1)).midicps, duration: dur * 1.5, out: ~fxBus]);
					Synth(\padLow, [freq: (root + deg + (12 * 2)).midicps, duration: dur * 1.5, out: ~fxBus]);
					// Synth(\padMid, [freq: (root + deg + (12 * 3)).midicps, duration: dur * 1.5]);
					// Synth(\padHigh, [freq: (root + deg + (12 * 2)).midicps, duration: dur * 1.5]);
					// Synth(\padMid, [freq: (root + deg + (12 * 3)).midicps, duration: dur * 1.5]);
					// Synth(\padLow, [freq: (root + deg + (12 * 2)).midicps, duration: dur * 1.5]);
				};
				dur.wait;
			};
		};
	}).play;
}).play;
)

44 + [2, 5, 7, 9];

// Jazzy
[0, 3, 7, 10, 2], // i9
[5, 9, 0, 4], // bVIMaj7
[6, 9, 1, 3], // ii7 ????? sounds bad
[9, 1, 4, 7], // V7

// trying to fix that 3rd chord
[0, 3, 7, 10, 2], // i9
[5, 9, 0, 4], // bVIMaj7
[2, 5, 7, 9], // ii7 ???? no idea what chord this is
[9, 1, 4, 7], // V7

// borrowed chord and sus
[0, 3, 7, 10, 2], // i9
[5, 9, 0, 2, 4], // bVI9
[9, 1, 4], // Vsus4
[9, 1, 4, 7], // V7
[8, 0, 3, 5], // IVMaj7

// pgrygian progs:
// i - bII - i - VII
[0, 3, 7, 10],
[2, 5, 9, 0],
[0, 3, 7, 10],
[7, 10, 2, 5],
// bII - i - VII - iv
[2, 5, 9, 0],
[0, 3, 7, 10],
[7, 10, 2, 5],
[5, 8, 0, 3],
// i - VII - bII - i
[0, 3, 7, 10],
[7, 10, 2, 5],
[2, 5, 9, 0],
[0, 3, 7, 10],
// i - bII - i - VII
[0, 3, 7, 10],
[2, 5, 9, 0],
[0, 3, 7, 10],
[7, 10, 2, 5],
// VII - bII - i - iv
[7, 10, 2, 5],
[2, 5, 9, 0],
[0, 3, 7, 10],
[5, 8, 0, 3],