(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 3, 5] * (LFNoise2.kr(7 ! 3) * 0.2).midiratio);
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
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.aeolian.degrees;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			(notes: 2 + [-12, 0, 3, 7, 2], length: 4),
			(notes: 7 + [-12, 0, 3, 7, -2], length: 4),
			(notes: 0 + [-12, 0, 5, 7, 10], length: 4),

		].do { |chord|
			notes = chord[\notes].sort;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.2).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)
