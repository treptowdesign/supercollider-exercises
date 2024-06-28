(
SynthDef(\square8, { |freq=110, pWidth=0.5, fCuttoff=14000, vibratoDepth=0.1, duration=1, span=1, amp=0|
	var snd;
	snd = Pulse.ar(freq * ((WhiteNoise.ar * 0.1).midiratio) * (SinOsc.kr(8) * vibratoDepth).midiratio, pWidth);
	snd = snd * Env.perc(0, 0.3).ar.range(1.2, 0.8);
	// snd = snd + (BRF.ar(snd, SinOsc.kr(4).exprange(60, 1000), 0.) * 0.4) * -2.dbamp;
	snd = LPF.ar(snd, fCuttoff);
	snd = snd * Env.linen(0.01, duration * span, 0.005).ar(Done.freeSelf);
	snd = snd * AmpComp.ir(freq);
	// snd = LeakDC.ar(snd);
	Out.ar(0, snd * -10.dbamp * amp.dbamp ! 2);
}).add;
SynthDef(\tri8, { |freq=110, pWidth=0.5, fCuttoff=14000, vibratoDepth=0.1, duration=1, span=1, amp=0|
	var snd;
	snd = VarSaw.ar(freq);
	snd = snd * Env.perc(0, 0.3).ar.range(1.2, 0.8);
	// snd = snd + (BRF.ar(snd, SinOsc.kr(4).exprange(60, 1000), 0.) * 0.4) * -2.dbamp;
	snd = LPF.ar(snd, fCuttoff);
	snd = snd * Env.linen(0.01, duration * span, 0.005).ar(Done.freeSelf);
	snd = snd * AmpComp.ir(freq);
	// snd = LeakDC.ar(snd);
	Out.ar(0, snd * -10.dbamp * amp.dbamp ! 2);
}).add;
)

(
var s, root, bpm, beat;
s = Server.default;
root = 38; // F#/Gb
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

	/*Routine({

		var amp, cutoff;
		amp = -6;
		cutoff = 10000;

		loop {
			wait.(0.5);
			play.(\square8, 0.5, [freq: getFreq.(7, 2), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.25, [freq: getFreq.(12, 2), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.25, [freq: getFreq.(5, 2), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.25, [freq: getFreq.(4, 2), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.25, [freq: getFreq.(12, 2), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);

		};
	}).play;*/

	Routine({

		var amp, cutoff;
		amp = -8;
		cutoff = 10000;

		loop {
			play.(\square8, 0.5, [freq: getFreq.(7, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.5, [freq: getFreq.(0, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.5, [freq: getFreq.(0, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.5, [freq: getFreq.(2, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);

			play.(\square8, 0.5, [freq: getFreq.(5, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.5, [freq: getFreq.(4, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.5, [freq: getFreq.(2, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);
			play.(\square8, 0.5, [freq: getFreq.(9, 1), span: 0.95, amp: amp, pWidth: 0.5, fCuttoff: cutoff]);

			/*wait.(1);
			wait.(1);*/

		};
	}).play;

	Routine({

		var amp, cutoff;
		amp = -6;
		cutoff = 10000;

		loop {
			play.(\tri8, 0.5, [freq: getFreq.(0, 0), span: 0.95, amp: amp]);
			play.(\tri8, 0.75, [freq: getFreq.(7, 0), span: 0.95, amp: amp]);
			play.(\tri8, 0.25, [freq: getFreq.(0, 0), span: 0.95, amp: amp]);
			play.(\tri8, 0.5, [freq: getFreq.(7, 0), span: 0.95, amp: amp]);

			play.(\tri8, 0.5, [freq: getFreq.(5, 0), span: 0.95, amp: amp]);
			play.(\tri8, 0.25, [freq: getFreq.(12, 0), span: 0.95, amp: amp]);
			play.(\tri8, 0.75, [freq: getFreq.(5, 0), span: 0.95, amp: amp]);
			play.(\tri8, 0.5, [freq: getFreq.(12, 0), span: 0.95, amp: amp]);

		};
	}).play;

}).play;

)