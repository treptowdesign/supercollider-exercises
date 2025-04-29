////////////////////////////////////////////////////////
// SynthDefs
////////////////////////////////////////////////////////

(
SynthDef(\square, {
	var snd, freq;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	snd = SinOsc.ar(\vibRate.kr(6), 0, \vibDepth.kr(4), freq);
	snd = Pulse.ar(snd, 0.5);
	snd = MoogFF.ar(snd, Env.perc(0.01, 2).kr.range(100, 9e3), 2);
	snd = snd * (SinOsc.ar(7).range(1, 0.8));
	snd = snd * Env.perc(\atk.kr(0.01), \rel.kr(2)).ar;
	snd = snd * Env.linen(\atk.kr(0.01), \duration.kr(2), 0.1).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.3));
	Out.ar(\out.kr(0), snd);
}).play;
)

////////////////////////////////////////////////////////
// Routines
////////////////////////////////////////////////////////