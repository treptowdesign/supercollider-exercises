(
SynthDef(\swarmHat, {
	arg rel=0.2, amp=(-20);
	var snd, freq=460;
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
	snd = snd + DelayC.ar(snd * -24.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(-20).dbamp;
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
	snd = snd * -22.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\perc2AlgoB, {
	var snd;
	snd = SinOsc.ar(312 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd + Latch.ar(GVerb.ar(snd * -15.dbamp, 4), Impulse.ar(8320));
	snd = snd * Env.perc(0.0, 0.5).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -32.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\padLow, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.3, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = LFTri.ar(freq * (LFNoise2.kr(3) * 0.1).midiratio);
	snd = snd ! 2;
	snd = snd * env;
	snd = snd * \amp.kr(-10).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\padMid, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.3, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = Saw.ar((freq * (LFNoise2.kr(3 ! 3) * 0.1).midiratio));
	snd = Splay.ar(snd, 0.5);
	snd = RLPF.ar([snd], env.linexp(0, 1, 100, 700) * [1, 1.3], 0.3).sum * -5.dbamp;
	snd = snd.tanh;
	snd = snd + FreqShift.ar(snd, 0.5);
	snd = BPF.ar([snd], (1..30).normalize.linexp(0, 1, 100, 7000), 0.3).sum;
	snd = snd + CombC.ar(snd * -10.dbamp, 0.2, 1 / 70, 1.0);
	snd = snd * env;
	snd = snd * \amp.kr(-28).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\padHigh, {
	var snd, freq, env;
	env = Env([0, 1, 0], [0.3, 1].normalizeSum * \duration.kr(1), \sin).ar(Done.freeSelf);
	freq = \freq.kr(440);
	snd = Pulse.ar((freq * (LFNoise2.kr(3 ! 3) * 0.1).midiratio));
	snd = Splay.ar(snd, 0.5);
	// snd = FreqShift.ar(snd, -20);
	// snd = (BPF.ar([snd], [730, 1240, 2200], 0.3) * [0, -5, -10].dbamp).sum;
	snd = LPF.ar(snd, 900);
	snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	snd = snd * env;
	snd = snd *\amp.kr(-10).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(320);
	snd = SinOsc.ar(freq * [3, 11]) * Env.perc(0.001, 3.0).ar * (1 + (4 * Env.perc(0, 0.3).ar)) * 600 * Hasher.kr(freq).linexp(-1, 1, 1, 1.2);
	snd = snd.sum;
	snd = SinOsc.ar(freq + snd);
	snd = snd * Env([0, 10, 0.5, 1], [0.001, 0.01, 0.001], curve: -4).ar;
	snd = snd.fold2;
	snd = snd * Env.perc(0.001, 1.0, curve: -10).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr, snd);
}).add;

SynthDef(\pluckBass, {
	var snd;
	snd = Pulse.ar(\freq.kr(60) * XLine.ar(2, 1, 0.01));
	snd = MoogFF.ar(snd, Env.perc(0.02, \filtVal.kr(0.35)).ar.linexp(0, 1, 80, 6000), 1) * 6.dbamp;
	snd = snd * Env.perc(0.001, 0.8).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -16.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\fxSidechain, { | trigger=1 |
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = FreeVerb.ar(snd, 0.8, 0.5);
	snd = snd * EnvGen.kr(Env([1,0,0,1], [0.0001, 0.06, 0.13], 'lin'), trigger, doneAction: 0);
	snd = snd + (snd * 10.dbamp).tanh * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keysFX, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + CombC.ar(snd * -25.dbamp, 0.3, 0.3, 2);
	snd = FreeVerb.ar(snd, 0.5, 0.8);
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\padLow, [freq: 440, duration: 4]);
Synth(\padMid, [freq: 440, duration: 4]);
Synth(\padHigh, [freq: 440, duration: 4]);
Synth(\percAlgoB);
Synth(\perc2AlgoB);
Synth(\keys);
Synth(\pluckBass, [freq: 89]);

Scale.dorian.degrees;


(
~fxBus = Bus.audio(s, 2);
~keysBus = Bus.audio(s, 2);
)
~fxBus.index;
~keysBus.index;

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play, playLayer, fx, keyBus;
s = Server.default;
bpm = 108;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
//
fx = Synth.tail(nil, \fxSidechain, [in: ~fxBus, out: 0, trigger: 0]);
keyBus = Synth.tail(nil, \keysFX, [in: ~keysBus, out: 0, trigger: 0]);

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
playLayer = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};


Routine({
	Routine({ // Hat
		if(false, { loop {
			[
				0.8, 0.1, 0.2, 0.2, 0.6, 0.2, 0.1, 0.2,
				0.5, 0.2, 0.2, 0.1, 0.4, 0.1, 0.2, 0.2
			].do { |rel, index|
				play.(\swarmHat, 1/4, [amp: (index % 4).linlin(1, 4, -22, -14), rel: rel]);
			};
		}; });
	}).play;
	Routine({ // Percs
		if(false, { loop {

			play.(\perc2AlgoB, 0.25);
			play.(\perc2AlgoB, 0.75);
			play.(\percAlgoB, 1);

			play.(\perc2AlgoB, 0.25);
			play.(\perc2AlgoB, 0.25);
			play.(\perc2AlgoB, 0.5);
			play.(\percAlgoB, 1);

		}; });
	}).play;
	Routine({ // Kick & Clap
		wait.(16);
		if(false, { loop {

			play.(\delKick, 0.25);
			play.(\delKick, 0.75);
			play.(\clapYcgm, 1, [amp: -10]);
			play.(\delKick, 0.25);
			play.(\delKick, 0.25);
			play.(\delKick, 0.5);
			play.(\clapYcgm, 0.75, [amp: -10]);
			play.(\clapYcgm, 0.25, [amp: -16, filtCutoff: 15e3]);

			play.(\delKick, 0.25);
			play.(\delKick, 0.75);
			play.(\clapYcgm, 0.5, [amp: -10]);
			play.(\clapYcgm, 0.5, [amp: -20, filtCutoff: 15e3]);
			play.(\delKick, 0.25);
			play.(\delKick, 0.25);
			play.(\delKick, 0.5);
			play.(\clapYcgm, 0.75, [amp: -10]);
			play.(\clapYcgm, 0.25, [amp: -16, filtCutoff: 15e3]);

		}; });
	}).play;
	Routine({ // Sidechain Trigger
		wait.(16);
		if(false, { loop {
			s.bind { fx.set(\trigger, 1); };
			wait.(0.05);
			s.bind { fx.set(\trigger, 0); };
			wait.(0.2);
			s.bind { fx.set(\trigger, 1); };
			wait.(0.05);
			s.bind { fx.set(\trigger, 0); };
			wait.(0.2);
			wait.(0.5);
			wait.(1);
			s.bind { fx.set(\trigger, 1); };
			wait.(0.05);
			s.bind { fx.set(\trigger, 0); };
			wait.(0.2);
			s.bind { fx.set(\trigger, 1); };
			wait.(0.05);
			s.bind { fx.set(\trigger, 0); };
			wait.(0.2);
			s.bind { fx.set(\trigger, 1); };
			wait.(0.05);
			s.bind { fx.set(\trigger, 0); };
			wait.(0.2);
			wait.(0.25);
			wait.(1);
		}; });
	}).play;
	Routine({ // Pad 16barLoop
		var dur;
		dur = beat * 4;
		if(false, { loop {
			[
				[0, 3, 7, 10, 2], // i9
				[5, 9, 0, 2, 4], // bVI9
				[9, 1, 4, 7], // V7
				[8, 0, 3, 5], // IVMaj7
			].do { |chord, index|
				chord.do { |deg|

					Synth(\padLow, [freq: (root + deg + (12 * 1)).midicps, duration: dur * 1.5, amp: -32, out: ~fxBus]);
					// Synth(\padHigh, [freq: (root + deg + (12 * 1)).midicps, duration: dur * 1.5, amp: -32, out: ~fxBus]);
					// Synth(\padLow, [freq: (root + deg + (12 * 2)).midicps, duration: dur * 1.5, amp: -18, out: ~fxBus]);
					Synth(\padHigh, [freq: (root + deg + (12 * 2)).midicps, duration: dur * 1.5, amp: -24, out: ~fxBus]);

				};
				dur.wait;
			};
		}; });
	}).play;

	Routine({ // Key
		// wait.(16);
		wait.(8);
		if(false, { loop {
			[
				0, 0, \, \, 7, \, \, \, 0, 0, 0, \, 7, \, \, \,
				0, 0, \, \, 7, \, \, \, 0, 0, 0, \, 7, \, \, 7,
				0, 0, \, \, 7, \, \, \, 0, 0, 0, \, 7, \, \, \,
				0, 0, \, \, 7, \, \, \, 0, 0, 0, \, 7, \, 7, 7,

				0, 0, 0, 0, 7, \, 7, \, 0, 0, 0, \, 7, \, \, \,
				0, 0, \, \, 7, \, \, \, 0, 0, 0, \, 7, \, \, 7,
				0, 0, \, \, 7, 7, 7, 7, 0, 0, \, 0, 7, \, \, \,
				0, 0, \, \, 7, \, \, \, 0, 0, 0, \, 7, \, 7, 7,

			].do { |deg|
				if(deg == \, {
					wait.(0.25);
				}, {
					play.(\keys, 0.25, [freq: (root + deg + (12 * 2)).midicps, out: ~keysBus]);
				});
			};
		}; });
	}).play;

	Routine({ // PluckBass
		// wait.(16);
		if(true, { loop {
			[
				\, \, \, \, 0, \, \, \, \, 0, 0, 0, \, \, \, \,
				\, \, \, \, 0, \, \, \, \, \, 0, 0, 0, 0, 0, 0,
				\, \, \, \, 0, \, \, \, \, 0, 0, 0, \, \, \, \,
				\, \, \, \, 0, \, \, \, \, \, 12, 12, 12, 0, 0, 0,
			].do { |deg|
				if(deg == \, {
					wait.(0.25);
				}, {
					play.(\pluckBass, 0.25, [freq: (root + deg + (12 * (-1))).midicps, out: 0]);
				});
			};
		}; });
	}).play;


}).play;

)

s.makeWindow;












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