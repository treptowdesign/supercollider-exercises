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
	delayTime = SinOsc.kr(0.2, 0).range(0.001, 0.01);
	feedback = 0.2;
	snd = In.ar(\in.kr(0), 2);
	fx = CombC.ar(snd, 0.01, delayTime, feedback);
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


( // Dynamic LPF on wet signal
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    var dynamicLPF = BLowPass.ar(wet, SinOsc.kr(0.1, 0).range(1000, 5000));  // Dynamic low-pass filter
    source.blend(dynamicLPF, 0.5) * 0.5 ! 2;
}.play;
)

( // Band Limited Delay modulation
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var bandLimited = BPF.ar(source, 2000, 0.5);  // Band-pass filter for wet signal
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    var wet = CombC.ar(bandLimited, 0.01, delayTime, feedback) * 0.5;
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

( // Soft Clip wet signal
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = 0.2;
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    wet = tanh(wet * 2);  // Soft clipping
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)

( // Modulate feedback!!!!
{
    var source = Pulse.ar(60, 0.5, 0.2);  // Input signal: Pulse
    var delayTime = SinOsc.kr(0.1, 0).range(0.001, 0.01);  // LFO for delay time modulation
    var feedback = SinOsc.kr(0.1, pi).linexp(-1, 1, 0.3, 0.01);  // Modulate feedback
    var wet = CombC.ar(source, 0.01, delayTime, feedback) * 0.5;
    source.blend(wet, 0.5) * 0.5 ! 2;
}.play;
)
)

{SinOsc.kr(0.1, pi).linexp(-1, 1, 0.3, 0.01)}.plot(2);
