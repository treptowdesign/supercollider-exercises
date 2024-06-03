(
SynthDef(\riser, {
	var snd, freq, amp, lfo, duration;
	freq = \freq.kr(60);
	amp = \amp.kr(-10);
	duration = \duration.kr(2);
	lfo = Pulse.kr(Line.kr(4, 10, duration));
	snd = Pulse.ar(freq * XLine.kr(1, 8, duration), lfo.range(0.2, 0.6)) * lfo;
	snd = MoogFF.ar(snd, XLine.kr(60, 14e3, duration), 2);
	snd = GVerb.ar(snd, 10, 3, 0.2);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, 0));
}).play;
)

(
SynthDef(\pitch, {
	var snd, amp;
	amp = \amp.kr(-10);
	snd = SinOsc.ar(
		60
		* (1 + (4 * Env.perc(0, 0.02).ar))
		* (1 + (6 * Env.perc(0, 0.2).ar))
	);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, 0));
}).play;
)