
(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 6] * (LFNoise2.kr(7 ! 3) * 0.2).midiratio);
	snd = snd * Env.perc(0, [5.5, 7, 4]).ar;
	snd = snd * [-2, 0, -10].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(11 ! snd.size)));
	snd = snd.sum;
	snd = HPF.ar(snd, 300);
	snd = LPF.ar(snd, XLine.kr(8000, 800, 4.0));
	snd = snd * Select.kr(Sweep.ar > 0.02, [ToggleFF.kr(Dust.ar(100)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -5.dbamp, 16, 4, damping: 0.2);
	snd = snd * (1 + (0.5 * Env.perc(0.001, 0.2).ar));
	snd = snd * Line.kr(1, 0.6, duration) * Env.perc(0, 0.8).kr.range(1, 0.6); // shaping vol...
	snd = snd * Env.linen(0.001, duration, 0.0, curve: -4).kr(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)



(
var s, root, bpm, beat;
s = Server.default;

root = 60 + 6 + (12 * 1) - 0.30;

bpm = 128;
beat = 60 / bpm;

Routine({


	Routine({
		[
			[
				0, \, 2, \, \, 0, 3, 2,
				7, \, \, \, \, \, \, \,
				8, \, \, \, 3, \, \, \,
				3, \, \, \, 2, \, \, \,

				2, \, 0, \, \, \, \, 0,
				8, \, \, \, \, \, \, \,
				8, \, \, \, \, \, \, \,
				7, \, \, \, \, \, \, \,
			],
			[
				-10, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,
				-4, \, \, \, \, \, \, \,
				-9, \, \, \, \, \, \, \,

				-10, \, \, \, \, \, \, \,
				-4, \, \, \, \, \, \, \,
				-4, \, \, \, \, \, \, \,
				-5, \, \, \, \, \, \, \,
			],
			/*-12 + [
				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,

				-4, \, \, \, \, \, \, \,
				0, \, \, \, \, \, \, \,
				3, \, \, \, \, \, \, \,
				-1, \, \, \, \, \, \, \,
			]*/
		].do { |pattern|
			Routine({
				loop {
					pattern.do { |note|
						if(note != \) {
							Routine({
								rrand(0, 0.02).wait;
								s.bind { Synth(\organ, [freq: (root + note).midicps]) };
							}).play;
						};
						(beat / 2).wait;
					};
				};
			}).play;
		};
	}).play;


}).play;
)
