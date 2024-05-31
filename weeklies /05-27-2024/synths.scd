(
SynthDef(\clown, {
	var snd, freqs;
	freqs = \freq.kr(440) * ((-5..5) * 0.1).midiratio;
	snd = LFSaw.ar(freqs, { Rand(0, 2) } ! freqs.size);
	snd = Splay.ar(snd);
	snd = snd * 0.dbamp;
	snd = snd * Env.adsr(0.001, 0.03, 0.7, 0.02).ar(Done.none, \gate.kr(1));
	snd = snd + (GVerb.ar(snd.sum, 20, 3) * -10.dbamp);
	snd = snd * Env.asr(0.0, 1, 1, curve: -8).ar(Done.freeSelf, Impulse.kr(0) + \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass, {
	var snd, dry;
	snd = SinOsc.ar(225 / 4);
	dry = snd;
	snd = (snd * 10).fold2;
	snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 5e-3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -20.dbamp, 8000, 0.3);
	snd = (snd * 1.2).wrap2 ** 3;
	snd = MoogFF.ar(snd, 12000, 0);
	snd = Splay.ar(snd, 0.3);
	snd = ((dry * 10) + 0.1).tanh + HPF.ar(snd * 12.dbamp * (Line.kr(0, 1, 0.18) ** 4), 3000);
	snd = snd * -2.dbamp;
	snd = snd * Env.asr(0.13, 1, 0.005, curve: 4).ar(Done.freeSelf, Impulse.kr(0) + \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\vocal, {
	var snd, duration;
	duration = 0.09;
	snd = Pulse.ar(50);
	snd = RLPF.ar(snd, XLine.kr([1520, 1820], [820, 3200], duration), 0.05);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd * (1 + (10 * Env.perc(0.001, 0.01).ar));
	snd = snd * Env.linen(0.0, duration, 0.001).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\vocal2, {
	var snd, duration;
	duration = 0.08;
	snd = Pulse.ar(50);
	snd = RLPF.ar(snd, XLine.kr([820, 3200], [1520, 1820], duration), 0.05);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd * (1 + (10 * Env.perc(0.001, 0.01).ar));
	snd = snd * Env.linen(0.0, duration, 0.001).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr, snd);
}).play;
)

(
SynthDef(\pad, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * [-0.1, 0, 0.1].midiratio * [1, 2, 1]);
	snd = RLPF.ar(snd, LFNoise2.kr(3).linexp(-1, 1, 100, 3000), 0.3);
	snd = (snd * 1.3).tanh;
	snd = snd * Env.linen(0.3, duration, 0.3, curve: -4).ar(Done.freeSelf);
	snd = snd * -25.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\acid, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2] * XLine.ar(2, 1, 0.01)).sum;
	snd = MoogFF.ar(snd, 400 * ExpRand(0.5, 2) * (Env.perc(0, duration * Rand(0.3, 3), curve: -4).ar * 12 * Rand(3, 8)).midiratio, 2) * 5.dbamp;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * 5.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.3, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\acid2, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * XLine.ar(2, 1, 0.01) * [1, 2]);
	snd = (snd * [1, 0.5]).sum;
	snd = MoogFF.ar(snd, { ExpRand(1000, 8000) } ! 3 * XLine.kr(2, 1, ExpRand(0.1, 0.9)), 3.4).sum * 7.dbamp;
	snd = snd.fold2;
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -3.dbamp;
	// Out.ar(\reverbBus.kr(0), snd);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 4] * (LFNoise2.kr(10 ! 3) * 0.1).midiratio);
	snd = snd * Env.perc(0, [5, 10, 1]).ar;
	snd = snd * [-5, 0, -9].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum;
	snd = LPF.ar(snd, XLine.ar(8000, 100, 3.0));
	snd = snd * Select.ar(Sweep.ar > 0.02, [ToggleFF.ar(Dust.ar(200)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.linen(0.0, duration, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
Synth(\organ, [freq: (42 + 0).midicps]);
Synth(\organ, [freq: (42 + 9).midicps]);
Synth(\organ, [freq: (42 + 14).midicps]);
)



(
SynthDef(\lead, {
	var snd, freq, n, intensity;
	freq = \freq.kr(440).lag(0.02);
	intensity = LFNoise2.kr(3).linlin(-1, 1, 0, 1) * Line.kr(0, 1, 10);
	n = (1..32);
	snd = SinOsc.ar(freq * n * (LFNoise2.kr(8 * (1 + intensity)) * 0.5 * intensity).midiratio);
	snd = snd * (n.pow(1.3) * (LFNoise2.kr(1).linexp(-1, 1, 1, 1.1)) + (3 * LFNoise2.ar(intensity.linexp(0, 1, 1, 2)))).cos.pow(10);
	snd = snd * (1 + LFNoise2.ar(3 * n.sqrt));
	snd = snd / n;
	snd = snd.sum;
	snd = LPF.ar(snd, intensity.linexp(0, 1, 1000, 16e3));
	snd = snd * (1 + (LFNoise2.ar(LFNoise2.ar(3).linexp(-1, 1, 1, 16)) * 0.5));
	snd = snd * intensity.linlin(-1, 1, 0.2, 1);
	snd = snd * 10.dbamp;
	snd = snd.tanh;
	snd = PitchShift.ar(snd, 0.3, 0.5) * 10.dbamp;
	snd = snd + GVerb.ar(snd * -10.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.asr(0.5, 1.0, 3.0, curve: -4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

