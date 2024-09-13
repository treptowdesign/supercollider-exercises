// Rhythm Exercise

(
SynthDef(\kick, {
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
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [30e-3, 54e-3]) * -15.dbamp);
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.005), 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(230 * XLine.ar(1.4, 1, 0.005) * [1, 2.3, 4.5]);
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd.clip2;
	snd = snd * -10.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(2000, 200, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(CombC.ar(Hasher.ar(Sweep.ar), 0.2, 1 / 60, 0.02), 2120, 0.3) * Env.perc(0.05, 0.1).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 830, 0.3) * Env.perc(0.01, 0.03).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2030, 0.5) * Env.perc(0.05, 0.15).ar * -13.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2520, 0.3) * Env.perc(0.0, 0.01).delay(0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1520, 0.3) * Env.perc(0.002, 0.01).delay(0.034).ar * -2.dbamp);
	snd = snd * (1 + (0.5 * Env.perc(0.005, 0.01).ar));
	snd = snd * (1 + (1 * Env.perc(0.001, 0.03).delay(0.03).ar));
	snd = snd * velocity.sqrt;
	snd = BHiShelf.ar(snd, 1200, 0.3, -5);
	snd = (snd * 20.dbamp).tanh + ((snd * 3.dbamp).fold2 * -15.dbamp);
	snd = BHiShelf.ar(snd, 3200, 0.3, 1);
	snd = snd + GVerb.ar(snd * -1.dbamp, 60, 1);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16e3));
	snd = snd + (DelayC.ar(LPF.ar(HPF.ar(snd, 200), 2300), 0.1, [63e-3, 74e-3]) * -15.dbamp);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.1, 0.015), 0.3 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = snd + CombC.ar(snd, 0.23, 1 / 90);
	snd = BPF.ar(snd, [12240, 6230, 10832, 9830, 8320], 0.1).sum;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.02, 0.03).ar * -15.dbamp, 8320, 0.3);
	snd = snd * Env.perc(0.01, 0.1, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp;
	snd = snd * -26.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\perc, {
	var snd;
	snd = SinOsc.ar(920 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + GVerb.ar(snd * -15.dbamp, 10);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr, snd);
}).add;
SynthDef(\perc2, {
	var snd;
	snd = SinOsc.ar(420 * (1.5 ** [0, 1, 2])).sum;
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd + Latch.ar(GVerb.ar(snd * -15.dbamp, 3), Impulse.ar(8320));
	snd = snd * Env.perc(0.0, 0.5).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * \amp.kr(1);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr, snd);
}).add;
)



(
var s, bpm, beat, bar, third;
s = Server.default;
bpm = 140;
beat = 60 / bpm;
bar = beat * 4;
third = bar / 3;

Routine({
	loop {
		s.bind { Synth(\kick); };
		(beat).wait;
	};
}).play;

Routine({
	loop {
		[
			\, \, 1, \, \, \, 1, \,
			\, \, 1, \, \, \, \, 1,
			\, \, 1, \, \, \, 1, \,
			\, \, 1, \, \, \, 1, 1,

		].do { |hit|
			if(hit != \, {
				s.bind { Synth(\snare); };
			});
			(beat / 2).wait;
		};
	};
}).play;

Routine({
	loop {
		s.bind { Synth(\hat); };
		(beat / 4).wait;
	};
}).play;

Routine({
	loop {
		s.bind { Synth(\perc2); };
		(third).wait;
		s.bind { Synth(\perc); };
		(third).wait;
	};
}).play;

)