(
SynthDef(\fmBass, {
	var snd, freq, noise;
	freq = \freq.kr(50);
	snd = SinOsc.ar(freq) * 220 * Env.perc(0.01, 8, curve: -10).ar;
	snd = SinOsc.ar(freq + snd);
	// snd = snd.clip2;
	// snd = (snd + snd.clip2) * -8.dbamp;
	snd = MoogFF.ar(snd, 800, 0) * 4.dbamp;
	noise = (BPF.ar(BrownNoise.ar.pow(8), freq, 0.1) * 14.dbamp) * Env.perc(0.01, 0.2, curve: 4).ar;
	snd = snd + noise;
	snd = snd * (1 + (0.3 * Env.perc(0, 0.2).ar));
	snd = snd * Env.perc(0.03, 2, curve: -10).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.4);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\fmBass);
Synth(\fmBass, [freq: 40]);
Synth(\fmBass, [freq: 45]);
Synth(\fmBass, [freq: 50]);
Synth(\fmBass, [freq: 80]);
