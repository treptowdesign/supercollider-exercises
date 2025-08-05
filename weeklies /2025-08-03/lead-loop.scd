(
SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * \index.kr.linlin(0, 1, 1, 10).round) * Env.perc(0.1, \decay.kr.linexp(0, 1, 0.5, 10)).ar * \brightness.kr.linlin(0, 1, 100, 3000);
	snd = SinOsc.ar(freq + snd);
	snd = snd + (DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 3).linlin(-1, 1, 0, 1) * 5e-3) * LFNoise2.kr(12 ! 2) * 5.dbamp);
	snd = snd * Env.perc(0.01, \decay.kr.linexp(0, 1, 5, 20), curve: -10).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -36.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass, {
	var snd, freq, dry;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * XLine.kr(2, 1, 0.03));
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 12.dbamp).tanh, 900), 0.2, SinOsc.ar(3, [0, pi]).linlin(-1, 1, 0, 1) * 0.5e-3);
	snd = dry + (snd * -1.dbamp);
	snd = snd * Env.adsr(0.001, 0.1, 0.9, 0.02).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -8.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\bass2, {
	var snd, freq, dry;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = MoogFF.ar(snd, (Line.kr(0, 1, 0.9) ** 0.7).linexp(0, 1, 200, 4200), 0.9) * 5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.asr(0.1, 1, 0.03).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -8.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)


{(Line.kr(0, 1, 0.9) ** 0.1)}.plot(1);


{Line.kr(1, 10, 0.5).log}.plot(1)




(
SynthDef(\lead, {
	var snd, freq, dry;
	freq = \freq.kr(330);
	snd = SinOsc.ar(freq * 4) * (200 * SinOsc.ar(Line.ar(8, 2, 0.5)).unipolar);
	snd = SinOsc.ar((freq * 2) + snd) * (200 * Line.ar(1, 0.6, 1));
	snd = SinOsc.ar(freq + snd);
	snd = (snd * 2.dbamp).tanh + ((snd * 2.dbamp).clip2 * -8.dbamp);
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 12.dbamp).tanh, 900), 0.2, SinOsc.ar(3, [0, pi]).linlin(-1, 1, 0, 1) * 3e-4);
	snd = dry + (snd * -2.dbamp);
	snd = snd * Env.perc(0.001, 4).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


/////////////////////////////////////////////////////////////


(
SynthDef(\lead, {
	var snd, freq, dry;
	freq = \freq.kr(220);
	snd = SinOsc.ar((freq * 4)) * (950 * Line.ar(1, 0.75, 1));
	snd = SinOsc.ar(freq + snd);
	snd = (snd * 4.dbamp).tanh + ((snd * 10.dbamp).clip2 * -4.dbamp);
	dry = snd;
	snd = DelayC.ar(HPF.ar((snd * 12.dbamp).tanh, 1200), 0.2, SinOsc.ar(3, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 5e-4);
	snd = dry + (snd * -2.dbamp);
	snd = snd * Env.perc(0.001, 1, curve: -2).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -16.dbamp ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, beat, bar, root, play;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
root = 51;
play = { |synth, dur, args|
	s.bind {
		Synth(synth, [duration: dur] ++ args);
	};
	dur.wait;
};
Routine({
	loop {
		[
			[0, beat],
			[12, beat/2],
			[10, beat],
			[-2, beat/2],
			[-5, beat/2],
			[7, beat/2],

			[2, beat],
			[14, beat/2],
			[12, beat/2],
			[3, beat],
			[-2, beat/2],
			[10, beat/2],

			[0, beat],
			[12, beat/2],
			[10, beat],
			[-2, beat/2],
			[-5, beat/2],
			[7, beat/2],

			[2, beat],
			[14, beat/2],
			[12, beat/2],
			[3, beat],
			[-2, beat/2],
			[10, beat/2],

		].do { |spec|
			var int, length;
			# int, length = spec;
			play.(\lead, length, [freq: (root + int + (12 * 0)).midicps]);
		};
	};
}).play;

)

/////////////////////////////////////////////////////////////














/////////////////////////////////////////////////////////////