{SinOsc.ar(200) * -10.dbamp ! 2}.play;

(
SynthDef(\bass, {
	var freq, dur, snd;
	freq = \freq.kr(60);
	dur = \dur.kr(1);
	snd = SinOsc.ar(freq, 0).cubed.cubed;
	snd = snd + (SinOsc.ar(freq, pi/2).cubed * -10.dbamp);
	snd = snd + ((snd * 8.dbamp).clip2 * 8.dbamp).tanh;
	snd = LPF.ar(snd, Line.kr(600, 300, dur));
	snd = BLowShelf.ar(snd, 100, 0.4, 5);
	snd = snd * Env.linen(0.1, dur, 0.2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -12.dbamp ! 2);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(58 * (1 + (3 * Env.perc(0.001, 0.03).ar) * velocity) * (1 + (0.5 * Env.perc(0.001, 0.3).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 12328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5 * velocity).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1420, 0.4) * 25.dbamp;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.3], curve: -12).ar;
	snd = Pan2.ar(snd, 0) * -16.dbamp;
	snd = snd * Env.perc(0.0, 1.0).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.aeolian.degrees;

Routine({
	var dur, note;
	dur = beat;
	loop {
		note = (root + 0 + (12 * -1)).midicps;
		s.bind{ Synth(\kick); };
		s.bind{ Synth(\bass, [dur: dur - 0.2, freq: note]); };
		(dur).wait;
	};
}).play;
)




(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.aeolian.degrees;

Routine({
	var dur, note;
	dur = beat * 2;
	loop {
		[0, 0, 1, 0, 0, 0, 12, 0].do { |interval|
			note = (root + interval + (12 * -1)).midicps;
			s.bind{ Synth(\kick); };
			s.bind{ Synth(\bass, [dur: dur - 0.2, freq: note]); };
			(dur/2).wait;
			s.bind{ Synth(\clap); };
			(dur/4).wait;
			s.bind{ Synth(\clap); };
			(dur/4).wait;
		};
	};
}).play;
)



















(
Synth(\bass);
)


{SinOsc.ar(90).cubed ! 2}.play;

{LeakDC.ar(SinOsc.ar(90).cubed) ! 2}.play;

{SinOsc.ar(90).cubed ! 2}.play;
