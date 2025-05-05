(
SynthDef(\keyWip, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(0.4), 100);
	snd = snd * SinOsc.ar(4, 0, 10, 280) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	snd = HPF.ar(snd, 100) + LPF.ar(HPF.ar(PinkNoise.ar(0.2), 300), 4000);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.06));
	snd = snd * Env.perc(0.01, \rel.kr(4.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.06).ar * [30, 10, 20, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 1.6, 2.4, 3.2]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 5220, 0.4) * Env.perc(0.05, 0.1).ar * -30.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 8.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = SinOsc.ar(220 * XLine.ar(1.1, 1, 0.02) * [1, 2.4, 7.4]);
	snd = snd * Env.perc(0.01, [0.1, 0.02, 0.03] * velocity, curve: -7).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * -4.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(3300, 200, 0.02)) * Env.perc(0.001, 0.05).ar);
	snd = snd + (SinOsc.ar(XLine.ar(5300, 100, 0.02)) * Env.perc(0.001, 0.02).ar * -10.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 2234, 0.2) * Env.perc(0.02, 0.07).ar * 5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3234, 0.2) * Env.perc(0.01, 0.05).delay(0.02).ar * 5.dbamp);
	// snd = snd + (BPF.ar(WhiteNoise.ar, 7234, 0.4) * Env.perc(0.001, 0.05).ar * -10.dbamp);
	snd = snd * velocity;
	snd = snd.tanh;
	snd = LeakDC.ar(snd);
	snd = snd * (1 + Env.perc(0, 0.02).ar);
	snd = snd * Line.ar(0, 1, velocity.linlin(0, 1, 0.02, 0));
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -28.dbamp, 0.2, [30e-3, 45e-3]), 200), 1000);
	snd = snd * \amp.kr(0.4);
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, velocity;
	velocity = \velocity.kr(1.0);
	snd = Pulse.ar(60 * [1, 2.3, 3.4, 4.5, 6.7, 5.8]);
	snd = snd.sum;
	snd = snd + PinkNoise.ar;
	snd = snd * Env.perc(0.01, 0.03).ar;
	snd = BPF.ar(snd, [9234, 5234, 6824], 0.1) * 13.dbamp;
	snd = snd.sum;
	3.do { snd = HPF.ar(snd, 3e3); };
	snd = snd + (SinOsc.ar(XLine.ar(9300, 3000, 0.01)) * Env.perc(0.001, 0.01).ar * -7.dbamp);
	snd = snd * velocity;
	snd = snd * 4.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.16));
	snd = snd * Env.linen(0.0, 0.5, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, root;
s = Server.default;
beat = 60 / 96;
root = 50; // D
Routine({
	loop {
		// Kick
		fork {
			[2, 2, 0.5, 1, 2, 0.5].do { |length|
				s.bind {Synth(\kick ); };
				(beat * length).wait;
			};
		};
		// Snare
		fork {
			4.do {
				(beat).wait;
				s.bind {Synth(\snare ); };
				(beat).wait;
			};
		};
		fork {
			4.do {
				(beat * 0.5).wait;
				s.bind {Synth(\hat ); };
				(beat * 0.25).wait;
				s.bind {Synth(\hat, [velocity: 0.6]); };
				(beat * 0.75).wait;
				s.bind {Synth(\hat ); };
				(beat * 0.5).wait;
			};
		};
		// Chord Progression
		[
			(notes: (5 + [-12, 5, 10, 14]), length: 2, bend: -5), // iv 11 (5 == 4th/11th)
			(notes: (10 + [-8, -2, 0, 7]), length: 2, bend: 0), // VII (3rd, 10th, root, 5th)
			(notes: (0 + [0, 3, 7, 14]), length: 1.5, bend: 0), // i add9 (14 == 9th)
			(notes: (0 + [0, 10, 15, 19]), length: 2, bend: 0), // i7
			(notes: (10 + [-12, 0, 7]), length: 0.5, bend: 0), // vii (just root and 5th)
		].do { |chord|
			chord[\notes].do { |degree|
				s.bind { Synth(\keyWip, [
					freq: (root + degree).midicps,
					duration: (beat * chord[\length]),
					bend: chord[\bend]
				]); };
			};
			(beat * chord[\length]).wait;
		};
	};

}).play;
)

(5 + [-12, 5, 10, 14]); // -> [ -7, 10, 15, 19 ]
(10 + [-8, -2, 0, 7]); // -> [ 2, 8, 10, 17 ]
(0 + [0, 3, 7, 14]); // -> [ 0, 3, 7, 14 ]
(0 + [0, 10, 15, 19]); // -> [ 0, 10, 15, 19 ]
(10 + [-12, 0, 7]); // -> [ -2, 10, 17 ]








// endfile...
