/////////////////////////////////////////////
// Synths
/////////////////////////////////////////////
(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.5]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar;
	snd = snd * [0, -8, -13].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4230, 0.3) * Env.perc(0.07, 0.15).ar * -15.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230, 0.3) * Env.perc(0.05, 0.07).ar * -12.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1230, 0.3) * Env.perc(0.01, 0.03).ar * -5.dbamp);
	snd = snd * (1 + (10 * Env.perc(0.0, 0.02).ar));
	snd = snd.tanh;
	snd = snd * 1.dbamp;
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick2, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(50 * ((Env.perc(0, 0.1).ar * [30, 20, 10, 20]) + (Env.perc(0, 0.02).ar * 10)).midiratio * [1, 2.3, 3.4, 5.3]);
	snd = snd * Env.perc(0.0, 0.3 * [1, 0.5, 0.2, 0.1]).ar(Done.none);
	snd = snd * [0, -5, -6, -5].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6120, 0.3) * Env.perc(0.05, 0.1).ar * -25.dbamp);
	snd = snd * velocity.sqrt;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = (snd * 13.dbamp).tanh;
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = snd * velocity.sqrt;
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2100), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ghostKick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 50, 400) * [1, 2.4, 3.5]);
	snd = snd * Env.perc(0.0, [1, 0.3, 0.05]).ar;
	snd = snd * [0, -8, -13].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4230, 0.3) * Env.perc(0.07, 0.15).ar * -15.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230, 0.3) * Env.perc(0.05, 0.07).ar * -12.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1230, 0.3) * Env.perc(0.01, 0.03).ar * -5.dbamp);
	snd = snd * (1 + (1 * Env.perc(0.0, 0.02).ar));
	snd = snd.tanh;
	snd = LPF.ar(snd, 5120);
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 0.08).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(830 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
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
SynthDef(\rimAlt, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(920 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd * [0, -3, 1, -5, 2, 0, 0].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.15, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.035, 1.6);
	snd = snd + PitchShift.ar(snd * -6.dbamp, 0.015, 2.23);
	snd = snd * -7.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd * Env.perc(0.0, 0.5).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\rimSplashy, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(720 * [0.54, 0.3, 0.7, 0.73, 1.4, 2.35, 3.9] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.002, 0.05).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = (snd * 5.dbamp).tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -1.dbamp, 0.025, 1.2);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -4.dbamp, 0.015, 1.83);
	snd = snd * -7.dbamp;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd * Env.linen(0.0, \duration.kr(0.3), 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\ghostRim, {
	var snd;
	snd = SinOsc.ar(920 * [0.34, 0.43, 0.5, 0.91, 1.3, 1.45, 1.7]);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3230, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2630, 0.4) * Env.perc(0.03, 0.01).ar * 1.dbamp);
	snd = snd.tanh;
	snd = LPF.ar(snd, 4120);
	snd = HPF.ar(snd, 520);
	snd = snd * -5.dbamp;
	snd = snd ! 2;
	snd = snd * Env.perc(0.02, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [60, 230, 345], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 10342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Splay.ar(snd, 0.3);
	snd = snd * -23.dbamp;
	snd = snd * Env.perc(0.02, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [70, 330, 445], 0.3);
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = BPF.ar(snd, [5430, 7342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -30.dbamp;
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat3, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [90, 430, 145], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 9342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0.3));
	snd = snd * -27.dbamp;
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat4, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 90);
	snd = BPF.ar(snd, [12240, 6230, 10832, 9830, 8320], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -18.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\crash, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = CombC.ar([snd], 0.2, 1 / [90, 123, 140]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 320);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 1.0, curve: -4).ar;
	snd = HPF.ar(snd, 930);
	snd = snd + GVerb.ar(snd.sum * -2.dbamp, 30, 20, damping: 0.1);
	snd = LeakDC.ar(snd);
	snd = snd * -25.dbamp;
	snd = snd * Env.perc(0.01, 10.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = RHPF.ar(snd, 1600, 0.6) * 2.dbamp;
	snd = LPF.ar(snd, 5200);
	snd = snd * Env([0, 2, 0.1, 1, 0.1, 1, 0.1, 0], [0.001, 0.01, 0.003, 0.01, 0.003, 0.08, 0.2] * 0.5, curve: -2).ar ** 1.6;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -26.dbamp, 10, 1, 0.9);
	snd = snd * Env.linen(0, 0.2, 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, freq, freqs;
	freq = \freq.kr(58);
	snd = SinOsc.ar(freq * [1, 3]);
	snd = snd * [0, -16].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * -6.dbamp;
	snd = snd * Env.linen(0.05, \duration.kr(1.0) - 0.05, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub2, {
	var snd, freq, freqs;
	freq = \freq.kr(58);
	snd = SinOsc.ar(freq * [1, 2]);
	snd = snd * [0, -10].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.1).ar));
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * -6.dbamp;
	snd = snd * Env.linen(0.05, \duration.kr(1.0) - 0.05, 0.05, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
// FX //////////////////////////////////
SynthDef(\sidechainFx, {
	var snd, trigger;
	trigger = T2A.ar(\trigger.tr(0));
	snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (0.4 * Env.perc(0.01, 0.1, curve: 4).ar(gate: trigger)));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\drumsFx, {
	var snd, compressed;
	snd = In.ar(\in.kr(0), 2);
	// reverb
	snd = (snd + LPF.ar(HPF.ar(GVerb.ar(snd.sum * -40.dbamp, 10, 1), 100), 3000)) * -2.dbamp;
	// saturate mids (200-3200)
	snd = BLowShelf.ar(snd, 200, 0.3, -3);
	snd = BHiShelf.ar(snd, 3200, 0.3, -3);
	snd = (snd * 10.dbamp).tanh;
	snd = BLowShelf.ar(snd, 200, 0.3, 3);
	snd = BHiShelf.ar(snd, 3200, 0.3, 3);
	// parallel compression
	compressed = Compander.ar(
        snd,              // input signal
        snd,              // control signal
        thresh: 0.5,            // threshold level
        slopeBelow: 1,          // ratio below threshold
        slopeAbove: 0.3,        // ratio above threshold (0.3 = strong compression)
        clampTime: 0.01,        // attack time
        relaxTime: 0.1          // release time
    );
	snd = XFade2.ar(snd, compressed * 1.dbamp, 0);
	// level adjust
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\formantSwarmPulse, {
	arg amp = 0.2, vowel = 1, vowelB = 3, gate = 1;
	var source, count, freq, env, formants, formantsB, filtered, high;

	count = 8;
	freq = \freq.kr(58) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	source = LFPulse.ar(freq * (({LFNoise2.kr(0.5) }! count) * 0.1).midiratio, {Rand(0, 2pi) } ! count);

	high = (Pulse.ar(\freq.kr(58) * [4, 8]) * [1, 0.1] * amp).mean ! 2;

	// source = Splay.ar(source) * -8.dbamp;
	source = Mix(source) * -14.dbamp;

	formants = Select.kr(vowel.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);
	formantsB = Select.kr(vowelB.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);

	filtered = Mix.new([
		BPF.ar(source, SinOsc.kr(0.1).range(formants[0], formantsB[0]), 0.04),
		BPF.ar(source, SinOsc.kr(0.1).range(formants[1], formantsB[1]), 0.04),
		BPF.ar(source, SinOsc.kr(0.1).range(formants[2], formantsB[2]), 0.04)
	]) * 28.dbamp;

	filtered = HPF.ar(filtered, 200);
	filtered = RLPF.ar(filtered, Env.perc(0.001, 0.4, curve: -2).kr.range(200, 6240), 0.2);
	filtered.tanh;

	env = XLine.kr(1, 0.6, \duration.kr(1)) * Env.linen(0.01, \duration.kr(1), 0.1).ar(Done.freeSelf);
	// filtered = (filtered ) * env * amp;
	filtered = (filtered + high) * env * amp;

	Out.ar(0, Pan2.ar(filtered));
}).add;
)

Synth(\kick);
Synth(\kick2);
Synth(\ghostKick);
Synth(\rim);
Synth(\rimAlt);
Synth(\rimSplashy);
Synth(\ghostRim);
Synth(\hat);
Synth(\hat2);
Synth(\hat3);
Synth(\hat4);
Synth(\crash);
Synth(\clap);
Synth(\sub, [freq: 58]);



/////////////////////////////////////////////
// Bussing
/////////////////////////////////////////////

(
~sidechainBus = Bus.audio(nil, 2);
~drumsBus = Bus.audio(nil, 2);
)
~sidechainBus.index;
~drumsBus.index;




/////////////////////////////////////////////
// Routine
/////////////////////////////////////////////

(
var s, beat, tatum, playP, play, wait;
s = Server.default;
beat = 60 / 170;
tatum = beat / 4;

playP = { |synthDef, durationInTatums, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: durationInTatums * tatum] ++ args) };
	};
};

play = { |synthDef, durationInTatums, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: durationInTatums * tatum] ++ args) };
	};
	(durationInTatums * tatum).wait;
};

wait = { |durationInTatums|
	(durationInTatums * tatum).wait;
};

Routine({
	var sidechainFx, drumsFx, pump;

	sidechainFx = Synth.tail(nil, \sidechainFx, [in: ~sidechainBus, out: 0]);
	drumsFx = Synth.tail(nil, \drumsFx, [in: ~drumsBus, out: 0]);

	pump = {
		s.bind { sidechainFx.set(\trigger, 1) };
	};

	fork {
		loop {
			play.(\hat, 2, [out: ~drumsBus]);
			play.(\hat2, 2, [out: ~drumsBus]);
			play.(\hat2, 1, [out: ~drumsBus]);
			play.(\hat2, 1, [out: ~drumsBus]);

			play.(\hat, 1, [out: ~drumsBus]);
			play.(\hat3, 1, [out: ~drumsBus]);
			play.(\hat2, 2, [out: ~drumsBus]);

			play.(\hat, 1, [out: ~drumsBus]);
			play.(\hat3, 1, [out: ~drumsBus]);
			play.(\hat4, 2, [out: ~drumsBus]);

			play.(\hat, 1, [out: ~drumsBus]);
			play.(\hat3, 1, [out: ~drumsBus]);
			play.(\hat4, 2, [out: ~drumsBus]);
		};
	};
	fork {
		loop {
			playP.(\sub2, 6, [freq: 55, out: ~sidechainBus]);
			pump.();
			play.(\kick, 12, [out: ~drumsBus]);
			play.(\ghostKick, 4, [out: ~drumsBus]);

			playP.(\sub2, 6, [freq: 55, out: ~sidechainBus]);
			pump.();
			play.(\kick, 8, [out: ~drumsBus]);
			play.(\ghostKick, 4, [out: ~drumsBus]);
			playP.(\sub2, 4, [freq: 55, out: ~sidechainBus]);
			pump.();
			play.(\kick, 4, [out: ~drumsBus]);
		};
	};
	fork {
		loop {
			wait.(8);
			playP.(\clap, 8, [out: ~drumsBus], latency: 0.04);
			play.(\rim, 8, [out: ~drumsBus]);
			wait.(6);
			playP.(\clap, 8, [out: ~drumsBus]);
			wait.(2);
			playP.(\clap, 8, [out: ~drumsBus], latency: 0.04);
			play.(\rim, 8, [out: ~drumsBus]);
		};
	};
	fork {
		loop {
			[
				(degree: 12, length: 2, bend: -7, vowels: [0, 4]),
				(degree: 0, length: 1, bend: 0, vowels: [0, 1]),
				(degree: 8, length: 2, bend: 0, vowels: [2, 1]),
				(degree: 0, length: 1, bend: 7, vowels: [3, 4]),
				(degree: 7, length: 2, bend: 0, vowels: [4, 2]),

				(degree: 12, length: 2, bend: -7, vowels: [0, 4]),
				(degree: 0, length: 1, bend: 0, vowels: [0, 1]),
				(degree: 8, length: 2, bend: 0, vowels: [2, 1]),
				(degree: 0, length: 1, bend: 7, vowels: [3, 4]),
				(degree: 7, length: 1, bend: 0, vowels: [4, 2]),
				(degree: 7, length: 1, bend: 0, vowels: [0, 4]),
			].do { |note|
				s.bind {
					Synth(\formantSwarmPulse, [
						freq: (30 + note[\degree]).midicps,
						duration: beat * note[\length],
						bend: note[\bend],
						amp: 0.075,
						vowel: note[\vowels][0],
						vowelB: note[\vowels][1]
					]);
				};
				(beat * note[\length]).wait;
			};
		};
	};

}).play;
)


30 + 25


















// endfile...