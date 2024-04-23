(
SynthDef(\paramsSynth, {
	|freq=440, initFreq=440, pan=0, amp=(-10), atk=0.01, rel=0.6, cutoffMin=80, cutoffMax=8000, rq=0.5, gate=1|
	var snd;
	snd = VarSaw.ar(XLine.kr(initFreq, freq, 0.1), 0, 0.9);
	// snd = RLPF.ar(snd, XLine.kr(cutoffMin, cutoffMax, rel), rq);
	snd = (snd * 2.dbamp).tanh;
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, pan));
}).add;
)

Synth(\paramsSynth);

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;

randomNote = { |octave|
	(root + scale.choose + (12 * octave)).midicps;
};

getNote = { |note=0, octave=0|
	(root + scale.wrapAt(note) + (12 * (note.div(scale.size) + octave))).midicps;
};

wait = { |duration|
	(duration * beat).wait;
};
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	wait.(duration);
};

Routine({
	var tatum;
	tatum = beat / 4;
	loop {
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);

		play.(\paramsSynth, 1, [initFreq: getNote.(0), freq: getNote.(12)]);

		play.(\paramsSynth, 1/3, [initFreq: getNote.(7), freq: getNote.(0)]);
		play.(\paramsSynth, 1/3, [initFreq: getNote.(7), freq: getNote.(0)]);
		play.(\paramsSynth, 1/3, [initFreq: getNote.(7), freq: getNote.(0)]);

		play.(\paramsSynth, 1, [initFreq: getNote.(7), freq: getNote.(0)]);

	};
}).play;
)


Scale.dorian.degrees;