////////////////////////////////////////////////////////
// Reese Bass
////////////////////////////////////////////////////////

(
SynthDef(\reese, {
	var snd, detune;
	detune = (-4..4).linlin(-4, 4, -1, 1); // -1, to 1, intervals of 0.25, includes 0
	snd = LFSaw.ar(\freq.kr(60).lag(0.2) * (detune * 0.1).midiratio, Rand(0.0, 2.0 ! 9));
	snd = RLPF.ar(snd, SinOsc.ar(0.2, (0..8).normalize * 0.6 * 2pi).linexp(-1, 1, 200, 5230), 0.1);
	snd = Splay.ar(snd);
	snd = snd.clip2;
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


~root = 50;
~bass = Synth(\reese, [freq: ~root]);

~bass.set(\freq, ~root);
~bass.set(\freq, ~root * 1/2); // down octave
~bass.set(\freq, ~root * 3/4); // down a 4th (5th below)
~bass.set(\freq, ~root * 3/2); // up 5th


~bass.free;



