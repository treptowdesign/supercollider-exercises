//////////////////////////////////////////////////////
// SynthDef
//////////////////////////////////////////////////////
(
SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.2).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.3), 100);
	snd = snd * 200 * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + HPF.ar(PinkNoise.ar(0.1), 300);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.06));
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 10, 3, 1);
	snd = snd * Env.perc(0.01, \rel.kr(3.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd * freq.explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 6000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -12.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\lead, {
	var snd, freq;
	freq = \freq.kr(110);
	snd = Pulse.ar(freq * (LFNoise2.ar(6 ! 6) * 0.1).midiratio, [0.6, 0.2, 0.5, 0.3, 0.5, 0.4]);
	snd = Splay.ar(snd);
	snd = snd + SinOsc.ar(freq / 2, 0, 0.4);
	snd = snd + ({ PinkNoise.ar(0.18)} ! 2);
	snd = RLPF.ar(snd, (LFNoise2.ar(2) + Env.perc(0.05, 0.3).ar).linexp(-1, 1, 500, 7000), 0.3);
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.2, 0.5);
	snd = snd * -16.dbamp;
	snd = snd * Env.perc(0.01,  \rel.kr(4)).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ping, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = LFTri.ar(freq);
	snd = LPF.ar(snd, XLine.ar(3000, 100, 0.3));
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd * -16.dbamp;
	snd = snd ! 2;
	snd = snd * Env.perc(0.005, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.06).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6220, 0.4) * Env.perc(0.05, 0.1).ar * -24.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 12.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(210 * XLine.ar(1.4, 1, 0.005) * [1, 2.3, 4.5]);
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 830, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.2 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\perc, {
	var snd;
	snd = SinOsc.ar(920 * (1.5 ** [0, 1, 1.5])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.08).ar;
	snd = snd + GVerb.ar(snd * -25.dbamp, 20);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hatSoft, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.25, 1 / 60, 1);
	snd = FreqShift.ar(snd, -30);
	snd = BPF.ar(snd, [12240, 5230, 8832] * XLine.ar(0.9, 1.2, 0.1), 0.3).sum;
	snd = HPF.ar(snd, 4e3);
	snd = snd * Env.perc(0.05, 0.03, curve: 4).ar(Done.freeSelf);
	snd = snd * -34.dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 60);
	snd = BPF.ar(snd, [12640, 6230, 10832, 9830, 8620], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.01, 0.03).ar * -15.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (1 * Env.perc(0.01, 0.3, curve: 2).ar(gate: trigger)));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumsFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = BLowShelf.ar(snd, 200, 0.3, -3);
	snd = BHiShelf.ar(snd, 3200, 0.3, -3);
	snd = (snd * 4.dbamp).tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 3);
	snd = BHiShelf.ar(snd, 3200, 0.3, 3);
	// snd = snd + GVerb.ar(snd.sum * -40.dbamp, 10, 10);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\delayFx, {
	var snd, fb, beat;
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	fb = snd;
	fb = fb + LocalIn.ar(2);
	// fb = DelayC.ar(fb, 1.0, (beat) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 1e-3));
	fb = DelayC.ar(fb, 1.0, (beat) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 1e-3));
	fb = fb * -5.dbamp;
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 500);
	LocalOut.ar(fb);
	snd = snd + fb;
	Out.ar(\out.kr(0), snd);
}).add;
)


//////////////////////////////////////////////////////
// Busses
//////////////////////////////////////////////////////

(
~sidechainBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
~delayBus = Bus.audio(nil, 2);
)




~drumsBus.index;
~sidechainBus.index;
~delayBus.index;


//////////////////////////////////////////////////////
// Routine
//////////////////////////////////////////////////////

(
var s, beat, root;
s = Server.default;
beat = 60 / 118;
root = 58;
Routine({
	var sidechainFx, duck, play;
	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);
	Synth.tail(nil, \drumsFx, [in: ~drumsBus, out: 0]);
	Synth.tail(nil, \delayFx, [in: ~delayBus, out: 0, beat: beat/2]);

	duck = {
		s.bind { sidechainFx.set(\trigger, 1) };
	};

	play = { |synthDef, duration, args = #[], latency = 0.0|
		fork {
			latency.wait;
			s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
		};
		(duration * beat).wait;
	};

	loop {
		fork {
			var leadRoot = root;
			[
				// [ 0, 2, 7, 10 ]
				(freq: 2, length: 0.5),
				(freq: 14, length: 0.5),
				(freq: 7, length: 1),
				(freq: 10, length: 0.5),
				(freq: -2, length: 1),
				(freq: -5, length: 0.5),
				// [ 5, 8, 12, 15 ]
				(freq: -7, length: 4),
				// [ -2, 1, 5, 8 ]
				(freq: -2, length: 4),
				// [ 1, 6, 8, 11 ]
				(freq: 1, length: 1),
				(freq: -4, length: 1),
				(freq: 8, length: 1),
				(freq: 1, length: 1),
			].do { |note|
				play.(\lead, note[\length], [freq: (leadRoot + note[\freq]).midicps, out: ~sidechainBus]);
			};
		};
		fork {
			3.do {
				play.(\hat, 1, [out: ~drumsBus]);
				3.do { play.(\hat, 0.25, [out: ~drumsBus]); };
				(beat/4).wait;
				play.(\hat, 1, [out: ~drumsBus]);
				2.do { play.(\hat, 0.5, [out: ~drumsBus]); };
			};
			4.do {
				play.(\hat, 0.5, [pan: -0.3, out: ~drumsBus]);
				play.(\hat, 0.5, [pan: 0.3, out: ~drumsBus]);
			}
		};
		fork {
			4.do {
				(beat * 0.5).wait;
				play.(\hatSoft, 0.5, [out: ~drumsBus]);
				play.(\perc, 1, [out: ~delayBus]);
				(beat * 1).wait;
				play.(\hatSoft, 1, [out: ~drumsBus]);
			};
		};
		fork {
			4.do {
				duck.();
				play.(\kick, 1.5, [out: ~drumsBus]);
				// (beat * 1.5).wait;
				duck.();
				play.(\kick, 0.5, [velocity: 0.6, out: ~drumsBus]);
				// (beat * 0.5).wait;
				play.(\snare, 0.5, [out: ~drumsBus]);
				play.(\snare, 0.5, [velocity: 0.8, out: ~drumsBus], latency: 0);
				duck.();
				play.(\kick, 1, [velocity: 0.8, out: ~drumsBus]);
				// (beat * 1).wait;
			};
		};
		fork {
			[0, 5, -2].do { |degree|
				play.(\sub, 4, [
					freq: (root - 24 + degree).midicps,
					duration: (beat * 4), out: ~sidechainBus
				]);
			};
			[1, -4, 8, 1].do { |degree|
				play.(\sub, 1, [
					freq: (root - 24 + degree).midicps,
					duration: (beat), out: ~sidechainBus
				]);
			};
		};

		[
			(0 + [0, 2, 7, 10]),
			(5 + [0, 3, 7, -2]),
			(-2 + [0, 3, 7, 10]),
			(1 + [0, 3, 7, 10]),
		].do { |chord|
			chord.do { |degree|
				s.bind { Synth(\key, [
					freq: (root + degree).midicps,
					duration: (beat * 4),
					bend: 0,
					out: ~sidechainBus
				]); };
			};
			(beat * 4).wait;
		};
	};
}).play;
)



(0 + [0, 2, 7, 10]);
(5 + [0, 3, 7, 10]);
(-2 + [0, 3, 7, 10]);
(1 + [0, 5, 7, 10]);


//////////////////////////////////////////////////////
// Misc...
//////////////////////////////////////////////////////

[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]
Scale.dorian.degrees; // [ 0, 2, 3, 5, 7, 9, 10 ]
Scale.phrygian.degrees; // [ 0, 1, 3, 5, 7, 8, 10 ]

(0 + [-12, 2, 7, 10]);
(5 + [-12, 3, -5, -2]);

(0 + [0, 2, 7, 10]);
(-2 + [0, 3, 7, 10]);

(
var root = 58;
[-12, 2, 7, 10].do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)

(
var root = 58;
[0, 2, 7, 10].do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)

(
var root = 58;
[-14, 1, 5, 8].do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)


(
var root = 58;
[-14, 2, 5, 9].do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)

(
var root = 58;
(1 + [0, 5, 7, 10]).do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)

(
var root = 58;
(7 + [0, 5, 8]).do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)

(
var root = 58;
(5 + [0, 4, 7, 11]).do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)



(
var root = 58;
(-1 + [0, 3, 7, 10]).do{ |degree|
	Synth(\key, [freq: (root + degree).midicps]);
};
)