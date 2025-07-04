//////////////////////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	var snd, wet;
	snd = SinOsc.ar(46 * (1 + (3 * Env.perc(0, 0.1).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
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
	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ghostKick, {
	var snd, wet;
	snd = SinOsc.ar(60 * (1 + (4 * Env.perc(0, 0.06).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, 600);
	snd = snd + ((BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.01, 0.02).ar) * -10.dbamp);
	wet = snd + 0.1;
	wet = wet.clip2 + (wet.fold2 * -6.dbamp);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + (DelayC.ar(snd * -16.dbamp, 0.1, [0.03, 0.045]) * -16.dbamp);
	snd = snd * Env.linen(0.0, \duration.kr(0.5), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -16.dbamp;
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
SynthDef(\ride, {
	var snd, freqs, velocity;
	velocity = \velocity.kr(1);
	freqs = ((0..12) ** 0.9).normalize.linexp(0, 1, 4120, 10400);
	snd = Ringz.ar(Hasher.ar(Sweep.ar + freqs) * Env.perc(0.001, 0.01).ar, freqs, 10 * ((freqs.minItem / freqs) ** 1.5) * ExpRand(1, 2 ! freqs.size));
	snd = snd * (freqs.minItem / freqs).squared;
	snd = snd * (1 + LFNoise2.ar(50 * (freqs / freqs.minItem) * (1 + (2 * velocity))));
	snd = snd * (1 + (SinOsc.ar(4000 + (3000 * freqs.sin)) * Env.perc(0, ExpRand(0.5, 2 ! snd.size)).ar));
	snd = snd.sum;
	snd = snd * -35.dbamp;
	snd = snd.tanh;
	snd = snd + (Hasher.ar(Sweep.ar) * Env.perc(0, 0.01).ar * velocity);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -17.dbamp * Env.perc(0.05, 0.5).ar, 3200, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -17.dbamp * Env.perc(0.1, 0.9).ar, 5200, 0.1);
	snd = RHPF.ar(snd, 9120 * ExpRand(0.9, 1.1), 0.4);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 6000, 16200));
	snd = snd + PitchShift.ar(snd, 0.05, 0.72);
	snd = snd + PitchShift.ar(snd, 0.1, 0.6);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3);
	snd = snd * velocity;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.01, 0.001), 2.0, curve: -2).ar;
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.03, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
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
/*SynthDef(\hatRand, {
	var snd, duration, hzRand;
	hzRand = {Rand(-0.3, 0.3).midiratio};
	duration = \duration.kr(1.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 16320 * hzRand, 0.3) * 5.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12320 * hzRand, 0.1) * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320 * hzRand, 0.1) * -3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 13320 * hzRand, 0.05) * 3.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, Rand(0.08, 0.11)).ar;
	snd = snd + GVerb.ar(snd * -20.dbamp, 7, 2);
	snd = snd * Env.linen(0, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * Rand(-14.0, -16.0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;*/
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd * freq.explin(50, 100, 0, -5).dbamp;
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 10).tanh * -5.dbamp, 6000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 3e-4);
	hi = hi * 2.dbamp;
	snd = (snd * 2).tanh + hi;
	snd = snd * -10.dbamp;
	snd = snd * Env.linen(0.0, duration, 0.02, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\keys, {
	var snd, freq, wet;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * 0.1).midiratio * XLine.ar(2, 1, 0.01);
	freq = freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = SinOsc.ar(freq) + HPF.ar(PinkNoise.ar(1), 200);
	snd = snd * SinOsc.ar(LFNoise2.ar(0.5).range(1, 6), 0, 50, 260) * (1 + Env.perc(0, 0.1).ar);
	snd = SinOsc.ar(freq + snd);
	wet = snd + 0.1;
	wet = (snd * 14.dbamp).tanh;
	// wet = LPF.ar(wet, 1200);
	wet = LeakDC.ar(wet);
	snd = XFade2.ar(snd, wet, 0);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 1e-4);
	snd = HPF.ar(HPF.ar(snd, 60), 60);
	snd = snd * Env.perc(0.001, \rel.kr(2.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\saw, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.ar(4) * [0, 0.1]).midiratio;
	snd = Saw.ar(freq * Line.kr(\bend.kr(0), 0, 0.2).midiratio).sum;
	snd = Pan2.ar(snd, 0, 0.2);
	// snd = (snd * 2.dbamp).tanh;
	snd = LPF.ar(snd, 12e3);
	snd = snd * Env.perc(0.001, \rel.kr(3.0), curve: -4).ar;
	snd = snd * Env.linen(0.01, \duration.kr(4.0), 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

// FX
SynthDef(\fxPhaser, {
    var snd, wet, lfo, delay;
	delay = \delay.kr(1e-4);
	snd = In.ar(\in.kr(0), 2);
	lfo = { |rate=1, phase=0| SinOsc.ar(rate, phase, delay, delay + 1e-6) };
	wet = snd;
	8.do { wet = AllpassL.ar(wet, 0.2, lfo.(\speed.kr(0.5), Rand(0.0, 0.5) * pi), \fb.kr(0)); };
	snd = XFade2.ar(snd, wet, \mix.kr(0), \amp.kr(1));
	// reverb
	wet = GVerb.ar(snd.mean * \gain.kr(-16).dbamp, \size.kr(20), \revtime.kr(4), \damp.kr(0.8));
	snd = XFade2.ar(snd, wet, 0, 1);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxDrums, {
    var snd, wet;
	snd = In.ar(\in.kr(0), 2);
	wet = GVerb.ar(snd.mean * \gain.kr(-16).dbamp, \size.kr(20), \revtime.kr(4), \damp.kr(0.8));
	snd = XFade2.ar(snd, wet, 0, 1);
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(1));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.9 * Env.perc(0, 0.2, curve: 2).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;


)
//////////////////////////////////////////////////////////////////////
// Busses
//////////////////////////////////////////////////////////////////////


(
~sidechainBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
~phaserBus = Bus.audio(nil, 2);
)

~sidechainBus.index;
~drumsBus.index;
~phaserBus.index;

//////////////////////////////////////////////////////////////////////
// Patterns
//////////////////////////////////////////////////////////////////////

(
var s, beat, root;
s = Server.default;
beat = 60 / 118;
root = 58;

Routine({
	var loopIndex, sidechainFx, duck, wait, playParallel, play;
	loopIndex = 0;

	Synth.tail(nil, \fxPhaser, [
		in: ~phaserBus, out: 0, mix: 0, amp: 1,
		delay: 3e-4, speed: 1, fb: 0.03
	]);
	Synth.tail(nil, \fxDrums, [
		in: ~drumsBus, out: 0, amp: 1
	]);
	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);

	duck = {
		s.bind { sidechainFx.set(\trigger, 1) };
	};
	wait = { |duration=1|
		(beat * duration).wait;
	};
	playParallel = { |synthDef, duration, args = #[], latency = 0.0|
		fork {
			latency.wait;
			s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
		};
	};
	play = { |synthDef, duration, args = #[], latency = 0.0|
		playParallel.(synthDef, duration, args, latency);
		wait.(duration);
	};

	loop {
		loopIndex.postln;
		fork {
			4.do {
				// play.(\hat, 0.5, latency: 0);
				/*wait.(1);
				play.(\hat, 0.25, latency: 0);
				play.(\hat, 0.25, latency: 0);
				play.(\hat, 0.25, latency: 0);
				play.(\hat, 0.25, latency: 0);*/
				// wait.(0.5);
				// play.(\hat, 0.5, latency: 0);
				wait.(0.5);
				play.(\hat, 0.5, latency: 0.01);
				play.(\hat, 0.5, latency: 0.01);
				play.(\hat, 0.5, latency: 0.01);
			};
		};
		fork {
			play.(\ride, 8);
		};
		fork {
			var oct, outBus;
			// oct = (12 * if(loopIndex % 2 == 0, { -1 }, { 0 }));
			oct = (12 * -1);
			outBus = ~phaserBus;
			wait.(1);
			play.(\saw, 1, [freq: (root + oct).midicps, out: outBus, bend: -12]);
			play.(\saw, 0.5, [freq: (root + oct + 12.neg).midicps, out: outBus]);
			play.(\saw, 0.5, [freq: (root + oct + 5.neg).midicps, out: outBus]);
			play.(\saw, 0.5, [freq: (root + oct + 2).midicps, out: outBus]);
			wait.(0.5);
			play.(\saw, 0.5, [freq: (root + oct + 7).midicps, out: outBus, bend: -12]);
			play.(\saw, 0.5, [freq: (root + oct + 3).midicps, out: outBus]);
			play.(\saw, 0.5, [freq: (root + oct + 2.neg).midicps, out: outBus]);
			wait.(0.5);
			play.(\saw, 0.5, [freq: (root + oct + 3).midicps, out: outBus, bend: -12]);
			play.(\saw, 0.5, [freq: (root + oct).midicps, out: outBus]);
			play.(\saw, 0.5, [freq: (root + oct + 5.neg).midicps, out: outBus]);
		};
		2.do {
			playParallel.(\sub, 4, [freq: (root + -24).midicps, out: ~sidechainBus]);
			duck.();
			play.(\kick, 1);
			if(0.5.coin, {
				wait.(0.5);
				duck.();
				play.(\kick, 0.5);
			}, {
				wait.(1);
			});
			play.(\snare, 1, latency: 0);
			if(0.5.coin, {
				wait.(0.5);
				playParallel.(\sub, 0.5, [freq: (root + 5 + -24).midicps, out: ~sidechainBus]);
				duck.();
				play.(\kick, 0.5);
			}, {
				if(0.5.coin, {
					wait.(0.5);
					play.(\clap, 0.25, latency: 0);
					play.(\clap, 0.25, latency: 0.006);
				}, {
					wait.(0.5);
					play.(\clap, 0.5, latency: 0);
				});
			});
		};

		loopIndex = loopIndex + 1;
	};

}).play;
)





//////////////////////////////////////////////////////////////////////
// Endfile
//////////////////////////////////////////////////////////////////////