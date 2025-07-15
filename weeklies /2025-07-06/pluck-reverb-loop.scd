// SYNTHS
(
SynthDef(\guitar, {
	var snd, wet, exciter, freq;
	freq = \freq.kr(60);
	exciter = SinOsc.ar(
		Env.perc(0, 0.01).ar.linexp(0, 1, 50, 2300)
	) * Env.perc(0, 0.01).ar;
	snd = Pluck.ar(exciter, Impulse.ar(0), 0.2, 1 / (freq), 20.0, freq.linexp(50, 800, 0.9, 0.3));
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.3));
	wet = ((snd + 0.1) * 8.dbamp).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.linen(0.001, \duration.kr(4), 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
SynthDef(\blip, {
	var snd;
	snd = SinOsc.ar(Env([2300, 6520, 9930], [0.05, 0.05, 0.05], \hold).ar);
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, 0.15, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
// DRUMS
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(46 * (1 + (3 * Env.perc(0, 0.1).ar)) * (1 + (3 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	// snd = LPF.ar(snd, 1200);
	wet = snd + 0.1;
	wet = wet.clip2 + (wet.fold2 * -6.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	snd = snd + (DelayC.ar(snd * -22.dbamp, 0.1, 0.02)) ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(220 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.2, 4.1] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.04, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.12).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.15) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -8.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 20, 2, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.1, 1.6);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.06, 2.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.02, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(15e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd, wet, scale;
	scale = \scale.kr(1.1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), [1420, 1320, 1120, 930] * 1.4, 0.2) * 30.dbamp;
	snd = Splay.ar(snd, 0.5);
	// snd = Mix(snd) * -10.dbamp ! 2;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] * 0.5, -4).ar;
	wet = snd + 0.1;
	wet = (snd * 6.dbamp).tanh;
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd + (DelayC.ar(snd * -25.dbamp, 0.1, 0.02));
	snd = snd + GVerb.ar(snd.mean * -28.dbamp, 10, 1);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 15320, 0.3) * 5.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12320, 0.1) * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.1) * -3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 11320, 0.05) * 3.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, 0.11).ar;
	snd = snd + (DelayC.ar(snd * -25.dbamp, 0.1, 0.02));
	snd = HPF.ar(snd, 900);
	snd = snd + GVerb.ar(snd * -20.dbamp, 4, 3);
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
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
	wet = LPF.ar(wet, 3000);
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


(
~reverbBus = Bus.audio(nil, 2);
~reverbBus2 = Bus.audio(nil, 2);
)
~reverbBus.index;
~reverbBus2.index;


(
var s, beat, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 124;
root = 52;

wait = { |duration=1|
	(beat * duration).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0| // remove seperate duration param here...
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	playParallel.(synthDef, duration, [duration: duration * beat] ++ args, latency);
	wait.(duration);
};

Routine({
	Synth(\reverbFx, [in: ~reverbBus, wet: 1]);
	Synth(\reverbFx, [in: ~reverbBus2, wet: 0.15]);
	loop {
		/*fork {
			1.do {
				play.(\kick, 1, [out: ~reverbBus2]);
				play.(\hat, 1, [out: ~reverbBus2]);
				play.(\clap, 1, [out: ~reverbBus2]);
				// wait.(1);
				play.(\hat, 0.5, [out: ~reverbBus2]);
				/*if(0.5.coin, {
					playParallel.(\blip, 0.5, [out: ~reverbBus]);
				});*/
				play.(\kick, 0.5, [out: ~reverbBus2]);
			}
		};*/
		[
			(deg: 0, length: 1),
			(deg: -12, length: 0.5),
			(deg: 1, length: 1),
			(deg: 8, length: 0.5),
			(deg: 7, length: 1),

		].do { |note|
			var noteHz = (root + note[\deg] + (12 * 1)).midicps;
			play.(\guitar, note[\length], [freq: noteHz, out: ~reverbBus]);
		};
	};
}).play
)



















// endfile