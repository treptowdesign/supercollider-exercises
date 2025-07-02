
(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(50 * (Env.perc(0, 0.25).ar * 8).midiratio * XLine.ar(3, 1, 0.02) * [1, 3.5]);
	snd = snd * Env.perc(0.01, [0.4, 0.1] * velocity, curve: -7).ar;
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd + ((SinOsc.ar(XLine.ar(1100, 200, 0.02)) * Env.perc(0.002, 0.03).ar) * -6.dbamp);
	snd = snd + ((SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.002, 0.01).ar) * -6.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3234, 0.7) * Env.perc(0.001, 0.01).ar * -12.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 5234, 0.7) * Env.perc(0.001, 0.02).delay(0.01).ar * -12.dbamp);
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
}).play;
)


(
SynthDef(\sat, {
	var snd;
	snd = SinOsc.ar(\freq.kr(220));
	snd = snd * Env.perc(0.001, \rel.kr(4)).ar(Done.freeSelf);
	snd = snd + 0.5;
	snd = (snd * 8.dbamp).tanh;
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\satNoise, {
	var snd;
	snd = SinOsc.ar(\freq.kr(330));
	snd = snd * Env.perc(0.001, \rel.kr(4)).ar(Done.freeSelf);
	snd = snd + LFNoise2.ar(1).range(-0.5, 0.5);
	snd = (snd * 8.dbamp).tanh;
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.4));
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\clap, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = WhiteNoise.ar;
	snd = BPF.ar(snd, [1630, 1015, 1840, 2500], 0.4).sum;
	snd = snd * Env([0, 1, 0.5, 1, 0.5, 1, 0], [0.001, 0.005, 0.001, 0.005, 0.001, 0.04], curve: -4).ar;
	snd = Pan2.ar(snd, 0);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.2, [30e-3, 45e-3]), 200), 1000);
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

/////////////////////////////////////////////////////////
// Keys
/////////////////////////////////////////////////////////

(
SynthDef(\keys, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(3, 1, 0.02);
	freq = freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.1), 100);
	snd = snd * SinOsc.ar(4, 0, 10, 200) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = snd + 0.2;
	snd = (snd * 4.dbamp).tanh;
	snd = LeakDC.ar(snd);
	snd = LPF.ar(snd, 1200);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.1), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd * Env.perc(0.01, \rel.kr(4.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	snd = BLowShelf.ar(snd, 250, 0.5, -5);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
(52 + [0, 3, 7, 10]).do { |note|
	Synth(\keys, [freq: (note + (12 * 0)).midicps, amp: 0.15, pan: rrand(-0.25, 0.25)]);
};
)


/////////////////////////////////////////////////////////
// Keys
/////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////
// Keys
/////////////////////////////////////////////////////////

(
SynthDef(\keys1, {
	var snd, freq, wet;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01);
	freq = freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(1), 100);
	snd = snd * SinOsc.ar(4, 0, 10, 100) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	wet = snd + 0.3;
	wet = (snd * 4.dbamp).tanh;
	wet = LPF.ar(wet, 1200);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, -1);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.1), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	snd = snd * Env.perc(0.01, \rel.kr(4.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	// snd = BLowShelf.ar(snd, 250, 0.5, -5);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keys11, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(3, 1, 0.01);
	freq = freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(1), 200);
	snd = snd * SinOsc.ar(LFNoise2.ar(0.25).range(1, 4), 0, 20, 120) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	snd = snd * Env.perc(0.01, \rel.kr(4.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)







/////////////////////////////////////////////////////////
// Keys
/////////////////////////////////////////////////////////

(
SynthDef(\keys2, {
	var snd, freq, wet;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(3, 1, 0.01);
	freq = freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(1), 200);
	snd = snd * SinOsc.ar(LFNoise2.ar(0.25).range(1, 4), 0, 30, 240) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	wet = snd + 0.3;
	wet = (snd * 4.dbamp).tanh;
	wet = LPF.ar(wet, 1200);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, -0.5);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 3e-4);
	snd = HPF.ar(HPF.ar(snd, 60), 60);
	snd = snd * Env.perc(0.01, \rel.kr(3.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(50 * (Env.perc(0, 0.25).ar * 8).midiratio * XLine.ar(3, 1, 0.02) * [1, 3.5]);
	snd = snd * Env.perc(0.01, [0.4, 0.1] * velocity, curve: -7).ar;
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd + ((SinOsc.ar(XLine.ar(1100, 200, 0.02)) * Env.perc(0.002, 0.03).ar) * -8.dbamp);
	snd = snd + ((SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.002, 0.01).ar) * -8.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3234, 0.7) * Env.perc(0.001, 0.01).ar * -14.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 5234, 0.7) * Env.perc(0.001, 0.02).delay(0.01).ar * -14.dbamp);
	snd = snd * 5.dbamp;
	snd = snd * velocity;
	snd = snd + 0.1;
	snd = snd.tanh;
	snd = LeakDC.ar(snd);
	snd = snd * -7.dbamp;
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -40.dbamp, 0.2, [30e-3, 45e-3]), 200), 1000);
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = WhiteNoise.ar;
	snd = (BPF.ar(snd, [1830, 1015, 2400], 0.3) * [18, 10, 10].dbamp).sum;
	snd = snd * Env([0, 1, 0.5, 1, 0.5, 1, 0], [0.001, 0.003, 0.001, 0.002, 0.001, 0.03], curve: -4).ar;
	snd = Pan2.ar(snd, 0);
	snd = snd.tanh;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.2, [30e-3, 42e-3]), 200), 1000);
	snd = snd + GVerb.ar(snd.mean * -24.dbamp, 30, 3, 0.8);
	snd = snd * Env.linen(0.0, 0.5, 1).ar(Done.freeSelf) * -6.dbamp;
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
	snd = snd * -8.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxPhaser, {
    var snd, wet, lfo, delay;
	delay = \delay.kr(1e-4);
	snd = In.ar(\in.kr(0), 2);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay + 1e-6) };
	wet = snd;
	8.do { wet = AllpassL.ar(wet, 0.2, lfo.(\speed.kr(0.5), Rand(0.0, 0.5) * pi), \fb.kr(0)); };
	snd = XFade2.ar(snd, wet, \mix.kr(0), \amp.kr(1));
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxChorus, {
    var snd, wet, wet2, lfo, delay;
	delay = \delay.kr(1e-4);
	snd = In.ar(\in.kr(0), 2);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay + 1e-6) };
	wet = snd;
	wet2 = snd;
	wet = DelayC.ar(wet, 0.1, SinOsc.ar(\modSpeed.kr(0.35), 0).range(0, \modDelay.kr(8e-3)));
	wet2 = DelayC.ar(wet2, 0.1, SinOsc.ar(\modSpeed2.kr(0.5), 0).range(0, \modDelay2.kr(1e-3)));
	snd = XFade2.ar(snd, Mix([wet, wet2]), \mix.kr(0), \amp.kr(1));
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxDelay, {
	var snd, wet, delayTime;
	delayTime = \delayTime.kr(0.3);
	snd = In.ar(\in.kr(0), 2);
	wet = snd + (LocalIn.ar(2));
	wet = DelayN.ar(wet, delayTime, delayTime - ControlDur.ir) * -12.dbamp;
	LocalOut.ar(wet);
	snd = snd + (wet * 0.dbamp);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-3);
	Limiter.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxReverb, {
    var snd, wet;
	snd = In.ar(\in.kr(0), 2);
	wet = GVerb.ar(snd.mean * \gain.kr(-10).dbamp, \size.kr(10), \revtime.kr(3), \damp.kr(0.1));
	snd = XFade2.ar(snd, wet, \mix.kr(0), \amp.kr(1));
    Out.ar(\out.kr(0), snd);
}).add;
)

(
~fxBus = Bus.audio(nil, 2);
~fxBus2 = Bus.audio(nil, 2);
~fxBus3 = Bus.audio(nil, 2);
~fxBus4 = Bus.audio(nil, 2);
~masterxBus = Bus.audio(nil, 2);
)

~fxBus.index;
~fxBus2.index;
~fxBus3.index;
~fxBus4.index;

// weeklies/2025-04-20/drum-rack.scd

(
var s, root, beat, wait, play, playP;
s = Server.default;
root = 52;
beat = 60 / 118;
wait = { |duration|
	(duration * beat).wait;
};
playP = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};
play = { |synthDef, duration, args = #[]|
	playP.(synthDef, duration, args);
	wait.(duration);
};
Synth.tail(nil, \fxPhaser, [
	in: ~fxBus, out: ~fxBus2, mix: -0.5, amp: 1,
	delay: 1e-4, speed: 0.2, fb: 0
]);
Synth.tail(nil, \fxChorus, [
	in: ~fxBus2, out: ~fxBus3, mix: -0.5, amp: 1,
	modSpeed: 1.2, modDelay: 3e-3, modSpeed2: 1, modDelay2: 1e-4
]);
Synth.tail(nil, \fxDelay, [in: ~fxBus4, out: ~fxBus3, delayTime: beat/2]);
Synth.tail(nil, \fxReverb, [
	in: ~fxBus3, out: 0, mix: -0.2, amp: 0.8,
	gain: -15, size: 20, revtime: 3, damp: 0.65
]);
Routine({
	var chordsOut, oct;
	chordsOut = ~fxBus;
	oct = (12 * 0);
	loop {
		fork {
			8.do {
				play.(\hat, 1, [out: ~fxBus4]);
				play.(\hat, 0.25, [out: ~fxBus4]);
				play.(\hat, 0.25, [out: ~fxBus4]);
				play.(\hat, 0.5, [out: ~fxBus4]);
			};
		};
		fork {
			4.do {
				play.(\kick, 0.5, [out: 0]);
				play.(\kick, 0.5, [out: 0, velocity: 0.7]);
				wait.(1);
				play.(\clap, 1, [out: 0]);
				wait.(0.5);
				play.(\kick, 0.5, [out: 0, velocity: 0.7]);
			};
		};
		// i
		(0 + [0, 3, 7, 10]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + oct).midicps, out: chordsOut, bend: -7]);
		};
		wait.(2);
		(0 + [-5, 3]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + oct).midicps, out: chordsOut]);
		};
		// bII
		(1 + [0, 4, 7, 11]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + oct).midicps, out: chordsOut, bend: -7]);
		};
		wait.(2);
		(1 + [4, 7]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + oct).midicps, out: chordsOut]);
		};
		// iv
		(5 + [0, 3, 7, 10]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + oct).midicps, out: chordsOut, bend: -7]);
		};
		wait.(2);
		(5 + [3, 7]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + oct).midicps, out: chordsOut]);
		};
		// v
		(7 + [0, 3, 7, 10 - 12]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + oct).midicps, out: chordsOut, bend: -7]);
		};
		wait.(2);
		(7 + [10 - 12, 7]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + oct).midicps, out: chordsOut]);
		};
	};
}).play;
)













// end 