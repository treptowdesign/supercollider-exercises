// Monday 11-18-2024

(
SynthDef(\pulseBass, {
	var snd, env, freq;
	freq = \freq.kr(60) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).kr;
	snd = Pulse.ar(freq, 0.5);
	snd = RLPF.ar(snd, env.exprange(freq, freq * 20), 0.3);
	snd = snd * env * Env.linen(0, \duration.kr(1), 0.1).kr(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -8.dbamp);
}).add;
)

(
var s, root, scale, beat;
s = Server.default;
root = 32;
scale = Scale.phrygian.degrees;
beat = 60 / 110;
Routine({
	var note, dur;
	loop {
		[
			(interval: 0, length: 1, bend: 0),
			(interval: 7, length: 1/2, bend: -6),
			(interval: 7, length: 1/2, bend: 0),
			(interval: 6, length: 1, bend: -6),
			(interval: 1, length: 1, bend: 0),
		].do { |item|
			note = (root + item[\interval] + (12 * 0)).midicps;
			dur = beat * item[\length];
			s.bind { Synth(\pulseBass, [freq: note, duration: dur, bend: item[\bend]]) };
		dur.wait;
		};
	};
}).play;
)
