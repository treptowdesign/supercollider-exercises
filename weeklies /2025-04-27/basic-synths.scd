////////////////////////////////////////////////////////
// SynthDefs
////////////////////////////////////////////////////////

(
SynthDef(\square, {
	var snd, freq;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	snd = SinOsc.ar(\vibRate.kr(6), 0, \vibDepth.kr(3), freq);
	snd = Pulse.ar(snd, 0.5);
	snd = MoogFF.ar(snd, Env.perc(0.01, 1).kr.range(4e2, 9e3), 2);
	snd = snd * (SinOsc.ar(8, 0, 0.1, 0.9)); // (mul: 0.1, add: 0.9) = range: 0.8-1
	snd = snd * Env.perc(\atk.kr(0.01), \rel.kr(2)).ar;
	snd = snd * Env.linen(\atk.kr(0.01), \duration.kr(2), 0.1).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.3));
	snd = Limiter.ar(LeakDC.ar(snd));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\square, [freq: 330, duration: 1, bend: 0]);

////////////////////////////////////////////////////////
// Routines
////////////////////////////////////////////////////////

(
var s, beat, root;
s = Server.default;
beat = 60 / 130;
root = 58;
Routine({
	loop {
		[14, 7, 0, 12, -5, 2, 0 ].do { |degree|
			Synth(\square, [
				freq: (root + degree).midicps,
				duration: beat/2,
				bend: [0, -7, 7].wchoose([0.8, 0.1, 0.1]);
			]);
			(beat/2).wait;
		};
	};
}).play;
)