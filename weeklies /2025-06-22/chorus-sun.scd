///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Synths
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
(
SynthDef(\sourcePulse, {
	var snd;
	snd = Pulse.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, \rel.kr(2)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sourceSaw, {
	var snd;
	// snd = Saw.ar(\freq.kr(440) * ([0, 0.3, 0.7] * LFNoise2.ar(2).unipolar).midiratio).sum;
	snd = Saw.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, \rel.kr(2)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\chorus, {
    var snd, wet, mod;
	mod = SinOsc.ar(\modSpeed.kr(0.25), 0).range(0, \modDelay.kr(3e-3));
	snd = In.ar(\in.kr(0), 2);
	wet = LPF.ar(HPF.ar(snd, \hpf.kr(20)), \lpf.kr(2e4));
	wet = DelayC.ar(wet, 0.03, mod);
	snd = XFade2.ar(snd, wet, \mix.kr(0));
	snd = Limiter.ar(snd * \amp.kr(0).dbamp);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\chorus2, {
    var snd, wet, wet2, mod, mod2;
	mod = SinOsc.ar(\modSpeed.kr(0.25), 0).range(0, \modDelay.kr(3e-3));
	mod2 = SinOsc.ar(\modSpeed2.kr(0.1), 0).range(0, \modDelay2.kr(1e-3));
	snd = In.ar(\in.kr(0), 2);
	wet = LPF.ar(HPF.ar(snd, \hpf.kr(20)), \lpf.kr(2e4));
	wet2 = LPF.ar(HPF.ar(snd, \hpf.kr(20)), \lpf.kr(2e4));
	wet = DelayC.ar(wet, 0.03, mod);
	wet2 = DelayC.ar(wet2, 0.03, mod2);
	snd = XFade2.ar(snd, wet + wet2, \mix.kr(0));
	snd = Limiter.ar(snd * \amp.kr(0).dbamp);
    Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\masterFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 30, 6, 0.2);
	Out.ar(\out.kr(0), snd);
}).add;
)


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Routing
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

(
~fxBus = Bus.audio(nil, 2);
~fxBusMaster = Bus.audio(nil, 2);
)

~fxBus.index;
~fxBusMaster.index;

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Flanger Pattern
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

(
var s, beat, root, scale, play, splitScale;
s = Server.default;
beat = 60 / 138;
root = 52;
scale = Scale.aeolian.degrees;
splitScale = { |scale|
    var s1, s2;
    s1 = [0, 2, 4, 6].collect { |i| scale.wrapAt(i) };
    s2 = [1, 3, 5, 0].collect { |i| scale.wrapAt(i) };
    [s1, s2]
};
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};
Synth.tail(nil, \chorus2, [
	in: ~fxBus, out: ~fxBusMaster,
	mix: -0.5, amp: 0,
	modDelay: 6e-3, modSpeed: 0.85,
	modDelay2: 2e-3, modSpeed2: 2.15
]);
Synth.tail(nil, \masterFx, [in: ~fxBusMaster]);
Routine({
	loop {
		splitScale.(scale).do { |noteArr|
			noteArr.postln;
			4.do {
				noteArr.scramble.do { |deg|
					var note, octave, length, rel, panRange, pan;
					octave = (-2..2).choose;
					panRange = octave.linlin(-2, 2, 0.0, 1.0);
					pan = rrand(-1 * panRange, panRange);
					length = [0.5, 1, 2, 4].choose;
					rel = (beat * length * [4, 8, 16].choose);
					note = (root + deg + (12 * octave)).midicps;
					play.(\sourceSaw, length, [freq: note, rel: rel, pan: pan, out: ~fxBus]);
				}
			}
		};
	};
}).play;
)