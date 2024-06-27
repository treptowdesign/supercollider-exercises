(
SynthDef(\square8, { |freq=220|
	var snd;
	snd = Pulse.ar(freq * ((WhiteNoise.ar * 0.1).midiratio), 0.5);
	// snd = snd + (VarSaw.ar(freq, 2pi, 1) * 0.1);
	snd = (snd.tanh * 2.dbamp).clip2;
	snd = Decimator.ar(snd, bits: 8);
	snd = snd * Env.perc(0.01, 1, curve: -8).ar(Done.freeSelf);
	// snd = snd * Env.linen(0.1, 1, 0.1).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -10.dbamp ! 2);
}).add;
)


Scale.ionian.degrees;
// [ 0, 2, 4, 5, 7, 9, 11 ]
// [ 12, 14, 16, 17, 19, 21, 23 ]

(
var s, root, bpm, beat;
s = Server.default;
root = 42; // F#/Gb
bpm = 140;
beat = 60 / bpm;

Routine({
	var dur, note, octave;
	dur = beat / 4;

		[
			12 + [
				7, \, \, \, 0, \, \, \,    \, \, 0, \, 4, \, 9, \,    11, \, 9, \, 7, \, \, \,    12, \, 7, \, 4, \, \, \,

			],
			[
				7, \, 0, \, 4, \, 0, \,    7, \, 0, \, 4, \, 0, \,      7, \, 0, \, 4, \, 0, \,    7, \, 0, \, 4, \, 0, \,
			],
			-12 + [
				0, \, \, \, 7, \, 7, \,    0, \, \, \, 7, \, 7, \,     0, \, \, \, 7, \, 7, \,    0, \, \, \, 7, \, 7, \,
			],
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
						s.bind { Synth(\square8, [freq: (root + 12 + note).midicps]) };
						};
						dur.wait;
					};
				};
			}).play;

	};
}).play;
)




(
SynthDef(\noise8, { |freq=110|
	var snd;
	snd = Pulse.ar(WhiteNoise.ar.range(60, 100), 0.1);
	// snd = Decimator.ar(snd, bits: 8);
	snd = snd * Env.perc(0.01, 1, curve: -8).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -5.dbamp ! 2);
}).play;
)

(
SynthDef(\noise8alt, { |freq=110|
	var snd;
	snd = BrownNoise.ar;
	// snd = Decimator.ar(snd, bits: 8);
	snd = MoogFF.ar(snd, 400);
	snd = snd * Env.perc(0.01, 1, curve: -8).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -5.dbamp ! 2);
}).play;
)










// end...