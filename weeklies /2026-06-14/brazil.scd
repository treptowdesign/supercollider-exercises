(
SynthDef(\kick, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(Env.perc(0, 0.14, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 300)) * XLine.ar(1.05, 1, 0.2));
	snd = snd * Env.perc(0, 3).ar; // <=== tail length
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.3, curve: -8).ar;
	snd = LPF.ar(snd, XLine.ar(300, 100, 0.2));
	hi = snd;
	hi = hi * (1 + (LPF.ar(LPF.ar(RHPF.ar({ PinkNoise.ar } ! 2, 1230, 0.5), 2e3), 7e3) * -5.dbamp));
	hi = (hi * 6).tanh;
	hi = hi + DelayC.ar(hi * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	hi = HPF.ar(hi, 2500);
	hi = LPF.ar(hi, 8000);
	hi = hi * -14.dbamp;
	snd = (snd * 0.8).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	// snd = snd + hi;
	snd = snd.tanh ! 2;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = (BPF.ar(snd, [1223, 1400], 0.4) * [20, 10].dbamp).sum;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.013, 0.001, 0.013, 0.001, 0.07] * 0.9, curve: -4).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -35.dbamp, 30, 0.4);
	snd = BHiShelf.ar(snd, 2300, 0.3, -3);
	snd = snd * (1 + Env.perc(0, 0.01).ar); // transient
	snd = snd * Env.linen(0.0, 0.5, 0.9, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [1320, 1120, 1200], 0.3) * 15.dbamp;
	snd = snd * Env([0, 8, 0.4, 0], [0.001, 0.01, 0.3] * 0.8, curve: -4).delay([0, 2, 1.2] * 17e-3).ar;
	snd = (snd * 2).clip2;
	snd = Splay.ar(snd, spread: 0.4);
	snd = snd + (GVerb.ar(snd.sum, 20, 3, damping: 0.3) * -12.dbamp);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(220))) + Hasher.ar(Sweep.ar + 1);
	snd = BPF.ar(snd, [7223, 9234], 0.4);
	snd = snd.sum;
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.perc(0.003, 0.09, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\keysA, {
	var snd, freq, velocity, n, freqs;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..20);
	// outer partial, inner detune
	freqs = freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 2] * n * n)).sqrt * [([0, -0.03, 0.03] * 3).midiratio];
	snd = Env([0, 1, 0.2, 1, 0.02, 1, 0], [0.003, 0.002 * Rand(1, 2), 0.002, 0.003 * Rand(1, 2), 0.001, 0.01] * 2, -4).ar * 3.dbamp;
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

SynthDef(\keys, {
	var snd, freq, velocity, n, freqs;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..20);
	// outer partial, inner detune
	freqs = freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 2] * n * n)).sqrt * [([0, -0.03, 0.03] * 3).midiratio];
	snd = Env([0, 1, 0.2, 1, 0.02, 1, 0], [0.003, 0.002 * Rand(1, 2), 0.002, 0.003 * Rand(1, 2), 0.001, 0.01] * 2, -4).ar * 3.dbamp;
	snd = (snd * 10.dbamp).fold2;
	snd = HPF.ar(snd, 300);
	snd = snd * (1 + (WhiteNoise.ar * 2));
	snd = Ringz.ar(snd, freqs,3 / n.pow(0.8));
	snd = snd / (n ** 0.7);
	snd = snd.sum;
	snd = LeakDC.ar(snd);
	snd = Splay.ar(snd, 0.05);
	snd = snd * -60.dbamp * \amp.kr(1.0);
	snd = snd * Env.perc(0.0, 10.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\saw, {
	var snd, count, freq, duration;
	count = 10;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(0.6) } ! count) * 0.4).midiratio, { Rand(0, 4) } ! count);
	snd = snd + PitchShift.ar(snd * 0.dbamp, 0.12, 0.5);
	snd = Splay.ar(snd) * -8.dbamp;
	snd = snd + (MoogFF.ar(snd, XLine.kr(6000, freq, duration), 2) * -2.dbamp);
	snd = snd * Env.perc(0.06, duration * 3, curve: -8).ar(Done.freeSelf);
	snd = snd * -5.dbamp * \amp.kr(1.0);
	Out.ar(\out.kr(0), snd);
}).add;


/*SynthDef(\pianoFx2, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = CombC.ar(snd, 0.2, 1 / 46, 0.2);
	/*snd = HPF.ar(snd, 200);
	snd = snd * 5.dbamp;
	snd = LPF.ar(snd, 2000);
	snd = snd.tanh;
	snd = LPF.ar(snd, 2000);*/
	// snd = snd + DelayC.ar(snd * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	snd = LPF.ar(snd, 12000);
	snd = snd.tanh;
	snd = LPF.ar(snd, 10000);
	snd = snd + GVerb.ar(snd.sum * -12.dbamp, 30, 4);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;*/

SynthDef(\pianoFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	// snd = CombC.ar(snd, 0.2, 1 / 45, 0.2);
	snd = snd + (FreqShift.ar(CombC.ar(FreqShift.ar(snd, -41), 0.2, 1 / 58, -0.17), 41) * -8.dbamp);
	snd = LPF.ar(snd, 5000);
	snd = snd + GVerb.ar(snd.sum * -2.dbamp, 30, 2);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sidechainFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (Env.perc(0.01, 0.3, curve: 8).ar(gate: T2A.ar(\pump.tr)) * 0.7));
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

beat = 60 / 94;
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
				// var amp = i.linlin(0, 4, 1.1, 0.9) * vol;
				var amp = vol;
				playP.(\keys, 1/2, [ freq: noteToFreq.(note), amp: amp, out: pianoBus]);
				wait.(rrand(1/16, 1/8));
				// wait.(1/16);
			};
		};
		wait.(length);
	};

	playKick = { |duration, args = #[]|
		pump.();
		play.(\kick, duration, args);
	};


	/////////////////////////////////////////////////////////////////
	~playHat_16beat = {
		fork {
			2.do {
				[2,4,2,4,2,6,2,4].do { |n|
					playHat.(n);
				};
			};
		};
	};

	~playKick_16beat = {
		fork {
			16.do {
				playKick.(1, [freq: noteToFreq.(0, -3)]);
			};
		};
	};

	~playKick2_16beat = {
		fork {
			4.do {
				playKick.(4, [freq: noteToFreq.(0, -3)]);
			};
		};
	};

	~playClap_16beat = {
		fork {
			4.do {
				wait.(0.75);
				play.(\clap, 0.75);
				play.(\clap, 0.5);
				wait.(0.75);
				play.(\clap, 0.75);
				play.(\clap, 0.5);
			};
		};
	};

	~playClap2_16beat = {
		fork {
			4.do {
				wait.(0.75);
				playP.(\clap2, 0.75);
				play.(\clap, 0.75);
				playP.(\clap2, 0.5);
				play.(\clap, 0.5);
				wait.(0.75);
				playP.(\clap2, 0.75);
				play.(\clap, 0.75);
				playP.(\clap2, 0.5);
				play.(\clap, 0.5);
			};
		};
	};

	~playSaw_16beat = { |octave=1|
		fork {
			var outBus = pianoBus;
			4.do {
				[-4, 0, 3, 2,   -5, 5, 2, 3 ].do { |int|
					play.(\saw, 0.5, [freq: noteToFreq.(int, octave), bend: 0, out: outBus]);
				};
			};
		};
	};

	~playKeys_16beat = {
		fork {
			var outBus = 0, octave = 0;
			4.do {
				[-4, 0, 3, 2,   -5, 5, 2, 3 ].do { |int|
					play.(\keys, 0.5, [freq: noteToFreq.(int, octave), bend: 0, out: outBus]);
				};
			};
		};
	};

	inf.do {

		~playHat_16beat.();
		~playKick2_16beat.();
		~playClap_16beat.();
		~playSaw_16beat.(octave: 0);
		wait.(16); // GLOBAL WAIT

		~playHat_16beat.();
		~playKick_16beat.();
		~playClap2_16beat.();
		~playSaw_16beat.(octave: 1);
		wait.(16); // GLOBAL WAIT




	};
}).play;
)



{ Hasher.ar(Sweep.ar(Impulse.ar(310))) + Hasher.ar(Sweep.ar + 1) * 0.01 ! 2}.play;


( // Start Up for Headphones
Server.default.options.outDevice_("External Headphones");
s.options.memSize = 1048576;
s.options.numWireBufs = 128;
s.boot;
)


s.makeWindow;



// endfile... 