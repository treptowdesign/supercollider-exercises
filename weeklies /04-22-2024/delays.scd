////////////////////////////////////////////////////////////////
// Notes
////////////////////////////////////////////////////////////////

// Delays, Comb Filters and Reverb UGens
DelayN DelayL DelayC
CombL CombL CombC
GVerb FreeVerb
NHHall (pluging from Nathan Ho)

////////////////////////////////////////////////////////////////
// Synth Definitions
////////////////////////////////////////////////////////////////

// static delay val
(
SynthDef(\delaySynthStatic, { |maxDelay=0.4, delay=0.15, decay=3|
	var snd, trigger;
	trigger = Dust.kr(2);
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * EnvGen.kr(Env.perc(0.001, 0.2), trigger);
	snd = MoogFF.ar(snd, EnvGen.kr(Env([20, 8000, 20], [0.05, 0.01]), trigger), 2);
	snd = CombN.ar(snd, maxDelay, delay, decay);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)

Synth(\delaySynthStatic, [maxDelay: 0.5, minDelay: 0.2, decay: 1]);

// modulated delay val
(
SynthDef(\delaySynth, { |maxDelay=0.5, minDelay=0.01, decay=2|
	var snd, trigger, delayMod;
	trigger = Dust.kr(5);
	delayMod = SinOsc.kr(2).range(minDelay, maxDelay);
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * EnvGen.kr(Env.perc(0.01, 0.2), trigger);
	snd = CombL.ar(snd, maxDelay, delayMod, decay);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)

Synth(\delaySynth, [maxDelay: 0.4, minDelay: 0.1, decay: 8]);
Synth(\delaySynth, [maxDelay: 0.4, minDelay: 0.1, decay: 1]);
Synth(\delaySynth, [maxDelay: 1, minDelay: 0.2, decay: 1]);
Synth(\delaySynth, [maxDelay: 0.2, minDelay: 0.1, decay: 6]);
Synth(\delaySynth, [maxDelay: 0.8, minDelay: 0.01, decay: 0.1]);
Synth(\delaySynth, [maxDelay: 0.6, minDelay: 0.05, decay: 0.2]);
Synth(\delaySynth, [maxDelay: 0.5, minDelay: 0.25, decay: 0.05]);

////////////////////////////////////////////////////////////////
// Synth Definitions
////////////////////////////////////////////////////////////////

(
SynthDef(\synth, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).add;
SynthDef(\fx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = CombN.ar(
		in: snd,
		maxdelaytime: 0.3,
		delaytime: 0.1,
		decaytime: 1
	);
	Out.ar(\out.kr(0), snd * \amp.kr(1.dbamp));
}).add;
)

Synth(\synth);

////////////////////////////////////////////////////////////////
// Bus Routing
////////////////////////////////////////////////////////////////

(
~fxBus = Bus.audio(s, 2);
)

~fxBus.index;

////////////////////////////////////////////////////////////////
// Sequencing (Routine)
////////////////////////////////////////////////////////////////

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.lydian.degrees;

Synth.tail(nil, \fx, [in: ~fxBus]);

Routine({
	var tatum, dur, note, octave;
	var freqs = Pseq([440, 550, 660, 880], inf).asStream;
	tatum = beat / 4;
	loop {
		dur = tatum  * [1,2,3,4].choose;
		8.do {
			octave = [0, 1, 2].choose;
			// note = (root + scale.choose + (12 * octave)).midicps;
			note = freqs.next;
			s.bind { Synth(\synth, [freq: note, out: ~fxBus]); };
			dur.wait;
		};

	};
}).play;

)

























// end...