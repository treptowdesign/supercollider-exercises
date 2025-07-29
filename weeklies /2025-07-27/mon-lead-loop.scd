(
SynthDef(\source, {
	var snd, freq, duration, chorus, lfo;
	freq = \freq.kr(220);
	duration = \duration.kr(1);
	lfo = { |rate=1, min=0, max=1| LFNoise2.ar(rate).linlin(-1, 1, min, max); };
	snd = XFade2.ar(Pulse.ar(freq), Saw.ar(freq), lfo.(4, -0.6, 0.6));
	chorus = DelayC.ar(snd, 0.2, lfo.(5, 0, 6e-4));
	snd = XFade2.ar(snd, chorus, 0);
	chorus = DelayC.ar(snd, 0.2, lfo.(3, 0, 3e-3));
	snd = XFade2.ar(snd, chorus, 0);
	snd = Pan2.ar(snd, \pos.kr(0), \amp.kr(1) * 0.25);
	snd = snd * Env.perc(0.01, \rel.kr(5)).ar;
	snd = snd * Env.linen(0.01, duration, 0.2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;
)

(
var s, beat, root, seq;
s = Server.default;
beat = 60 / 118;
root = 51;

seq = { |synth, dur, args|
	s.bind { Synth(synth, [duration: dur] ++ args); };
	(dur).wait;
};

Routine({
	loop {
		[
			// interval, duration, release, amp
			[0, beat/2, 3, 0.8],
			[8, beat, 6, 1],
			[1, beat/2, 3, 0.5],
			[8, beat, 6, 0.8],
			[7, beat, 6, 0.9]
		].do { |spec|
			var note, dur, rel, amp;
			# note, dur, rel, amp = spec;
			note = (root + note + (12 * -1)).midicps;
			seq.(\source, dur, [freq: note, rel: 6]);
		};
	};
}).play;
)