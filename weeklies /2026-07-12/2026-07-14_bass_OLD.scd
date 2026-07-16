

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