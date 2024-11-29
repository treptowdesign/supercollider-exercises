(
SynthDef(\guitar, {
	var snd, freq;
	freq = \freq.kr(80);
	snd = Pluck.ar(SinOsc.ar(XLine.ar(3000, 50, 0.01) * ExpRand(0.5, 1)) + WhiteNoise.ar, Impulse.ar(0), 0.2, 1 / freq, 20, 0.2);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 63), 0.2, 1 / 150, 0.01), -63);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 63), 0.2, 1 / 240, 0.01), -63);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.6, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -30.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\guitarFx, {
	var snd, fb, beat;
	beat = \beat.kr(1);
	snd = In.ar(\in.kr(0), 2);
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	fb = snd;
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 1.0, (beat) - ControlDur.ir + (LFNoise2.ar(3 ! 2) * 0.001));
	fb = fb * -5.dbamp;
	fb = LPF.ar(fb, 4000);
	fb = HPF.ar(fb, 200);
	LocalOut.ar(fb);
	snd = snd + fb;
	// snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(0.1, [0, pi]).linlin(-1, 1, 0, 1) * 8e-3);
	Out.ar(\out.kr(0), snd);
}).add;
)


(
~guitarFx = Bus.audio(nil, 2);
)
~guitarFx.index;


(
Synth(\guitarFx, [in: ~guitarFx, beat: (60 / 110)]);
Synth(\guitar, [freq: (60 + 0).midicps, out: ~guitarFx]);
Synth(\guitar, [freq: (60 + 4).midicps, out: ~guitarFx]);
Synth(\guitar, [freq: (60 + 7).midicps, out: ~guitarFx]);
)

(
Synth(\guitar, [freq: 80, out: 0]);
)



(
var s, beat, root, scale;
s = Server.default;
beat = 60 / 110;
root = 60;
scale = Scale.aeolian.degrees;

Synth(\guitarFx, [in: ~guitarFx, beat: (60 / 110)]);

Routine({
	loop {
		s.bind {
			Synth(\guitar, [freq: (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps, out: ~guitarFx]);
		};
		(beat/2).wait;
	};
}).play;
)






(
SynthDef(\guitar, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = Pluck.ar(
		in: SinOsc.ar(XLine.ar(4000, 50, 0.01) * ExpRand(0.5, 1)) + WhiteNoise.ar,
		trig: Impulse.ar(0),
		maxdelaytime: 0.2,
		delaytime: 1 / freq,
		decaytime: 40,
		coef: 0.3
	);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 63), 0.2, 1 / 350, 0.01), -63);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 63), 0.2, 1 / 240, 0.01), -63);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.6, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)








// end 