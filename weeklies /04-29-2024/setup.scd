// synth
(
SynthDef(\synth, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).add;
SynthDef(\fx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = CombN.ar(
		in: snd,
		maxdelaytime: 0.3,
		delaytime: 0.1,
		decaytime: 1
	);
	Out.ar(\out.kr(0), snd * \amp.kr(1.dbamp));
}).add;
)

Synth(\synth);


// bussing
(
~fxBus = Bus.audio(s, 2);
)

~fxBus.index;


// routine
(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.lydian.degrees;

Synth.tail(nil, \fx, [in: ~fxBus]);

Routine({
	var tatum, dur, note, octave;
	// var freqs = Pseq([440, 550, 660, 880], inf).asStream;
	tatum = beat / 4;
	loop {
		dur = tatum  * [1,2,3,4].choose;
		8.do {
			octave = [0, 1, 2].choose;
			note = (root + scale.choose + (12 * octave)).midicps;
			// note = freqs.next;
			s.bind { Synth(\synth, [freq: note, out: ~fxBus]); };
			dur.wait;
		};

	};
}).play;

)
