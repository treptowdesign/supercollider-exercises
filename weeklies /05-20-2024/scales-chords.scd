(
SynthDef(\synth, {
	var freq, snd, rel, spread, vol;
	spread = \spread.kr(1);
	vol = \vol.kr(0);
	freq = \freq.kr(440) * ([0, 0.1, 0.03, -0.13, -0.01] * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = VarSaw.ar(freq, 0, 0);
	// snd = snd.sum;
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 16000, 0.2);
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.06, rel, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd * -25.dbamp * vol.dbamp ! 2);
}).play;
)

(
var s, bpm, beat, root, scale, playChord, scaleFromIndex, chordFromScale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.lydian.degrees;

playChord = { |chord, octave = 0, dur, args = #[]|
	chord.do {|deg|
		var note = (root + deg + (12 * octave)).midicps;
		s.bind { Synth(\synth, [freq: note] ++ args); };
	};
	dur.wait;
};

scaleFromIndex = { |scale, index|
	(scale[index..] ++ (scale[0..(index-1)] + 0))[0..6];
};
chordFromScale = { |scale, degrees = #[0, 2, 4, 6]|
	degrees.collect { |i| scale[i] }.postln;
};

// chordFromScale.(scaleFromIndex.(scale, 1));

Routine({
	var dur, octave, note;
	loop {
		dur = beat * [1, 2].choose;
		playChord.(
			chordFromScale.(scaleFromIndex.(scale, rrand(0, 6))
		), 2, dur, [rel: 2, spread: 0.65, vol: 0]);
	};
}).play;
)


