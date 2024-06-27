(
SynthDef(\square8, { |freq=440, pWidth=0.5, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * ((WhiteNoise.ar * 0.1).midiratio), pWidth);
	// snd = snd + (VarSaw.ar(freq, 2pi, 1) * 0.1);
	snd = (snd.tanh * 0.dbamp).clip2;
	snd = Decimator.ar(snd, bits: 8);
	//snd = snd * Env.perc(0.01, 1, curve: -8).ar(Done.freeSelf);
	snd = snd * LFTri.kr(64).range(0.8, 1);
	snd = snd * Env.perc(0, 0.3).ar.range(1.2, 0.8);
	snd = snd * Env.linen(0.01, duration * span, 0.05).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -10.dbamp * amp.dbamp ! 2);
}).play;
)

(
var s, root, bpm, beat;
s = Server.default;
root = 42; // F#/Gb
bpm = 95;
beat = 60 / bpm;

Routine({
	var play, wait, getFreq;

	wait = { |durationInBeats|
		var duration;
		duration = durationInBeats * beat;
		duration.wait;
	};

	play = { |synthDef, durationInBeats, args = #[]|
		var duration;
		duration = durationInBeats * beat;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
		duration.wait;
	};

	getFreq = { |degree, octave=0|
		(root + degree + (octave * 12)).midicps
	};

	Routine({
		loop {

			play.(\square8, 1/2, [freq: getFreq.(7, 2), span: 0.9]);
			play.(\square8, 1/2, [freq: getFreq.(0, 2), span: 0.9]);

			wait.(1/4);
			play.(\square8, 1/4, [freq: getFreq.(0, 2), span: 0.9]);
			play.(\square8, 1/4, [freq: getFreq.(4, 2), span: 0.9]);
			play.(\square8, 1/4, [freq: getFreq.(5, 2), span: 0.9]);

			play.(\square8, 1/2, [freq: getFreq.(2, 2), span: 0.9]);
			play.(\square8, 1/2, [freq: getFreq.(4, 2), span: 0.9]);

			play.(\square8, 1/2, [freq: getFreq.(9, 2), span: 0.9]);
			play.(\square8, 1/2, [freq: getFreq.(5, 2), span: 0.9]);

		};
	}).play;

	Routine({
		loop {

			2.do {
				play.(\square8, 1/4, [freq: getFreq.(4, 1), span: 0.9, amp: -6]);
				play.(\square8, 1/4, [freq: getFreq.(7, 1), span: 0.9, amp: -6]);
				play.(\square8, 1/4, [freq: getFreq.(0, 1), span: 0.9, amp: -6]);
				play.(\square8, 1/4, [freq: getFreq.(7, 1), span: 0.9, amp: -6]);
			};
			2.do {
				play.(\square8, 1/4, [freq: getFreq.(2, 1), span: 0.9, amp: -6]);
				play.(\square8, 1/4, [freq: getFreq.(9, 1), span: 0.9, amp: -6]);
				play.(\square8, 1/4, [freq: getFreq.(5, 1), span: 0.9, amp: -6]);
				play.(\square8, 1/4, [freq: getFreq.(9, 1), span: 0.9, amp: -6]);
			};

		};
	}).play;

}).play;

)