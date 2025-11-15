////////////////////////////////////////////////////////
// Reese Bass
////////////////////////////////////////////////////////

(
SynthDef(\reese, {
	var snd, detune;
	detune = (-4..4).linlin(-4, 4, -1, 1); // -1, to 1, intervals of 0.25, includes 0
	snd = LFSaw.ar(\freq.kr(60).lag(0.1) * (detune * 0.1).midiratio, Rand(0.0, 2.0 ! 9));
	snd = RLPF.ar(snd, SinOsc.ar(0.2, (0..8).normalize * 0.1 * 2pi).linexp(-1, 1, 200, 5230), 0.1);
	snd = Splay.ar(snd);
	snd = snd.clip2;
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


~root = 65.75;
~bass = Synth(\reese, [freq: ~root]);

~bass.set(\freq, ~root);
~bass.set(\freq, ~root * 1/2); // down octave
~bass.set(\freq, ~root * 3/4); // down a 4th (inverted 5th)
~bass.set(\freq, ~root * 3/2); // up 5th
~bass.set(\freq, ~root * 16/15); // up b2nd
~bass.set(\freq, ~root * 6/5/2); // up b3rd


~bass.set(\freq, ~root * 4/3); // up 4th
~bass.set(\freq, ~root * 17/16); // up ~ 2b
~bass.set(\freq, ~root * 3/2); // up 5th




~bass.free;



