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
	snd = snd * -20.dbamp * \amp.kr(0).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
var s, bpm, beat, root, scale;

s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.phrygian.degrees;

Routine({
	var dur, notes;
	dur = beat;
	loop {
		[
			(notes: 0 + [0, 2, 9], length: 2/3),
			(notes: 0 + [0, 2, 9], length: 2/3),
			(notes: 0 + [0, 3, 7], length: 2),
			(notes: -2 + [0, 4, 9], length: 2/3),
			(notes: -2 + [0, 4, 9], length: 2/3),
			(notes: 7 + [0, 3, -5, -2], length: 2),
		].do { |chord|
			notes = chord[\notes].scramble;
			dur = chord[\length] * beat;
			notes.do { |deg, index|
				var note = (42 + deg + (12 * 1)).midicps;
				Routine({
					if(index > 0, { rrand(0, 0.1).wait; });
					s.bind { Synth(\organ, [freq: note, duration: dur]); };
				}).play;
			};
			(dur).wait;
		};
	};
}).play;
)