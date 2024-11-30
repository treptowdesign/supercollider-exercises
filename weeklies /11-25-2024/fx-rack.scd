// Signal and FX Rack
(
SynthDef(\pulseSynth, {
	var snd, env;
	env = Env.perc(0.001, \rel.kr(1)).ar(Done.freeSelf);
	snd = Pulse.ar(\freq.kr(110));
	snd = Pan2.ar(snd * env * \amp.kr(0.1) ! 2, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxFlanger, {
	var snd, fx, delayTime, feedback;
	delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);
	feedback = 0.2;
	snd = In.ar(\in.kr(0), 2);
	fx = CombC.ar(snd, 0.01, delayTime, feedback);
	snd = snd.blend(fx, \wet.kr(0.8));
	Out.ar(\out.kr(0), snd);
}).add;
)

(
~fxBus = Bus.audio(nil, 2);
)

~fxBus.index;

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
	var flangerFX;
	flangerFX = Synth(\fxFlanger, [in: ~fxBus]);
	loop {
		s.bind {
			Synth(\pulseSynth, [
				freq: (root + scale.choose + (12 * [-1, 0, 1].choose)).midicps,
				rel: beat * 2,
				out: ~fxBus
			]);
		};
		(beat / 2).wait;
	};
}).play;
)

{ SinOsc.ar(1, 0.5pi).range(0, 1) }.plot(4);
{ SinOsc.ar(1, 0.5pi).range(0, 1).sqrt }.plot(4);
{ SinOsc.ar(1, 0.5pi).range(0, 1).squared }.plot(4);
{ SinOsc.ar(1, 0.5pi).range(0, 1).cubed }.plot(4);

