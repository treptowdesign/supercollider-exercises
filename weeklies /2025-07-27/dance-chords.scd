

(
SynthDef(\danceChords, {
	var snd, freq;
	freq = \freq.kr(220) * (LFNoise2.ar(1) * 0.1).midiratio;

	snd = SinOsc.ar(freq * [1,4,8,12], pi / [1,2,3,4]).sum;
	// snd = RLPF.ar(snd, Env.perc(0.2, 0.3).ar.linexp(0, 1, 60, 1000), XLine.kr(0.1, 0.3, 0.3));
	// snd = Latch.ar(snd, Impulse.ar(13350));
	// snd = snd + GVerb.ar(snd * -10.dbamp, 10, 3, 0.8);
	snd = snd + CombC.ar(snd, 0.2, SinOsc.ar(1).range(0, 3e-3), 0);
	snd = snd * Env.perc(0.01, 0.3).ar(Done.freeSelf);

	snd = snd * \amp.kr(0.1) ! 2;

	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

(
[0, 3, 7, 10].do { |deg|
	Synth(\danceChords, [freq: (51 + deg + (12 * -1)).midicps]);
};
)