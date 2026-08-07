(
SynthDef(\kick, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 52, 210) * [1, 1.22, 2.35] * XLine.ar(2, 1, 0.01));
    snd = snd * Env.perc(0.002, [2, 0.1, 0.03]).ar;
    snd = snd.sum;
    snd = snd + (BPF.ar(WhiteNoise.ar, 1220, 0.3) * Env.perc(0.02, 0.02).ar * -10.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 3420, 0.3) * Env.perc(0.001, 0.03).ar * -20.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity * 0.5));
    snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 6.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
    snd = BLowShelf.ar(snd, 100, 0.3, 3);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.01 * (2 - velocity), 0.4 * velocity).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -30.dbamp, 20, 1);
	snd = snd * -8.dbamp;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -25.dbamp);
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\kick2, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\808, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(50);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(Env.perc(0, 0.14, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 200)) * XLine.ar(1.05, 1, 0.2));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.3, curve: -4).ar;
	snd = LPF.ar(snd, XLine.ar(200, 100, 0.2));
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
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\hat, {
    var snd, velocity;
    velocity = \velocity.kr(1);
    snd = { WhiteNoise.ar } ! 4;
    snd = CombC.ar(snd, 0.1, 1 / [159, 474, 392, 723], 2.0);
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [305, 234, 199, 923] * 1.2);
    snd = snd.sum;
    snd = HPF.ar(snd, 6000);
    snd = HPF.ar(snd, 6000);
    snd = LPF.ar(snd, 12300);
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.001, 0.12).ar;
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -12.dbamp;
    snd = snd ! 2;
    Out.ar(\out.kr(0), snd);
}).add;
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
SynthDef(\hat2b, {
    var snd, velocity;
    velocity = \velocity.kr(1);
	snd = Hasher.ar(Sweep.ar(Impulse.ar(210))) + Hasher.ar(Sweep.ar + (0..3));
    snd = CombC.ar(snd, 0.1, 1 / [259, 374, 492, 823], 1.0);
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [205, 134, 299, 423] * 2);
    snd = snd.sum;
    snd = snd + PinkNoise.ar;
	snd = HPF.ar(snd, 8000);
    snd = HPF.ar(snd, 8000);
    snd = LPF.ar(snd, XLine.ar(12e3, 1000, 0.2));
    snd = snd * velocity.sqrt;
    snd = snd * Env.perc(0.01, 0.12).ar;
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    snd = snd * -12.dbamp;
    snd = snd ! 2;
    Out.ar(\out.kr(0), snd);
}).add;
)


(
SynthDef(\hat3, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(230))) + Hasher.ar(Sweep.ar + 1);
	snd = BPF.ar(snd, [7220, 9230], 0.5);
	snd = snd.sum;
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.perc(0.001, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.2, 1 / 60, 0.2);
	snd = FreqShift.ar(snd, -34);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.8, 1.3, 0.06), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.01, 0.1, curve: 3).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)






Synth(\hat);
Synth(\hat3);
Synth(\hatSoft);
Synth(\hat2b);

Synth(\hat2);






(
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = (BPF.ar(snd, [1223, 1500], 0.3) * [22, 12].dbamp).sum;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.015, 0.001, 0.015, 0.001, 0.07] * 0.8, curve: -8).ar;
	snd = snd.clip2;
	snd = snd * (1 + (Env.perc(0, 0.1).ar));
	snd = snd + GVerb.ar(snd * -20.dbamp, 30, 3);
	snd = BHiShelf.ar(snd, 2300, 0.3, -3);
	snd = snd * Env.linen(0.0, 0.5, 0.9, curve: -4).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\pitch, {
    var snd, freq, mult;
	freq = \freq.kr(440);
	mult = \mult.kr(30);
    snd = SinOsc.ar(Env.perc(0, 0.12).ar.linexp(0, 1, freq, freq * mult));
    snd = snd + GVerb.ar(snd * -35.dbamp, 20, 1);
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -35.dbamp); // slapback
    snd = snd * Env.linen(0.001, 0.12, 0.01).ar(Done.freeSelf);
	snd = snd * -16.dbamp * \amp.kr(1.0);
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
    snd = snd * (1 + (SinOsc.ar(110) * Env.perc(0, 0.03).ar * velocity));
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
    snd = snd + GVerb.ar(snd * -22.dbamp, 20, 1);
	snd = snd * -4.dbamp;
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
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
    snd = snd * (1 + (SinOsc.ar(110) * Env.perc(0, 0.03).ar * velocity));
    snd = snd * (1 + (SinOsc.ar(220) * Env.perc(0, 0.09).ar * -5.dbamp));
    snd = snd * (1 + (SinOsc.ar(420) * Env.perc(0, 0.01).ar * -5.dbamp));
    snd = snd + (SinOsc.ar(930 * XLine.ar(1.5, 1, 0.01)) * Env.perc(0, 0.01).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 3420, 0.3) * Env.perc(0.01, 0.03).ar * 2.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 1620, 0.3) * Env.perc(0.01, 0.05, curve: \sin).ar * 4.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 720, 0.3) * Env.perc(0.01, 0.03).ar * 3.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 820, 0.3) * Env.perc(0.005, 0.01).ar * -2.dbamp);
    snd = snd * (1 + (Env.perc(0, 0.1).ar * velocity));
    snd = snd.tanh;
    snd = snd * velocity.sqrt;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = snd * Env.perc(0.01, 0.2).ar(Done.freeSelf);
    snd = snd + GVerb.ar(snd * -22.dbamp, 50, 1);
	snd = snd * -6.dbamp;
    snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)




//////////////////////////////////////////////////////////////


(
var s, beat, tatum, bar, noteToFreq, play;
s = Server.default;
beat = 60 / 118;
tatum = beat / 4;
bar = beat * 4;
noteToFreq = { |note, octave = 0|
    (61 + note + (octave * 12)).midicps;
};
play = { |synthDef, duration, args = #[]|
	s.bind {
		Synth(synthDef, [duration: duration] ++ args);
	};
	duration.wait;
};
Routine({

	/*s.bind {
        Synth(\crackles);
        Synth(\rain);
    };*/

	loop {

		fork {
			(0 + [0-12, 3, 7-12, 10, 14]).sort.postln.do { |int|
				fork {
					play.(\key, bar * 2, [freq: noteToFreq.(int, 0)]);
				};
			};
			fork {
				(beat).wait;
				play.(\key, beat, [freq: noteToFreq.(7, 1)]);
				play.(\key, beat/2, [freq: noteToFreq.(10, 0)]);
				play.(\key, beat/2, [freq: noteToFreq.(2, 0)]);
				play.(\key, beat/2, [freq: noteToFreq.(3, 1)]);
				play.(\key, beat, [freq: noteToFreq.(7, 0)]);
				play.(\key, beat, [freq: noteToFreq.(3, 1)]);
				play.(\key, beat/2, [freq: noteToFreq.(10, 0)]);
				play.(\key, beat/2, [freq: noteToFreq.(2, 0)]);
				play.(\key, beat * 2, [freq: noteToFreq.(10, -1)]);
			};
			(bar * 2).wait;
			(5 + [0-12, 3-12, 7, 10, 14-12]).sort.postln.do { |int|
				fork {
					play.(\key, bar * 2, [freq: noteToFreq.(int, 0)]);
				};
			};
			fork {
				(beat).wait;
				play.(\key, beat, [freq: noteToFreq.(5+7, -1)]);
				play.(\key, beat/2, [freq: noteToFreq.(5+2, 0)]);
				play.(\key, beat/2, [freq: noteToFreq.(5+7, 0)]);
				play.(\key, beat, [freq: noteToFreq.(5+7, -1)]);
				(beat).wait;
				play.(\key, beat, [freq: noteToFreq.(5+7, -1)]);
				play.(\key, beat/2, [freq: noteToFreq.(5+2, 0)]);
				play.(\key, beat, [freq: noteToFreq.(5+7, 0)]);
			};
			(bar * 2).wait;
		};

		fork {
			8.do {
				beat.wait;
				play.(\clap, beat);
			};
		};

		// 4x bar
		1.do {
			// bar
			play.(\808, beat, [freq: noteToFreq.(0, -3)]);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\hatSoft, tatum);
			play.(\hat2b, tatum);
			play.(\snare, tatum * 2);
			play.(\hat, tatum);
			play.(\hatSoft, tatum);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\kick, tatum * 2);
			// bar
			play.(\kick, tatum * 1);
			play.(\kick, tatum * 3, [velocity: 0.8]);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\kick, tatum, [velocity: 0.8]);
			play.(\hat2b, tatum);
			play.(\snare, tatum * 2);
			play.(\hatSoft, tatum);
			play.(\hat2b, tatum);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\snare2, tatum * 2);
			// bar
			play.(\kick, tatum * 1);
			play.(\kick, tatum * 3, [velocity: 0.8]);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\hatSoft, tatum);
			play.(\hat2b, tatum);
			play.(\snare, tatum * 2);
			play.(\hat, tatum);
			play.(\hatSoft, tatum);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\kick, tatum * 2, [velocity: 0.8]);
			// bar
			play.(\kick, tatum * 1);
			play.(\kick, tatum * 3, [velocity: 0.8]);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\808, tatum * 2, [freq: noteToFreq.(5, -3)]);
			play.(\snare, tatum * 2);
			fork {
				play.(\pitch, tatum, [freq: noteToFreq.(0, 0), amp: 0.1]);
				play.(\pitch, tatum * 2, [freq: noteToFreq.(2, 0), amp: 0.2]);
				play.(\pitch, tatum, [freq: noteToFreq.(3, 0), amp: 0.3]);
				play.(\pitch, tatum * 2, [freq: noteToFreq.(5, 0), amp: 0.7]);
			};
			play.(\hat2b, tatum);
			play.(\hatSoft, tatum);
			play.(\hat, tatum);
			play.(\hat3, tatum);
			play.(\snare2, tatum * 2);

		};

	};
}).play
)








(
SynthDef(\key, {
	var snd, freq, duration;
	duration = \duration.kr(1.0);
	freq = \freq.kr(440) * XLine.ar(1.3, 1, 0.005) * XLine.ar(0.015.midiratio, 1, 3.0);
	freq = freq * (SinOsc.ar(30, mul: 0.1).midiratio);
	snd = SinOsc.ar(freq * [8, 16]) * Env.perc(0.001, [0.2, 0.03]).ar * [0.1, 0.2];
	snd = SinOsc.ar(freq, snd.sum);
	snd = snd * Env.perc(0.003, 10.0).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.001, 0.01).ar * 1.5.dbamp);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 4.dbamp).tanh * -2.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = snd * Line.kr(1, 0.8, duration);
	snd = snd * Env.linen(0.01, duration, 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * SinOsc.ar(Rand(0.5, 1), Rand(0, pi) + [0, pi]).linlin(-1, 1, 0.3, 1);
	snd = snd * -25.dbamp;
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
    snd = snd * -25.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;
)









// s.makeWindow;



// endfile...