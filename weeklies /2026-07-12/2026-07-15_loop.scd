///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
// Synths
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////


(
SynthDef(\lead, {
    var snd, gate, freq, fb, timbreEnv;
    gate = \gate.kr(1);
    freq = \freq.kr(440).cpsmidi.lag(\lag.kr(0.01)).midicps;
    freq = freq * (SinOsc.ar(4.34) * 0.02).midiratio * (SinOsc.ar(0.5) * 0.1).midiratio;
    timbreEnv = Env.asr(3.0, 1.0, 1.0, curve: -4).ar(gate: gate);
    snd = SinOsc.ar(freq * [1, 0.5]) * timbreEnv * SinOsc.ar(0.1, [0, pi]).linexp(-1, 1, 4, 7);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * [0, -12].dbamp;
    snd = snd.sum;
    snd = snd * -20.dbamp;
    snd = snd * Env.perc(0.01, 6.0, curve: -4).ar;
    snd = LPF.ar(snd, 1500);
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, 1.0, [0.45, 0.35] + (SinOsc.ar(0.5, [0, pi]) * 1e-3));
    fb = LPF.ar(fb, 2000);
    fb = HPF.ar(fb, 100);
    fb = fb * -2.dbamp;
    LocalOut.ar(fb);
    snd = snd + fb;
	snd = snd * 4.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.01, \duration.kr(3), 0.1).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\bassGuitar, {
    var snd, freq, trigger, env;
    freq = \freq.kr(60).cpsmidi.lag(0.05).midicps;
	trigger = Impulse.kr(0);
	env = Env.perc(0.01, \rel.kr(1), curve: \curve.kr(-4)).ar * Env.linen(0.01, \duration.kr(3), 0.01).ar(Done.freeSelf);
    snd = Pluck.ar(
        SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 92, 300)),
        trigger, 0.1, 1 / freq, 10.0, 0.3
    );
    snd = LPF.ar(snd, 500) * 4.dbamp;
    snd = LeakDC.ar(snd);
	snd = snd + (snd.tanh * -8.dbamp);
    snd = snd * -8.dbamp ! 2;
	snd = BLowShelf.ar(snd, 200, 0.3, 2);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * env;
    Out.ar(\out.kr(0), snd);
}).add;
)

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
	snd = snd * -6.dbamp * \amp.kr(1);
    snd = snd * Env.linen(0.001, \duration.kr(0.3), 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\kick_new, {
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
    snd = snd * -6.dbamp * \amp.kr(1);
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
    snd = snd * -6.dbamp;
    snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.05, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
    var snd, fx;
    snd = Pulse.ar(40 * [1, 2.34, 3.55, 6.28]);
    snd = snd.sum;
    snd = HPF.ar(snd, 7e3);
    snd = BPF.ar(snd, 12e3) * 6.dbamp;
    snd = snd * Env.perc(0.01, 0.06).ar;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
    snd = snd * -1.dbamp;
    snd = snd * Env.linen(0.001, \duration.kr(0.3), 0.03, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\clank, {
    var snd, ratio, duration;
    duration = \duration.kr(1);
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(780 * [1, 1.3] * Line.kr(0.9, 1.1, duration), SinOsc.ar([98, 250] * ratio) % 2pi).sum;
    snd = snd * Env.perc(0.001, 0.1).ar;
    snd = snd * -3.dbamp;
	snd = Latch.ar(snd, Impulse.ar(12e3));
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
    snd = snd * Env.linen(0.001, duration, 0.08, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clank2, {
    var snd, ratio, duration;
    duration = \duration.kr(1);
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(810 * [1, 1.3] * Line.kr(0.9, 1.2, duration), SinOsc.ar([398, 150] * ratio) % 2pi).sum;
    snd = snd * Env.perc(0.001, 0.1).ar;
    snd = snd * -10.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
    snd = snd * Env.linen(0.001, duration, 0.1, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\crash, {
    var snd, duration;
    duration = \duration.kr(3.0);
    snd = Hasher.ar(Sweep.ar) ! 10;
    snd = CombC.ar(snd, 0.1, 1 / (0..snd.size - 1).normalize.linexp(0, 1, 100, 200), 0.1);
    snd = LeakDC.ar(snd);
    snd = BPF.ar(snd, (0..snd.size - 1).normalize.pow(1.5).linexp(0, 1, 700, 16000), 0.1);
    snd = snd.sum;
    snd = HPF.ar(snd, 2500);
    snd = CombC.ar(snd, 0.3, 1 / 180, 0.2);
    snd = FreqShift.ar(snd, 41);
    snd = snd * Env.perc(0.001, 1.5).ar;
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7240, 0.5) * Env.perc(0.001, 0.3).ar);
    snd = snd + GVerb.ar(snd, 60, 6);
    snd = snd * -24.dbamp;
    snd = snd * Env.linen(0.0, duration * 1.4, 0.05, curve: -4).ar(Done.freeSelf);
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
SynthDef(\laser, {
    var snd, fx, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(LFSaw.ar(25, 1).linlin(-1, 1, 1, 0).pow(8).linexp(0, 1, 200, 6000));
    snd = snd * Env.linen(0.001, duration / 2, 0.02, curve: -4).ar;
    snd = LPF.ar(snd, XLine.ar(16e3, 100, duration / 2));
    snd = snd * -5.dbamp;
	snd = snd * SinOsc.ar(ZeroCrossing.ar(snd).lag(0.01)) * 4.dbamp;
    snd = Pan2.ar(snd, \pan.kr(0));
    snd = snd * Env.linen(0.001, duration * 2, 0.03, curve: -4).ar(Done.freeSelf);
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
SynthDef(\fsSqr, {
	var snd, freq, env, lfo;
	freq = \freq.kr(60);
	env = Env.perc(\atk.kr(0.01), \rel.kr(3)).ar * Env.linen(0.01, \duration.kr(3), 0.01).ar(Done.freeSelf);
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
	snd = SinOsc.ar(freq * 2) * 0.2;
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 9.dbamp;
	snd = (snd * 0.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -8.dbamp ! 2;
	snd = snd * (1 + Env.perc(0.001, 0.02).ar);
    snd = snd * Env.linen(atk, sus, rel, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub2, {
    var snd, freq, duration, atk, rel, sus;
    duration = \duration.kr(1);
	atk = 0.01;
	rel = 0.1;
	sus = duration - (atk + rel);
    freq = \freq.kr(60);
	snd = SinOsc.ar(freq * 2) * 0.6;
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 9.dbamp;
	snd = (snd * 4.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -8.dbamp ! 2;
	snd = snd * (1 + Env.perc(0.001, 0.02).ar);
    snd = snd * Env.linen(atk, sus, rel, curve: -4).ar(Done.freeSelf);
    Out.ar(\out.kr(0), snd);
}).add;
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
    snd = snd + CombC.ar(snd * -5.dbamp, 0.05, 1 / ExpRand(30 ! n, 90), -0.2);
    snd = Splay.ar(snd, 0.7);
    snd = snd * Env.perc(0.01, 0.4).ar(gate: trigger);
    snd = snd * (1 + Env.perc(0.001, 0.01).ar(gate: trigger));
    snd = RLPF.ar(
        snd,
        Env.perc(0.01, 0.3, curve: -8).ar(gate: trigger).linexp(0, 1, 600, 4500)
        * SinOsc.ar(0.23).linexp(-1, 1, 0.5, 2),
        0.6
    );
    snd = snd * 3.dbamp;
    snd = BHiShelf.ar(snd, 1200, 0.3, -4);
    snd = BLowShelf.ar(snd, 200, 0.3, -5);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -18.dbamp;
    snd = snd * Env.perc(0, 2.0, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).play;
)


///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
// Routine
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

(
var s, bpm, beat, tatum, bar, root, noteHz, play;
s = Server.default;
bpm = 93;
beat = 60 / bpm;
tatum = beat / 4;
bar = beat * 4;
root = 58;

noteHz = { |int=0, oct=0|
	(root + int + (12 * oct)).midicps;
};

play = { |synth, duration, args = #[]|
	s.bind {
		Synth(synth, [duration: duration] ++ args);
	};
	(duration).wait;
};

Routine({
	loop {
		// kick + snare + percs
		fork {
			1.do {
				play.(\kick, tatum * 2);
				play.(\kick, tatum * 2, [amp: 0.6]);
				play.(\clank, tatum * 1, [amp: 0.7, ratio: 0.5]);
				play.(\clank, tatum * 1, [amp: 0.3, ratio: 1.5]);
				play.(\kick, tatum * 2, [amp: 0.4]);
				play.(\snare, tatum * 2);
				play.(\clank, tatum * 2, [amp: 0.7, ratio: 1]);
				play.(\clank, tatum * 1, [amp: 0.7, ratio: 0.5]);
				play.(\clank, tatum * 1, [amp: 0.3, ratio: 1.5]);
				play.(\kick, tatum * 2, [amp: 0.75]);

				play.(\kick, tatum * 2);
				play.(\clank, tatum * 1, [amp: 0.3, ratio: 0.5]);
				play.(\clank, tatum * 1, [amp: 0.2, ratio: 3.5]);
				play.(\clank, tatum * 2, [amp: 0.7, ratio: 2]);
				play.(\kick, tatum * 2, [amp: 0.4]);
				play.(\snare, tatum * 2);
				play.(\clank, tatum * 2, [amp: 0.6, ratio: 1.5]);
				play.(\crash, tatum * 2);
				play.(\kick, tatum * 2, [amp: 0.75]);

				play.(\kick, tatum * 2);
				play.(\kick, tatum * 2, [amp: 0.6]);
				play.(\clank, tatum * 1, [amp: 0.7, ratio: 0.5]);
				play.(\clank, tatum * 1, [amp: 0.3, ratio: 1.5]);
				play.(\kick, tatum * 2, [amp: 0.4]);
				play.(\snare, tatum * 2);
				play.(\clank, tatum * 2, [amp: 0.7, ratio: 1]);
				play.(\clank, tatum * 1, [amp: 0.7, ratio: 0.5]);
				play.(\clank, tatum * 1, [amp: 0.3, ratio: 1.5]);
				play.(\kick, tatum * 2, [amp: 0.75]);

				play.(\kick, tatum * 2);
				play.(\kick, tatum * 2, [amp: 0.6]);
				play.(\clank, tatum * 1, [amp: 0.7, ratio: 0.5]);
				play.(\clank, tatum * 1, [amp: 0.3, ratio: 1.5]);
				play.(\kick, tatum * 2, [amp: 0.4]);
				play.(\snare, tatum * 2);
				play.(\clank, tatum * 2, [amp: 0.7, ratio: 1]);
				play.(\crash, tatum * 2);
				play.(\kick, tatum * 2, [amp: 0.75]);
			};
		};
		// hats
		fork {
			2.do {
				7.do {
					4.do { |index|
						play.(\hat, tatum, [amp: index.linlin(0, 3, 0.25, 1.25)]);
					};
				};
				1.do {
					2.do { |index|
						play.(\hat, tatum/2, [amp: 0.25]);
						play.(\hat, tatum/2, [amp: 0.75]);
						play.(\hat, tatum/2, [amp: 0.5]);
						play.(\hat, tatum/2, [amp: 1.25]);
					};
				};
			};
		};
		// chords
		fork {
			var chordsA = [
				(0 + [0, 2, 7, 10]),
				(-2 + [0, 3, 7, 10]),
			];
			var chordsB = [
				(0 + [0, 2, 7, 10]),
				(5 + [0, 3, 7-12, 10-12]),
			];
			[chordsA, chordsB].do { |chords|
				chords.do { |chord|
					chord.do { |int|
						fork { play.(\lead, bar, [freq: noteHz.(int, 2), amp: 0.4]); };
						fork { play.(\lead, bar, [freq: noteHz.(int, -1), amp: 0.4]); };
					};
					(bar).wait;
				};
			};
		};
		// arp
		fork {
			(tatum * 32).wait;
			1.do {
				8.do {
					(0 + [0, 2, 7, 10]).reverse.do { |int|
						play.(\arp, tatum/2, [freq: noteHz.(int, 1), curve: -4]);
					};
				};
				8.do {
					(-2 + [0, 3, 7, 10]).do { |int|
						play.(\arp, tatum/2, [freq: noteHz.(int, 1), curve: -4]);
					};
				};
			};
		};
		// bass
		2.do {
			[
				// 16 tatums / 1 Bar
				[2, 2, -4],
				[10-12, 3, -4],
				[7-12, 3, -4],
				[7-12, 8, -4],
				// 16 tatums / 1 Bar
				[5-12, 2, -4],
				[5-12, 1, -4],
				[5-12, 1, -4],
				[5-12, 1, -4],
				[5-12, 2, -4],
				[8-12, 1, -4],
				[10-12, 2, -4],
				[5-12, 2, -4],
				[10-12, 4, -4],
			].do { |spec|
				var int, dur, curve;
				# int, dur, curve = spec;
				play.(\sub, dur * tatum, [freq: noteHz.(int, -2), curve: -4]);
				// (dur * tatum).wait;
			};
		};
	};

}).play;
)




2.pow(2);
[32, 16, 8, 4];


///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
// Endfile
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////