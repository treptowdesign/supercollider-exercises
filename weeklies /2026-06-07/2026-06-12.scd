(
SynthDef(\kick, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(Env.perc(0, 0.14, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 200)) * XLine.ar(1.05, 1, 0.2));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.3, curve: -4).ar;
	snd = LPF.ar(snd, XLine.ar(300, 100, 0.2));
	hi = snd;
	hi = hi * (1 + (LPF.ar(LPF.ar(RHPF.ar({ PinkNoise.ar } ! 2, 1230, 0.5), 2e3), 7e3) * -5.dbamp));
	hi = (hi * 8).tanh;
	hi = hi + DelayC.ar(hi * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	hi = HPF.ar(hi, 2500);
	hi = LPF.ar(hi, 8000);
	hi = hi * -10.dbamp;
	snd = (snd * 0.8).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd + hi;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = (BPF.ar(snd, [1223, 1500], 0.4) * [20, 10].dbamp).sum;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.015, 0.001, 0.015, 0.001, 0.07] * 0.9, curve: -4).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -27.dbamp, 30, 1);
	snd = BHiShelf.ar(snd, 2300, 0.3, -3);
	snd = snd * (1 + Env.perc(0, 0.01).ar); // transient
	snd = snd * Env.linen(0.0, 0.5, 0.9, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar(Impulse.ar(230))) + Hasher.ar(Sweep.ar + 1);
	snd = BPF.ar(snd, [7223, 9.234e3], 0.4);
	snd = snd.sum;
	snd = HPF.ar(snd, 6e3);
	snd = snd * Env.perc(0.003, 0.09, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\keys, {
	var snd, freq, velocity, n;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..25);
	// outer partial, inner detune
	snd = SinOsc.ar(freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 32] * n * n)).sqrt * [[0, -0.06, 0.06].midiratio], Rand(0, 2pi ! n.size));
	snd = snd / (n ** 0.8);
	snd = snd * Env.perc(n.normalize.linexp(0, 1, 0.03, 0.001), 10 / n.squared, curve: -1).kr * 2;
	snd = snd.tanh;
	snd = snd.sum;
	snd = Splay.ar(snd, 0.1);
	snd = snd * -15.dbamp;
	snd = snd.tanh;
	snd = snd * Env.perc(0.01, 10.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -2.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\pianoFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = CombC.ar(snd, 0.1, 1 / 34, 0.2);
	snd = HPF.ar(snd, 200);
	snd = snd * 4.dbamp;
	snd = LPF.ar(snd, 2000);
	snd = snd.tanh;
	snd = LPF.ar(snd, 2500);
	snd = snd + DelayC.ar(snd * -8.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 3e-3);
	snd = snd + GVerb.ar(snd.sum * -16.dbamp, 30, 4);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sidechainFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (Env.perc(0.01, 0.3, curve: 4).ar(gate: T2A.ar(\pump.tr)) * 0.6));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Saw.ar(\freq.kr(440) * (LFNoise2.ar(20 ! 5) * 0.3).midiratio);
	snd = RLPF.ar(snd, XLine.ar(100, 1000, 0.1) * LFNoise2.ar(3 ! snd.size).linexp(-1, 1, 0.5, 2), 0.6);
	snd = Splay.ar(snd);
	snd = snd * Env.linen(0.01, duration * 0.8, duration * 0.2, curve: 4).ar(Done.freeSelf);
	snd = snd * -20.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, beat, play, playP, wait, noteToFreq;

s = Server.default;

beat = 60 / 121;

playP = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};

play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};

wait = { |duration|
	(duration * beat).wait;
};

noteToFreq = { |note, octave = 0|
	(60 + note + (octave * 12)).midicps;
};

Routine({
	var sidechainBus, sidechainFx, pianoBus, pump;
	var playHat, pianoChord, playKick;

	s.newBusAllocators;

	s.bind {
		sidechainBus = Bus.audio(nil, 2);
		pianoBus = Bus.audio(nil, 2);
		Synth.tail(nil, \pianoFx, [in: pianoBus, out: sidechainBus]);
		sidechainFx = Synth.tail(nil, \sidechainFx, [in: sidechainBus, out: 0]);
	};

	pump = {
		s.bind { sidechainFx.set(\pump, 1) };
	};

	playHat = { |n|
		n.do { |i|
			play.(\hat, 1 / n, [pan: if(((n % 2) == 1) or: { n >= 6 }, 0.0, [-0.3, 0.3].wrapAt(i))]);
		};
	};

	pianoChord = { |notes, length|
		fork {
			notes.sort.do { |note, i|
				var amp = i.linlin(0, 4, 1.2, 0.6);
				playP.(\keys, 1 / 2, [ freq: noteToFreq.(note), amp: amp, out: pianoBus]);
				// playP.(\pad, length, [freq: noteToFreq.(note + 12), amp: amp, out: pianoBus]);
				wait.(rrand(1 / 16, 1 / 32));
			};
		};
		wait.(length);
	};

	playKick = { |duration, args = #[]|
		pump.();
		play.(\kick, duration, args);
	};

	inf.do {

		fork {
			2.do {
				[
					2, 2, 2, 3,
					2, 2, 6, 2,
					2, 2, 2, 3,
					2, 3, 2, 12
				].do { |n|
					playHat.(n);
				};
			};
		};

		fork {
			// (beat * 16).wait;
			2.do {
				// 8 beats
				playKick.(2, [freq: noteToFreq.(8, -3)]);
				play.(\clap, 2);
				wait.(1 / 2);
				playKick.((1 / 2), [freq: noteToFreq.(8, -3), velocity: 0.5]);
				playKick.(1, [freq: noteToFreq.(8, -3)]);
				play.(\clap, 1);
				playKick.(1, [freq: noteToFreq.(7, -3), velocity: 0.5]);
				// 8 beats
				playKick.(2, [freq: noteToFreq.(0, -3)]);
				play.(\clap, 2);
				wait.(1 / 2);
				playKick.((1 / 2), [freq: noteToFreq.(0, -3), velocity: 0.5]);
				playKick.(1, [freq: noteToFreq.(0, -3), bend: 12]);
				play.(\clap, 1);
				playKick.(1, [freq: noteToFreq.(7, -3), bend: 12, velocity: 0.5]);
			};
		};

		// CHORD PROGRESSION...

		0.do {
			'=> init from synthDef'.postln;
			pianoChord.([3 -12, 8 -12, 0, 7], length: 3);
			pianoChord.([3 -12, 8 -12, 2, 7], length: 5);
			pianoChord.([-12, 10 -12, 3, 7], length: 8);
		};

		0.do {
			'=> my version'.postln;
			pianoChord.([3 -12, 8 -12, 0, 7], length: 3);
			pianoChord.([3 -12, 9 -12, 1, 6], length: 5);
			pianoChord.([-12, 3, 7, 10 -12], length: 8);
		};

		0.do { // 2-5-1 minor
			'=> 2-5-1 minor'.postln;
			pianoChord.((2 + [-12, 3, 6-12, 10]).sort.postln, length: 3);
			pianoChord.((-5 + [-12, 4+12, 7, 10-12]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8);
		};

		0.do { // 2-5-1 minor w/ 9ths
			'=> 2-5-1 minor w/ 9ths'.postln;
			pianoChord.((2 + [-12, 3, 6-12, 10, 13]).sort.postln, length: 3);
			pianoChord.((-5 + [-12, 4+12, 7 +12, 10-12, 13]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10, 14]).sort.postln, length: 8);
		};

		2.do { // 2-5-1 minor (phrygian b2)
			'=> 2-5-1 minor (phrygian b2)'.postln;
			pianoChord.((1 + [-12, 4, 7-12, 11]).sort.postln, length: 3);
			pianoChord.((-5 + [-12, 4+12, 7, 10-12]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8);
		};

		0.do { // 4-5-1 minor
			'=> 4-5-1 minor'.postln;
			pianoChord.((-7 + [-12, 3+12, 7, 10-12]).sort.postln, length: 3);
			pianoChord.((-5 + [-12, 4+12, 7, 10-12]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8);
		};

		0.do { // 4-7-1 minor
			'=> 4-7-1 minor'.postln;
			pianoChord.((-7 + [-12, 3+12, 7, 10]).sort.postln, length: 3);
			pianoChord.((-2 + [-12, 4, 7, 10]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7, 10]).sort.postln, length: 8);
		};

		0.do { // 4-7-1 minor
			'=> 4-7-1 minor (alt)'.postln;
			pianoChord.((5 + [-12, 3-12, 7, 10]).sort.postln, length: 3);
			pianoChord.((-2 + [-12, 4+12, 7-12, 10]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7, 10]).sort.postln, length: 8);
		};

		0.do { // 3-4-1 minor
			'=> 3-4-1 minor'.postln;
			pianoChord.((3 + [-12, 3-12, 7, 10]).sort.postln, length: 3);
			pianoChord.((5 + [-12, 3-12, 7, 10]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8);
		};

		0.do { // 3-4-1 minor
			'=> 3-4-1 minor (alt)'.postln;
			pianoChord.((3 + [-12, 3-12, 7, 10]).sort.postln, length: 3);
			pianoChord.((5 + [-12, 3-12, 7, 10]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8);
		};

		0.do { // 3-6-1 minor
			'=> 3-6-1 minor'.postln;
			pianoChord.((3 + [-12, 3, 7, 10]).sort.postln, length: 3);
			pianoChord.((-4 + [-12, 4+12, 7, 11]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8);
		};

		0.do { // 3-6-1 minor (2x length)
			'=> 3-6-1 minor'.postln;
			pianoChord.((3 + [-12, 3, 7, 10]).sort.postln, length: 3 * 2);
			pianoChord.((-4 + [-12, 4+12, 7, 11]).sort.postln, length: 5 * 2);
			pianoChord.((0 + [-12, 3, 7-12, 10]).sort.postln, length: 8 * 2);
		};

		0.do { // 3-6-1 minor (9ths instead of 5ths)
			'=> 3-6-1 minor (9ths instead of 5ths)'.postln;
			pianoChord.((3 + [-12, 3, 10, 14-12]).sort.postln, length: 3);
			pianoChord.((-4 + [-12, 4+12, 11, 14]).sort.postln, length: 5);
			pianoChord.((0 + [-12, 3, 10, 14]).sort.postln, length: 8);
		};

		0.do { // quartal ii - V - i
			'=> quartal ii - V - i'.postln;
			// ii quartal
			pianoChord.((2 + [0, 5, 10, 15]).sort.postln, length: 3);
			// V quartal
			pianoChord.((-5 + [0, 5+12, 10, 15]).sort.postln, length: 5);
			// i quartal
			pianoChord.((0 + [0, 5, 10, 15]).sort.postln, length: 8);
		};

		// (beat * 16).wait;






	};
}).play;
)


((3 + [-12, 3-12, 7, 10]) % 12).sort.postln;
((5 + [-12, 3-12, 7, 10]) % 12).sort.postln;
((0 + [-12, 3, 7-12, 10]) % 12).sort.postln;


-9 % 12;