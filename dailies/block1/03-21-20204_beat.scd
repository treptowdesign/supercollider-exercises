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
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		59
		* (1 + (3 * Env.perc(0.0, 0.3, curve: -10).ar))
		* (1 + (2 * Env.perc(0.0, 0.03, curve: -8).ar))
		* [1, 2.4, 1.4]
	);
	snd = snd * (Env.perc(0, [3.0, 0.2, 0.1]).ar);
	snd = (snd * [0, -10, -15].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = (snd * 12.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.25).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		319
		* (1 + (0.5 * Env.perc(0.0, 0.06, curve: -9).ar))
		* (1 + (0.3 * Env.perc(0.0, 0.01, curve: -4).ar))
		* [0.56, 1, 2.3, 3.4]
	);
	snd = snd * (Env.perc(0, [0.3, 3.0, 0.2, 0.1]).ar);
	snd = (snd * [-5, 0, -5, -3].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), [2420, 5420, 8329], 0.6)
		* Env.perc(0.05, 0.2).ar * [5, 0, -8].dbamp).sum;
	snd = (snd * 10.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.12, curve: -1).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
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
SynthDef(\bass, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-13),
    cRatio=2,
    mRatio=3, mIdx=1, mIdxScale=2.5,
	mRatio2=4, mIdx2=1, mIdxScale2=1.25;
    var snd, env, dur, car, mod, mFreq, mIdxEnv;
	dur = atk + rel;
	// MODULATOR2
    mIdxEnv = Env.new([mIdx2, (mIdx2 * mIdxScale2), mIdx2], [dur * 0.01, dur * 0.99], [-8, 8]).kr;
	mFreq = freq * mRatio2;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // MODULATOR
    mIdxEnv = Env.new([mIdx, (mIdx * mIdxScale), mIdx], [dur * 0.01, dur * 0.99], [4, -4]).kr;
	mFreq = freq * mRatio + mod;
	mod = SinOsc.ar(mFreq, mul: mFreq * mIdxEnv);
    // CARRIER
    car = SinOsc.ar(freq * cRatio + mod);
	// FX & AMP
	snd = car;
	// snd = HPF.ar(snd, freq/2);
	snd = LPF.ar(snd, 786);
	snd = (snd * 12.dbamp).tanh;
    env = Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd * env, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
SynthDef(\arp, {
    arg freq=440, atk=0.1, rel=1.2, pan=0, lvl=(-20);
    var snd, dur;
	dur = atk + rel;
	snd = Pulse.ar(freq);
    snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd, pan, lvl.dbamp);
    Out.ar(0, snd);
}).add;
)

Synth(\kick);
Synth(\bass, [freq: 28.midicps]);


(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 40;
scale = Scale.phrygian.degrees;
Routine({
	var idx;
	idx = 1;
	loop {
		"xxx.-.x. x.x.-..x xxx.-.x. x.x.--.-".do{ |char|
			switch(char)
			{$x} {
				s.bind { Synth(\kick); };
				(beat/4).wait;
			}
			{$-} {
				s.bind { Synth(\snare); };
				(beat/4).wait;
			}
			{$.} {
				(beat/4).wait;
			};
			idx.postln; idx = (idx % 4) + 1;
		};
	};
}).play;
Routine({
	var idx;
	idx = 1;
	loop {
		s.bind { Synth(\hat, [amp: -16.dbamp]); };
		(beat/4).wait;
		idx = (idx % 4) + 1;
	};
}).play;
Routine({
	var pattern, note, octave, dur;
	pattern = [0, 5, 4, 1, 0, 0, 1, 1];
	dur = beat/2;
	loop {
		pattern.do { | d |
			note = (root + scale[d] + (12 * -1)).midicps;
			s.bind { Synth(\bass, [freq: note, rel: dur * 1.5]); };
			dur.wait;
		};
	};
}).play;
Routine({
	var pattern, note, octave, dur;
	pattern = [5, 4, 1, 0];
	dur = beat / 4;
	loop {
		pattern.do { | d |
			note = (root + scale[d] + (12 * 3)).midicps;
			s.bind { Synth(\arp, [freq: note, rel: dur]); };
			dur.wait;
		};
	};
}).play;
)
















///////////////////////////////////////////////////////////////
// end...
///////////////////////////////////////////////////////////////
