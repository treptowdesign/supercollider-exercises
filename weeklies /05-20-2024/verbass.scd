(
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, [0.05, 0.042, 0.035, 0.038, 0.04]).ar.linexp(0, 1, 58, 400) * [1, 1.4, 1.65, 1.3, 1.8]);
	snd = snd * Env.perc(0.001, [0.4, 0.06, 0.001, 0.02, 0.3]).ar;
	snd = snd * [0, -5, -2, -8, -14].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0, 0.01).ar));
	snd = (snd * 1.dbamp).tanh;
	snd = (snd * -15.dbamp) ! 2;
	snd = snd * Env.linen(0, duration, 0.01, curve: -2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\swarmHat, {
	arg rel=0.2, amp=(-20);
	var snd, freq=450;
	snd = Pulse.ar(freq * [1, 1.75, 0.06, 0.75, 1.55].midiratio) * -5.dbamp;
	snd = (WhiteNoise.ar.pow(9.0)) + snd.sum;
	snd = BPF.ar(snd, 14e3, 0.3);
	snd = snd * (1 + (5 * Env.perc(0, 0.03).ar));
	snd = snd * Env.perc(0.001, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * amp.dbamp * 0.dbamp);
}).add;
SynthDef(\clapYcgm, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1510);
	snd = snd * 20.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.008, 1e-4, 0.005, 1e-4, 0.08], -4).ar(Done.freeSelf);
	snd = LPF.ar(snd, \filtCutoff.kr(2e4));
	snd = snd * (1 + (1.1 * Env.perc(0.001, 0.01).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1).dbamp * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\verb, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	/*snd = GVerb.ar(
		snd,
		roomsize: 10,
		revtime: 3,
		damping: 0.9,
		inputbw: 0.5,
		spread: 0,
		drylevel: 1,
		earlyreflevel: 0.1,
		taillevel: 0.5,
		maxroomsize: 300
	) * -10.dbamp;*/
	snd = FreeVerb.ar(snd, mix: 0.3, room: 0.4, damp: 0.1) * 0.dbamp;
	snd = snd.sum;
	Out.ar(\out.kr(0), snd * \amp.kr(0.dbamp) ! 2);
}).add;
)

// bussing
(
~fxBus = Bus.audio(s, 2);
)

~fxBus.index;

(
var s, bpm, beat;
s = Server.default;
bpm = 110;
beat = 60 / bpm;

Synth.tail(nil, \verb, [in: ~fxBus]);

Routine({
	loop {
		s.bind { Synth(\kick, [out: 0]); };
		beat.wait;
	};
}).play;

Routine({
	loop {
		beat.wait;
		s.bind { Synth(\clapYcgm, [out: 0]); };
		beat.wait;
	};
}).play;

Routine({
	loop {
		(beat/2).wait;
		s.bind { Synth(\swarmHat, [out: 0]); };
		(beat/2).wait;
	};
}).play;
)

// end... 