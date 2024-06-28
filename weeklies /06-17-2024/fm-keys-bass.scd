(
SynthDef(\fmBass, {
	var snd, freq, noise;
	freq = \freq.kr(50);
	snd = SinOsc.ar(freq) * 240 * Env.perc(0.01, 8, curve: -4).ar;
	snd = SinOsc.ar(freq + snd);
	snd = snd.clip2;
	snd = (snd + snd.clip2) * -8.dbamp;
	snd = MoogFF.ar(snd, 800, 0) * 4.dbamp;
	// snd = RLPF.ar(snd, { LFNoise2.kr(3).exprange(100, 400) } ! 2, 0.3).sum * -3.dbamp;
	// snd = snd * AmpComp.ir(freq);
	// snd = snd * Env.adsr(0.03, 5, 0, 1).ar(Done.freeSelf, \gate.kr(1));
	noise = (BPF.ar(BrownNoise.ar.pow(8), freq * 2, 0.1) * 10.dbamp) * Env.perc(0.01, 0.4).ar;
	// snd = snd + noise;
	// snd = noise;
	snd = snd * (1 + (0.3 * Env.perc(0, 0.2).ar));
	snd = snd * Env.perc(0.03, 1.2, curve: -10).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.4);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\fmBass);
Synth(\fmBass, [freq: 40]);
Synth(\fmBass, [freq: 45]);
Synth(\fmBass, [freq: 50]);
Synth(\fmBass, [freq: 100]);

{SinOsc.ar(60) ! 2}.play

(
SynthDef(\808, {
	var snd, freq, noise;
	freq = \freq.kr(50) * (1 + (4 * Env.perc(0.001, 0.04).ar));
	snd = SinOsc.ar(freq) * Line.kr(200, 100, 2.4);
	snd = SinOsc.ar(freq + snd);
	// snd = snd.clip2;
	snd = (snd + snd.clip2) * -8.dbamp;
	snd = MoogFF.ar(snd, 1100, 0) * 4.dbamp;
	noise = (BPF.ar(BrownNoise.ar.pow(8), freq * 2, 0.1) * 5.dbamp) * Env.perc(0.01, 0.04).ar;
	snd = snd + noise;
	snd = snd + (snd.tanh * -6.dbamp) ;
	snd = snd * (1 + (1 * Env.perc(0, 0.2).ar));
	snd = snd * Line.kr(4, 0, 3).dbamp;
	snd = snd * Env.linen(0.03, 0.8, 0.4, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(0.2);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).play;
)