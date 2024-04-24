(
SynthDef(\paramsSynth, {
	|freq=440, initFreq=440, pan=0, amp=(-10), atk=0.01, rel=0.6, cutoffMin=80, cutoffMax=8000, rq=0.5, gate=1|
	var snd;
	snd = VarSaw.ar(XLine.kr(initFreq, freq, 0.1), 0, 0.1);
	snd = snd + RLPF.ar(snd, XLine.kr(cutoffMin, cutoffMax, rel), rq);
	snd = (snd * 2.dbamp).tanh;
	snd = snd + CombC.ar(snd * -10.dbamp, 0.4, 0.4, 4);
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, pan));
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(58 * (1 + (3 * Env.perc(0, 0.1).ar)) * (1 + (4 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.02).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * \amp.kr(-6).dbamp;
	Out.ar(\out.kr(0), snd ! 2);
}).add;
SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(192 * (1 + (0.5 * Env.perc(0.003, 0.012).ar)) * [1, 1.6, 3.5, 6.4, 8.8]);
	snd = snd * Env.perc(0, [1, 0.6, 0.3, 0.05, 0.1]).ar;
	snd = snd * [0, -2, -5, -8, -12].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (1.2 * Env.perc(0, 0.07).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(2.0), 2310, 0.3) * Env.perc(0.03, 0.16).ar * -2.dbamp);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 1000, 16000));
	snd = (snd * -3.dbamp).clip2;
	snd = snd * Env.perc(0.001, \decay.kr(1) * 0.7, curve: -1).ar;
	snd = snd * -10.dbamp;
	snd = snd * velocity;
	snd = snd * \amp.kr(1);
	snd = Pan2.ar(snd, \pan.kr(0)) * 3.dbamp + GVerb.ar(snd * -15.dbamp, 10, 3);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\swarmHat, {
	var freq = 440;
	var snd;
	snd = Pulse.ar(freq * [1, 1.75, 0.06, 0.75, 1.55].midiratio);
	snd = (WhiteNoise.ar.pow(9.0) * 0.8) + snd.sum;
	snd = BPF.ar(snd, 16e3, 0.3);
	snd = snd * (1 + (6 * Env.perc(0, 0.03).ar));
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -20.dbamp);
}).add;
)

Synth(\paramsSynth);

(
var s, bpm, beat, root, scale;
var randomNote, getNote, wait, play;
s = Server.default;
bpm = 120;
beat = 60 / bpm;
root = 44;
scale = Scale.dorian.degrees;

randomNote = { |octave|
	(root + scale.choose + (12 * octave)).midicps;
};

getNote = { |note=0, octave=0|
	(root + scale.wrapAt(note) + (12 * (note.div(scale.size) + octave))).midicps;
};

wait = { |duration|
	(duration * beat).wait;
};
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	wait.(duration);
};
Routine({
	loop {
		play.(\swarmHat, 1/4);
	};
}).play;
Routine({
	loop {
		play.(\kick, 1/3, [amp: -20]);
		play.(\kick, 1/3, [amp: -20]);
		play.(\kick, 1/3, [amp: -20]);
		play.(\snare, 1);
		play.(\kick, 1/4, [amp: -20]);
		play.(\kick, 1/4, [amp: -20]);
		play.(\kick, 1/4, [amp: -20]);
		play.(\kick, 1/4, [amp: -20]);
		play.(\snare, 1);

	};
}).play;

Routine({
	var tatum;
	tatum = beat / 4;
	loop {
		play.(\paramsSynth, 1/3, [initFreq: getNote.(7), freq: getNote.(0)]);
		play.(\paramsSynth, 1/3, [initFreq: getNote.(7), freq: getNote.(0)]);
		play.(\paramsSynth, 1/3, [initFreq: getNote.(7), freq: getNote.(0)]);
		play.(\paramsSynth, 1, [initFreq: getNote.(7), freq: getNote.(0)]);

		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 0.25, [initFreq: getNote.(0), freq: getNote.(12)]);
		play.(\paramsSynth, 1, [initFreq: getNote.(0), freq: getNote.(12)]);

	};
}).play;
)


Scale.dorian.degrees;