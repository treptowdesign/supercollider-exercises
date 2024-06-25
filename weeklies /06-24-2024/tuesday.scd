// Tuesday Project

(
SynthDef(\pulse, { |freq=440, pWidth=0.5|
	var snd;
	snd = Pulse.ar(freq, pWidth);
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\pulse, [freq: 110, pWidth: 0.8]);

// scales...
Scale.aeolian.degrees; // [ 0, 2, 3, 5, 7, 8, 10 ]

(
var s, root, bpm, beat;
s = Server.default;
root = 42;
bpm = 120;
beat = 60 / bpm;
Routine({
	var dur, note;
	dur = beat / 4;
	loop {
		[
			0,3,7,\, 1,5,8,\

		].do { |degree|
			if(degree != \, {
				note = (root + degree + (12 * 1)).midicps;
				s.bind { Synth(\pulse, [freq: note, pWidth: 0.5]); };
			});
			dur.wait;
		};
	};
}).play;
)

