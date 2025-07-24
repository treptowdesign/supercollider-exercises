(
SynthDef(\shaker, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 60, 0.1);
	snd = BPF.ar(snd, [12120, 16230] * XLine.kr(0.5, 1, 2) * 0.8 * velocity, 0.3).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.1, 0.1, 0.01, 0.1], curve: [2, 0.1, -2]).ar;
	snd = snd * Env.perc(0, 0.35 * velocity, curve: -8).ar(Done.freeSelf);
	snd = snd * 6.dbamp * velocity;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 600 * [3.1, 6.4, 4.5, 6.7, 7.8, 9.3, 10.3], 0.06) * 15.dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = (snd * 4).clip2;
	snd = RHPF.ar(snd, 9320, 0.3) * 4.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.1).ar(Done.freeSelf);
	snd = snd * -6.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
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
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1700, 0.3) * -3.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.005, 0.01, 0.005, 0.01, 0.005, 0.1, 0.15], curve: -2).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -25.dbamp, 30, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(920 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -7.dbamp;
	snd = snd * Env.perc(0.0, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
//
SynthDef(\pad, {
	var snd, freq, fb, duration;
	duration = \duration.kr(5.0);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (LFNoise2.ar(3 ! 8) * 0.2).midiratio * [1, 2, 1, 2, 2, 1, 2, 1], LFNoise2.ar(3 ! 8).linlin(-1, 1, 0.1, 0.9));
	snd = snd * LFNoise2.ar(8 ! snd.size).linlin(-1, 1, 0.5, 1);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, freq * XLine.ar(1, 3, duration));
	snd = ((snd + 0.1) * 4.dbamp).tanh;
	snd = LeakDC.ar(snd);
	snd = snd + DelayC.ar(snd * -8.dbamp, 0.2, SinOsc.ar(Rand(0.1, 0.3), [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-4);
	snd = snd * freq.explin(100, 4000, 0, -8).dbamp;
	snd = snd * -14.dbamp * \amp.kr(1);
	snd = snd * Env.linen(duration * 0.2, duration * 0.6, duration * 0.2, curve: -8).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(60));
	snd = snd * \freq.kr(60).explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 6).tanh * -5.dbamp, 4000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -3.dbamp * \amp.kr(1);
	snd = snd * Env.linen(0.0, duration * 0.9, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
// fx
SynthDef(\fxDelay, {
	var snd, fb, beat;
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	fb = snd;
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 1.0, (beat) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 2e-3));
	fb = fb * -5.dbamp;
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 500);
	LocalOut.ar(fb);
	snd = snd + fb;
	Out.ar(\out.kr(0), snd);
}).add;
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
~busDelay = Bus.audio(nil, 2);
~reverbBus = Bus.audio(nil, 2);
~percBus = Bus.audio(nil, 2);
)

~busDelay.index;
~reverbBus.index;
~percBus.index;

(
var s, beat, bar, root, wait, playParallel, play;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
root = 56;

wait = { |duration=1|
	(duration).wait;
};
playParallel = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
};
play = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
	wait.(duration);
};

Routine({
	Synth.tail(nil, \fxDelay, [in: ~busDelay, out: ~reverbBus, beat: beat/4]);
	Synth.tail(nil, \reverbFx, [in: ~reverbBus, wet: 0.65]);
	Synth.tail(nil, \reverbFx, [in: ~percBus, wet: 0.06]);
	loop {
		fork {
			// shaker loop
			4.do {
				[1, 0.8, 0.95, 0.8, 0.8, 0.8, 0.9, 0.75].do { |vel, index|
					var late;
					late = if(index % 2 == 1) { 0.02 } { 0 };
					play.(\shaker2, beat * 0.5, [velocity: vel, out: ~reverbBus], late);
				};
			};

		};
		fork {
			[
				// b2 major (prygian) =================================
				(notes: (1 + [0, 4, 7, 11]), length: 3),
				(notes: (1 + [0, 4, 7, 11]), length: 1),
				// 2 dim ==============================================
				/*(notes: (2 + [0, 3, 6, 10]), length: 3),
				(notes: (2 + [0, 3, 6, 10]), length: 1),*/
				// 4 min =================================
				/*(notes: (5 + [-2, 0, 3, 7]), length: 3),
				(notes: (5 + [-2, 0, 3, 7]), length: 1),*/
				// 5 min ==============================================
				(notes: (7 + [-5, -2, 0, 3]), length: 3),
				(notes: (7 + [-5, -2, 0, 3]), length: 1),
				// b7 min ===========================================
				/*(notes: (10 + [-9, -5, -2, 0]), length: 3),
				(notes: (10 + [-9, -5, -2, 0]), length: 1),*/
				// 1 sus2 =============================================
				(notes: (0 + [0, 2, 7, 10]), length: 3),
				(notes: (0 + [0, 2, 7, 10]), length: 1),
				// 1 minor ============================================
				(notes: (0 + [0, 3, 7, 10]), length: 3),
				(notes: (0 + [0, 3, 7, 10]), length: 1),
			].do { |chord|
				chord[\notes].sort.do { |deg, index|
					[
						(octave: 2, amp: 0.6),
						(octave: 1, amp: 0.9),
						(octave: 0, amp: 0.5)
					].do { |voice|
						playParallel.(\pad, (chord[\length] * beat), [
							freq: (root + (12 * voice[\octave]) + deg).midicps,
							amp: (1 / (1 + index).cbrt) * voice[\amp],
							// amp: 1 * voice[\amp],
							duration: (chord[\length] * beat),
							out: ~reverbBus
						]);
					};
				};
				/*playParallel.(\sub, chord[\length] * beat, [
					freq: (root + chord[\notes].sort[0] + (12 * -1)).midicps,
					amp: 1
				]);*/
				wait.(chord[\length] * beat);
			};
		};
		4.do {
			play.(\kick, beat, [out: ~percBus]);
			// wait.(beat/3);
			play.(\hat, beat/3 * 2, [out: ~busDelay], 0.01);
			play.(\kick, beat/3, [out: ~percBus]);
			playParallel.(\clap, beat, [out: ~percBus]);
			play.(\rim, beat, [out: ~percBus]);
			play.(\hat, beat/3 * 2, [out: ~busDelay], 0.01);
			play.(\kick, beat/3, [out: ~percBus]);
		};
		// wait.(beat * 16);
	};
}).play;
)