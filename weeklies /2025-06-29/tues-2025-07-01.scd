
(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(50 * (Env.perc(0, 0.25).ar * 8).midiratio * XLine.ar(3, 1, 0.02) * [1, 3.4]);
	snd = snd * Env.perc(0.01, [0.4, 0.1] * velocity, curve: -7).ar;
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(1100, 200, 0.02)) * Env.perc(0.002, 0.03).ar);
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.002, 0.01).ar);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3234, 0.7) * Env.perc(0.001, 0.01).ar * -10.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 5234, 0.7) * Env.perc(0.001, 0.02).delay(0.01).ar * -10.dbamp);
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

(
SynthDef(\keys2, {
	var snd, freq, wet;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01);
	freq = freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.2), 100);
	snd = snd * SinOsc.ar(4, 0, 10, 100) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	wet = snd + 0.3;
	wet = (snd * 6.dbamp).tanh;
	wet = LPF.ar(wet, 1200);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
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
	Synth(\keys2, [freq: (note + (12 * 0)).midicps, amp: 0.1, pan: 0]);
};
)


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
Routine({
	loop {
		// i
		(0 + [0, 3, 7, 10]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + (12 * 0)).midicps]);
		};
		wait.(2);
		(0 + [-5, 3]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + (12 * 0)).midicps]);
		};
		// bII
		(1 + [0, 4, 7, 11]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + (12 * 0)).midicps]);
		};
		wait.(2);
		(1 + [4, 7]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + (12 * 0)).midicps]);
		};
		// iv
		(5 + [0, 3, 7, 10]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + (12 * 0)).midicps]);
		};
		wait.(2);
		(5 + [3, 7]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + (12 * 0)).midicps]);
		};
		// v
		(7 + [0, 3, 7, 10 - 12]).postln.do { |deg|
			playP.(\keys2, 4, [freq: (root + deg + (12 * 0)).midicps]);
		};
		wait.(2);
		(7 + [10 - 12, 7]).do { |deg|
			play.(\keys2, 1, [freq: (root + deg + (12 * 0)).midicps]);
		};
	};
}).play;
)













// end 