(
SynthDef(\strings, {
	var snd, freq, detune, rate;
	freq = \freq.kr(440);
	rate = 1;
	detune = ((LFNoise2.kr(3 * rate) * 0.3) + (LFNoise2.kr(8) * 0.1) + Line.kr(10, 0, 0.003)).midiratio;
	snd = SinOsc.ar(freq * IRand(1, 3 ! 8) * (LFNoise2.kr(3 ! 8 * rate) * 0.7).midiratio * detune) * 1000 * (1 + Env.perc(0.05 * ExpRand(0.5, 2.0), 0.3 * ExpRand(0.5, 2.0)).ar);
	snd = SinOsc.ar((freq * (LFNoise2.kr(3 ! 8 * rate) * 0.8).midiratio * detune) + snd);
	snd = snd * (1 + LFNoise2.ar(3 ! snd.size));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, LFNoise2.kr(3).linexp(0, 1, 400, 600));
	snd = snd * Env.linen(0.2, \duration.kr(5.0), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, root, bpm, beat;
s = Server.default;
root = 60 + 6 + (12 * 1);
bpm = 128;
beat = 60 / bpm;

Routine({

	Routine({
		loop {
			[0, 3, 2, -4, 1, 3, 2, -5].do { |note|
				s.bind { Synth(\strings, [freq: (root + note).midicps * (2 ** -2), duration: beat * 4]) };
				s.bind { Synth(\strings, [freq: (root + note).midicps * (2 ** -3), duration: beat * 4]) };
				(beat * 4).wait;
			};
		};
	}).play;

}).play;
)