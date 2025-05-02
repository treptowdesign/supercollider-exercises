//////////////////////////////////////////////
// SynthDefs
//////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.06).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6220, 0.4) * Env.perc(0.05, 0.1).ar * -24.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 12.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(210 * XLine.ar(1.4, 1, 0.005) * [1, 2.3, 4.5]);
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 830, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.2 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 60);
	snd = BPF.ar(snd, [12640, 6230, 10832, 9830, 8620], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.01, 0.03).ar * -15.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.25, 1 / 60, 1);
	snd = FreqShift.ar(snd, -30);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\honk, {
	var snd, dry, wet;
	snd = VarSaw.ar(\freq.kr(80) * (LFNoise2.kr(16) * 0.1).midiratio, width: 0.98);
	snd = MoogFF.ar(snd, XLine.kr(700, 5300, 0.03), 0.2) * 5.dbamp;
	dry = snd * Env([0, 1, 0.7, 0], [0.01, 0.07, 0.06], -4).ar * (1 + (0.3 * Env.perc(0.01, 0.05).ar));
	dry = dry * -5.dbamp;
	dry = dry.tanh;
	wet = snd;
	wet = wet + DelayC.ar(wet, 0.2, LFNoise2.kr(7 ! 2).linlin(-1, 1, 0, 1) * 5e-3);
	wet = MoogFF.ar(wet, 2200) * 4.dbamp;
	wet = wet * Env.perc(0.01, 1.4, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	wet = wet * -12.dbamp;
	snd = dry + wet;
	snd = snd * -12.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fmBass, {
	var freq, snd, env, modEnv;
	freq = \freq.kr(50);
	env = Env.perc(\atk.kr(0.001), \rel.kr(0.8), curve: -4).ar;
	modEnv = EnvGen.kr(Env.perc(0.01, 1), levelScale: \modIndex.kr(3));
	snd = SinOsc.ar(freq * \modRatio.kr(1), 0, freq * modEnv);
	snd = SinOsc.ar(freq + snd);
	snd = Pan2.ar(snd * env, 0, \amp.kr(0.2));
	snd = XFade2.ar(snd, (snd * 8.dbamp).tanh, 0.25);
	snd = snd * (1 + (1 * Env.perc(0, 0.04).ar)) * SinOsc.ar(10, 0, 0.2, 0.8);
	snd = snd * Env.linen(0, \duration.kr(1), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\square, {
	var snd, freq, high;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(\vibRate.kr(6), 0, \vibDepth.kr(2), freq);
	// high
	// high = Pulse.ar(freq * 2, 0.5, 0.2);
	// high = LPF.ar(high, 10000);
	// body
	snd = Pulse.ar(snd, 0.5);
	snd = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.02))
	});
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.5).kr.range(600, 6e3), Line.kr(1, 0, 0.5));
	// snd = snd + high;
	snd = snd * Env.perc(\atk.kr(0.01), \rel.kr(2), curve: -4).ar;
	snd = snd * Env.linen(\atk.kr(0.01), \duration.kr(1), 0.1, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\squareDecay, {
	var snd, freq;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(\vibRate.kr(6), 0, \vibDepth.kr(2), freq);
	snd = Pulse.ar(snd, 0.5);
	snd = Mix.fill(2, { |i|
		DelayC.ar(snd, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.02))
	});
	snd = MoogFF.ar(snd, Env.perc(0.01, 0.5).kr.range(600, 6e3), Line.kr(1, 0, 0.5));
	snd = snd * Env.perc(\atk.kr(0.01), \rel.kr(2), curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sawUnison, {
	var snd, freq;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	snd = SinOsc.ar(\vibRate.kr(6), 0, \vibDepth.kr(2), freq);
	snd = LFSaw.ar(snd * (0.5 * [0, 0.3, -0.32, 0.16, -0.11]).midiratio, Rand(0.0, 1.0));
	snd = MoogFF.ar(snd, Env.perc(0.01, 1).kr.range(4e2, 1e4), 0);
	snd = snd * ({SinOsc.ar(Rand(2, 10), Rand(0.01, pi), 0.1, 0.9)} ! 5); // (mul: 0.1, add: 0.9) = range: 0.8-1
	snd = snd * Env.perc(\atk.kr(0.02), \rel.kr(2)).ar(Done.freeSelf);
	snd = Splay.ar(snd, 1, \amp.kr(0.2), \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

//////////////////////////////////////////////
// Bussing
//////////////////////////////////////////////

(
~drumsBus = Bus.audio(nil, 2);
)
~drumsBus.index;


//////////////////////////////////////////////
// Routine
//////////////////////////////////////////////

(
var s, root, bpm, beat, play, playP, wait;
s = Server.default;
root = 60;
bpm = 124;
beat = 60 / bpm;

play = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
	(duration * beat).wait;
};

playP = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
};

wait = { |duration|
	(duration * beat).wait;
};

Routine({
	loop {
		fork {
			play.(\square, 0.5, [freq: (root +1).midicps, bend: -12]);
			play.(\square, 0.5, [freq: (root).midicps]);
			play.(\square, 0.5, [freq: (root -5).midicps, bend: 7]);
			play.(\square, 1.5, [freq: (root +1).midicps]);
			play.(\squareDecay, 1.5, [freq: (root).midicps, rel: 2, vibDepth: 4, vibRate: (beat/4) * 60]);
			wait.(0.5);

			play.(\sawUnison, 2, [freq: (root -12 -5).midicps]);
			play.(\sawUnison, 2, [freq: (root -12).midicps]);

		};
		fork {
			var bassRoot = root -24;
			play.(\fmBass, 0.5, [freq: (bassRoot +1).midicps]);
			play.(\fmBass, 0.5, [freq: (bassRoot +1).midicps]);
			wait.(1);
			play.(\fmBass, 0.5, [freq: (bassRoot).midicps]);
			play.(\fmBass, 1, [freq: (bassRoot).midicps]);
			wait.(0.5);

			play.(\fmBass, 0.5, [freq: (bassRoot).midicps]);
			play.(\fmBass, 0.5, [freq: (bassRoot).midicps]);
			wait.(1);
			play.(\fmBass, 0.5, [freq: (bassRoot -5).midicps]);
			play.(\fmBass, 1, [freq: (bassRoot -5).midicps]);
			wait.(0.5);
		};
		fork {
			2.do {
				play.(\hat, 0.5, [pan: 0], latency: 0);
				play.(\hatSoft, 0.5);
				play.(\hat, 0.25, [pan: -0.3], latency: 0);
				play.(\hat, 0.25, [pan: 0.3], latency: 0);
				play.(\hat, 0.25, [pan: -0.3], latency: 0);
				play.(\hat, 0.25, [pan: 0.3], latency: 0);
				play.(\hat, 0.5, [pan: 0], latency: 0);
				play.(\hatSoft, 0.5);
				play.(\hat, 0.5, [pan: 0.3], latency: 0);
				play.(\hat, 0.5, [pan: -0.3]);
			}
		};
		2.do {
			play.(\kick, 0.5);
			wait.(1);
			play.(\kick, 0.5, [\velocity: 0.8], latency: 0.02);
			play.(\snare, 0.5);
			wait.(1);
			play.(\kick, 0.5, [\velocity: 0.6]);
		};

	};
}).play;
)






















// endfile