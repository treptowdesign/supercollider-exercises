




(
SynthDef(\src, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq, 0, -14.dbamp);
	snd = snd * Env.perc(0.001, 3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\src2, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq, 0, -14.dbamp);
	snd = snd * Env.perc(0.001, 3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\src3, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * 2, 0, 0.4);
	snd = SinOsc.ar(freq * 2, snd.mod(2pi), 0.2);
	snd = SinOsc.ar(freq, snd.mod(2pi), -14.dbamp);
	snd = snd * Env.perc(0.001, 3).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;
)



(0..9).choose;


(
SynthDef(\kick, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(Env.perc(0, 0.14, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 200)) * XLine.ar(1.05, 1, 0.2));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar;
	snd = LPF.ar(snd, XLine.ar(300, 100, 0.2));
	hi = snd;
	hi = hi * (1 + (LPF.ar(LPF.ar(RHPF.ar({ PinkNoise.ar } ! 2, 1230, 0.5), 2e3), 7e3) * -5.dbamp));
	hi = (hi * 10).tanh;
	hi = hi + DelayC.ar(hi * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	hi = HPF.ar(hi, 2500);
	hi = LPF.ar(hi, 8000);
	hi = hi * -10.dbamp;
	snd = (snd * 0.9).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd + hi;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\blip, {
	var freq, duration, env, snd, trig;
	duration = \duration.kr(2);
	trig = Impulse.kr(XLine.kr(16, 4, duration));
	freq = \freq.kr(260) * TRand.kr(1, 8, trig);
	env = Env.perc(0.01, duration, curve: -2).ar(Done.freeSelf);
	snd = Pulse.ar(freq, 0.5, -14.dbamp);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)



(
SynthDef(\blip, { | pattern = #[1, 8, 3, 1, 3] |
	var freq, duration, env, snd, trig;
	duration = \duration.kr(2);
	trig = Impulse.kr(XLine.kr(16, 4, duration));
	freq = \freq.kr(260) * Demand.kr(trig, 0, Dseq(pattern, inf));
	env = Env.perc(0.01, duration, curve: -2).ar(Done.freeSelf);
	snd = Pulse.ar(freq, 0.5, -14.dbamp);
	snd = snd + PitchShift.ar(snd, 0.15, 0.5);
	snd = snd + CombC.ar(snd * -8.dbamp, 0.2, 1 / 71, 0.2);
	snd = snd + CombC.ar(snd * -8.dbamp, 0.2, 1 / 54, -0.25);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)


Synth(\blip, [freq: 380, pattern: [1,0.5,3,7,5,4]]);


Synth(\blip, [freq: 380, pattern: [1,10,1,9,1,12]]);


(
SynthDef(\blip, { | pattern = #[1, 8, 3, 1, 3, 0.5] |
	var freq, duration, env, snd, trig;
	duration = \duration.kr(2);
	trig = Impulse.kr(Line.kr(16, 4, duration));
	freq = \freq.kr(130) * Demand.kr(trig, 0, Dseq(pattern, inf));
	env = Env.perc(0.01, duration, curve: -2).ar(Done.freeSelf);
	snd = Pulse.ar(freq.lag(0.01), 0.5, -10.dbamp);
	// snd = LeakDC.ar(snd);
	snd = snd + PitchShift.ar(snd, 0.15, 0.5);
	snd = snd + CombC.ar(snd * -4.dbamp, 0.1, 1 / 78, 0.18);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)


Synth(\blip, [freq: 36.midicps]);
Synth(\blip, [freq: 39.midicps]);
Synth(\blip, [freq: 38.midicps]);



snd = snd + (FreqShift.ar(CombC.ar(FreqShift.ar(snd, -43), 0.2, 1 / 250, 0.005), 43) * -9.dbamp);



(
SynthDef(\blip, { | pattern = #[1, 8, 3, 1, 3, 0.5] |
	var freq, duration, env, snd, trig;
	duration = \duration.kr(2);
	trig = Impulse.kr(Line.kr(16, 4, duration));
	freq = \freq.kr(130) * Demand.kr(trig, 0, Dseq(pattern, inf));
	env = Env.perc(0.01, duration, curve: -4).ar(Done.freeSelf);
	snd = Pulse.ar(freq.lag(0.01), 0.45, -10.dbamp);
	snd = LeakDC.ar(snd);
	// snd = snd * (1 + (WhiteNoise.ar * 0.5));
	snd = snd + (FreqShift.ar(CombC.ar(FreqShift.ar(snd, -26), 0.2, 1 / 68, -0.2), 26) * -8.dbamp);
	snd = snd + PitchShift.ar(snd, 0.15, 0.5);
	snd = snd + (FreqShift.ar(CombC.ar(FreqShift.ar(snd, -63), 0.2, 1 / 130, -0.2), 63) * -8.dbamp);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

Synth(\blip, [freq: 36.midicps]);
Synth(\blip, [freq: 39.midicps]);
Synth(\blip, [freq: 38.midicps]);



(
SynthDef(\blipB, {
	var freq, duration, env, snd, trig;
	duration = \duration.kr(2);
	trig = Impulse.kr(XLine.kr(16, 4, duration));
	freq = \freq.kr(280) * Demand.kr(trig, 0, Dseq([1, 8, 3, 1, 3], inf));
	env = Env.perc(0.01, duration, curve: -2).ar(Done.freeSelf);
	snd = Pulse.ar(freq, 0.5, -14.dbamp);
	snd = (snd + CombC.ar(snd, 0.2, 1 / 94, 0.2))  * -3.dbamp;
	snd = (snd + PitchShift.ar(snd, 0.14, 0.5));
	snd = (snd + CombC.ar(snd , 0.2, 1 / 54, -0.25)) * -3.dbamp;

	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)

FreqShift
PitchShift



(
SynthDef(\blipC, { | pattern = #[1, 0.5, 9, 1, 3, 0.5] |
	var freq, duration, env, snd, trig;
	duration = \duration.kr(2);
	trig = Impulse.kr(XLine.kr(32, 4, duration));
	freq = \freq.kr(160) * Demand.kr(trig, 0, Dseq(pattern, inf));
	env = Env.perc(0.01, duration, curve: -2).ar(Done.freeSelf);
	snd = Pulse.ar(freq.lag(0.01), 0.5, -14.dbamp);
	snd = snd + PitchShift.ar(snd, 0.15, 0.5);
	snd = snd + (FreqShift.ar(CombC.ar(FreqShift.ar(snd, -26), 0.2, 1 / 68, -0.2), 26) * -8.dbamp);
	snd = snd + PitchShift.ar(snd, 0.15, 0.5);
	snd = snd + (FreqShift.ar(CombC.ar(FreqShift.ar(snd, -63), 0.2, 1 / 130, -0.2), 63) * -8.dbamp);
	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), snd);
}).play;
)



///////////////////////////////////////////////////////



(
SynthDef(\kick, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(2);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * 1, 0, SinOsc.ar(64, 0, 8.dbamp).tanh.linlin(-1, 1, 0.6, 0.8));
	snd = SinOsc.ar(freq, snd.mod(2pi));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd.tanh ! 2;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)



{SinOsc.ar(4, 0, 10.dbamp).tanh}.plot(1);
{SinOsc.ar(4, 0, 10.dbamp).tanh.linlin(-1, 1, 0.3, 1)}.plot(1);


(
SynthDef(\bass, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [1, 2], 0, [0.3, 0.1]).sum;
	snd = SinOsc.ar(freq, snd.mod(2pi));
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar;
	snd = (snd * 0.8).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd.tanh ! 2;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\808, {
	var snd, freq, hi, velocity, duration;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	freq = \freq.kr(60);
	freq = freq * (Env([0, 0, 1, 1], [1, 0.5, 1].normalizeSum * duration, curve: \sin).kr * \bend.kr(0)).midiratio;
	snd = SinOsc.ar(
		Env.perc(0, 0.12, curve: -8).ar.linexp(0, 1, freq, velocity.linexp(0, 1, 100, 300))
		* XLine.ar(1.2, 1, 0.2)
	);
	snd = snd * Env.perc(0, 10.0).ar;
	snd = snd * (1 + (1 * Env.perc(0, 1.0).ar * velocity));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.3, curve: -4).ar;
	snd = LPF.ar(snd, XLine.ar(300, 100, 0.2));
	hi = snd;
	hi = hi * (1 + (LPF.ar(LPF.ar(RHPF.ar({ PinkNoise.ar } ! 2, 1230, 0.5), 2e3), 7e3) * -5.dbamp));
	hi = (hi * 20).tanh;
	hi = hi + DelayC.ar(hi * -5.dbamp, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 2e-3);
	hi = HPF.ar(hi, 2500);
	hi = LPF.ar(hi, 8000);
	hi = hi * -12.dbamp;
	snd = (snd * 1).tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd + hi;
	snd = snd.tanh;
	snd = BLowShelf.ar(snd, 100, 0.3, 3);
	snd = snd * Env.linen(0.0, duration, 0.6, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)





(
SynthDef(\keys, {
	var snd, freq, velocity, n, freqs;
	velocity = \velocity.kr(1);
	freq = \freq.kr(260);
	n = (1..20);
	// outer partial, inner detune
	freqs = freq * n * (1 + ([[0.2e-4, 0.015e-4, 0.025e-4] * 2.5] * n * n)).sqrt * [([0, -0.03, 0.03] * 6).midiratio];
	snd = Env([0, 1, 0.2, 1, 0.05, 1, 0], [0.004 * Rand(1, 2), 0.001 * Rand(1, 2), 0.003 * Rand(1, 2), 0.004 * Rand(1, 2), 0.005 * Rand(1, 2), 0.001 * Rand(1, 2)] * 2, -4).ar * 3.dbamp;
	snd = (snd * 10.dbamp).fold2;
	snd = HPF.ar(snd, 300);
	snd = snd * (1 + (WhiteNoise.ar * 2));
	snd = Ringz.ar(snd, freqs, 20 / n.pow(1.3));
	snd = snd / (n ** 0.7);
	snd = snd.sum;
	snd = LeakDC.ar(snd);
	snd = Splay.ar(snd, 0.05);
	snd = snd * -53.dbamp * \amp.kr(1.0);
	snd = snd * Env.perc(0.0, 10.0, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;

)





// endfile 