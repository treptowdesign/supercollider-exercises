(
SynthDef(\buffer, {
    var snd, buffer, ratio;
    buffer = \buffer.kr;
    ratio = \transpose.kr(-4).midiratio;
    snd = PlayBuf.ar(2, buffer, BufRateScale.ir(buffer) * ratio);
    snd = BHiShelf.ar(snd, 2000, 0.5, 3);
    snd = snd * Env.linen(0.1, BufDur.ir(buffer) / ratio, 1.0, curve: \sin).ar(Done.freeSelf);
    snd = snd * -5.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\vocalFx, {
    var snd, fb;
    snd = In.ar(\in.kr(0), 2);
    fb = [
        DelayN.ar(snd[0], 0.1, 0.03),
        snd[1],
        DelayN.ar(snd[1], 0.1, 0.04),
        DelayN.ar(snd[0], 0.1, 0.06),
    ];
    fb = fb + LocalIn.ar(4);
    fb = DelayC.ar(fb, 1.3, [0.1, 0.34, 0.23, 0.55] + (LFNoise2.ar(8 ! 4) * 0.001));
    fb = LPF.ar(fb, 3000);
    fb = HPF.ar(fb, 200);
    // Stautner-Puckette unitary matrix
    fb = (fb * [
        [0, 1, 1, 0],
        [-1, 0, 0, -1],
        [1, 0, 0, -1],
        [0, 1, -1, 0],
    ]).sum / sqrt(2);
    fb = fb * -1.dbamp;
    LocalOut.ar(fb);
    snd = snd + (Splay.ar(fb) * -2.dbamp);
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\kick, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 60, 220) * [1, 1.34, 2.56] * XLine.ar(1.5, 1, 0.01));
    snd = snd * Env.perc(0.002, [0.8, 0.08, 0.03]).ar;
    snd = snd.sum;
    snd = snd + (BPF.ar(WhiteNoise.ar, 2420, 0.3) * Env.perc(0.02, 0.01).ar * -5.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 3420, 0.3) * Env.perc(0.023, 0.03).ar * -15.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity * 0.5));
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 100, 0.3, 3);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.015 * (2 - velocity), 0.4 * velocity).ar;
    snd = snd + GVerb.ar(snd * -20.dbamp, 20, 1);
    snd = snd * Env.linen(0.0, \duration.kr(0.3) * 1, 0.01).ar(Done.freeSelf);
    snd = snd * -7.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

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
}).add;

SynthDef(\snare2, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(274 * [1, 2.34, 7.56]);
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
}).add;

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
}).add;

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
}).add;

SynthDef(\drumFx_new, {
    var snd, compressed;
    var compThresh, compRatio, compAttack, compRelease;
    var compMakeup, compMix;

    snd = In.ar(\in.kr(0), 2);
    snd = LeakDC.ar(snd);
    snd = snd + GVerb.ar(snd.sum * -40.dbamp, 80, 3);
    snd = snd + HPF.ar(PitchShift.ar(snd * -20.dbamp, 0.03, 2.5, 0.01, 0.01), 400);
    snd = LPF.ar(snd, snd.abs.lagud(0.01, 0.05).sum.linexp(0, 0.5, 16e3, 6000));
    snd = snd * (1 + (Dust2.ar(100 ! 2) * -10.dbamp));
    snd = snd * (1 + (Dust2.ar(1000 ! 2) * -30.dbamp));
    snd = snd + DelayC.ar(snd * -10.dbamp, 0.1, SinOsc.ar(0.5, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
    snd = snd * (1 + (0.5 * LFNoise2.ar(100)));
    snd = snd * 15.dbamp;
    snd = BLowShelf.ar(snd, 200, 0.3, -3);
    snd = BHiShelf.ar(snd, 2000, 0.3, -3);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = BHiShelf.ar(snd, 2000, 0.3, 3);

	// Compressor controls
    compThresh = \compThresh.kr(-12).dbamp;
    compRatio = \compRatio.kr(4).max(1);
    compAttack = \compAttack.kr(0.01).max(0.0001);
    compRelease = \compRelease.kr(0.1).max(0.001);
    compMakeup = \compMakeup.kr(4).dbamp;
    compMix = \compMix.kr(0.5).clip(0, 1);

    compressed = Compander.ar(
        in: snd,
        control: snd,
        thresh: compThresh,
        slopeBelow: 1,
        slopeAbove: compRatio.reciprocal,
        clampTime: compAttack,
        relaxTime: compRelease
    );

    compressed = compressed * compMakeup;

    // Parallel compression blend
    snd = XFade2.ar(
        snd,
        compressed,
        compMix.linlin(0, 1, -1, 1)
    );

    snd = snd * -10.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\drumFx, {
    var snd;
    snd = In.ar(\in.kr(0), 2);
    snd = LeakDC.ar(snd);
    snd = snd + GVerb.ar(snd.sum * -40.dbamp, 80, 2);
    snd = snd + HPF.ar(PitchShift.ar(snd * -20.dbamp, 0.03, 2.5, 0.01, 0.01), 400);
    snd = LPF.ar(snd, snd.abs.lagud(0.01, 0.05).sum.linexp(0, 0.5, 16e3, 6000));
    snd = snd * (1 + (Dust2.ar(200 ! 2) * -8.dbamp));
    snd = snd * (1 + (Dust2.ar(1600 ! 2) * -26.dbamp));
    snd = snd + DelayC.ar(snd * -10.dbamp, 0.1, SinOsc.ar(0.5, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
    snd = snd * (1 + (0.5 * LFNoise2.ar(100)));
    snd = snd * 15.dbamp;
    snd = BLowShelf.ar(snd, 200, 0.3, -3);
    snd = BHiShelf.ar(snd, 2000, 0.3, -3);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = BHiShelf.ar(snd, 2000, 0.3, 3);
    snd = snd * -10.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;


// sustained
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
    snd = snd * Env.asr(0.02, 1.0, 0.2).ar(gate: K2A.ar(\gate.kr(0)));
    snd = snd + GVerb.ar(snd.sum * -5.dbamp, 90, 2);
    snd = snd * -16.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
    var snd, freq, duration, env;
    duration = \duration.kr(5.0);
    freq = \freq.kr(60);
    env = Env.perc(duration * 0.5, duration * 2, curve: \sin).ar(Done.freeSelf);
    snd = Saw.ar(freq * (LFNoise2.ar(30 ! 8) * 0.5).midiratio);
    snd = Splay.ar(snd);
    snd = LPF.ar(snd, env.linexp(0, 1, 200, 500));
    snd = snd * env;
	snd = snd * -16.dbamp * \amp.kr(1);
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\horn, {
    var snd, freq, fb;
    freq = \freq.kr(440);
    snd = SinOsc.ar(freq) * [20, 6] * Line.ar(0, 1, 0.1);
    snd = SinOsc.ar(freq, snd % 2pi).sum;
    snd = LPF.ar(snd, Env.perc(0.01, 0.3, curve: \lin).ar.linexp(0, 1, 200, 12500));
    snd = snd.tanh;
    snd = snd * Env.perc(0.05, 0.5).ar(Done.freeSelf);
    snd = snd ! 2;
    snd = snd * -13.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

// i think the lack of expression is an issue here
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
}).add;

SynthDef(\stringFx, {
    var snd;
    snd = In.ar(\in.kr(0), 2);
    snd = (snd * -4.dbamp) + GVerb.ar(snd.sum * -10.dbamp, 50, 3);
    snd = BHiShelf.ar(snd, 2000, 0.9, -5);
    snd = LPF.ar(snd, LFNoise2.ar(0.3).linexp(-1, 1, 3000, 8000));
    Out.ar(\out.kr(0), snd);
}).add;

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
}).add;

SynthDef(\rain, {
    var snd;
    snd = {
        snd = Dust2.ar(LFNoise2.ar(0.3).linexp(-1, 1, 1000, 6000));
        snd = snd * LFNoise2.ar(0.4).linlin(-1, 1, 0.3, 1);
        snd = LPF.ar(snd, LFNoise2.ar(0.5).linexp(-1, 1, 2000, 16000));
    } ! 10;
    snd = Splay.ar(snd);
    snd = snd + GVerb.ar(snd.sum * -5.dbamp, 60, 5);
    snd = HPF.ar(snd, 200);
    snd = LPF.ar(snd, 3000);
    snd = snd * Line.ar(0, 1, 8).sqrt;
    snd = snd * -20.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

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
}).add;

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
    snd = snd * -12.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hornFx, {
    var snd, fb;
    snd = In.ar(\in.kr(0), 2);
    3.do {
        snd = LPF.ar(snd, 900);
    };
    snd = snd + GVerb.ar(snd.sum * -20.dbamp, 30, 5);
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, 0.4, [0.5, 0.52] + (SinOsc.ar(0.5, [0, pi]) * 1e-3));
    fb = LPF.ar(fb, 3000);
    fb = HPF.ar(fb, 200);
    fb = fb * -5.dbamp;
    LocalOut.ar(fb);
    snd = snd + fb;
    Out.ar(\out.kr(0), snd);
}).add;
)

// Burial imitation
// vocal samples by D!SHA from "Casually Dating"

(
var s, beat, wait, play, playP, noteToFreq;
s = Server.default;
beat = 60 / 129;

if(~buffer.isNil) {
    ~buffer = Buffer.read(nil, "./2026-07-16-thinking-of-you.wav".resolveRelative);
};
if(~buffer2.isNil) {
    ~buffer2 = Buffer.read(nil, "./2026-07-16-when-youre-not-around.wav".resolveRelative);
};
if(~buffer3.isNil) {
    ~buffer3 = Buffer.read(nil, "./2026-07-16-with-or-without-you.wav".resolveRelative);
};
if(~buffer4.isNil) {
    ~buffer4 = Buffer.read(nil, "./2026-07-16-with-or-without-you-2.wav".resolveRelative);
};

wait = { |duration|
    (duration * beat).wait;
};

play = { |synthDef, duration, args = #[]|
    s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
    wait.(duration);
};

playP = { |synthDef, duration, args = #[]|
    s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};

noteToFreq = { |note, octave = 0|
    (61 + note + (octave * 12)).midicps;
};

Routine({
    var drumBus, hornBus, stringBus, vocalBus;


    s.newBusAllocators;
    s.sync;

    s.bind {
        drumBus = Bus.audio(nil, 2);
        hornBus = Bus.audio(nil, 2);
        stringBus = Bus.audio(nil, 2);
        vocalBus = Bus.audio(nil, 2);
        Synth.tail(nil, \drumFx, [in: drumBus, out: 0]);
        Synth.tail(nil, \hornFx, [in: hornBus, out: 0]);
        Synth.tail(nil, \stringFx, [in: stringBus, out: 0]);
        Synth.tail(nil, \vocalFx, [in: vocalBus, out: 0]);
    };

    s.bind {
        Synth(\crackles, [out: 0]);
        Synth(\rain, [out: 0]);
    };

    /*fork {
        wait.(4);
        loop {
            play.(\ping, 1, [freq: noteToFreq.(7, 1)]);
            wait.(8);
            play.(\horn, 1 / 3, [freq: noteToFreq.(5), out: hornBus]);
            play.(\horn, 1 / 3, [freq: noteToFreq.(7), out: hornBus]);
            wait.(12);
            play.(\horn, 1 / 3, [freq: noteToFreq.(5), out: hornBus]);
            play.(\horn, 1 / 3, [freq: noteToFreq.(3), out: hornBus]);
            wait.(5);
            play.(\horn, 1 / 3, [freq: noteToFreq.(0), out: hornBus]);
            wait.(5);
            wait.(3);
            play.(\vocal, 1 / 2, [freq: noteToFreq.(12), out: hornBus]);
            play.(\vocal, 1 / 2, [freq: noteToFreq.(12 + 2), out: hornBus]);
        };
    };*/

	fork {
        loop {
			wait.(4);
            playP.(\ping, 1, [freq: noteToFreq.(7, 1)]);
			wait.((4 * 7));
        };
    };

    fork {
        loop {
            [0, 5, 7, 8, 7, 0, 5, 7, 8, 10, \].do { |note|
                if(note != \) {
					playP.(\pad, 15, [freq: noteToFreq.(note+12), out: 0, amp: 0.5]); // vocalBus
                    playP.(\pad, 15, [freq: noteToFreq.(note), out: 0]); // vocalBus
                };
                wait.(4);
            };
        };
    };

	wait.(4 * 8);

    fork {
		var pattern, grid, positions, phase, depth;
		phase = 0;
		depth = 0.03;
        grid = 16.collect { |i| if((i % 2) == 0, { 2/3 }, { 1/3 }); };
		positions = ((0..grid.size - 1) / grid.size);
		grid = grid + (((positions * 2pi) + phase).cos * depth);
        grid = grid.normalizeSum * 4;
        pattern = [
			// 16 tatums: synth, duration (16ths), velocity
            [\kick, 1, 1.0],
            [\hat2, 1, 0.5],
            [\kick, 2, 0.6],
            [\snare, 2, 0.9],
            [\hat, 1, 0.5],
            [\snare, 1, 0.1],
            [\kick, 2, 0.8],
            [\kick, 1, 0.1],
            [\snare2, 2, 0.9],
            [\hat2, 1, 0.9],
            [\hat, 1, 0.5],
            [\snare, 1, 0.5],
			// 16 tatums: synth, duration (16ths), velocity
            [\kick, 1, 0.3],
            [\hat2, 1, 0.5],
            [\kick, 2, 0.5],
            [\snare, 2, 0.8],
            [\hat, 1, 0.5],
            [\snare, 1, 0.1],
            [\kick, 2, 0.8],
            [\kick, 1, 0.1],
            [\snare2, 2, 0.9],
            [\snare, 1, 0.2],
            [\hat2, 1, 0.3],
            [\hat, 1, 0.5],
        ];
        inf.do { |n|
            var i;
            i = 0;
            pattern.do { |spec|
                var synthDef, duration16ths, duration, velocity;
                # synthDef, duration16ths, velocity = spec;
                duration = 0;
                duration16ths.do {
                    duration = duration + grid.wrapAt(i);
                    i = i + 1;
                };
				/*if(n < 4, {
                    velocity = velocity.linlin(0, 1, 0.1, 0.3);
                });*/
                play.(synthDef, duration, [out: drumBus, velocity: velocity]);
            };
        };
    };

    wait.(4 * 8);


    fork {
        var synth;
        s.bind { synth = Synth(\reese, [freq: noteToFreq.(0, -2)]); };
        loop {
            [
                [4, -2],
                [2, 7],
                [2, -5],
                [4, -4],
                [2, \],
                [1, 3],
                [1, 2],

                [4, -2],
                [2, 7],
                [2, -5],
                [4, -4],
                [2, \],
                [2 / 3, 3],
                [2 / 3, 2],
                [2 / 3, 12],
            ].do { |spec|
                var duration, note;
                # duration, note = spec;
                if(note == \) {
                    s.bind { synth.set(\gate, 0) };
                } {
                    s.bind { synth.set(\freq, noteToFreq.(note, -2), \gate, 1) };
                };
                wait.(duration);
            };
        };
    };
}).play;
)






(0.0 * 2pi).cos;
(0.1 * 2pi).cos;
(0.2 * 2pi).cos;
(0.3 * 2pi).cos;
(0.4 * 2pi).cos;
(0.5 * 2pi).cos;
(0.6 * 2pi).cos;
(0.7 * 2pi).cos;
(0.8 * 2pi).cos;
(0.9 * 2pi).cos;
(1.0 * 2pi).cos;