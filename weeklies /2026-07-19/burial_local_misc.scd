


(
SynthDef(\vocal, {
    var snd, freq;
    freq = \freq.kr(64.midicps);
    snd = Pulse.ar(freq * (LFNoise2.ar(30) * 0.2).midiratio * XLine.ar(-1.midiratio, 1, 0.05), 0.2);
    snd = snd + (WhiteNoise.ar * -15.dbamp);
    snd = CombC.ar(snd, 0.3, 1 / 92, 0.1);
    snd = BPF.ar(snd, [900, 1300] * XLine.ar(1, [1.2, 0.9], 0.2), [0.3, 0.04]).sum * 20.dbamp;
    snd = LeakDC.ar(snd);
    snd = snd * Env.perc(0.03, 0.5, curve: 2).ar(Done.freeSelf);
    snd = Pan2.ar(snd, 0);
    snd = snd * -29.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\reese, {
    var snd, freq, low, high;
    freq = \freq.kr(60).cpsmidi.lagud(0.2, 0.1).midicps;
    snd = Saw.ar(freq * [-0.3, 0, 0.3].midiratio);
    snd = Splay.ar(snd);
    low = snd;
    low = LPF.ar(low, SinOsc.ar(0.3).linexp(-1, 1, 300, 350));
    low = low * 4.dbamp;
    low = low * LFNoise2.ar(30).linlin(-1, 1, 0.9, 1.2);
    low = low.tanh;
    low = low * -1.dbamp;
    high = snd * -3.dbamp;
    high = (high * 4.dbamp).tanh;
    high = high + DelayC.ar(high * -13.dbamp, 0.2, SinOsc.ar(0.2, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
    high = HPF.ar(high, SinOsc.ar(1 / 7).linexp(-1, 1, 3000, 8000));
    high = high * -8.dbamp;
    snd = low + high;
    snd = BLowShelf.ar(snd, 100, 0.3, 3);
    snd = snd * Env.asr(0.02, 1.0, 0.2).ar(gate: K2A.ar(\gate.kr(1)));
    snd = snd + GVerb.ar(snd.sum * -5.dbamp, 90, 2);
    snd = snd * -16.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)








(
SynthDef(\crackles, {
    var snd;
    snd = {
        snd = Dust2.ar(LFNoise2.ar(1).linexp(-1, 1, 5, 100));
        snd = Decay2.ar(snd, 0.001, 0.005);
        snd = snd * LPF.ar(WhiteNoise.ar, LFNoise2.ar(0.3).linexp(-1, 1, 200, 8000));
        snd = Pan2.ar(snd, LFNoise2.ar(3).fold2);
    } ! 10;
    snd = snd.sum;
    snd = LPF.ar(snd, 3000);
    snd = HPF.ar(snd, 500);
    snd = snd + GVerb.ar(snd.sum * -10.dbamp, 60, 5);
    snd = snd * -15.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\rain, {
    var snd;
    snd = {
        snd = Dust2.ar(LFNoise2.ar(0.3).linexp(-1, 1, 3000, 6000));
        snd = snd * LFNoise2.ar(0.6).linlin(-1, 1, 0.2, 1);
        snd = LPF.ar(snd, LFNoise2.ar(0.5).linexp(-1, 1, 5000, 16000));
    } ! 10;
    snd = Splay.ar(snd);
    snd = snd + GVerb.ar(snd.sum * -5.dbamp, 60, 5);
    snd = HPF.ar(snd, 200);
    snd = LPF.ar(snd, 4000);
    snd = snd * Line.ar(0, 1, 8).sqrt;
    snd = snd * -20.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)





(
SynthDef(\cracklesMod, {
    var snd;
    snd = {
        snd = Dust2.ar(LFNoise2.ar(1).linexp(-1, 1, 5, 200));
        snd = Decay2.ar(snd, 0.001, 0.005);
        snd = snd * LPF.ar(WhiteNoise.ar, LFNoise2.ar(0.3).linexp(-1, 1, 200, 8000));
        snd = Pan2.ar(snd, LFNoise2.ar(3).fold2);
    } ! 10;
    snd = snd.sum;
	snd = LPF.ar(snd, SinOsc.ar(0.43).range(2000, 4000));
    snd = HPF.ar(snd, SinOsc.ar(0.36, pi).range(400, 600));
    snd = snd + GVerb.ar(snd.sum * -10.dbamp, 60, 5);
    snd = snd * -15.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)





(
SynthDef(\snare, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(264 * [1, 2.34, 7.56]);
    snd = snd * Env.perc(0, [0.05, 0.04, 0.01]).ar;
    snd = snd.sum;
    snd = snd * (1 + (SinOsc.ar(120) * Env.perc(0, 0.03).ar * velocity));
    snd = snd * (1 + (SinOsc.ar(220) * Env.perc(0, 0.09).ar * -5.dbamp));
    snd = snd * (1 + (SinOsc.ar(420) * Env.perc(0, 0.01).ar * -5.dbamp));
    snd = snd + (SinOsc.ar(930 * XLine.ar(1.5, 1, 0.01)) * Env.perc(0, 0.01).ar * 0.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 1420, 0.2) * Env.perc(0.001, 0.03).ar * 1.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 2420, 0.2) * Env.perc(0.01, 0.19, curve: -4).ar * -1.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 720, 0.2) * Env.perc(0.01, 0.03).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 3220, 0.2) * Env.perc(0.005, 0.01).ar * -2.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity));
    snd = snd.tanh;
    snd = snd * (1 + (0.3 * Env.perc(0, 0.02).ar * velocity));
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.01 * (2 - velocity), 0.25).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -20.dbamp, 30, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -6.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\snare2, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(284 * [1, 2.34, 7.56]);
    snd = snd * Env.perc(0, [0.03, 0.03, 0.01]).ar;
    snd = snd.sum;
    snd = snd * (1 + (SinOsc.ar(120) * Env.perc(0, 0.03).ar * velocity));
    snd = snd * (1 + (SinOsc.ar(220) * Env.perc(0, 0.09).ar * -5.dbamp));
    snd = snd * (1 + (SinOsc.ar(420) * Env.perc(0, 0.01).ar * -5.dbamp));
    snd = snd + (SinOsc.ar(930 * XLine.ar(1.5, 1, 0.01)) * Env.perc(0, 0.01).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 2420, 0.3) * Env.perc(0.01, 0.03).ar * 2.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 1420, 0.3) * Env.perc(0.01, 0.05, curve: \sin).ar * 4.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 720, 0.3) * Env.perc(0.01, 0.03).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 820, 0.3) * Env.perc(0.005, 0.01).ar * -2.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity));
    snd = snd.tanh;
    snd = snd * velocity.sqrt;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * Env.perc(0.01, 0.25).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -20.dbamp, 50, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -6.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\pad, {
    var snd, freq, duration, env;
    duration = \duration.kr(1.0);
    freq = \freq.kr(60);
    env = Env.perc(duration * 0.5, duration * 2, curve: \sin).ar(Done.freeSelf);
    snd = Saw.ar(freq * (LFNoise2.ar(30 ! 8) * 0.5).midiratio);
    snd = Splay.ar(snd);
    snd = LPF.ar(snd, env.linexp(0, 1, 200, 500));
    snd = snd * env;
    snd = snd * -16.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


(
(0 + [0, 3, 7, 10]).do { |int|
	Synth(\pad, [freq: (60 + int + (12 * 0)).midicps]);
};
)


(
(0 + [0, 4, 7, 11]).do { |int|
	Synth(\pad, [freq: (60 + int + (12 * 0)).midicps]);
};
)



(
SynthDef(\ping, {
    var snd, freq;
    freq = \freq.kr(900);
    snd = SinOsc.ar(freq * (LFNoise2.ar(30) * 0.02).midiratio);
    snd = snd * Env.perc(0.02, 0.9, curve: -2).ar;
    snd = snd * (1 + (PinkNoise.ar * -10.dbamp));
    snd = snd + GVerb.ar(snd * -5.dbamp, 80, 1);
    snd = snd * LFNoise2.ar(30 ! 2).linlin(-1, 1, 0.5, 1);
    snd = (snd * -4.dbamp).tanh * 4.dbamp;
    snd = DelayC.ar(snd, 0.2, LFNoise2.ar(8).linlin(-1, 1, 0, 1) * 1e-3);
    snd = snd + GVerb.ar(snd.sum * -9.dbamp, 80, 10);
    snd = snd.tanh;
    snd = snd * LFNoise2.ar(30 ! 2).linlin(-1, 1, 0.5, 1);
    snd = snd * (1 + (PinkNoise.ar * -10.dbamp));
    snd = snd + GVerb.ar(snd.sum * -30.dbamp, 30, 10);
    snd = snd * -12.dbamp;
    snd = snd.tanh;
    3.do {
        snd = LPF.ar(snd, 2000);
    };
    snd = snd * Env.linen(0, 20, 0.1).ar(Done.freeSelf);
	snd = snd * -12.dbamp * \amp.kr(1.0);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
(0 + [0-12, 3, 7, 10]).do { |int|
	Synth(\ping, [freq: (61 + int + (12 * 0)).midicps, amp: 0.5]);
};
)


(
(5 + [0-12, 3, 7, 10]).do { |int|
	Synth(\ping, [freq: (61 + int + (12 * 0)).midicps, amp: 0.5]);
};
)




(
(0 + [0-12, 3, 7-12, 10, 14]).do { |int|
	Synth(\ping, [freq: (60 + int + (12 * 0)).midicps, amp: 0.4]);
};
)





(
SynthDef(\stringPad, {
    var snd, freq, duration, env, velocity;
    duration = \duration.kr(5.0);
    freq = \freq.kr(73.midicps);
    velocity = \velocity.kr(1);
    snd = {
        var snd;
        snd = Pulse.ar(freq * ((LFNoise2.ar(8) * 0.1) + (SinOsc.ar(LFNoise2.ar(1).linexp(-1, 1, 4, 6), Rand(0, 2pi)) * 0.1 * Line.ar(0, 1, 0.3)) * velocity).midiratio, Rand(0.1, 0.3));
        snd = snd * (1 + HPF.ar(PinkNoise.ar * 5.dbamp * velocity, freq * 2));
        snd = CombC.ar(snd, 0.1, LFNoise2.ar(3).midiratio / ExpRand(63, 90), 0.1);
        snd = CombC.ar(snd, 0.1, LFNoise2.ar(3).midiratio / ExpRand(63, 90), 0.1);
        snd = BHiShelf.ar(snd, 3000 * ExpRand(0.5, 2.0), 0.3, -4);
        snd = BHiShelf.ar(snd, 6000 * ExpRand(0.5, 2.0), 0.3, 3);
        snd = snd * LFNoise2.ar(3).linlin(-1, 1, 0.5, 1);
        snd = LeakDC.ar(snd);
        snd;
    } ! 8;
    snd = Splay.ar(snd);
    snd = BHiShelf.ar(snd, 8000, 0.3, -3);
    snd = LPF.ar(snd, freq * velocity.linexp(0, 1, 2, 8));
    snd = LPF.ar(snd, freq.explin(1000, 3000, 8000, 4000));
    snd = snd * velocity.linlin(0, 1, -10, 0).dbamp;
    snd = snd * freq.explin(500, 1000, 0, -10).dbamp;
    snd = snd * Env.linen(1.5, duration, 1.3, curve: \sin).ar(Done.freeSelf);
    snd = snd * -25.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


2pi;


(
(0 + [0-12, 5, 16, 21]).do { |int|
	Synth(\stringPad, [freq: (60 + int + (12 * 0)).midicps]);
};
)


(
SynthDef(\hat, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = { WhiteNoise.ar } ! 4;
    snd = CombC.ar(snd, 0.1, 1 / [159, 474, 392, 723], 2.0);
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [305, 234, 199, 923]);
    snd = snd.sum;
    snd = HPF.ar(snd, 6000);
    snd = HPF.ar(snd, 6000);
    snd = LPF.ar(snd, 12300);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.005, 0.1).ar;
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -15.dbamp;
    snd = snd ! 2;
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat2, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = { WhiteNoise.ar } ! 4;
    snd = CombC.ar(snd, 0.1, 1 / [259, 374, 492, 823], 1.0);
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [205, 134, 299, 423] * 2);
    snd = snd.sum;
    snd = snd + PinkNoise.ar;
    snd = HPF.ar(snd, 9000);
    snd = HPF.ar(snd, 9000);
    snd = LPF.ar(snd, XLine.ar(12e3, 1000, 0.3));
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.005, 0.2).ar;
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -13.dbamp;
    snd = snd ! 2;
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\horn, {
    var snd, freq, fb;
    freq = \freq.kr(260);
    snd = SinOsc.ar(freq) * [20, 6] * Line.ar(0, 1, 0.05);
    snd = SinOsc.ar(freq, snd % 2pi).sum;
    snd = LPF.ar(snd, Env.perc(0.01, 0.3, curve: \lin).ar.linexp(0, 1, 100, 12500));
    snd = snd.tanh;
    snd = snd * Env.perc(0.05, 0.5).ar(Done.freeSelf);
    snd = snd ! 2;
    snd = snd * -20.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


[
	0.35333333333333,
	0.18514425731689,

	0.34747546895706,
	0.17432033531397,

	0.33333333333333,
	0.15901299801936,

	0.3191911977096,
	0.14818907601644,

	0.31333333333333,
	0.14818907601644,

	0.3191911977096,
	0.15901299801936,

	0.33333333333333,
	0.17432033531397,

	0.34747546895706,
	0.18514425731689
]




(
SynthDef(\kick, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 60, 210) * [1, 1.34, 2.56] * XLine.ar(1.5, 1, 0.01));
    snd = snd * Env.perc(0.002, [0.5, 0.05, 0.03]).ar;
    snd = snd.sum;
    snd = snd + (BPF.ar(WhiteNoise.ar, 3420, 0.3) * Env.perc(0.02, 0.01).ar * -5.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 5420, 0.3) * Env.perc(0.023, 0.03).ar * -15.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity * 0.5));
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 100, 0.3, 2);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.015 * (2 - velocity), 0.25 * velocity).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -20.dbamp, 20, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -7.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)





(
SynthDef(\pad, {
    var snd, freq, duration, env;
    duration = \duration.kr(5.0);
    freq = \freq.kr(60);
    env = Env.perc(duration * 0.5, duration * 2, curve: \sin).ar(Done.freeSelf);
    snd = Saw.ar(freq * (LFNoise2.ar(30 ! 8) * 0.5).midiratio);
    snd = Splay.ar(snd);
    snd = LPF.ar(snd, env.linexp(0, 1, 200, 500));
    snd = snd * env;
    snd = snd * -16.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


(
(0 + [0-12, 3, 7-12, 10, 14]).do { |int|
	Synth(\pad, [freq: (61 + int + (12 * 0)).midicps]);
};
)

(
(5 + [0-12, 3, 7-12, 10, 14]).do { |int|
	Synth(\pad, [freq: (61 + int + (12 * 0)).midicps]);
};
)

(
(7 + [0-12, 3, 7-12, 10, 14]).do { |int|
	Synth(\pad, [freq: (61 + int + (12 * 0)).midicps]);
};
)

(
(2 + [0-12, 3, 7-12, 10, 14]).do { |int|
	Synth(\pad, [freq: (61 + int + (12 * 0)).midicps]);
};
)









(
SynthDef(\strings, {
    var snd, freq, duration, env, velocity;
    duration = \duration.kr(3.0);
    freq = \freq.kr(73.midicps);
    velocity = \velocity.kr(1);
    snd = {
        var snd;
        snd = Pulse.ar(freq * ((LFNoise2.ar(8) * 0.1) + (SinOsc.ar(LFNoise2.ar(1).linexp(-1, 1, 4, 6), Rand(0, 2pi)) * 0.1 * Line.ar(0, 1, 0.3)) * velocity).midiratio, Rand(0.1, 0.3));
        snd = snd * (1 + HPF.ar(PinkNoise.ar * 5.dbamp * velocity, freq * 2));
        snd = CombC.ar(snd, 0.1, LFNoise2.ar(3).midiratio / ExpRand(63, 90), 0.1);
        snd = CombC.ar(snd, 0.1, LFNoise2.ar(3).midiratio / ExpRand(63, 90), 0.1);
        snd = BHiShelf.ar(snd, 3000 * ExpRand(0.5, 2.0), 0.3, -4);
        snd = BHiShelf.ar(snd, 6000 * ExpRand(0.5, 2.0), 0.3, 3);
        snd = snd * LFNoise2.ar(3).linlin(-1, 1, 0.5, 1);
        snd = LeakDC.ar(snd);
        snd;
    } ! 5;
    snd = Splay.ar(snd);
    snd = BHiShelf.ar(snd, 8000, 0.3, -3);
    snd = LPF.ar(snd, freq * velocity.linexp(0, 1, 2, 8));
    snd = LPF.ar(snd, freq.explin(1000, 3000, 8000, 4000));
    snd = snd * velocity.linlin(0, 1, -10, 0).dbamp;
    snd = snd * freq.explin(500, 1000, 0, -10).dbamp;
    snd = snd * Env.linen(0.1, duration, 0.5, curve: \sin).ar(Done.freeSelf);
    snd = snd * -25.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)






(
(0 + [ 0-12, 3, 7-12, 10 ]).sort.do { |int|
	Synth(\strings, [freq: (61 + int + (12 * 0)).midicps]);
};
)

(
(5 + [ 0-12, 3-12, 7, 10-12 ]).sort.do { |int|
	Synth(\strings, [freq: (61 + int + (12 * 0)).midicps]);
};
)







(
SynthDef(\kick, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 55, 220) * [1, 1.24, 2.46] * XLine.ar(1.7, 1, 0.01));
    snd = snd * Env.perc(0.002, [0.5, 0.08, 0.03]).ar;
    snd = snd.sum;
    snd = snd + (BPF.ar(WhiteNoise.ar, 3420, 0.3) * Env.perc(0.02, 0.01).ar * -5.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 5420, 0.3) * Env.perc(0.023, 0.03).ar * -15.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity * 0.5));
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 100, 0.3, 3);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.015 * (2 - velocity), 0.25 * velocity).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -20.dbamp, 20, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -7.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)

















(
SynthDef(\snare, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(264 * [1, 2.34, 7.56]);
    snd = snd * Env.perc(0, [0.05, 0.04, 0.01]).ar;
    snd = snd.sum;
    snd = snd * (1 + (SinOsc.ar(120) * Env.perc(0, 0.03).ar * velocity));
    snd = snd * (1 + (SinOsc.ar(220) * Env.perc(0, 0.09).ar * -5.dbamp));
    snd = snd * (1 + (SinOsc.ar(420) * Env.perc(0, 0.01).ar * -5.dbamp));
    snd = snd + (SinOsc.ar(930 * XLine.ar(1.5, 1, 0.01)) * Env.perc(0, 0.01).ar * 0.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 1420, 0.2) * Env.perc(0.001, 0.03).ar * 1.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 2420, 0.2) * Env.perc(0.01, 0.19, curve: -4).ar * -1.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 720, 0.2) * Env.perc(0.01, 0.03).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 3220, 0.2) * Env.perc(0.005, 0.01).ar * -2.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity));
    snd = snd.tanh;
    snd = snd * (1 + (0.3 * Env.perc(0, 0.02).ar * velocity));
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.01 * (2 - velocity), 0.25).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -20.dbamp, 30, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -6.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\snare2, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(274 * [1, 2.34, 7.56]);
    snd = snd * Env.perc(0, [0.03, 0.03, 0.01]).ar;
    snd = snd.sum;
    snd = snd * (1 + (SinOsc.ar(120) * Env.perc(0, 0.03).ar * velocity));
    snd = snd * (1 + (SinOsc.ar(220) * Env.perc(0, 0.09).ar * -5.dbamp));
    snd = snd * (1 + (SinOsc.ar(420) * Env.perc(0, 0.01).ar * -5.dbamp));
    snd = snd + (SinOsc.ar(920 * XLine.ar(1.5, 1, 0.01)) * Env.perc(0, 0.01).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 2420, 0.3) * Env.perc(0.01, 0.03).ar * 2.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 1420, 0.3) * Env.perc(0.01, 0.05, curve: \sin).ar * 4.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 720, 0.3) * Env.perc(0.01, 0.03).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 820, 0.3) * Env.perc(0.005, 0.01).ar * -2.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity));
    snd = snd.tanh;
    snd = snd * velocity.sqrt;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * Env.perc(0.01, 0.25).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -20.dbamp, 30, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -6.dbamp;
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\808, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(25.midicps);
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

61-36;


(
SynthDef(\hat3, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(230))) + Hasher.ar(Sweep.ar + 1);
	snd = BPF.ar(snd, [7223, 9.234e3], 0.4);
	snd = snd.sum;
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.perc(0.003, 0.09, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\tom, {
    var snd, ratio;
    ratio = \ratio.kr(1);
    snd = SinOsc.ar(Env.perc(0, 0.15).ar.linexp(0, 1, 235, 330) * [1, 2.3, 3.5] * ratio);
    snd = snd * Env.perc(0.001, [0.05, 0.01, 0.01] * 3, curve: -6).ar;
    snd = snd * [0, -10, -20].dbamp;
    snd = snd.sum;
    snd = snd.tanh;
    snd = snd + (SinOsc.ar(XLine.ar(2000, 500, 0.01) * ratio) * Env.perc(0.001, 0.01).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 1500 * ratio, 0.3) * Env.perc(0.05, 0.03).ar * -10.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 3500 * ratio, 0.3) * Env.perc(0.005, 0.01).ar * -5.dbamp);
    snd = snd * (1 + Env.perc(0.001, 0.3).ar);
    snd = snd * 3.dbamp;
    snd = snd.tanh;
    snd = snd * (1 + Env.perc(0.001, 0.05).ar);
    snd = snd * -9.dbamp;
    snd = snd ! 2;
	// snd = snd * (1 + (Dust2.ar(100 ! 2) * -10.dbamp));
    // snd = snd * (1 + (Dust2.ar(1000 ! 2) * -30.dbamp));
    snd = snd * Env.perc(0.0, 1.0).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)


(

SynthDef(\crash, {
    var snd;
    snd = Hasher.ar(Sweep.ar + (0..3));
    snd = CombC.ar(snd, 0.2, 1 / [63, 72, 93, 104], -1.0);
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [123, 442, 520, 320]);
    snd = snd.sum;
    snd = snd * -10.dbamp;
    snd = BPF.ar(snd, (0..6).pow(0.2).normalize.linexp(0, 1, 500, 8e3), 0.1);
    snd = snd.sum;
    snd = HPF.ar(snd, 4000);
    snd = HPF.ar(snd, 3000);
    snd = LPF.ar(snd, XLine.ar(16e3, 6e3, 3.0));
    snd = snd * Env.perc(0.001, 1.0).ar;
    snd = snd + GVerb.ar(snd * 1.dbamp, 20, 5);
    snd = snd * -20.dbamp;
    snd = snd * Env.perc(0.001, 10.0).ar(Done.freeSelf);
    snd = Pan2.ar(snd, \pan.kr(0));
    Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\openHat, {
    var snd;
    snd = Hasher.ar(Sweep.ar + (0..3));
    snd = CombC.ar(snd, 0.2, 1 / [63, 72, 93, 104], -2.0);
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [123, 442, 520, 320] * 2.5);
    snd = snd.sum;
    snd = snd * -10.dbamp;
    snd = BPF.ar(snd, (0..8).pow(0.2).normalize.linexp(0, 1, 500, 8e3), 0.1);
    snd = snd.sum;
    snd = HPF.ar(snd, 4000);
    snd = HPF.ar(snd, 3000);
    snd = LPF.ar(snd, XLine.ar(16e3, 2e3, 0.5));
    snd = snd * Env.perc(0.001, 0.3).ar;
    snd = snd + GVerb.ar(snd * -5.dbamp, 20, 1);
    snd = snd * -13.dbamp;
    snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
    snd = Pan2.ar(snd, \pan.kr(0));
    Out.ar(\out.kr(0), snd);
}).play;
)


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\ping, {
    var snd, freq;
    freq = \freq.kr(440);
    snd = SinOsc.ar(freq * (LFNoise2.ar(30) * 0.02).midiratio);
    snd = snd * Env.perc(0.02, 0.3, curve: -2).ar;
    snd = snd * (1 + (PinkNoise.ar * -10.dbamp));
    snd = snd + GVerb.ar(snd * -5.dbamp, 80, 1);
    snd = snd * LFNoise2.ar(30 ! 2).linlin(-1, 1, 0.5, 1);
    snd = (snd * -4.dbamp).tanh * 4.dbamp;
    snd = DelayC.ar(snd, 0.2, LFNoise2.ar(8).linlin(-1, 1, 0, 1) * 1e-3);
    snd = snd + GVerb.ar(snd.sum * -9.dbamp, 80, 10);
    snd = snd.tanh;
    snd = snd * LFNoise2.ar(30 ! 2).linlin(-1, 1, 0.5, 1);
    snd = snd * (1 + (PinkNoise.ar * -10.dbamp));
    snd = snd + GVerb.ar(snd.sum * -30.dbamp, 30, 10);
    snd = snd * -12.dbamp;
    snd = snd.tanh;
    3.do {
        snd = LPF.ar(snd, 2000);
    };
	snd = snd * Env.linen(0, 0.3, 0.3).ar(Done.freeSelf);
	snd = snd * -12.dbamp * \amp.kr(1.0);
    Out.ar(\out.kr(0), snd);
}).play;
)




(
var s, bpm, beat, tatum, bar, root, noteHz, wait, play, seq;
s = Server.default;
bpm = 118;
beat = 60 / bpm;
tatum = beat / 4;
bar = beat * 4;
root = 61; // 61 = C#
noteHz = { |int=0, oct=0|
	(root + int + (12 * oct)).midicps;
};
wait = { |duration|
	(duration).wait;
};
play = { |synthDef, duration, args=#[]|
	s.bind { Synth(synthDef, [duration: duration] ++ args); };
};
seq = { |synthDef, duration, args=#[]|
	play.(synthDef, duration, args);
	wait.(duration);
};
Routine({
	loop {
		[
			(0 + [0, 4, 7, 11]),
			(2 + [0, 3, 7, 10]),
			(-1 + [0, 3, 6, 10]),
			(-5 + [0, 4, 7, 10])
		].do { |chord|
			chord.sort.do { |spec|
				(0..3).do { |oct|
					seq.(\ping, tatum, [freq: noteHz.(spec, oct)]);
				};
			};
		};
	};
}).play;
)







/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

// endfile...