(
SynthDef(\swarmHat, {
	arg rel=0.2, amp=(-20);
	var snd, freq=460;
	snd = Pulse.ar(freq * [1, 1.75, 0.06, 0.75, 1.55].midiratio);
	snd = (WhiteNoise.ar.pow(9.0) * 0.8) + snd.sum;
	snd = BPF.ar(snd, 16e3, 0.3);
	snd = snd * (1 + (6 * Env.perc(0, 0.03).ar));
	snd = snd * Env.perc(0.001, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * amp.dbamp * -4.dbamp);
}).add;
SynthDef(\delKick, {
	var snd;
	snd = SinOsc.ar(60 * (1 + (1.5 * Env.perc(0, 0.1).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (2 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.04).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.25).ar;
	snd = snd + DelayC.ar(snd * -28.dbamp, 0.2, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-22).dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\clapYcgm, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1510);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	// snd = snd * (1 + (1.1 * Env.perc(0.001, 0.01).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1).dbamp * -2.dbamp;
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
	snd = snd * -26.dbamp;
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
	snd = snd * Env.perc(0.001, 0.6, curve: -10).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr, snd);
}).add;

SynthDef(\pluckBass, {
	var snd;
	snd = Pulse.ar(\freq.kr(60) * XLine.ar(2, 1, 0.01));
	snd = MoogFF.ar(snd, Env.perc(0.02, \filtVal.kr(0.4)).ar.linexp(0, 1, 80, 3000), 1) * 6.dbamp;
	snd = snd * Env.perc(0.001, 0.6).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -18.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\fxSidechain, { | trigger=1 |
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = FreeVerb.ar(snd, 0.5, 0.9);
	snd = snd + (snd * 14.dbamp).tanh * -22.dbamp;
	snd = snd * EnvGen.kr(Env([1,0,0.15,1], [0.0001, 0.07, 0.25], 'lin'), trigger, doneAction: 0);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keysFX, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + CombL.ar(snd * -20.dbamp, 0.25, 0.1, 1);
	snd = FreeVerb.ar(snd, 0.1, 0.8);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bassFX, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	// snd = snd + CombL.ar(snd * -15.dbamp, 0.25, 0.1, 1);
	snd = FreeVerb.ar(snd, 0.6, 0.4);
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
Synth(\swarmHat);

Scale.dorian.degrees;


(
~fxBus = Bus.audio(s, 2);
~keysBus = Bus.audio(s, 2);
~bassFxBus = Bus.audio(s, 2);
)
~fxBus.index;
~keysBus.index;
~bassFxBus.index;

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play, playLayer, fx, keyBus, bassBus;
s = Server.default;
bpm = 108;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;
//
fx = Synth.tail(nil, \fxSidechain, [in: ~fxBus, out: 0, trigger: 0]);
keyBus = Synth.tail(nil, \keysFX, [in: ~keysBus, out: 0, trigger: 0]);
bassBus = Synth.tail(nil, \keysFX, [in: ~bassFxBus, out: 0, trigger: 0]);

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
		if(true, { loop {
			[
				0.6, 0.1, 0.2, 0.2, 0.5, 0.2, 0.1, 0.2,
				0.5, 0.2, 0.2, 0.1, 0.4, 0.1, 0.2, 0.2
			].do { |rel, index|
				play.(\swarmHat, 1/4, [amp: (index % 8).linlin(1, 4, -22, -16), rel: rel]);
			};
		}; });
	}).play;
	Routine({ // Percs
		if(true, { loop {

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
		// wait.(16);
		if(true, { loop {

			play.(\delKick, 0.25);
			play.(\delKick, 0.75);
			play.(\clapYcgm, 1, [amp: -10]);
			play.(\delKick, 0.25);
			play.(\delKick, 0.25);
			play.(\delKick, 0.5);
			play.(\clapYcgm, 0.75, [amp: -12]);
			play.(\clapYcgm, 0.25, [amp: -14, filtCutoff: 10e3]);

			play.(\delKick, 0.25);
			play.(\delKick, 0.75);
			play.(\clapYcgm, 0.5, [amp: -12]);
			play.(\clapYcgm, 0.5, [amp: -14, filtCutoff: 10e3]);
			play.(\delKick, 0.25);
			play.(\delKick, 0.25);
			play.(\delKick, 0.5);
			play.(\clapYcgm, 0.75, [amp: -12]);
			play.(\clapYcgm, 0.25, [amp: -14, filtCutoff: 10e3]);

		}; });
	}).play;
	Routine({ // Sidechain Trigger
		// wait.(16);
		if(true, { loop {
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

					Synth(\padLow, [freq: (root + deg + (12 * 1)).midicps, duration: dur * 1.5, amp: -28, out: ~fxBus]);
					// Synth(\padHigh, [freq: (root + deg + (12 * 1)).midicps, duration: dur * 1.5, amp: -32, out: ~fxBus]);
					Synth(\padLow, [freq: (root + deg + (12 * 3)).midicps, duration: dur * 1.5, amp: -36, out: ~fxBus]);
					Synth(\padHigh, [freq: (root + deg + (12 * 2)).midicps, duration: dur * 1.5, amp: -22, out: ~fxBus]);

				};
				dur.wait;
			};
		}; });
	}).play;

	Routine({ // Key
		// wait.(16);
		// wait.(8);
		if(true, { loop {
			[
				0, 0, 7, \, 3, \, 2, \, \, \, \, \, 2, \, 2, \,
				5, \, 0, \, 2, \, 5, \, \, \, \, \, \, \, \, \,
				9, \, 1, \, 4, \, 7, \, \, \, \, \, \, \, \, \,
				8, \, 0, \, 3, \, 5, \, \, \, \, \, \, \, \, \,
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
		if(false, { loop {
			[
				/*0, \, \, \, 0, \, \, \, \, 0, 0, 0, \, \, \, \,
				0, \, \, \, 0, \, \, \, \, 0, 0, 0, \, \, \, \,
				0, \, \, \, 0, \, \, \, \, 0, 0, 0, \, \, \, \,
				0, \, \, \, 0, \, \, \, \, \, 0, 0, 0, 0, 0, 0,*/
				/*\, \, 2, 2, \, 2, 2, \, \, \, \, \, \, \, \, \,
				\, \, -1, -1, \, -1, -1, \, \, \, \, \, \, \, \, \,*/

				\, \, 0, 0, \, \, \, \, \, \, 0, 0, \, \, \, \,
				\, \, 0, 0, \, \, \, \, \, \, 0, 0, \, \, \, \,
				\, \, 0, 0, \, \, \, \, \, \, 0, 0, \, \, \, \,
				\, \, 0, 0, \, \, \, \, \, \, 0, 0, \, \, \, \,

				/*\, \, 0, 0, \, 0, 0, \, \, \, \, \, \, \, \, \,*/

				/*\, \, 0, 0, \, 0, 0, \, \, \, \, \, \, \, \, \,
				\, \, 5, 5, \, 5, 5, \, \, \, \, \, \, \, \, \,
				\, \, 9, 9, \, 9, 9, \, \, \, \, \, \, \, \, \,
				\, \, 8, 8, \, 8, 8, \, \, \, \, \, \, \, \, \,*/
			].do { |deg|
				if(deg == \, {
					wait.(0.25);
				}, {
					play.(\pluckBass, 0.25, [freq: (root + deg + (12 * (-1))).midicps, out: ~bassFxBus]);
				});
			};
		}; });
	}).play;


}).play;

)

s.makeWindow;








