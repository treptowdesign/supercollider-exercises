( // standard
SynthDef(\phaser, { |out=0, in=0, amp=0.2, mix=(0), delay=1e-4, fb=0|
    var snd, wet, lfo;
	snd = Pulse.ar(60);
	snd = Pan2.ar(snd, 0, amp);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay).lag(1e-4) };
	wet = snd;
	8.do { wet = AllpassL.ar(wet, 0.2, lfo.(0.2, Rand(0.0, 0.5) * pi), fb); };
	snd = XFade2.ar(snd, wet, mix);
    Out.ar(0, snd);
}).play;
)

( // standard
SynthDef(\phaser, { |out=0, in=0, amp=0.2, mix=(0), delay=1e-4, fb=0|
    var snd, wet, lfo;
	snd = Pulse.ar(60);
	snd = Pan2.ar(snd, 0, amp);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay).lag(1e-4) };
	wet = snd;
	4.do { wet = AllpassL.ar(wet, 0.2, lfo.(0.2, Rand(0.0, 0.5) * pi), fb); };
	snd = XFade2.ar(snd, wet, mix);
	4.do { wet = AllpassL.ar(wet, 0.2, lfo.(0.3, Rand(0.0, 0.5) * pi), fb); };
	snd = XFade2.ar(snd, wet, mix);
    Out.ar(0, snd);
}).play;
)

( // Mix at every stage
SynthDef(\phaser, { |out=0, in=0, amp=0.2, mix=(-0.75), delay=1e-4, fb=0|
    var snd, wet, lfo;
	snd = Pulse.ar(60);
	snd = Pan2.ar(snd, 0, amp);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay).lag(1e-4) };
	wet = snd;
	4.do {
		wet = AllpassL.ar(wet, 0.2, lfo.(0.2, 0), fb);
		snd = XFade2.ar(snd, wet, mix);
	};
    Out.ar(0, snd);
}).play;
)


( // Mix at every stage + flanger
SynthDef(\phaser, { |out=0, in=0, amp=0.2, mix=(-0.75), delay=1e-4, fb=0|
    var snd, wet, lfo;
	snd = Pulse.ar(60);
	snd = Pan2.ar(snd, 0, amp);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay).lag(1e-4) };
	wet = snd;
	4.do {
		wet = AllpassL.ar(wet, 0.02, lfo.(0.3, 0), fb);
		snd = XFade2.ar(snd, wet, mix);
	};
	snd = XFade2.ar(snd, CombC.ar(snd, 0.02, lfo.(0.5, pi), 0), -0.25);
    Out.ar(0, snd);
}).play;
)

( // standard
SynthDef(\phaser, { |out=0, in=0, amp=0.2, mix=(0), delay=1e-4, fb=0|
    var snd, wet, lfo;
	snd = Pulse.ar(60);
	snd = Pan2.ar(snd, 0, amp);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay).lag(1e-4) };
	wet = snd;
	8.do { wet = AllpassL.ar(wet, 0.2, lfo.(0.2), fb); };
	snd = XFade2.ar(snd, wet, mix);
    Out.ar(0, snd);
}).play;
)


/////////////////////////////////////////////////////////////
// FM
/////////////////////////////////////////////////////////////

(
SynthDef(\fmBass, {|cRatio=1, mRatio=3, index=2|
	var snd, mod, env, freq;
	freq = \freq.kr(110);
	env = Env.perc(0, 1).ar.linlin(0, 1, 1, index);
	mod = SinOsc.ar(freq * mRatio) * (freq * mRatio * env);
	snd = SinOsc.ar((freq * cRatio) + mod);
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play
)


/////////////////////////////////////////////////////////////
// FM
/////////////////////////////////////////////////////////////

(
SynthDef(\sourceFm, {|amp=0.1, cRatio=2, mRatio=4, index=3|
	var snd, mod, env, lfo, freq;
	freq = \freq.kr(110) * ([0, 0.1].midiratio);
	env = Env.perc(0, 1, curve: -2).ar.linlin(0, 1, 1, index);
	lfo = { |rate=1, phase=0, del=1e-4| SinOsc.ar(rate, phase, del, del + 1e-6) };
	mod = SinOsc.ar(freq * mRatio) * (freq * mRatio * env);
	snd = SinOsc.ar((freq * cRatio) + mod);
	snd = snd.sum;
	snd = Mix([snd, (snd * 2.dbamp).tanh]);
	snd = XFade2.ar(snd, CombC.ar(snd, 0.02, lfo.(2, 0, 3e-4), 0), \flangerMix.kr(0));
	snd = Limiter.ar(snd);
	snd = snd * Env.perc(0.01, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd * amp ! 2);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(50 * (Env.perc(0, 0.25).ar * 10).midiratio * XLine.ar(3, 1, 0.02) * [1, 3.4]);
	snd = snd * Env.perc(0.01, [0.4, 0.1] * velocity, curve: -7).ar;
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(1300, 200, 0.02)) * Env.perc(0.002, 0.03).ar);
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.002, 0.01).ar);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3234, 0.7) * Env.perc(0.001, 0.01).ar * -10.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 6234, 0.7) * Env.perc(0.001, 0.02).delay(0.01).ar * -10.dbamp);
	snd = snd * 5.dbamp;
	snd = snd * velocity;
	snd = snd + 0.1;
	snd = snd.tanh;
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -40.dbamp, 0.2, [30e-3, 45e-3]), 200), 1000);
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = Pulse.ar(40 * [1, 2.3, 3.4, 4.5, 6.7, 7.8]);
	snd = snd.sum;
	snd = snd + PinkNoise.ar;
	snd = snd * Env.perc(0.01, 0.04).ar;
	snd = BPF.ar(snd, [10234, 7234, 6824], 0.1) * 13.dbamp;
	snd = snd.sum;
	3.do {
		snd = HPF.ar(snd, 3e3);
	};
	snd = snd + (SinOsc.ar(XLine.ar(10300, 3000, 0.01)) * Env.perc(0.001, 0.01).ar * -7.dbamp);
	snd = snd * velocity;
	snd = snd * 2.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = WhiteNoise.ar;
	snd = BPF.ar(snd, 1830, 0.3) * 20.dbamp;
	snd = snd * Env([0, 1, 0.5, 1, 0.5, 1, 0], [0.001, 0.005, 0.001, 0.003, 0.001, 0.04], curve: -4).ar;
	snd = Pan2.ar(snd, 0);
	snd = snd.tanh;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.2, [30e-3, 42e-3]), 200), 1000);
	snd = snd + GVerb.ar(snd.mean * -24.dbamp, 20, 3, 0.4);
	snd = snd * Env.linen(0.0, 0.5, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxDelay, {
	var snd, wet, delayTime;
	delayTime = \delayTime.kr(0.3);
	snd = In.ar(\in.kr(0), 2);
	wet = snd + (LocalIn.ar(2)); // <- feedback control
	wet = DelayN.ar(wet, delayTime, delayTime - ControlDur.ir) * -8.dbamp;
	LocalOut.ar(wet);
	snd = snd + (wet * 0.dbamp); // <- wet/dry mix
	snd = snd + GVerb.ar(snd * -24.dbamp, 20, 4, 0.4) * -6.dbamp;
	Limiter.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

([0, 0.1].midiratio)

(
~fxBus = Bus.audio(nil, 2);
)

~fxBus.index;

(
var s, beat, root, scale, play;
s = Server.default;
beat = 60 / 118;
root = 52;
scale = Scale.dorian.degrees;
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};
Synth.tail(nil, \fxDelay, [in: ~fxBus, delayTime: beat/2]);
/*Routine({
	loop {
		[0, 7, 0, 1, 0, 5, 7, 10].do { |deg|
			var note, octave, length, rel, panRange, pan;
			octave = (0..1).choose;
			panRange = octave.linlin(-2, 2, 0.0, 1.0);
			pan = rrand(-1 * panRange, panRange);
			length = [0.5].choose;
			rel = (beat * length * [4, 8, 16].choose);
			note = (root + deg + (12 * octave)).midicps;
			play.(\sourceFm, length, [
				freq: note, rel: rel, pan: pan, out: ~fxBus,
				flangerMix: octave.linlin(-2, 1, -1, 0)
			]);
		}
	};
}).play;*/
Routine({
	loop {
		[0, 7, 0, 1, 0, 5, 7, 10].do { |deg|
			var note, octave, length, rel, panRange, pan;
			octave = (-2..-1).choose;
			panRange = octave.linlin(-2, 2, 0.0, 1.0);
			pan = rrand(-1 * panRange, panRange);
			length = [1].choose;
			rel = (beat * length * [4, 8, 16].choose);
			note = (root + deg + (12 * octave)).midicps;
			play.(\sourceFm, length, [
				freq: note, rel: rel, pan: pan, out: ~fxBus,
				flangerMix: octave.linlin(-2, 1, -1, 0)
			]);
		}
	};
}).play;
Routine({
	loop {
		if(0.5.coin, {
			play.(\kick, 0.5, [out: ~fxBus]);
			play.(\kick, 0.5, [out: ~fxBus]);
		}, {
			play.(\kick, 1, [out: ~fxBus]);
		});
		play.(\hat, 0.25, [out: ~fxBus]);
		play.(\hat, 0.25, [out: ~fxBus]);
		play.(\hat, 0.5, [out: ~fxBus]);
		play.(\clap, 1, [out: ~fxBus]);
		play.(\hat, 0.25, [out: ~fxBus]);
		play.(\hat, 0.25, [out: ~fxBus]);
		if(0.5.coin, {
			play.(\kick, 0.5, [out: ~fxBus]);
		}, {
			play.(\hat, 0.5, [out: ~fxBus]);
		});
	};
}).play;
)












