///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Synths
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
(
SynthDef(\sourceSaw, {
	var snd;
	snd = Saw.ar(\freq.kr(440) * ([0, 0.3, 0.6] * LFNoise2.ar(2).unipolar).midiratio).sum;
	snd = snd * Env.perc(0.01, \rel.kr(2)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sourcePulse, {
	var snd;
	snd = Pulse.ar(\freq.kr(440) * ([0, 0.2] * LFNoise2.ar(2).unipolar).midiratio).sum;
	snd = snd * Env.perc(0.01, \rel.kr(8)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sourceSin, {
	var snd;
	// snd = SinOsc.ar(\freq.kr(440) * ([0, 0.1] * LFNoise2.ar(2).unipolar).midiratio).sum;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, \rel.kr(8)).ar(Done.freeSelf);
	snd = snd.tanh;
	snd = Pan2.ar(snd, \pan.kr(0), 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fx, {
    var snd, mix;
	mix = { Rand(-0.8, 0.8) };
	snd = In.ar(\in.kr(0), 2);
	snd = snd.tanh;
	snd = XFade2.ar(snd, AllpassC.ar(snd, 0.1, SinOsc.ar(0.15, 0, 1e-4, 1e-4), 0), mix);
	snd = XFade2.ar(snd, AllpassC.ar(snd, 0.1, LFNoise2.ar(0.275, 2e-4, 2e-4), 0), mix);
	snd = XFade2.ar(snd, AllpassC.ar(snd, 0.1, SinOsc.ar(0.255, 0.1, 1e-4, 1e-4), 0), mix);
	snd = XFade2.ar(snd, AllpassC.ar(snd, 0.1, LFNoise2.ar(0.166, 2e-4, 2e-4), 0), mix);
	snd = XFade2.ar(snd, AllpassC.ar(snd, 0.1, SinOsc.ar(0.95, 0.5pi, 3e-4, 3e-4), 0), mix);
	snd = XFade2.ar(snd, AllpassC.ar(snd, 0.1, SinOsc.ar(0.325, 0.35pi, 2.5e-4, 2.5e-4), 0), mix);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).unipolar * 2e-3);
	snd = snd + GVerb.ar(snd.mean * -10.dbamp, 10, 3, 0.1);
	snd = snd * \amp.kr(0).dbamp;
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
~fxBus2 = Bus.audio(nil, 2);
)

~fxBus.index;
~fxBus2.index;

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Patterns
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

(
var s, beat, root, scale, play;
s = Server.default;
beat = 60 / 88;
root = 52;
scale = [0, 5, 7];
play = { |synthDef, duration, args = #[]|
	s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	(duration * beat).wait;
};
Synth.tail(nil, \fx, [in: ~fxBus, mix: 0, amp: -12]);
/*Routine({
	loop {
		[
			[0, 3, 7, 10],
			[1, 5, 8, 0]
		].do { |noteArr|
			4.do {
				noteArr.scramble.do { |deg|
					var note, length, pan;
					pan = rrand(-1.0, 1.0);
					length = [0.5, 1, 2, 4].choose;
					note = (root + deg + (12 * (-1..2).choose)).midicps;
					play.(\sourceSaw, length, [freq: note, rel: (beat * length * 16), pan: pan, out: ~fxBus]);
				}
			}
		};
	};
}).play;*/
Routine({
	loop {
		[
			[0, 3, 7, 10],
			[1, 5, 8, 0]
		].do { |noteArr|
			4.do {
				noteArr.scramble.do { |deg|
					var note, length, pan;
					pan = rrand(-1.0, 1.0);
					length = [0.5, 1, 2, 4].choose;
					note = (root + deg + (12 * (-1..2).choose)).midicps;
					play.(\sourcePulse, length, [freq: note, rel: (beat * length * 16), pan: pan, out: ~fxBus]);
				}
			}
		};
	};
}).play;
/*Routine({
	loop {
		[
			[0, 3, 7, 10],
			[1, 5, 8, 0]
		].do { |noteArr|
			4.do {
				noteArr.scramble.do { |deg|
					var note, length, pan;
					pan = 0;
					length = [0.5, 1, 2, 4].choose;
					note = (root + deg + (12 * -1)).midicps;
					play.(\sourceSin, length, [freq: note, rel: (beat * length * 16), pan: pan, out: ~fxBus]);
				}
			}
		};
	};
}).play;*/
)