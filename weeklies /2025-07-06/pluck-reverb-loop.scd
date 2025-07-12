// SYNTHS
(
SynthDef(\guitar, {
	var snd, wet, exciter, freq;
	freq = \freq.kr(60);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 50, 2000)
	) * Env.perc(0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, freq.linexp(50, 800, 0.9, 0.3));
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.5));
	wet = ((snd + 0.1) * 8.dbamp).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.linen(0.001, \duration.kr(4), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
// REVERB FROM NATHAN HO SYNTHDEF - DECONSTRUCTING
SynthDef(\reverbFx, {
	var snd, wet;
	snd = In.ar(\in.kr(0), 2);
	wet = snd;
	// 1) Early Reflection Smear
	wet = AllpassC.ar(wet, 0.2, [0.0344, 0.05], 0.1);
	// 2) Feedback Loop Preparation
	wet = [wet[0], wet[1], wet[0], wet[1]] + LocalIn.ar(4);
	// 3) Multi-tap Delay: Diffusion
	wet = DelayC.ar(wet, 1.0, [0.2, 0.343, 0.4335, 0.5242] * 0.2);
	// 4) Modulated Allpass: Dense, Evolving Texture
	wet = AllpassC.ar(wet, 0.2, ([0.12, 0.445, 0.31, 0.38] * 0.03) + (LFNoise2.ar(3 ! 4) * 0.0001), [0.3, 0.5, 0.6, 0.7]);
	// 5) Second Allpass Layer
	wet = AllpassC.ar(wet, 0.2, [0.42, 0.245, 0.11, 0.78] * 0.01, [0.3, 0.5, 0.6, 0.7]);
	// 6) Tone Shaping (EQ)
	wet = wet * -2.dbamp;
	wet = LPF.ar(wet, 6000);
	wet = HPF.ar(wet, 100);
	// 7) Hadamard Matrix: Feedback Mixing
	wet = wet * ([
		[1, 1, 1, 1],
		[1, -1, 1, -1],
		[1, 1, -1, -1],
		[1, -1, -1, 1],
	] / 2);
	wet = wet.sum;
	LocalOut.ar(wet);
	// 8) Stereo Reassembly + Final Delay
	wet = [wet[0] + wet[3], wet[1] + wet[2]];
	wet = DelayC.ar(wet, 0.05, 0.05);
	wet = wet * -5.dbamp * \wet.kr(1).lag(0.1);
	snd = snd + wet;

	Out.ar(\out.kr(0), snd);
}).add;
)


~reverbBus = Bus.audio(nil, 2);
~reverbBus.index;


(
var s, beat, root;
s = Server.default;
beat = 60 / 124;
root = 52;

Routine({
	Synth(\reverbFx, [in: ~reverbBus, wet: 1]);
	loop {
		[
			(deg: 0, length: 1),
			(deg: -12, length: 0.5),
			(deg: 1, length: 1),
			(deg: 8, length: 0.5),
			(deg: 7, length: 1)
		].do { |note|
			var noteHz = (root + note[\deg] + (12 * 1)).midicps;
			s.bind {
				Synth(\guitar, [freq: noteHz, out: ~reverbBus]);

			};
			(note[\length] * beat).wait;
		};
	};
}).play
)



















// endfile