// Signal and FX Rack
(
SynthDef(\pulseSynth, {
	var snd, env;
	env = Env.perc(0.001, \rel.kr(1)).ar(Done.freeSelf);
	snd = Pulse.ar(\freq.kr(220));
	snd = Pan2.ar(snd * env * \amp.kr(0.1) ! 2, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxFlanger, {
	var snd, fx, delayTime, feedback, speed;
	speed = \speed.kr(0.1);
	delayTime = SinOsc.kr(speed, 0).range(0.001, 0.01);
	feedback = SinOsc.kr(speed, pi).linexp(-1, 1, 0.2, 0.01);
	snd = In.ar(\in.kr(0), 2);
	fx = CombC.ar(snd, 0.01, delayTime, feedback) * 1;
	snd = snd.blend(fx, \wet.kr(0.5));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~fxBus = Bus.audio(nil, 2);
)

~fxBus.index;

(
Synth(\fxFlanger, [in: ~fxBus]);
[0, 4, 7, 11].do { |interval |
	Synth(\pulseSynth, [freq: (60 + interval).midicps, rel: 6, out: ~fxBus]);
};
)

(
Synth(\fxFlanger, [in: ~fxBus]);
Synth(\pulseSynth, [freq: 60, rel: 6, out: ~fxBus]);
)

( // Routine
var s, beat, root, scale;
s = Server.default;
beat = 60 / 110;
root = 60;
scale = Scale.aeolian.degrees;
Routine({
	var flangerFX, dur;
	flangerFX = Synth(\fxFlanger, [in: ~fxBus, wet: 0.5]);
	loop {
		dur = beat / [1, 2, 4].choose;
		s.bind {
			Synth(\pulseSynth, [
				freq: (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps,
				rel: beat * 4,
				out: ~fxBus
			]);
		};
		(dur).wait;
	};
}).play;
)
