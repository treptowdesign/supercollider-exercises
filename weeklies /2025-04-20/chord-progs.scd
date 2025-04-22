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

////////////////////////////////////////////////////////
// Baisc Routine
////////////////////////////////////////////////////////


(
var s, bpm, beat;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
Routine({
	var octave = 5;
	loop {
		1.do { |index|
			(0 + [0, 2, 7, 10]).do { |degree| // i: sus2 min7
				var note = ((12 * octave) + degree).midicps;
				s.bind{
					Synth(\blipChord, [freq: note, amp: 0.5, duration: beat * 2]);
					Synth(\glitterWash, [amp: 0.3, duration: beat * 2, lfoRate: beat]);
				};
			};
			(beat * 2).wait;
		};
		1.do { |index|
			(1 + [0, 4, 7, 11]).do { |degree| // bII: Maj7
				var note = ((12 * octave) + degree).midicps;
				s.bind{
					Synth(\blipChord,[freq: note, amp: 0.5, duration: beat] );
					Synth(\glitterWash, [amp: 0.3, duration: beat, lfoRate: beat]);
				};
			};
			(beat).wait;
		};
		1.do { |index|
			(-2 + [0, 3, 7, 10]).do { |degree| // bvii: min7
				var note = ((12 * octave) + degree).midicps;
				s.bind{
					Synth(\blipChord, [freq: note, amp: 0.5, duration: beat]);
					Synth(\glitterWash, [amp: 0.3, duration: beat, lfoRate: beat]);
				};
			};
			(beat).wait;
		};
	};
}).play;
)