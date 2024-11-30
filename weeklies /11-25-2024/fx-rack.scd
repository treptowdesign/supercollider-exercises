// Signal and FX Rack
(
SynthDef(\pulseSynth, {
	var snd, env, freq;
	freq = \freq.kr(220);
	env = Env.perc(0.001, \rel.kr(1)).ar(Done.freeSelf);
	snd = Pulse.ar(freq);
	snd = snd + (BPF.ar(PinkNoise.ar, freq) * 0.5);
	snd = Pan2.ar(snd * env * \amp.kr(0.1) ! 2, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxFlanger, {
	var snd, fx, delayTime, feedback, speed;
	speed = \speed.kr(0.2);
	delayTime = SinOsc.kr(speed, 0).range(0.001, 0.01);
	feedback = SinOsc.kr(speed, 0).linexp(-1, 1, 0.01, 0.3);
	snd = In.ar(\in.kr(0), 2);
	fx = CombC.ar(snd, 0.01, delayTime, feedback) * \fxAmp.kr(0.5);
	snd = snd.blend(fx, \wet.kr(0.5));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~fxBus = Bus.audio(nil, 2);
)
~fxBus.index;

(
Synth(\fxFlanger, [in: ~fxBus, speed: 0.2, wet: 1, fxAmp: 0.7]);
[0, 4, 7, 11].do { |interval |
	Synth(\pulseSynth, [freq: (60 + interval).midicps, rel: 30, out: ~fxBus, amp: 0.05]);
};
)

(
Synth(\fxFlanger, [in: ~fxBus, speed: 0.2, wet: 1, fxAmp: 0.7]);
[0, 3, 7, 10].do { |interval |
	Synth(\pulseSynth, [freq: (60 + interval).midicps, rel: 30, out: ~fxBus, amp: 0.05]);
};
)


(
Synth(\fxFlanger, [in: ~fxBus, wet: 0.5]);
Synth(\pulseSynth, [freq: 60, rel: 30, out: ~fxBus]);
)

( // Routine
var s, beat, root, scale;
s = Server.default;
beat = 60 / 110;
root = 60;
scale = Scale.aeolian.degrees;
Routine({
	Synth(\fxFlanger, [in: ~fxBus, wet: 0.5, speed: 0.2, fxAmp: 0.5]);
	loop {
		var dur = beat / [1, 2].choose;
		s.bind {
			Synth(\pulseSynth, [
				freq: (root + scale.choose + (12 * [-2, -1, 0, 1, 2].choose)).midicps,
				rel: beat * [8, 4, 2].choose,
				out: ~fxBus
			]);
		};
		(dur).wait;
	};
}).play;
)
