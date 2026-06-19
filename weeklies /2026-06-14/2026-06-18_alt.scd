(
SynthDef(\kick, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(Env.perc(0, 0.14, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 200)) * XLine.ar(1.05, 1, 0.2));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.3, curve: -4).ar;
	snd = LPF.ar(snd, XLine.ar(300, 100, 0.2));
	hi = snd;
	hi = hi * (1 + (LPF.ar(LPF.ar(RHPF.ar({ PinkNoise.ar } ! 2, 1230, 0.5), 2e3), 7e3) * -5.dbamp));
	hi = (hi * 10).tanh;
	hi = hi + DelayC.ar(hi * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	hi = HPF.ar(hi, 2500);
	hi = LPF.ar(hi, 8000);
	hi = hi * -14.dbamp;
	snd = (snd * 0.8).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd + hi;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = (BPF.ar(snd, [1223, 1500], 0.4) * [20, 10].dbamp).sum;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.015, 0.001, 0.015, 0.001, 0.07] * 0.9, curve: -4).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -27.dbamp, 30, 1);
	snd = BHiShelf.ar(snd, 2300, 0.3, -3);
	snd = snd * (1 + Env.perc(0, 0.01).ar); // transient
	snd = snd * Env.linen(0.0, 0.5, 0.9, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(230))) + Hasher.ar(Sweep.ar + 1);
	snd = BPF.ar(snd, [7223, 9.234e3], 0.4);
	snd = snd.sum;
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.perc(0.003, 0.09, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\keys, {
	var snd, freq, velocity, n, freqs;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..20);
	// outer partial, inner detune
	freqs = freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 2.5] * n * n)).sqrt * [([0, -0.03, 0.03] * 2).midiratio];
	snd = Env([0, 1, 0.2, 1, 0.02, 1, 0], [0.003, 0.002 * Rand(1, 2), 0.002, 0.003 * Rand(1, 2), 0.001, 0.01] * 1, -4).ar * 3.dbamp;
	snd = (snd * 10.dbamp).fold2;
	snd = HPF.ar(snd, 300);
	snd = snd * (1 + (WhiteNoise.ar * 2));
	snd = Ringz.ar(snd, freqs, 20 / n.pow(1.3));
	snd = snd / (n ** 0.7);
	snd = snd.sum;
	snd = LeakDC.ar(snd);
	snd = Splay.ar(snd, 0.05);
	snd = snd * -53.dbamp * \amp.kr(1.0);
	snd = snd * Env.perc(0.0, 10.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\pianoFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = CombC.ar(snd, 0.2, 1 / 54, 0.1);
	snd = HPF.ar(snd, 200);
	snd = snd * 5.dbamp;
	snd = LPF.ar(snd, 2000);
	snd = snd.tanh;
	snd = LPF.ar(snd, 2000);
	// snd = snd + DelayC.ar(snd * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	snd = snd + GVerb.ar(snd.sum * -14.dbamp, 30, 3);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sidechainFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (Env.perc(0.01, 0.3, curve: 4).ar(gate: T2A.ar(\pump.tr)) * 0.6));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Saw.ar(\freq.kr(440) * (LFNoise2.ar(20 ! 5) * 0.4).midiratio);
	snd = RLPF.ar(snd, XLine.ar(100, 1000, 0.1) * LFNoise2.ar(3 ! snd.size).linexp(-1, 1, 0.5, 2), 0.6);
	snd = Splay.ar(snd);
	snd = snd * Env.linen(0.01, duration * 0.8, duration * 0.2, curve: 4).ar(Done.freeSelf);
	snd = snd * -15.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, bar, tatum, play, playP, wait, noteToFreq;

s = Server.default;

beat = 60 / 121;
bar = beat * 4;
tatum = beat / 4;

playP = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};

play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};

wait = { |duration|
	(duration * beat).wait;
};

noteToFreq = { |note, octave = 0|
	(60 + note + (octave * 12)).midicps;
};

Routine({
	var sidechainBus, sidechainFx, pianoBus, pump;
	var playHat, pianoChord, playKick;

	s.newBusAllocators;

	s.bind {
		sidechainBus = Bus.audio(nil, 2);
		pianoBus = Bus.audio(nil, 2);
		Synth.tail(nil, \pianoFx, [in: pianoBus, out: sidechainBus]);
		sidechainFx = Synth.tail(nil, \sidechainFx, [in: sidechainBus, out: 0]);
	};

	pump = {
		s.bind { sidechainFx.set(\pump, 1) };
	};

	playHat = { |n|
		n.do { |i|
			play.(\hat, 1 / n, [
				pan: if(((n % 2) == 1) or: { n >= 6 }, 0.0, [-0.3, 0.3].wrapAt(i))
			]);
		};
	};

	pianoChord = { |notes, length, vol=1.0|
		("n: " + notes.sort + ", int: " + (notes % 12).sort).postln;
		fork {
			notes.sort.do { |note, i|
				var amp = i.linlin(0, 4, 1.1, 0.9) * vol;
				playP.(\keys, 1 / 2, [ freq: noteToFreq.(note), amp: amp, out: pianoBus]);
				// wait.(rrand(1 / 16, 1 / 8));
			};
		};
		wait.(length);
	};

	playKick = { |duration, args = #[]|
		pump.();
		play.(\kick, duration, args);
	};

	inf.do {

		fork {
			0.do {
				[2, 2, 2, 3, 2, 2, 6, 2, 2, 2, 2, 3, 2, 3, 2, 12].do { |n|
					playHat.(n);
				};
			};
		};

		fork {
			0.do {
				// 8 beats
				playKick.(2, [freq: noteToFreq.(8, -3)]);
				play.(\clap, 2);
				wait.(1 / 2);
				playKick.((1 / 2), [freq: noteToFreq.(2, -3), velocity: 0.5]);
				playKick.(1, [freq: noteToFreq.(2, -3)]);
				play.(\clap, 1);
				playKick.(1, [freq: noteToFreq.(7, -3), velocity: 0.5]);
				// 8 beats
				playKick.(2, [freq: noteToFreq.(0, -3)]);
				play.(\clap, 2);
				wait.(1 / 2);
				playKick.((1 / 2), [freq: noteToFreq.(0, -3), velocity: 0.5]);
				playKick.(1, [freq: noteToFreq.(0, -3), bend: 12]);
				play.(\clap, 1);
				playKick.(1, [freq: noteToFreq.(7, -3), bend: 12, velocity: 0.5]);
			};
		};

		// CHORD PROGRESSION...


		1.do {
			'bvi-v-biii | bvi-v-i'.postln;

			'=> chord: bvi <==============='.postln;
			pianoChord.((-4 + [0, 3+24, 7+24, 10, 17]), length: 3);
			'=> chord: v <==============='.postln;
			pianoChord.((-5 + [0, 3+24, 7+24, 10+12, 12]), length: 5 + 8);

			'=> chord: bvi <==============='.postln;
			pianoChord.((-4 + [0, 3+24, 7+24, 10, 17]), length: 3);
			'=> chord: v <==============='.postln;
			pianoChord.((-5 + [0, 3+24, 7+24, 10+12, 12]), length: 5);

			'=> chord: biii sus2 <==============='.postln;
			pianoChord.((-9 + [0, 12, 2+24, 7+24, 10+24]), length: 8); // sus 2

			'=> chord: bvi <==============='.postln;
			pianoChord.((-4 + [0, 3+24, 7+24, 10, 17]), length: 3);
			'=> chord: v <==============='.postln;
			pianoChord.((-5 + [0, 3+24, 7+24, 10+12, 12]), length: 5 + 8);

			'=> chord: bvi <==============='.postln;
			pianoChord.((-4 + [0, 3+24, 7+24, 10, 17]), length: 3);
			'=> chord: v <==============='.postln;
			pianoChord.((-5 + [0, 3+24, 7+24, 10+12, 12]), length: 5);

			'=> chord: i (root) <==============='.postln;
			pianoChord.((0 + [-12, 24, 3+12, 7, 10+12]), length: 8); // root
		};


	};
}).play;
)


((-4 + [0, 3+24, 7+12, 10])  % 12).sort; // bvi [ 3, 6, 8, 11 ]
((-5 + [0, 3+24, 7+12, 10]) % 12).sort; // v [ 2, 5, 7, 10 ]
((-9 + [0, 2+12, 7+24, 10+12]) % 12).sort; // biii sus2 [ 1, 3, 5, 10 ]
((0 + [0, 3+12, 7, 10+12]) % 12).sort; // i [ 0, 3, 7, 10 ]

// endfile... 