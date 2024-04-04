(
SynthDef(\fmSynth3, {
    arg freq=440, atk=0.25, rel=1.2, pan=0, lvl=(-10),
    cRatio=1,
    mRatio=2, mIdx=0.15, mIdxScale=36,
    m2Ratio=5, m2Idx=0.75, m2IdxScale=25;
    var snd, env, car, mod, mIdxEnv, mod2, m2IdxEnv;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [(atk + rel) * 0.5, (atk + rel) * 0.5], [-4, -4]).kr;
    mod = SinOsc.ar(freq * mRatio, mul: freq * mRatio * mIdxEnv);
    // MODULATOR 2
    m2IdxEnv = Env.new([m2Idx, (m2Idx * m2IdxScale), m2Idx], [(atk + rel) * 0.75, (atk + rel) * 0.25], [-2, 2]).kr;
    mod2 = SinOsc.ar(freq * m2Ratio, mul: freq * m2Ratio * m2IdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod + mod2);
    // AMP
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(car * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmSynth3, [freq: 38.midicps]);

(
SynthDef(\fmSynth4, {
    arg freq=440, atk=0.25, rel=1.2, pan=0, lvl=(-10),
    cRatio=2,
    mRatio=3, mIdx=0.05, mIdxScale=33,
    m2Ratio=7, m2Idx=0.13, m2IdxScale=17;
    var snd, env, car, mod, mIdxEnv, mod2, m2IdxEnv;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [(atk + rel) * 0.5, (atk + rel) * 0.5], [-4, -4]).kr;
    mod = SinOsc.ar(freq * mRatio, mul: freq * mRatio * mIdxEnv);
    // MODULATOR 2
    m2IdxEnv = Env.new([m2Idx, (m2Idx * m2IdxScale), m2Idx], [(atk + rel) * 0.75, (atk + rel) * 0.25], [-2, 2]).kr;
    mod2 = SinOsc.ar(freq * m2Ratio, mul: freq * m2Ratio * m2IdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod + mod2);
    // AMP
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(car * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmSynth4, [freq: 50.midicps]);


(
SynthDef(\fmSynth5, {
    arg freq=440, atk=0.01, rel=0.6, pan=0, lvl=(-10),
    cRatio=7,
    mRatio=1, mIdx=0.045, mIdxScale=51,
    m2Ratio=4, m2Idx=0.103, m2IdxScale=32;
    var snd, env, car, mod, mIdxEnv, mod2, m2IdxEnv;
    // MODULATOR
    mIdxEnv = Env.new([(mIdx * mIdxScale), mIdx, (mIdx * mIdxScale)], [(atk + rel) * 0.6, (atk + rel) * 0.4], [-2, -6]).kr;
    mod = SinOsc.ar(freq * mRatio, mul: freq * mRatio * mIdxEnv);
    // MODULATOR 2
    m2IdxEnv = Env.new([m2Idx, (m2Idx * m2IdxScale), m2Idx], [(atk + rel) * 0.7, (atk + rel) * 0.3], [4, -4]).kr;
    mod2 = SinOsc.ar(freq * m2Ratio, mul: freq * m2Ratio * m2IdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod + mod2);
    // AMP
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(car * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmSynth5, [freq: 38.midicps]);


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 140;
beat = 60 / bpm;
root = 38;
scale = Scale.aeolian.degrees;
Routine({
	var note, dur;
	loop {
		dur = beat / [4,2,1].choose;
		note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
		s.bind { Synth(\fmSynth5, [freq: note, rel: dur * 2]); };
		dur.wait;
	};
}).play;
)



(
SynthDef(\fmSynth6, {
    arg freq=440, atk=0.01, rel=1.2, pan=0, lvl=(-10),
    cRatio=3,
    mRatio=4, mIdx=0.11, mIdxScale=13;
    var snd, env, dur, car, mod, mIdxEnv;
	dur = atk + rel;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.6, dur * 0.4], [2, -6]).kr;
    mod = SinOsc.ar(freq * mRatio, mul: freq * mRatio * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX
	snd = car;
	snd = car + (SinOsc.ar(freq) * 0.3);
	snd = (snd + (snd * 12.dbamp).tanh) * 0.4;
    // AMP
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmSynth6, [freq: 50.midicps]);

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 140;
beat = 60 / bpm;
root = 38;
scale = Scale.aeolian.degrees;
Routine({
	var note, dur;
	loop {
		dur = beat * 4;
		note = (root + scale.choose + (12 * 1)).midicps;
		// s.bind { Synth(\fmSynth6, [freq: note, atk: 0.1, rel: dur * 4, lvl: -12]); };
		// s.bind { Synth(\fmSynth7, [freq: note, atk: 0.1, rel: dur, lvl: -12]); };
		dur.wait;
	};
}).play;
Routine({
	var note, dur;
	loop {
		dur = beat / 4;
		note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
		s.bind { Synth(\fmSynth5, [freq: note, rel: dur * 2]); };
		dur.wait;
	};
}).play;
)



// --------------------
// FM Sine: 2 Mod Stacked, 2nd is Sin LFO
// --------------------

(
SynthDef(\fmSine, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15),
    cRatio=1,
    mRatio=7, mIdx=0.08, mIdxScale=48,
	mRatio2=4, mIdx2=0.17, mIdxScale2=31;
    var snd, env, dur, car, mod, mIdxEnv, mod2, mIdxEnv2;
	dur = atk + rel;
	// MODULATOR 2
	mIdxEnv2 = Saw.kr(XLine.kr(dur * 16, dur/2, dur)).range(mIdx2, (mIdx2 * mIdxScale2));
    mod2 = SinOsc.ar(freq * mRatio2, mul: freq * mRatio2 * mIdxEnv2);
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.7, dur * 0.3], [-2, 4]).kr;
	mod = SinOsc.ar(freq * mRatio + mod2, mul: (freq * mRatio + mod2) * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX
	snd = car;
	// snd = car + (SinOsc.ar(freq) * 0.3);
	// snd = (snd + (snd * 10.dbamp).tanh) * 0.4;
    // AMP
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmSine, [freq: 42.midicps]);


// --------------------
// Basic Temp
// --------------------

(
SynthDef(\fmTemp, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15),
    cRatio=1,
    mRatio=4, mIdx=1, mIdxScale=7;
    var snd, env, dur, car, mod, mFreq, mIdxEnv;
	dur = atk + rel;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.5, dur * 0.5], [-2, 2]).kr;
	mFreq = freq * mRatio;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX & AMP
	snd = car;
	// snd = car + (SinOsc.ar(freq) * 0.3);
	// snd = (snd + (snd * 10.dbamp).tanh) * 0.4;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmTemp, [freq: 50.midicps]);

(
SynthDef(\fmTemp2, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15),
    cRatio=2,
    mRatio=3, mIdx=1, mIdxScale=5;
    var snd, env, dur, car, mod, mFreq, mIdxEnv;
	dur = atk + rel;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.5, dur * 0.5], [-2, 2]).kr;
	mFreq = freq * mRatio;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX & AMP
	snd = car;
	// snd = car + (SinOsc.ar(freq) * 0.3);
	// snd = (snd + (snd * 10.dbamp).tanh) * 0.4;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmTemp2, [freq: 50.midicps]);




// --------------------
// 2Car 3Mod...
// --------------------

(
SynthDef(\car2mod3, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15),
    cRatio=1,
    mRatio=3, mIdx=1, mIdxScale=9,
	cRatio2=3,
	mRatio2=4, mIdx2=1, mIdxScale2=7;
    var snd, env, dur, car, mod, mFreq, mIdxEnv,
	car2, mod2, mFreq2, mIdxEnv2;
	dur = atk + rel;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.5, dur * 0.5], [-2, 2]).kr;
	mFreq = freq * mRatio;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
	// MODULATOR2
    mIdxEnv2 = Env.new([mIdx2, (mIdx2 * mIdxScale2), mIdx2], [dur * 0.3, dur * 0.7], [-2, 2]).kr;
	mFreq2 = freq * mRatio2;
	mod2 = SinOsc.ar(mFreq2, mul: mFreq2 * mIdxEnv2);
    // CARRIERs
    car = SinOsc.ar(freq * cRatio + mod);
	car2 = SinOsc.ar(freq * cRatio2 + mod2);
	// FX & AMP
	snd = (car * Line.kr(0, 1, dur)) + (car2 * Line.kr(1, 0, dur));
	// snd = (car + car2) * 0.5;
	snd = snd + (SinOsc.ar(freq) * 0.7);
	snd = (snd + (snd * 10.dbamp).tanh) * 0.4;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\car2mod3, [freq: 50.midicps]);
Synth(\fmSynth5, [freq: 50.midicps]);
Synth(\fmSine, [freq: 50.midicps])


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 118;
beat = 60 / bpm;
root = 41;
scale = Scale.phrygian.degrees;
Routine({
	var note, dur, inst;
	dur = beat;
	loop {
		inst = [1, 2, 3].choose;
		if(inst == 1, {
			dur = beat;
			note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
			s.bind { Synth(\car2mod3, [freq: note, rel: dur * 2]); };
			dur.wait;
		});
		if(inst == 2, {
			4.do {
				dur = beat / 4;
				note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
				s.bind { Synth(\fmSynth5, [freq: note, rel: dur * 2]); };
				dur.wait;
			};
		});
		if(inst == 3, {
			dur = beat;
			note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
			s.bind { Synth(\fmSine, [freq: note, rel: dur * 2]); };
			dur.wait;
		});
	};
}).play;
)


// --------------------
// Self Modulation
// --------------------

(
SynthDef(\fmSelf, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-10);
    var snd, env, dur, car, fb, mouse;
	dur = atk + rel;
	mouse = MouseX.kr(1, 1e4, 1);
	// CARRIER & FEEDBACK
	fb = LocalIn.ar(1);
	car = SinOsc.ar(freq + (fb * mouse));
	LocalOut.ar(car);
	// FX & AMP
	snd = car;
	snd = LeakDC.ar(snd);
    // env = Env.perc(atk, rel).ar(Done.freeSelf);
	env = 1;
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmSelf, [freq: 62.midicps]);

// end...




















// --------------------
// --------------------
// --------------------
// --------------------
// All Routine
// --------------------
// --------------------
// --------------------
// --------------------

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		69
		* (1 + (3 * Env.perc(0.0, 0.3, curve: -9).ar))
		* (1 + (3 * Env.perc(0.0, 0.03, curve: -4).ar))
		* [1, 2.3, 1.4]
	);
	snd = snd * (Env.perc(0, [3.0, 0.5, 0.1]).ar);
	snd = (snd * [0, -10, -15].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 1.0).ar(Done.freeSelf);
	snd = snd * -25.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		319
		* (1 + (0.5 * Env.perc(0.0, 0.1, curve: -9).ar))
		* (1 + (0.3 * Env.perc(0.0, 0.03, curve: -4).ar))
		* [0.56, 1, 2.3, 3.4]
	);
	snd = snd * (Env.perc(0, [0.3, 3.0, 0.2, 0.1]).ar);
	snd = (snd * [-5, 0, -5, -3].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), [2420, 5420, 8329], 0.5)
		* Env.perc(0.05, 0.2).ar * [5, 0, -8].dbamp).sum;
	snd = (snd * 8.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.12, curve: -1).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 17210, 0.25);
	snd = snd.sign;
	snd = snd * Env.linen(0.0, \rel.kr(0.02), 0.0).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

)

(
SynthDef(\car2mod3, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15),
    cRatio=1,
    mRatio=3, mIdx=1, mIdxScale=9,
	cRatio2=3,
	mRatio2=4, mIdx2=1, mIdxScale2=7;
    var snd, env, dur, car, mod, mFreq, mIdxEnv,
	car2, mod2, mFreq2, mIdxEnv2;
	dur = atk + rel;
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.5, dur * 0.5], [-2, 2]).kr;
	mFreq = freq * mRatio;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
	// MODULATOR2
    mIdxEnv2 = Env.new([mIdx2, (mIdx2 * mIdxScale2), mIdx2], [dur * 0.3, dur * 0.7], [-2, 2]).kr;
	mFreq2 = freq * mRatio2;
	mod2 = SinOsc.ar(mFreq2, mul: mFreq2 * mIdxEnv2);
    // CARRIERs
    car = SinOsc.ar(freq * cRatio + mod);
	car2 = SinOsc.ar(freq * cRatio2 + mod2);
	// FX & AMP
	snd = (car * Line.kr(0, 1, dur)) + (car2 * Line.kr(1, 0, dur));
	// snd = (car + car2) * 0.5;
	snd = snd + (SinOsc.ar(freq) * 0.5);
	snd = (snd + (snd * 10.dbamp).tanh) * 0.4;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\car2mod3, [freq: 50.midicps]);


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 118;
beat = 60 / bpm;
root = 41;
scale = Scale.phrygian.degrees;
Routine({
	var note, dur, inst;
	dur = beat;
	loop {
		inst = [1, 2, 3].choose;
		if(inst == 1, {
			dur = beat;
			note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
			s.bind { Synth(\car2mod3, [freq: note, rel: dur * 2]); };
			dur.wait;
		});
		if(inst == 2, {
			4.do {
				dur = beat / 4;
				note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
				s.bind { Synth(\fmSynth5, [freq: note, rel: dur * 2]); };
				dur.wait;
			};
		});
		if(inst == 3, {
			dur = beat / 2;
			note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
			s.bind { Synth(\fmSine, [freq: note, rel: dur * 2]); };
			dur.wait;
		});
	};
}).play;

Routine({
	var idx;
	idx = 1;
	loop {
		s.bind { Synth(\hat, [amp: -25.dbamp]); };
		(beat/4).wait;
		idx = (idx % 4) + 1;
	};
}).play;

Routine({
	var idx;
	idx = 1;
	loop {
		"x.x.-... x.x.-... xxxx-... x.x.-.x.".do{ |char|
			switch(char)
			{ $x } {
				s.bind { Synth(\kick); };
				(beat/8).wait;
			}
			{ $- } {
				s.bind { Synth(\snare); };
				(beat/8).wait;
			}
			{$.} {
				(beat/8).wait;
			};
			idx.postln; idx = (idx % 8) + 1;
		};
	};
}).play;
)






