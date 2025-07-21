(
SynthDef(\shaker, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 40, 0.1);
	snd = BPF.ar(snd, [12120, 16230] * XLine.kr(0.5, 1, 2) * 0.9 * velocity, 0.3).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 0.8, 0.1, 0], [0.1, 0.2, 0.01, 0.1], curve: [2, 0.1, -2]).ar;
	snd = snd * Env.perc(0, 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * 8.dbamp * velocity;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 800 * [3.1, 6.4, 4.5, 6.7, 7.8, 9.3, 10.3], 0.06) * 15.dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = (snd * 4).clip2;
	snd = RHPF.ar(snd, 9320, 0.3) * 6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1).clip(0, 1);
	snd = SinOsc.ar(
		68
		* (1 + (3 * Env.perc(0.0, 0.3, curve: -9).ar * velocity))
		* (1 + (4 * Env.perc(0.0, 0.01, curve: -4).ar * velocity))
		* [1, 2.3, 1.4]
	);
	snd = snd * (Env.perc(0, [3.0, 0.5, 0.1]).ar);
	snd = (snd * [0, -8, -30].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.8 * velocity.sqrt).ar(Done.freeSelf);
	snd = (snd * 5.dbamp * velocity).clip2;
	snd = snd * -6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
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
)

(
~busDelay = Bus.audio(nil, 2);
)

~busDelay.index;

(
var s, beat, bar, root, wait, play;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
root = 56;

wait = { |duration=1|
	(duration).wait;
};

play = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
	wait.(duration);
};

Routine({
	Synth.tail(nil, \fxDelay, [in: ~busDelay, out: 0, beat: beat/2]);
	loop {
		fork {
			// shaker loop
			2.do {
				[1, 0.7, 0.9, 0.8, 0.6, 0.8, 0.9, 0.6].do { |vel, index|
					var late;
					late = if(index % 2 == 1) { 0 } { 0.01 };
					play.(\shaker, beat * 0.5, [velocity: vel, out: ~busDelay], late);
				};
			};

		};
		fork {
			4.do {
				wait.((beat/3) * 2);
				play.(\hat, beat/3);
				/*wait.(beat / 2);
				play.(\hat, beat / 2);*/
			};
		};
		1.do {
			play.(\kick, beat * 2);
			play.(\rim, beat * 2);
		};
	};
}).play;
)