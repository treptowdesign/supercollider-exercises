///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)

// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

///////////////////////////////////////////////////////////////
// SynthDefs
///////////////////////////////////////////////////////////////

(
SynthDef(\fmTemp, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-15),
    cRatio=1,
    mRatio=8, mIdx=1, mIdxScale=3,
	mRatio2=3, mIdx2=1, mIdxScale2=4;
    var snd, env, dur, car, mod, mFreq, mIdxEnv;
	dur = atk + rel;
	// MODULATOR2
    mIdxEnv = Env.new([mIdx2, (mIdx2 * mIdxScale2), mIdx2], [dur * 0.01, dur * 0.99], [6, -6]).kr;
	mFreq = freq * mRatio2;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.01, dur * 0.99], [2, -2]).kr;
	mFreq = freq * mRatio + mod;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX & AMP
	snd = car;
	snd = HPF.ar(snd, freq);
	snd = LPF.ar(snd, 3000);
	snd = (snd * 3.dbamp).tanh;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\fmTemp, [freq: 42.midicps, rel: 2]);

Synth(\fmTemp, [freq: 42.midicps, rel: 2, mRatio: 2, mIdx: 0.13, mIdxScale: 42]);

Synth(\fmTemp, [freq: 24.midicps, rel: 2]);
Synth(\fmTemp, [freq: 44.midicps, rel: 2, mRatio: 2, mIdx: 0.105, mIdxScale: 12]);



Scale.aeolian.degrees;

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 40;
scale = Scale.phrygian.degrees;
Routine({
	var pattern, note, octave, dur;
	pattern = [0, 5, 4, 1, 0, 0, 1, 1];
	dur = beat/2;
	loop {
		pattern.do { | d |
			note = (root + scale[d] + (12 * -1)).midicps;
			Synth(\fmTemp, [freq: note, rel: dur * 2]);
			dur.wait;
		};
	};
}).play;
)





///////////////////////////////////////////////////////////////
// Subtle
///////////////////////////////////////////////////////////////
(
SynthDef(\subtle, {
    arg freq=440, atk=0.01, rel=1.2, pan=0, lvl=(-15),
    cRatio=2,
    mRatio=4, mIdx=0.16, mIdxScale=17,
	mRatio2=3, mIdx2=0.07, mIdxScale2=28;
    var snd, env, dur, car, mod, mFreq, mIdxEnv;
	dur = atk + rel;
	// MODULATOR2
    mIdxEnv = Env.new([mIdx2, (mIdx2 * mIdxScale2), mIdx2], [dur * 0.01, dur * 0.99], [-3, 4]).kr;
	mFreq = freq * mRatio2;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.01, dur * 0.99], [2, -2]).kr;
	mFreq = freq * mRatio + mod;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX & AMP
	snd = car;
	// snd = HPF.ar(snd, freq);
	// snd = LPF.ar(snd, 3000);
	// snd = (snd * 3.dbamp).tanh;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\subtle, [freq: 42.midicps, rel: 0.6]);


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 40;
scale = Scale.phrygian.degrees;
Routine({
	var note, dur;
	dur = beat / 2;
	loop {
		note = (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps;
		Synth(\subtle, [freq: note, rel: dur]);
		dur.wait;
	};
}).play;
)


///////////////////////////////////////////////////////////////
// Subtle
///////////////////////////////////////////////////////////////
(
SynthDef(\mod3, {
    arg freq=440, atk=0.01, rel=1.2, pan=0, lvl=(-15),
    cRatio=2,
    mRatio=5, mIdx=0.26, mIdxScale=17,
	mRatio2=3, mIdx2=0.07, mIdxScale2=24,
	mRatio3=4, mIdx3=0.12, mIdxScale3=32;
    var snd, env, dur, car, mod, mFreq, mIdxEnv, mod2, mFreq2, mIdxEnv2, mod3, mFreq3, mIdxEnv3;
	dur = atk + rel;
	// MOD2 => MOD1
    mIdxEnv2 = Env.new([mIdx2, (mIdx2 * mIdxScale2), mIdx2], [dur * 0.7, dur * 0.3], [-2, 4]).kr;
	mFreq2 = freq * mRatio2;
	mod2 = SinOsc.ar(mFreq2, mul: mFreq2 * mIdxEnv2);
    // MOD1 => CARRIER
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.01, dur * 0.99], [2, -2]).kr;
	mFreq = freq * mRatio + mod2;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
	// MOD3 => CARRIER
    mIdxEnv3 = Env.new([mIdx3, (mIdx3 * mIdxScale3), mIdx3], [dur * 0.2, dur * 0.8], [-6, 4]).kr;
	mFreq3 = freq * mRatio3;
	mod3 = SinOsc.ar(mFreq3, mul: mFreq3 * mIdxEnv3);
    // CARRIER
	car = SinOsc.ar((freq * cRatio) + mod + mod3);
	// FX & AMP
	snd = car;
	snd = (snd + SinOsc.ar(freq)) * -5.dbamp;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\mod3, [freq: 42.midicps, rel: 3]);


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 40;
scale = Scale.phrygian.degrees;
Routine({
	var note, dur;
	dur = beat / 2;
	loop {
		note = (root + scale.choose + (12 * [0, 1, 2].choose)).midicps;
		Synth(\mod3, [freq: note, rel: dur * 2]);
		dur.wait;
	};
}).play;
)







// end...