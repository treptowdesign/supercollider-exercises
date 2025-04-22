////////////////////////////////////////////////////////
// Synth
////////////////////////////////////////////////////////

(
SynthDef(\simpleSin, {|freq=440, amp=1, duration=1|
	var snd, env;
	env = Env.perc(1e-1, duration * 3, curve: -4).ar;
	snd = SinOsc.ar(freq, mul: 0.2);
	snd = Pan2.ar(snd * env, 0, amp);
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(0, snd);
}).add;
)

(
SynthDef(\blipChord, {|freq=440, amp=1, duration=1|
	var snd, env;
	env = Env.perc(1e-2, duration * 3, curve: -4).ar;
	snd = SinOsc.ar(freq*[0.9 ,0.985 , 1, 1.01, 1.2], mul: [0.05,0.18,1,0.2,0.05]).mean;
	snd = Pan2.ar(snd * env, 0, amp);
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(0, snd);
}).add;
)

{Env.perc(1e-2, 1, curve: 8).ar}.plot(2);

(
SynthDef(\glitterWash, { |duration=2, amp=1, lfoRate=1|
	var snd, lfo;
	lfo = SinOsc.kr(lfoRate);
	snd = WhiteNoise.ar;
	snd = 10.collect {
		FreqShift.ar(
			CombC.ar(snd * (1 + (0.5 * LFNoise2.kr(7))) * (1 + (0.3 * LFNoise2.kr(30))),
				0.1,
				1 / (ExpRand(500, 1000) * (LFNoise2.kr(3) * 0.3).midiratio),
				1.0
			),
			ExpRand(1000, 5000)
		)
	};
	snd = Splay.ar(snd) * -10.dbamp;
	// snd = BPF.ar(snd, 9200, 0.3);
	snd = BPF.ar(snd, lfo.range(8200, 9800), 0.3);
	3.do { snd = HPF.ar(snd, 8000); };
	snd = snd * -23.dbamp * amp;
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2100), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1600, 0.6) * -3.dbamp;
	snd = LPF.ar(snd, 6200);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.001, 0.01, 0.003, 0.01, 0.003, 0.08, 0.2] * 0.5, curve: -2).ar ** 1.2;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -25.dbamp, 10, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

////////////////////////////////////////////////////////
// Baisc Routine
////////////////////////////////////////////////////////


(
var s, bpm, beat;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
Routine({
	fork {
		loop {
			s.bind { Synth(\kick); };
			((beat * 2)).wait;
			s.bind { Synth(\clap); };
			((beat * 1.5) - 0.01).wait;
			s.bind { Synth(\kick); };
			((beat * 0.5) + 0.01).wait;
		}
	};
	fork {
		var octave = 5;
		loop {
			// Synth(\glitterWash, [amp: 0.3, duration: beat * 4, lfoRate: beat]);
			[
				(intervals: (0 + [0, 2, 7, 10]), length: beat * 2),
				(intervals: (1 + [0, 4, 7, 11]), length: beat),
				(intervals: (-2 + [0, 3, 7, 10]), length: beat)
			].do { |chord|
				chord[\intervals].do { |degree|
					var note = ((12 * octave) + degree).midicps;
					s.bind{
						Synth(\blipChord, [freq: note, amp: 0.5, duration: chord[\length]]);

					};
				};
				chord[\length].wait;
			};

		};
	};

}).play;
)