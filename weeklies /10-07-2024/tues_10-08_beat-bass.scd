{SinOsc.ar(200) * -10.dbamp ! 2}.play;

(
SynthDef(\bass, {
	var freq, dur, snd;
	freq = \freq.kr(60) + SinOsc.ar(16).range(-0.5, 0.5);
	dur = \dur.kr(1);
	snd = SinOsc.ar(freq, 0).cubed.cubed;
	snd = snd + (SinOsc.ar(freq, pi/2).cubed * -10.dbamp);
	snd = snd + ((snd * 8.dbamp).clip2 * 8.dbamp).tanh;
	snd = LPF.ar(snd, Line.kr(600, 300, dur));
	snd = BLowShelf.ar(snd, 100, 0.4, 5);
	snd = snd * Env.linen(0.1, dur, 0.2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -10.dbamp ! 2);
}).add;
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(52 * (1 + (3 * Env.perc(0.001, 0.03).ar) * velocity) * (1 + (0.5 * Env.perc(0.001, 0.3).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 12328, 0.3) * Env.perc(0.01, 0.04).ar * -8.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.4 * velocity).ar(Done.freeSelf);
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
			s.bind{ Synth(\bass, [dur: dur - 0.2, freq: note]); };
			s.bind{ Synth(\kick); };
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
SynthDef(\snare2, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(198 * (1 + (0.5 * Env.perc(0.003, 0.012).ar)) * [1, 1.6, 3.5, 6.4, 8.8]);
	snd = snd * Env.perc(0, [1, 0.6, 0.3, 0.05, 0.1]).ar;
	snd = snd * [0, -2, -5, -8, -12].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (1.6 * Env.perc(0, 0.07).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2310, 0.3) * Env.perc(0.03, 0.16).ar * 5.dbamp * velocity);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16000));
	snd = (snd * -3.dbamp).clip2;
	snd = snd * Env.perc(0.001, 0.7 * velocity, curve: -0.5).ar;
	snd = snd * -8.dbamp;
	snd = snd * velocity;
	snd = snd * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp + GVerb.ar(snd * -15.dbamp, 10, 3);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(

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
		[\, 0, 1, 0, \, 0, 12, 0].do { |interval|
			if(interval != \, {
				note = (root + interval + (12 * -1)).midicps;
				s.bind{ Synth(\bass, [dur: dur - 0.2, freq: note]); };
			});
			s.bind{ Synth(\kick); };
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
SynthDef(\bass, {
	var freq, dur, snd;
	freq = \freq.kr(60);
	dur = \dur.kr(1);
	snd = SinOsc.ar(freq + SinOsc.ar(8).range(-1, 1), 0).cubed.cubed;
	snd = snd + (SinOsc.ar(freq, pi/2).cubed * -10.dbamp);
	snd = snd + ((snd * 8.dbamp).clip2 * 8.dbamp).tanh;
	snd = LPF.ar(snd, Line.kr(600, 300, dur));
	snd = BLowShelf.ar(snd, 100, 0.4, 5);
	snd = snd * Env.linen(0.1, dur, 0.2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -10.dbamp ! 2);
}).play;
)






(
Synth(\bass);
)


{SinOsc.ar(90).cubed ! 2}.play;

{LeakDC.ar(SinOsc.ar(90).cubed) ! 2}.play;

{SinOsc.ar(90).cubed ! 2}.play;
