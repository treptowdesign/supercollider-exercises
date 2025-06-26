
(
SynthDef(\source, {
	var snd;
	snd = Pulse.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, \rel.kr(2)).ar(Done.freeSelf);
	snd = LPF.ar(snd, 12e3);
	snd = Pan2.ar(snd, \pan.kr(0), 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sourceUnison, {
	var snd;
	snd = Pulse.ar(\freq.kr(440) * ([0, 0.1] * LFNoise2.ar(2).unipolar).midiratio).sum;
	snd = snd * Env.perc(0.01, \rel.kr(8)).ar(Done.freeSelf);
	snd = LPF.ar(snd, 12e3);
	snd = Pan2.ar(snd, 0, 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sourceSin, {
	var snd;
	// snd = SinOsc.ar(\freq.kr(440) * ([0, 0.4] * LFNoise2.ar(2).unipolar).midiratio).sum;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, \rel.kr(8)).ar(Done.freeSelf);
	snd = LPF.ar(snd, 8e3);
	snd = Pan2.ar(snd, 0, 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\phaser, {
    var snd;
	snd = In.ar(\in.kr(0), 2);
    snd = snd + AllpassC.ar(snd, 0.1, SinOsc.ar(1, 0, 2e-4, 2e-4), 0);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\flanger, {
    var snd;
	snd = In.ar(\in.kr(0), 2);
    snd = snd + CombC.ar(snd, 0.1, SinOsc.ar(1, 0, 2e-4, 2e-4), 0);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fx, {
    var snd;
	snd = In.ar(\in.kr(0), 2);
    snd = snd + AllpassC.ar(snd, 0.1, SinOsc.ar(0.25, 0, 2e-4, 2e-4), 0);
	snd = snd + CombC.ar(snd, 0.1, SinOsc.ar(0.35, 0.5pi, 2e-4, 2e-4), 0);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 30, 6, 0.2);
	snd = snd * -5.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;
)

~fxBus = Bus.audio(nil, 2);

(
~fxBus.index;
)

(
Synth(\phaser, [in: ~fxBus]);
Synth(\source, [out: ~fxBus]);
)

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 3, -5, 10].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \phaser, [in: ~fxBus]);
[0, 3, 7, 10].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \flanger, [in: ~fxBus]);
[0, 3, 7, 10].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)


(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0].do{ |deg|
	Synth(\sourceUnison, [freq: (42 + (-24) + deg).midicps, rel: 10, out: ~fxBus]);
};
)


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
(
var s, beat, root, scale, play;
s = Server.default;
beat = 60 / 128;
// beat = 4;
root = (48..59).choose.postln;
scale = Scale.choose.degrees.postln;
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};
Routine({
	Synth.tail(nil, \fx, [in: ~fxBus]);
	loop {
		var note, octave, length, pan;
		pan = rrand(-1.0, 1.0);
		length = [0.5, 1, 2].choose;
		octave = (-2..2).choose;
		note = (root + scale.choose + (12 * octave)).midicps;
		play.(\sourceUnison, length, [freq: note, rel: (beat * length * 16), pan: pan, out: ~fxBus])
	};
}).play;
)
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

(
var s, beat, root, scale, play;
s = Server.default;
beat = 60 / 82;
root = (48..59).choose.postln;
scale = Scale.choose.degrees.postln;
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};
Synth.tail(nil, \fx, [in: ~fxBus]);
Routine({
	var noteArr;
	noteArr = scale.scramble[0..3];
	noteArr = (noteArr - noteArr.minItem).postln; // set minItem to 0
	loop {
		noteArr.do { |deg|
			var note, length, pan;
			pan = rrand(-1.0, 1.0);
			length = [0.5, 1, 2].choose;
			note = (root + deg + (12 * (-2..2).choose)).midicps;
			play.(\sourceUnison, length, [freq: note, rel: (beat * length * 16), pan: pan, out: ~fxBus])
		}
	};
}).play;
)





///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 3, 9, 1 + 12].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 3, 8, 1 + 12].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 3, 11, 2 + 12].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 4, 7, 2 + 12].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[ 0, 5, 7 - 12, 10 ].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 4 + 12, 6, 11].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

[ 4, 6, 0, 1 ]

(
Synth.tail(nil, \fx, [in: ~fxBus]);
[0, 4 + 12, 6, 1 + 12].do{ |deg|
	Synth(\source, [freq: (42 + (12) + deg).midicps, rel: 10, out: ~fxBus]);
};
)

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////



Scale.aeolian.degrees[0..3];









(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 128;
beat = 60 / bpm;
root = 58;
scale = Scale.aeolian.degrees;
Routine({
	Synth.tail(nil, \phaser, [in: ~fxBus]);
	loop {
		var note, octave;
		octave = [-1, 0, 1, 2].choose;
		note = (root + (12 * octave) + scale.choose).midicps;
		s.bind { Synth(\source, [freq: note, rel: 2, out: ~fxBus]); };
		(beat / 2).wait;
	};
}).play;
)





(
var chord, scale;
scale = Scale.aeolian.degrees;
chord = scale.scramble[0..3];
chord.postln;
)

(
var s, bpm, beat, root, scale, playChord;
s = Server.default;
bpm = 90;
beat = 60 / bpm;
root = 48;
scale = Scale.aeolian.degrees;


playChord = { |root, scale, numTones=3|
	var chord;
	chord = scale.scramble[0..numTones];
	chord.postln;
	chord = chord.collect { |deg| root + deg + (12 * [0, 1, 2].choose) };
	chord.collect(_.midicps);
};

Routine({
	Synth.tail(nil, \phaser, [in: ~fxBus]);
	loop {
		var chord;
		chord = playChord.(root, scale, rrand(1, 3));
		chord.do { |freq|
			s.bind {
				Synth(\source, [freq: freq, rel: 6, out: ~fxBus]);
			};
		};
		(beat * 2).wait;
	};
}).play;
)






