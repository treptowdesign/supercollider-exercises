(
SynthDef(\kick, {
    var snd, fx;
    snd = SinOsc.ar(Env.perc(0, 0.15).ar.linexp(0, 1, 60, 300) * XLine.ar(4, 1, 0.01) * XLine.ar(1, 0.7, 1.2));
    snd = snd * Env.perc(0.001, 0.5).ar;
    snd = snd + (Env.perc(0.001, 0.01).ar * Hasher.ar(Sweep.ar) * -10.dbamp);
    snd = snd * (1 + (3 * Env.perc(0.0, 0.1).ar));
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.02, [12e-3, 34e-3]), 200), 3000);
    snd = snd * -8.dbamp;
    // snd = fxChain.(snd, \fx.kr(0));
    snd = snd * Env.linen(0.001, \duration.kr(0.3), 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



fxChain = { |snd, fx|
    Select.ar(DC.ar(fx), [
        CombC.ar(snd, 0.1, 1 / 40, Rand(-0.1, -0.9)) * -1.dbamp,
        Latch.ar(snd, Impulse.ar(4000 * IRand(1, 2))),
        PitchShift.ar(snd, 0.01, 1.2) * 4.dbamp,
        CombC.ar(snd, 0.1, 1 / 90, 0.1) * -1.dbamp,
        snd * SinOsc.ar(ZeroCrossing.ar(snd.sum).lag(0.01)) * 4.dbamp,
        GVerb.ar(snd.sum * -23.dbamp, 10, 1),
    ]);
};


// comb filter (randomized) negative feedback
CombC.ar(snd, 0.1, 1 / 40, Rand(-0.1, -0.9)) * -1.dbamp

// comb filter positive feedback
CombC.ar(snd, 0.1, 1 / 90, 0.1) * -1.dbamp


(
SynthDef(\src, {
	var freq, env, snd;
	freq = \freq.kr(440);
	env = Env.perc(0, 4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 1.998, 0, 4);
	snd = SinOsc.ar(freq, snd.mod(2pi), -10.dbamp);
	// snd = CombC.ar(snd, 0.1, 1 / 40, Rand(-0.1, -0.9)) * -1.dbamp;
	// snd = CombC.ar(snd, 0.1, 1 / 90, 0.1) * -1.dbamp;
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\bass, {
    var snd, freq, duration;
    duration = \duration.kr(1);
    snd = Pulse.ar(60 * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, 0.5), 0.5);
    snd = snd * Env.perc(0.001, 0.5).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [73, 74], -0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * Line.ar(0, 1, 0.05).squared;
    snd = snd * -4.dbamp;
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\bass2, {
    var snd, freq, duration;
    duration = \duration.kr(1);
    snd = Pulse.ar(60 * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, duration), 0.5);
    snd = snd * Env.perc(0.001, duration).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.1, 1 / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.1, 1 / [73, 74], 0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * 1.dbamp;
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


{ Line.ar(0, 1, 0.05).squared }.plot(0.1);



(
SynthDef(\bass, {
    var snd, freq, duration;
	freq = \freq.kr(10);
    duration = \duration.kr(1);
    snd = Pulse.ar(freq * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, duration), 0.5);
    snd = snd * Env.perc(0.001, duration).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [73, 74], -0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * Line.ar(0, 1, 0.05).squared;
	snd = snd * SinOsc.ar(ZeroCrossing.ar(snd.sum).poll.lag(0.01)) * 4.dbamp;
	// snd = snd * SinOsc.ar(freq / 2) * 4.dbamp;
    snd = snd * 1.dbamp;
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\bass, {
    var snd, freq, duration;
	freq = \freq.kr(10);
    duration = \duration.kr(1);
    snd = Pulse.ar(freq * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, duration), 0.5);
    snd = snd * Env.perc(0.001, duration).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [73, 74], -0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * Line.ar(0, 1, 0.05).squared;
	snd = snd * SinOsc.ar(ZeroCrossing.ar(snd.sum).poll.lag(0.01)) * 4.dbamp;
    snd = snd * 1.dbamp;
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\laser, {
    var snd, fx, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(LFSaw.ar(25, 1).linlin(-1, 1, 1, 0).pow(8).linexp(0, 1, 200, 6000));
    snd = snd * Env.linen(0.001, duration / 2, 0.02, curve: -4).ar;
    snd = LPF.ar(snd, XLine.ar(16e3, 100, duration / 2));
    snd = snd * -5.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * SinOsc.ar(ZeroCrossing.ar(snd.sum).lag(0.01)) * 4.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\laser, {
    var snd, fx, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(LFSaw.ar(25, 1).linlin(-1, 1, 1, 0).pow(8).linexp(0, 1, 200, 6000));
    snd = snd * Env.linen(0.001, duration / 2, 0.02, curve: -4).ar;
    snd = LPF.ar(snd, XLine.ar(16e3, 100, duration / 2));
    snd = snd * -5.dbamp;
	snd = snd * SinOsc.ar(ZeroCrossing.ar(snd).lag(0.01)) * 4.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));
    snd = snd * Env.linen(0.001, duration, 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\clank, {
    var snd, fx, duration;
    duration = \duration.kr(1);
	snd = SinOsc.ar(1200 * [1, 1.3] * Line.kr(0.9, 1.1, duration)).sum;
    snd = snd * Env.perc(0.001, 0.1).ar;
    snd = snd * -4.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));
    snd = snd * Env.linen(0.001, duration, 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clank2, {
    var snd, fx, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(600 * [1, 1.4]);
    snd = snd * Env.perc(0.001, [0.1, 0.05]).ar;
    snd = snd.sum;
    snd = snd * 0.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));

    snd = snd * Env.linen(0.001, duration, 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\additive, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(Rand(0, 1 ! 60).pow(0.5).linexp(0, 1, 50, 8000));
    snd = Splay.ar(snd, 0.5);
    snd = RLPF.ar(snd, XLine.ar(8000, 100, duration), 0.3);
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar;
    snd = snd + PitchShift.ar(snd, 0.023, 1.7);
    snd = snd + CombC.ar(snd, 0.1, 1 / [90, 93], -0.9);
    snd = snd * -25.dbamp;
    snd = snd * Env.linen(0.001, duration, 1.0, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)





(
var arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
arr[..3];
)



(
SynthDef(\bass2, {
    var snd, freq, duration;
    duration = \duration.kr(1);
    snd = Pulse.ar(10 * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, duration), 0.5);
    snd = snd * Env.perc(0.001, duration).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.1, 1 / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.1, 1 / [73, 74], -0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * 1.dbamp;
	snd = snd * SinOsc.ar(ZeroCrossing.ar(snd.sum).poll.lag(0.01)) * -2.dbamp;
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\pmSrc, {
	var freq, env, snd;
	freq = \freq.kr(260);
	env = Env.perc(0, 4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * [1.998, 0.998], 0, [1, 5]).sum;
	snd = SinOsc.ar(freq, snd.mod(2pi), -10.dbamp);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)












(
SynthDef(\bass, {
    var snd, freq, duration;
    duration = \duration.kr(1);
    snd = Pulse.ar(60 * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, 0.5), 0.5);
    snd = snd * Env.perc(0.001, 0.5).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.2, ExpRand(1, 1.5) / [73, 74], -0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * Line.ar(0, 1, 0.05).squared;
    snd = snd * -4.dbamp;
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)





///////////////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\kick, {
    var snd, fx;
    snd = SinOsc.ar(Env.perc(0, 0.15).ar.linexp(0, 1, 60, 300) * XLine.ar(4, 1, 0.01) * XLine.ar(1, 0.7, 1.2));
    snd = snd * Env.perc(0.001, 0.5).ar;
    snd = snd + (Env.perc(0.001, 0.01).ar * Hasher.ar(Sweep.ar) * -10.dbamp);
    snd = snd * (1 + (3 * Env.perc(0.0, 0.1).ar));
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.02, [12e-3, 34e-3]), 200), 3000);
    snd = snd * -8.dbamp;
    snd = snd * Env.linen(0.001, \duration.kr(0.3), 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
    var snd, fx;
    snd = Env.perc(0.001, 0.1).ar * BPF.ar(Hasher.ar(Sweep.ar), 1600, 0.5) * 14.dbamp;
    snd = snd * (1 + Env.perc(0.001, 0.01).delay(0.03).ar);
    snd = snd.tanh;
    snd = snd + (GVerb.ar(snd, 60, 1) * -30.dbamp);
    snd = snd * -8.dbamp;
    snd = snd * Env.linen(0.001, \duration.kr(0.3), 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
    var snd, fx;
    snd = Pulse.ar(40 * [1, 2.34, 3.55, 6.28]);
    snd = snd.sum;
    snd = HPF.ar(snd, 7e3);
    snd = BPF.ar(snd, 12e3) * 6.dbamp;
    snd = snd * Env.perc(0.01, 0.05).ar;
    snd = Pan2.ar(snd, \pan.kr(0));
    snd = snd * -8.dbamp;
    snd = snd * Env.linen(0.001, \duration.kr(0.3), 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\combBass, {
    var snd, freq, duration;
	freq = \freq.kr(60);
    duration = \duration.kr(1);
    snd = Pulse.ar(freq * [-0.1, 0.1].midiratio);
    snd = MoogFF.ar(snd, XLine.ar(8000, 1000, duration), 0.5);
    snd = snd * Env.perc(0.001, duration).ar;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = CombC.ar(snd, 0.2, 1.5 / [83, 98], -0.3);
    snd = CombC.ar(snd, 0.2, 1.5 / [73, 74], -0.2);
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 3);
    snd = snd * Line.ar(0, 1, 0.05).squared;
	snd = snd * -2.dbamp * \amp.kr(1);
    snd = snd * Env.linen(0.001, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)




(
var s, beat, bar, tatum, root, noteHz, play;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
tatum = beat / 4;
root = 38;

noteHz = { |int=0, oct=0|
	(root + int + (12 * oct)).midicps;
};

play = { |synth, dur=1, args=#[]|
	s.bind { Synth(synth, [duration: dur] ++ args); };
	(dur).wait;
};

Routine({
	loop {
		play.(\hat, tatum);
	};
}).play;

Routine({
	loop {
		[
			[0, 16],
			[2, 16]
		].do { |spec|
			var int, dur; # int, dur = spec;
			play.(\combBass, (dur * tatum), [freq: noteHz.(int, -1)]);
		};
	};
}).play;
)







(
SynthDef(\keys2, {
	var snd, freq, velocity, n, freqs;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..50);
	// outer partial, inner detune
	freqs = freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 2] * n * n)).sqrt * [([0, -0.03, 0.03] * 2).midiratio];
	snd = Env([0, 1, 0.2, 1, 0.02, 1, 0], [0.003, 0.002 * Rand(1, 2), 0.002, 0.003 * Rand(1, 2), 0.001, 0.01] * 2, -4).ar * 3.dbamp;
	snd = (snd * 10.dbamp).fold2;
	snd = HPF.ar(snd, 300);
	snd = snd * (1 + (WhiteNoise.ar * 2));
	snd = Ringz.ar(snd, freqs, 20 / n.pow(1.3));
	snd = snd / (n ** 0.8);
	snd = snd.sum;
	snd = LeakDC.ar(snd);
	snd = Splay.ar(snd, 0.05);
	snd = snd * -53.dbamp;
	snd = snd * Env.perc(0.0, 10.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\keys, {
	var snd, freq, velocity, n;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..8);
	// outer partial, inner detune
	snd = SinOsc.ar(freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 4] * n * n)).sqrt * [[0, -0.03, 0.03].midiratio], Rand(0, 2pi ! n.size));
	snd = snd / (n ** 1.1);
	snd = snd * Env.perc(n.normalize.linexp(0, 1, 0.03, 0.001), 10 / n.squared, curve: -1).kr * 2;
	snd = snd.tanh;
	snd = snd.sum;
	snd = Splay.ar(snd, 0.1);
	snd = snd * -15.dbamp;
	snd = snd.tanh;
	snd = snd * Env.perc(0.01, 10.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



(
(60 + 0 + [0, 4, 8, 10, 15]).do { |int|
	Synth(\keys, [freq: (int + (12 * 0)).midicps]);
};
)

(
(60 + 0 + [4-12, 7, 12, 14]).do { |int|
	Synth(\keys, [freq: (int + (12 * 0)).midicps]);
};
)

(
(60 + 3 + [3, 7, 10, 14]).do { |int|
	Synth(\keys, [freq: (int + (12 * 0)).midicps]);
};
)




(
(38 + 0 + [-9, -4, 0, 7]).do { |int|
	Synth(\keys, [freq: (int + (12 * 2)).midicps]);
};
)
(
(38 + 0 + [-9, -5, 0, 8]).do { |int|
	Synth(\keys, [freq: (int + (12 * 2)).midicps]);
};
)


(
(38 + 0 + [-9, -4, 2, 7]).do { |int|
	Synth(\keys, [freq: (int + (12 * 2)).midicps]);
};
)

(
(38 + 0 + [-12, -2, 3, 7]).do { |int|
	Synth(\keys, [freq: (int + (12 * 2)).midicps]);
};
)

fork {
	pianoChord.([-12 + 3, -12 + 8, 0, 7]);
	wait.(3);
	pianoChord.([-12 + 3, -12 + 8, 2, 7]);
	wait.(5);
	pianoChord.([-12, -2, 3, 7]);
	wait.(4);
};


[-9, -4, 0, 7].sort;
[-9, -4, 2, 7].sort;
[-12, -2, 3, 7].sort;

// endfile...




(
SynthDef(\arp, {
    var snd, gate, freq, trigger, n;
    gate = \gate.kr(1);
    freq = \freq.kr(440);
    trigger = T2A.ar(\trigger.tr(1));
    n = 7;
    snd = Pulse.ar(
        freq * [-0.2, -12.1, 0 + 0.1, 0, 0 - 0.1, -12 + 0.1, 0.2].midiratio * (LFNoise2.ar(20 ! n) * 0.12).midiratio,
        LFNoise2.ar(0.3 ! n).linlin(-1, 1, 0.1, 0.9)
    );
    snd = snd + CombC.ar(snd * -5.dbamp, 0.05, 1 / ExpRand(30 ! n, 90), -0.35);
    snd = Splay.ar(snd, 0.7);
    snd = snd * Env.perc(0.01, 0.3).ar(gate: trigger);
    snd = snd * (1 + Env.perc(0.001, 0.01).ar(gate: trigger));
    snd = RLPF.ar(
        snd,
        Env.perc(0.01, 0.3, curve: -8).ar(gate: trigger).linexp(0, 1, 500, 3500)
        * SinOsc.ar(0.23).linexp(-1, 1, 0.5, 2),
        0.6
    );
    snd = snd * 3.dbamp;
    snd = BHiShelf.ar(snd, 1200, 0.3, -4);
    snd = BLowShelf.ar(snd, 200, 0.3, -5);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -13.dbamp;
    snd = snd * Env.asr(0.01, 1.0, 0.01, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\arp, {
    var snd, gate, freq, trigger, n;
    gate = \gate.kr(1);
    freq = \freq.kr(440);
    trigger = T2A.ar(\trigger.tr(1));
    n = 7;
    snd = Pulse.ar(
        freq * [-0.2, -12.1, 0 + 0.1, 0, 0 - 0.1, -12 + 0.1, 0.2].midiratio * (LFNoise2.ar(20 ! n) * 0.12).midiratio,
        LFNoise2.ar(0.3 ! n).linlin(-1, 1, 0.1, 0.9)
    );
    snd = snd + CombC.ar(snd * -5.dbamp, 0.05, 1 / ExpRand(30 ! n, 90), -0.35);
    snd = Splay.ar(snd, 0.7);
    snd = snd * Env.perc(0.01, 0.3).ar(gate: trigger);
    snd = snd * (1 + Env.perc(0.001, 0.01).ar(gate: trigger));
    snd = RLPF.ar(
        snd,
        Env.perc(0.01, 0.3, curve: -8).ar(gate: trigger).linexp(0, 1, 500, 3500)
        * SinOsc.ar(0.23).linexp(-1, 1, 0.5, 2),
        0.6
    );
    snd = snd * 3.dbamp;
    snd = BHiShelf.ar(snd, 1200, 0.3, -4);
    snd = BLowShelf.ar(snd, 200, 0.3, -5);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -13.dbamp;
    snd = snd * Env.perc(0.01, 2.0, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
(60 + [-12, 3, 7, 10]).do { |int|
	Synth(\arp, [freq: (int + (12 * 0)).midicps]);
};
)



(
SynthDef(\lead, {
    var snd, gate, freq, fb, timbreEnv;
    gate = \gate.kr(1);
    freq = \freq.kr(440).cpsmidi.lag(\lag.kr(0.01)).midicps;
    freq = freq * (SinOsc.ar(4.34) * 0.02).midiratio;
    freq = freq * (SinOsc.ar(0.5) * 0.1).midiratio;
    timbreEnv = Env.asr(3.0, 1.0, 1.0, curve: -4).ar(gate: gate);
    snd = SinOsc.ar(freq * [1, 1 / 2]) * timbreEnv * SinOsc.ar(0.1, [0, pi]).linexp(-1, 1, 4, 7);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * [0, -10].dbamp;
    snd = snd.sum;
    snd = snd * -20.dbamp;
    snd = snd * Env.asr(0.01, 1.0, 3.0, curve: -4).ar(Done.none, gate);
    snd = LPF.ar(snd, 1500);
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, 1.0, [0.45, 0.35] + (SinOsc.ar(0.5, [0, pi]) * 1e-3));
    fb = LPF.ar(fb, 2000);
    fb = HPF.ar(fb, 100);
    fb = fb * -1.dbamp;
    LocalOut.ar(fb);
    snd = snd + fb;
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\lead, {
    var snd, gate, freq, fb, timbreEnv;
    gate = \gate.kr(1);
    freq = \freq.kr(440).cpsmidi.lag(\lag.kr(0.01)).midicps;
    freq = freq * (SinOsc.ar(4.34) * 0.02).midiratio * (SinOsc.ar(0.5) * 0.1).midiratio;
    timbreEnv = Env.asr(3.0, 1.0, 1.0, curve: -4).ar(gate: gate);
    snd = SinOsc.ar(freq * [1, 1 / 2]) * timbreEnv * SinOsc.ar(0.1, [0, pi]).linexp(-1, 1, 4, 7);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * [0, -10].dbamp;
    snd = snd.sum;
    snd = snd * -20.dbamp;
    snd = snd * Env.perc(0.01, 6.0, curve: -4).ar(Done.freeSelf);
    snd = LPF.ar(snd, 1500);
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, 1.0, [0.45, 0.35] + (SinOsc.ar(0.5, [0, pi]) * 1e-3));
    fb = LPF.ar(fb, 2000);
    fb = HPF.ar(fb, 100);
    fb = fb * -1.dbamp;
    LocalOut.ar(fb);
    snd = snd + fb;
    Out.ar(\out.kr(0), snd);
}).play;
)



[0, [0, 2, 3, 7]];
[-5, [-2, 2, 3, 7]];
[7, [0, 3, 7, 10]];
[-2, [-2, 2, 9, 5]];
[0, [0, 2, 3, 7]];
[-5, [-2, 2, 3, 7]];
[7, [0, 3, 7, 10]];
[-2, [-5, 2, 3, 5]];



( // maj 6
var spec = [0, [0, 4, 7, 9]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (60 + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (60 + int + (12 * 0)).midicps]);
};
)

( //  9th
var spec = [0, [0, 4, 7, 11, 14]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (60 + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (60 + int + (12 * 0)).midicps]);
};
)

( // dominant #5 & #9
var spec = [0, [0, 4, 8, 10, 15]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (60 + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (60 + int + (12 * 0)).midicps]);
};
)





(
var spec = [0, [0, 2, 3, 7]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (60 + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (60 + int + (12 * 0)).midicps]);
};
)


(
var spec = [0, [0, 4, 7, 18]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (60 + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (60 + int + (12 * 0)).midicps]);
};
)

[ 0, 1, 4, 7, 9 ]



(
SynthDef(\kick, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(Env.perc(0, 0.15, curve: -6).ar.linexp(0, 1, 59, 300) * XLine.ar(2, 1, 0.01) * XLine.ar(1, 0.7, 0.5) * [1, 1.6, 2.3]);
    snd = snd * Env.perc(0.001, [0.9, 0.4, 0.05]).ar * [0, -13, -20].dbamp;
    snd = snd.sum;
    snd = snd * (1 + Env.perc(0.001, 0.1).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230, 0.3) * Env.perc(0.01, 0.02).ar * 9.dbamp);
    snd = snd + (SinOsc.ar(XLine.ar(4000, 500, 0.01)) * Env.perc(0.001, 0.01).ar);
    snd = snd.clip2;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * (1 + (0.5 * Env.perc(0.001, 0.05).ar));
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd, 0.05, [27e-3, 45e-3]) * -30.dbamp, 3000), 200);
    snd = snd * -5.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    OffsetOut.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\kick, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(
		Env.perc(0, 0.15, curve: -6).ar.linexp(0, 1, 58, 200)
		* XLine.ar(2, 1, 0.02)
		* XLine.ar(1, 0.6, 0.4) * [1, 1.4, 2.1]
	);
    snd = snd * Env.perc(0.001, [0.9, 0.4, 0.06]).ar * [0, -13, -20].dbamp;
    snd = snd.sum;
    snd = snd * (1 + Env.perc(0.001, 0.1).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230, 0.2) * Env.perc(0.01, 0.02).ar * 4.dbamp);
	snd = snd + (SinOsc.ar(XLine.ar(2600, 400, 0.01)) * Env.perc(0.001, 0.01).ar);
    snd = snd.clip2;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * (1 + (0.5 * Env.perc(0.001, 0.05).ar));
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd, 0.05, [27e-3, 45e-3]) * -30.dbamp, 3000), 200);
    snd = snd * -5.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\kick, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(
		Env.perc(0, 0.15, curve: -6).ar.linexp(0, 1, 38.89, 200) *
		XLine.ar(2, 1, 0.01) *
		XLine.ar(1, 0.7, 0.3) *
		[1, 1.4, 1.9]
	);
    snd = snd * Env.perc(0.001, [0.9, 0.4, 0.05]).ar * [0, -13, -20].dbamp;
    snd = snd.sum;
    snd = snd * (1 + Env.perc(0.001, 0.1).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230, 0.3) * Env.perc(0.01, 0.02).ar * 9.dbamp);
    snd = snd + (SinOsc.ar(XLine.ar(4000, 500, 0.01)) * Env.perc(0.001, 0.01).ar);
    snd = snd.clip2;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * (1 + (0.5 * Env.perc(0.001, 0.05).ar));
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd, 0.05, [27e-3, 45e-3]) * -30.dbamp, 3000), 200);
    snd = snd * -5.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    OffsetOut.ar(\out.kr(0), snd);
}).play;
)






(63 + [0, -12, -24, -36]).midicps;



(
SynthDef(\sub, {
    var snd, gate, freq, trigger;
    gate = \gate.kr(1);
    freq = \freq.kr(60);
    trigger = T2A.ar(\trigger.tr(0));
	snd = SinOsc.ar(freq * 2, mul: 0.07);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 12.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd ! 2;
    snd = snd * -10.dbamp;
    snd = snd * Env.asr(0.01, 1.0, 0.01, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\sub, {
    var snd, gate, freq, trigger, duration, atk, rel, sus;
    duration = \duration.kr(1);
	atk = 0.01;
	rel = 0.1;
	sus = duration - (atk + rel);
    gate = \gate.kr(1);
    freq = \freq.kr(60);
    trigger = T2A.ar(\trigger.tr(0));
	snd = SinOsc.ar(freq * 2, mul: 0.07);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 9.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -10.dbamp ! 2;
    snd = snd * Env.linen(atk, sus, rel, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).play;
)
















(
SynthDef(\snare, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(230 * XLine.ar(1.3, 1, 0.01) * [1, 2.3, 1.5]);
    snd = snd * Env.perc(0.001, [0.05, 0.01, 0.005]).ar;
    snd = snd.sum;
    snd = snd.tanh;
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 0), 2230, 0.3) * Env.perc(0.05, 0.12).ar * 1.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 1230, 0.5) * Env.perc(0.03, 0.30).ar * 1.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 2), 1530, 0.5) * Env.perc(0.02, 0.15).ar * 1.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 3), 2530, 0.3) * Env.perc(0.03, 0.05).ar * -5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 4), 3230, 0.5) * Env.perc(0.1, 0.20, curve: -6).ar * -7.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 0), 730, 0.3) * Env.perc(0.05, 0.1).ar * -4.dbamp);
    snd = snd.clip2;
    snd = LPF.ar(snd, 9000) + LPF.ar(HPF.ar(GVerb.ar(snd * -5.dbamp, 120, 2), 300), 2500);
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd, 0.05, [37e-3, 95e-3]) * -30.dbamp, 3000), 200);
    snd = snd * Line.ar(0, 1, 0.02).squared;
    snd = snd * -6.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    OffsetOut.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\kick, {
    var snd, duration;
    duration = \duration.kr(1.0);
    snd = SinOsc.ar(Env.perc(0, 0.4, curve: -6).ar.linexp(0, 1, 60, 400) * XLine.ar(5, 1, 0.01) * XLine.ar(1, 0.7, 0.5));
    snd = snd * Env.perc(0.01, 3.0).ar;
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [1, 2]), 3000, 0.3) * Env.perc(0.01, 0.05).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [0, 3]), 9000, 0.3) * Env.perc(0.001, 0.01).ar);
    snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
    snd = snd * (1 + (0.3 * Env.perc(0.01, 0.1).ar));
    snd = snd.fold2;
    snd = snd.tanh;
    snd = BHiShelf.ar(snd, 3000, 0.3, 3);
    snd = BLowShelf.ar(snd, 300, 0.3, 3);
    snd = snd + (LPF.ar(HPF.ar(DelayN.ar(snd, 0.1, [35e-3, 55e-3]), 300), 3000) * -20.dbamp);
    snd = snd * -13.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\laser, {
    var snd, duration, lfo;
    duration = \duration.kr(3.0);
    lfo = LFSaw.ar(XLine.ar(60, 1, duration)).linlin(-1, 1, 1, 0);
    snd = SinOsc.ar(lfo.pow(4).linexp(0, 1, 100, 8000)) * lfo.pow(3);
    snd = (snd * 3).fold2 * 5.dbamp;
    snd = BPF.ar(snd, (0..30).normalize.linexp(0, 1, 60, 6000), 0.04).sum * -1.dbamp;
    snd = LeakDC.ar(snd);
    snd = snd + CombC.ar(snd * -9.dbamp, 0.1, [1, 1.1] / XLine.ar(90, 120, duration), 0.1);
    snd = snd + PitchShift.ar(snd, [0.03, 0.04], 0.9);
    snd = BLowShelf.ar(snd, 0.3, 3);
    snd = snd * Line.ar(0, 1, 0.1).squared;
    snd = snd + GVerb.ar(snd.sum * -25.dbamp, 50, 3);
    snd = snd * -15.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\vocalBass, {
    var snd, duration, k, freq, formantFreqs1, formantFreqs2, formantFreqs, blend;
    duration = \duration.kr(2.0);
    freq = 73 * (SinOsc.ar(5) * 0.02).midiratio * Env([0, 0, -12, -12], [3, 2, 3].normalizeSum * duration, \sin).ar.midiratio;
    formantFreqs1 = [830, 1220, 3200];
    formantFreqs2 = [532, 2220, 2500];
    blend = Env([0, 0, 1, 1], [2, 1, 2].normalizeSum * duration, \sin).ar;
    formantFreqs = (formantFreqs1 * (1 - blend)) + (formantFreqs2 * blend);
    snd = Phasor.ar(Impulse.ar(freq), ([freq] ++ formantFreqs) * SampleDur.ir, 0, 1);
    snd = (((snd[1..] * 8).round / 8) * 2pi).sin * (1 - snd[0]);
    snd[snd.size - 1] = snd[snd.size - 1].sign;
    snd = snd * [0, -5, -13].dbamp;
    snd = snd.sum;
    snd = BLowShelf.ar(snd, 200, 0.3, -4);
    snd = BHiShelf.ar(snd, 2000, 0.3, -4);
    snd = snd * 5.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 8);
    snd = BHiShelf.ar(snd, 2000, 0.3, -2);
    snd = snd + DelayC.ar(snd * -10.dbamp, 0.1, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 50, 3);
    snd = HPF.ar(snd, 100);
    snd = snd + ((SinOsc.ar(freq) * 9.dbamp).tanh * -5.dbamp);
    snd = snd + (SinOsc.ar(freq / 2) * -15.dbamp);
    snd = HPF.ar(snd, 20);
    snd = snd * -16.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\bass, {
    var snd, duration, k;
    duration = \duration.kr(2.0);
    snd = Pulse.ar(30, Line.ar(0.1, 0.9, duration));
    k = 0.99;
    4.do { |i|
        10.do { snd = FOS.ar(snd, k * -1, 1, k); };
        snd = snd * [4, 3].dbamp;
        if((i % 2) == 0) { snd = snd.reverse; };
        snd = snd.fold2;
    };
    snd = LPF.ar(snd, Env([1, 0, 1], [1, 1].normalizeSum * duration).ar.linexp(0, 1, 100, 16000));
    snd = snd * 4.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 4);
    snd = BHiShelf.ar(snd, 2000, 0.3, 4);
    snd = snd + HPF.ar(GVerb.ar(snd.sum * -10.dbamp, 30, 1), 300);
    snd = snd * Line.ar(0, 1, 0.1).squared;
    snd = snd * -19.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clap, {
    var snd, duration;
    duration = \duration.kr(1.0);
    snd = Hasher.ar(Sweep.ar + [0, 1, 2]);
    snd = BPF.ar(snd, 1300 * [0.9, 1, 1.2], 0.3) * 15.dbamp;
    snd = snd * Env([0, 5, 1, 0], [0.001, 0.01, 0.2], curve: -4).delay([1.3, 0, 2] * 10e-3).ar;
    snd = Splay.ar(snd, 0.5);
    snd = snd.clip2;
    snd = snd + PitchShift.ar(snd, 0.05, 0.9);
    snd = snd + LPF.ar(GVerb.ar(snd.sum * -10.dbamp, 50, 3), 3000);
    snd = snd * -11.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
    var snd, duration;
    duration = \duration.kr(1.0);
    snd = SinOsc.ar(Env.perc(0, 0.05, curve: -6).ar.linexp(0, 1, 290, 260) * [1, 2.3, 4.5]);
    snd = snd * Env.perc(0.001, 0.09 * [1, 0.3, 0.1]).ar * [0, -5, -10].dbamp;
    snd = snd.sum;
    snd = (snd * 5.dbamp).clip2;
    snd = snd + (SinOsc.ar(820) * Env.perc(0.001, 0.01).ar * 20.dbamp);
    snd = snd + (SinOsc.ar(1220) * Env.perc(0.001, 0.01).ar * 10.dbamp);
    snd = snd + LPF.ar(HPF.ar((FreqShift.ar(Pulse.ar(60), 336) * Env.perc(0.05, 0.3).ar * -10.dbamp), 300), XLine.ar(3000, 200, 0.1));
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar(Impulse.ar(53) + 23)), 2500, 0.3) * Env.perc(0.05, 0.1).ar * 5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar(Impulse.ar(70) + 45)), 3500, 0.3) * Env.perc(0.05, 0.3).ar * -5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 0), 900, 0.3) * Env.perc(0.05, 0.1).ar * 5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 2), 3000, 0.3) * Env.perc(0.001, 0.01).ar * 8.dbamp);
    snd = snd * 3.dbamp;
    snd = snd * (1 + Env.perc(0, 0.01).ar);
    snd = snd.fold2;
    snd = snd * (1 + Env.perc(0.002, 0.05).delay(0.002).ar);
    snd = snd * (1 + (0.5 * Env.perc(0.001, 0.02).delay(0.003).ar));
    snd = snd + PitchShift.ar(snd * -15.dbamp, 0.05, 1.5);
    snd = BLowShelf.ar(snd, 400, 0.3, 2);
    snd = snd + LPF.ar(GVerb.ar(snd * -12.dbamp, 50, 5), 4000);
    snd = snd * -13.dbamp;
    snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



//////////////////////////////////////////////////////////////////


(
SynthDef(\kick, {
    var snd;
    snd = SinOsc.ar(
        Env.perc(0.0, 0.1).ar.linexp(0, 1, 60, 200) * XLine.ar(3, 1, 0.01) * [1, 3.3, 4.2, 7.38]
        * XLine.ar(1, 0.6, 0.2)
    );
    snd = snd * Env.perc(0.001, 0.5 * [1, 0.1, 0.05, 0.02]).ar;
    snd = snd * [0, -5, -8, -20].dbamp;
    snd = snd.sum;
    snd = snd * (1 + Env.perc(0, 0.02).ar);
    snd = snd * 5.dbamp;
    snd = snd + (SinOsc.ar(XLine.ar(1200, 300, 0.02)) * Env.perc(0.001, 0.03).ar);
    snd = LeakDC.ar(snd);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 300, 0.3, 5);
    snd = snd * -5.dbamp;
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [34e-3, 37e-3]), 2000), 300);
    snd = snd * Env.linen(0.0, 1.0, 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(
        Env.perc(0.0, 0.02).ar.linexp(0, 1, 180, 195) * XLine.ar(1.2, 1, 0.01) * [1, 2.3, 3.2, 5.38]
    );
    snd = snd * Env.perc(0.01, 0.05 * [1, 0.5, 0.05, 0.02] * velocity).ar;
    snd = snd * [0, -5, -8, -20].dbamp;
    snd = snd.sum;
    snd = snd * 2.dbamp;
    snd = snd * velocity.sqrt;
    snd = snd.tanh;
    snd = snd * 8.dbamp;
    snd = snd + (SinOsc.ar(XLine.ar(1200, 800, 0.02)) * Env.perc(0.001, 0.03).ar * 5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3100, 0.3) * Env.perc(0.05, 0.07).ar * 8.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3000, 0.4) * Env.perc(0.01, 0.09).ar * 6.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1500, 0.3) * Env.perc(0.0, 0.1).ar * 15.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 700, 0.3) * Env.perc(0.0, 0.3).ar * -4.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.3) * Env.perc(0.0, 0.2).ar * 1.dbamp);
    snd = snd * -1.dbamp;
    snd = LeakDC.ar(snd);
    snd = snd * velocity.sqrt;
    snd = snd.tanh;
    snd = snd * (1 + Env.perc(0.001, 0.02).ar);
    snd = snd + HPF.ar(SinOsc.ar(79, SinOsc.ar(93) % 2pi) * Env.perc(0.05, 0.3).ar * -25.dbamp, 220);
    snd = snd * velocity.sqrt;
    snd = snd.tanh;
    snd = snd + GVerb.ar(snd * -30.dbamp, 30, 1);
    snd = snd * (1 + (Env.perc(0.001, 0.01).ar * velocity));
    snd = snd * -8.dbamp;
    snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\snare, {
    var snd, velocity;
    velocity = \velocity.kr(1);


    snd = (BPF.ar(Hasher.ar(Sweep.ar), 3100, 0.3) * Env.perc(0.05, 0.07).ar * 8.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3000, 0.4) * Env.perc(0.01, 0.09).ar * 6.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1500, 0.3) * Env.perc(0.0, 0.1).ar * 15.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 700, 0.3) * Env.perc(0.0, 0.3).ar * -4.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.3) * Env.perc(0.0, 0.2).ar * 1.dbamp);
	snd = snd + (SinOsc.ar(XLine.ar(1100, 650, 0.02), 0) * Env.perc(0.001, 0.1).ar * 5.dbamp);


	snd = GVerb.ar(snd * 0.dbamp, 30, 2).sum;



	snd = SinOsc.ar(
        Env.perc(0.0, 0.02).ar.linexp(0, 1, 180, 195) * XLine.ar(1.2, 1, 0.01) * [1, 2.3, 3.2, 5.38],
		snd % 2pi
    );

    snd = snd * Env.perc(0.01, 0.05 * [1, 0.5, 0.05, 0.02] * velocity).ar;
    snd = snd * [0, -5, -8, -20].dbamp;
    snd = snd.sum;

	snd = snd * -8.dbamp ! 2;
    snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



{ HPF.ar(SinOsc.ar(80, SinOsc.ar(90) % 2pi) * Env.perc(0.05, 0.3).ar * 0.dbamp, 220) ! 2}.play;

(
SynthDef(\bassGuitar, {
    var snd, freq, trigger;
    freq = \freq.kr(60).cpsmidi.lag(0.05).midicps;
    trigger = T2A.ar(\trigger.tr(0));
    snd = Pluck.ar(
        SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 10, 500)),
        trigger, 0.1, 1 / freq, 20.0, 0.5
    );
    snd = LPF.ar(snd, 500) * 4.dbamp;
    snd = LeakDC.ar(snd);
    snd = snd ! 2;
    snd = snd * -5.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\bassGuitar, {
    var snd, freq, trigger;
    freq = \freq.kr(60).cpsmidi.lag(0.05).midicps;
	trigger = Impulse.kr(0);
    snd = Pluck.ar(
        SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 10, 500)),
        trigger, 0.1, 1 / freq, 20.0, 0.5
    );
    snd = LPF.ar(snd, 500) * 4.dbamp;
    snd = LeakDC.ar(snd);
    snd = snd * -5.dbamp ! 2;
	snd = BLowShelf.ar(snd, 200, 0.3, 2);
	snd = snd * Env.perc(0.01, 3).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\tom, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(
        120 * [1, 3.3, 8.2, 12.38] * \ratio.kr(1)
    );
    snd = snd * Env.perc(0.01, 0.35 * [1, 0.5, 0.05, 0.02] * velocity).ar;
    snd = snd * [0, -5, -8, -20].dbamp;
    snd = snd.sum;
    snd = snd * 2.dbamp;
    snd = snd * velocity.sqrt;
    snd = snd.tanh;
    snd = snd * 2.dbamp;
    snd = snd + (SinOsc.ar(XLine.ar(1200, 800, 0.02)) * Env.perc(0.001, 0.03).ar * 5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3000, 0.4) * Env.perc(0.01, 0.09).ar * 9.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1500, 0.3) * Env.perc(0.0, 0.1).ar * 4.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 700, 0.3) * Env.perc(0.0, 0.02).ar * 4.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.3) * Env.perc(0.0, 0.2).ar * 1.dbamp);
    snd = snd * -1.dbamp;
    snd = LeakDC.ar(snd);
    snd = snd * velocity.sqrt;
    snd = snd.tanh;
    snd = snd * (1 + Env.perc(0.001, 0.02).ar);
    snd = snd * velocity.sqrt;
    snd = snd.tanh;
    snd = snd + GVerb.ar(snd * -25.dbamp, 40, 2);
    snd = snd * (1 + (Env.perc(0.001, 0.01).ar * velocity));
    snd = snd * -8.dbamp;
    snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\hat, {
    var snd, duration;
    duration = \duration.kr(3.0);
    snd = WhiteNoise.ar ! 10;
    snd = CombC.ar(snd, 0.1, 1 / (0..snd.size - 1).normalize.linexp(0, 1, 100, 200), 0.1);
    snd = LeakDC.ar(snd);
    snd = BPF.ar(snd, (0..snd.size - 1).normalize.pow(1.5).linexp(0, 1, 700, 16000), 0.08);
    snd = snd.sum;
    snd = HPF.ar(snd, 2500);
    snd = CombC.ar(snd, 0.3, 1 / 90, 0.1);
    snd = FreqShift.ar(snd, 41);
    snd = snd * Env.perc(0.001, 1.5).ar;
    snd = snd + (BPF.ar(WhiteNoise.ar, 6240, 0.5) * Env.perc(0.001, 0.3).ar);
    snd = snd + GVerb.ar(snd, 30, 1);
    snd = snd * -15.dbamp;
    snd = snd * Env.linen(0.0, duration, 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\closedHat, {
    var snd, duration;
    duration = \duration.kr(3.0);
    snd = Hasher.ar(Sweep.ar + [0, 1, 2, 3]);
    snd = LeakDC.ar(snd);
    snd = BPF.ar(snd, [3240, 4230, 7230, 13342], 0.1) * 10.dbamp;
    snd = snd.sum;
    snd = HPF.ar(snd, 2500);
    snd = snd + (BPF.ar(WhiteNoise.ar, 6240, 0.5) * Env.perc(0.005, 0.01).ar * -5.dbamp);
    snd = snd * Env.perc(0.001, 0.05).ar;
    snd = snd.clip2;
    snd = snd * -9.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));
    snd = snd * Env.linen(0.0, duration, 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)






(
SynthDef(\closedHatComb, {
    var snd, duration;
    duration = \duration.kr(3.0);
    snd = Hasher.ar(Sweep.ar + [0, 1, 2, 3]);
    snd = LeakDC.ar(snd);
    snd = BPF.ar(snd, [3240, 4230, 7230, 13342], 0.1) * 10.dbamp;
    snd = snd.sum;
    snd = HPF.ar(snd, 2500);
    snd = snd + (BPF.ar(WhiteNoise.ar, 6240, 0.5) * Env.perc(0.005, 0.01).ar * -5.dbamp);
    snd = snd * Env.perc(0.001, 0.05).ar;
    snd = snd.clip2;
	snd = CombC.ar(snd, 0.2, 1 / 120, 0.3);
	// snd = FreqShift.ar(snd, 0);
    snd = snd * -9.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));
    snd = snd * Env.linen(0.0, duration, 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\vocalScratchSource, {
    var snd;
    snd = Saw.ar(330 * (LFNoise2.ar(8) * 9).midiratio);
    snd = SelectX.ar(ToggleFF.ar(Dust.ar(8)).lag(0.03), [snd, WhiteNoise.ar * -10.dbamp]);
    snd = BPF.ar(snd, [823, 1230, 5300] * (LFNoise2.ar(20) * 30 * [1, -1, 1]).midiratio, 0.2).sum;
    snd = snd + GVerb.ar(snd, 30, 1);
    snd = snd * -8.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\deepBass, {
	var snd;
	snd = SinOsc.ar(XLine.ar(500, 50, 0.01) * (LFNoise2.kr(1 ! 16) * 10).midiratio);
	snd = Splay.ar(snd);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 300, 3, 0.8);
	snd = snd.tanh;
	snd = snd * Env([0, 1, 0.1, 1, 0], [0.03, 0.01, 0.03, 5.0], curve: -8).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)






(
SynthDef(\sub, {
    var snd, gate, freq, duration, atk, rel, sus;
    duration = \duration.kr(1);
	atk = 0.01;
	rel = 0.1;
	sus = duration - (atk + rel);
    gate = \gate.kr(1);
    freq = \freq.kr(60);
	snd = SinOsc.ar(freq * 2, mul: 0.07);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 9.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -10.dbamp ! 2;
    snd = snd * Env.linen(atk, sus, rel, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\fsSqr, {
	var snd, freq, env, lfo;
	freq = \freq.kr(60);
	env = Env.perc(\atk.kr(0.01), \rel.kr(3)).ar(Done.freeSelf);
	lfo = SinOsc.kr(0.1, 0);
	// snd = Pulse.ar(freq * [1, 2], 0.5, [-10, -25].dbamp).sum;
	snd = Pulse.ar(freq , 0.5, -10.dbamp);
	// snd = LeakDC.ar(snd);
	snd = FreqShift.ar(snd, -25 * lfo.linlin(-1, 1, 0.5, 1.5));
	snd = CombC.ar(snd, 0.2, 1 / (62 * lfo.linlin(-1, 1, 1.25, 1)), 0.25);
	snd = FreqShift.ar(snd, 25 * lfo.linlin(-1, 1, 0.5, 1.5));
	// snd = MoogFF.ar(snd, 9000, 0);
	/*snd = snd * 9.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);*/
	// snd = snd.tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 3);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
[0].do { |int|
	Synth(\fsSqr, [freq: (60 + int + (12 * -3)).midicps.postln, rel: 2]);
};
)








///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
// Scale Transform => Chord Shape
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////



(
var getChordShape = { |scale, index, extensions = #[0, 2, 4, 6, 8, 10, 12]|
	var xScale, extendedScale;
	xScale = scale.copyRange(index, scale.size - 1) ++ (scale.copyRange(0, index - 1) + 12);

	extendedScale = xScale ++ (xScale + 12);
	extendedScale[extensions] - scale[index];
};

getChordShape.(Scale.dorian.degrees, 0);
)





///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
// BASS
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////


(
SynthDef(\reese, {
	var snd;
	snd = LFSaw.ar(\freq.kr(60).lag(0.1) * (Rand(-1, 1 ! 8) * 0.1).midiratio, Rand(0, 4 ! 8));
	snd = RLPF.ar(snd, SinOsc.ar(0.3, (0..7).normalize * 0.2 * 2pi).linexp(-1, 1, 300, 5230), 0.1);
	snd = Splay.ar(snd);
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 10).clip2;
	snd = BHiShelf.ar(snd, 7200, 0.3, 5);
	snd = BPeakEQ.ar(snd, 3120, 0.5, 3);
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\reese, {
	var snd, freq, duration;
	duration = \duration.kr(2.0);
	freq = 40 * Env([0, 0, 12, 12, -1, -2], [2, 1, 2, 1, 4].normalizeSum * duration, curve: \sin).ar.midiratio;
	snd = Saw.ar(freq * [-0.05, 12.02, 0, 12 - 0.02, 0.05].midiratio);
	snd = Splay.ar(snd);
	snd = BHiShelf.ar(snd, 3120, 0.3, -5);
	snd = BLowShelf.ar(snd, 320, 0.3, -5);
	snd = (snd * 3).tanh;
	snd = BHiShelf.ar(snd, 3120, 0.3, 3);
	snd = BLowShelf.ar(snd, 320, 0.3, 5);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 70), 0.2, 1 / [134, 144], 0.1), -70);
	snd = snd * Env.linen(0.01, duration, 0.02, curve: -4).ar;
	snd = snd + HPF.ar(GVerb.ar(snd.sum * -15.dbamp, 30, 1), 300);
	snd = snd * Line.ar(0, 1, 0.3).squared;
	snd = snd * Env.linen(0.01, duration + 1, 1, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


///////////////////////////////////////////////////////////////////////

(
SynthDef(\fsSqr, {
	var snd, freq, env, lfo;
	freq = \freq.kr(60);
	env = Env.perc(\atk.kr(0.01), \rel.kr(3)).ar(Done.freeSelf);
	lfo = SinOsc.kr(0.1, 0);
	snd = Pulse.ar(freq , 0.5, -10.dbamp);
	snd = FreqShift.ar(snd, -25 * lfo.linlin(-1, 1, 0.5, 1.5));
	snd = CombC.ar(snd, 0.2, 1 / (62 * lfo.linlin(-1, 1, 1.25, 1)), 0.25);
	snd = FreqShift.ar(snd, 25 * lfo.linlin(-1, 1, 0.5, 1.5));
	snd = BLowShelf.ar(snd, 200, 0.3, 3);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\sub, {
    var snd, freq, duration, atk, rel, sus;
    duration = \duration.kr(1);
	atk = 0.01;
	rel = 0.1;
	sus = duration - (atk + rel);
    freq = \freq.kr(60);
	snd = SinOsc.ar(freq * 2, mul: 0.07);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 9.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -10.dbamp ! 2;
    snd = snd * Env.linen(atk, sus, rel, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bassGuitar, {
    var snd, freq, trigger;
    freq = \freq.kr(60).cpsmidi.lag(0.05).midicps;
	trigger = Impulse.kr(0);
    snd = Pluck.ar(
        SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 10, 500)),
        trigger, 0.1, 1 / freq, 20.0, 0.5
    );
    snd = LPF.ar(snd, 500) * 4.dbamp;
    snd = LeakDC.ar(snd);
	snd = snd + (snd.tanh * -8.dbamp);
	snd = CombC.ar(snd, 0.2, 1 / 90, -0.1);
    snd = snd * -8.dbamp ! 2;
	snd = BLowShelf.ar(snd, 200, 0.3, 2);
	snd = snd * Env.perc(0.01, 3).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\808, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(Env.perc(0, 0.14, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 200)) * XLine.ar(1.05, 1, 0.2));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar;
	snd = LPF.ar(snd, XLine.ar(300, 100, 0.2));
	hi = snd;
	hi = hi * (1 + (LPF.ar(LPF.ar(RHPF.ar({ PinkNoise.ar } ! 2, 1230, 0.5), 2e3), 7e3) * -5.dbamp));
	hi = (hi * 10).tanh;
	hi = hi + DelayC.ar(hi * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	hi = HPF.ar(hi, 2500);
	hi = LPF.ar(hi, 8000);
	hi = hi * -10.dbamp;
	snd = (snd * 0.9).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd + hi;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



// bitcrusher...
snd = snd + Latch.ar(snd * -5.dbamp, Impulse.ar(12.3e3));


///////////////////////////////////////////////////////////////////////
// moog & acid

( // MOOG Ladder
SynthDef(\moogBass, {
	var snd, freq, duration, ampEnv, filterEnv, cutoff;

	duration = \duration.kr(1);
	freq = \freq.kr(60).cpsmidi
		.lag(\lag.kr(0.04))
		.midicps;

	ampEnv = Env.linen(
		\atk.kr(0.01),
		(duration - \atk.kr(0.01) - \rel.kr(0.15)).max(0.001),
		\rel.kr(0.15),
		curve: -4
	).ar(Done.freeSelf);

	filterEnv = Env.perc(
		\filterAtk.kr(0.005),
		\filterRel.kr(0.35),
		curve: -4
	).ar;

	snd = Saw.ar(freq * [1, 1.005]);
	snd = snd + (Pulse.ar(freq * 0.5, 0.5) * -8.dbamp);
	snd = Mix(snd);

	cutoff = (
		\cutoff.kr(120)
		+ (filterEnv * \filterAmount.kr(2200))
	).clip(40, 16000);

	snd = MoogFF.ar(
		snd,
		cutoff,
		\res.kr(2.4)
	);

	snd = (snd * \drive.kr(2)).tanh;
	snd = BLowShelf.ar(snd, 180, 0.4, 3);
	snd = LPF.ar(snd, 9000);

	snd = Pan2.ar(
		snd * ampEnv,
		\pan.kr(0),
		\amp.kr(0.3)
	);

	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\delayBass, {
	var snd, freq;
	freq = \freq.kr(50);
	snd = Saw.ar(freq);
	5.do {
		snd = snd + DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 2).linlin(-1, 1, 0, 1) * 2e-3);
	};
	snd = (SinOsc.ar(freq) * 3).tanh + (HPF.ar(snd, 400) * -10.dbamp);
	snd = snd * -10.dbamp;
	snd = snd * Env.asr(0.01, 1, 0.03, curve: 4).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\acid1, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = Saw.ar(freq);
	snd = Latch.ar(snd, Impulse.ar(ExpRand(3e3, 16e3)));
	snd = MoogFF.ar(snd, (ExpRand(100, 2000) * (Env.perc(0.001, Rand(0.1, 0.3)).ar * Rand(10, 30)).midiratio * [1, 1.5]).min(16e3), 3).sum;
	snd = (snd * 3).fold2;
	snd = snd * Env.asr(0.001, 1, 0.03).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\acid2, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2] * XLine.ar(2, 1, 0.01)).sum;
	snd = MoogFF.ar(snd, 400 * ExpRand(0.5, 2) * (Env.perc(0, duration * Rand(0.3, 3), curve: -4).ar * 12 * Rand(3, 8)).midiratio, 2) * 5.dbamp;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * 5.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.3, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\acid3, {
	var snd, freq, duration;
	duration = \duration.kr(0.3);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * XLine.ar(2, 1, 0.01) * [1, 2]);
	snd = (snd * [1, 0.5]).sum;
	snd = MoogFF.ar(snd, { ExpRand(1000, 8000) } ! 3 * XLine.kr(2, 1, ExpRand(0.1, 0.9)), 3.4).sum * 7.dbamp;
	snd = snd.fold2;
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)




///////////////////////////////////////////////////////////////////////
// pwm

(
SynthDef(\pwmBass, {
	var snd, freq, width, env;
	freq = \freq.kr(60).cpsmidi.lag(0.04).midicps;
	width = SinOsc.kr(
		\pwmRate.kr(0.4)
	).range(0.25, 0.75);
	env = Env.perc(
		0.01,
		\duration.kr(2),
		curve: -4
	).ar(Done.freeSelf);
	snd = Pulse.ar(freq, width);
	snd = RLPF.ar(
		snd,
		\cutoff.kr(900),
		0.35
	);
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 180, 0.3, 3);
	Out.ar(\out.kr(0),
		Pan2.ar(snd * env * -8.dbamp)
	);
}).play;
)


(
SynthDef(\pwmBass2, {
	var snd, freq, width, env;
	freq = \freq.kr(60).cpsmidi.lag(0.04).midicps;
	width = SinOsc.kr(0.5).range(0.3, 0.7);
	env = Env.perc(
		0.01,
		\duration.kr(2),
		curve: -4
	).ar(Done.freeSelf);
	snd = Pulse.ar(
		freq * [-0.04,0,0.04].midiratio,
		width
	);
	snd = Splay.ar(snd);
	snd = RLPF.ar(snd, 1200, 0.3);
	snd = (snd * 2).tanh;
	snd = BLowShelf.ar(snd, 180, 0.3, 3);
	Out.ar(\out.kr(0),
		Pan2.ar(snd * env * -8.dbamp)
	);
}).play;
)

///////////////////////////////////////////////////////////////////////
// dubstep / wobble


(
SynthDef(\wobbleBass, {
	var snd, freq, duration, ampEnv, wobble, cutoff;

	duration = \duration.kr(2);
	freq = \freq.kr(50).cpsmidi
		.lag(\lag.kr(0.03))
		.midicps;

	ampEnv = Env.linen(
		0.01,
		(duration - 0.11).max(0.001),
		0.1,
		curve: -4
	).ar(Done.freeSelf);

	wobble = SinOsc.kr(
		\wobbleRate.kr(2),
		\wobblePhase.kr(0)
	).linlin(-1, 1, 0, 1);

	snd = Saw.ar(
		freq * [-0.08, 0, 0.08].midiratio
	);

	snd = Splay.ar(snd, 0.35);

	cutoff = wobble.linexp(
		0,
		1,
		\cutoffMin.kr(80),
		\cutoffMax.kr(3500)
	);

	snd = RLPF.ar(
		snd,
		cutoff,
		\rq.kr(0.2)
	);

	snd = (snd * \drive.kr(4)).tanh;

	snd = BLowShelf.ar(snd, 180, 0.4, 3);
	snd = BHiShelf.ar(snd, 5000, 0.5, -4);

	snd = snd * ampEnv * \amp.kr(0.25);

	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\talkingWobble, {
	var snd, dry, freq, duration, ampEnv;
	var wobble, center, lowBand, midBand, highBand;

	duration = \duration.kr(2);

	freq = \freq.kr(45).cpsmidi
		.lag(\lag.kr(0.04))
		.midicps;

	ampEnv = Env.linen(
		0.01,
		(duration - 0.11).max(0.001),
		0.1,
		curve: -4
	).ar(Done.freeSelf);

	wobble = LFTri.kr(
		\wobbleRate.kr(2)
	).linlin(-1, 1, 0, 1);

	snd = Saw.ar(
		freq * [-0.05, 0.05].midiratio
	);

	snd = snd + Pulse.ar(
		freq * 0.5,
		0.5,
		-8.dbamp
	);

	dry = snd;

	center = wobble.linexp(
		0,
		1,
		\centerMin.kr(120),
		\centerMax.kr(2200)
	);

	lowBand = BPF.ar(
		snd,
		center,
		0.2
	) * 3;

	midBand = BPF.ar(
		snd,
		center * 2.2,
		0.15
	) * 2;

	highBand = BPF.ar(
		snd,
		center * 4.8,
		0.1
	);

	snd = lowBand + midBand + highBand;
	snd = snd + (LPF.ar(dry, 140) * 0.8);

	snd = (snd * \drive.kr(5)).tanh;
	snd = LeakDC.ar(snd);

	snd = Splay.ar(snd, 0.25);
	snd = snd * ampEnv * \amp.kr(0.2);

	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\stepWobble, {
	var snd, sub, freq, duration, ampEnv;
	var wobble, cutoff, rate;

	duration = \duration.kr(2);

	freq = \freq.kr(50).cpsmidi
		.lag(\lag.kr(0.02))
		.midicps;

	ampEnv = Env.linen(
		0.005,
		(duration - 0.105).max(0.001),
		0.1,
		curve: -4
	).ar(Done.freeSelf);

	rate = \wobbleRate.kr(4);

	wobble = LFPulse.kr(
		rate,
		0,
		\wobbleWidth.kr(0.5)
	).lag(\wobbleLag.kr(0.015));

	snd = VarSaw.ar(
		freq * [-0.1, 0, 0.1].midiratio,
		0,
		0.3
	);

	snd = Splay.ar(snd, 0.4);

	cutoff = Select.kr(
		wobble,
		[
			\cutoffLow.kr(120),
			\cutoffHigh.kr(2800)
		]
	);

	snd = RLPF.ar(
		snd,
		cutoff,
		\rq.kr(0.12)
	);

	snd = (snd * \preDrive.kr(8)).fold2;
	snd = LPF.ar(snd, 6500);

	sub = SinOsc.ar(freq * 0.5) * -6.dbamp;
	sub = sub ! 2;

	snd = snd + sub;

	snd = Compander.ar(
		snd,
		snd,
		0.25,
		1,
		0.3,
		0.005,
		0.08
	);

	snd = BLowShelf.ar(snd, 160, 0.4, 3);
	snd = snd * ampEnv * \amp.kr(1);

	Out.ar(\out.kr(0), snd);
}).play;
)

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////







// endfile 