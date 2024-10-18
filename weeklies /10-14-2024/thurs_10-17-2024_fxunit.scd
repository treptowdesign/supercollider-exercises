(

// Simple Instrument
SynthDef(\sine, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, 0.2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd * -20.dbamp ! 2);
}).add;

// FX Unit w/ Feedback
SynthDef(\fxUnit, {
	var snd, fb;
	snd = In.ar(\in.kr(0), 2);

	// feedback loop start
	fb = LocalIn.ar(2);
	fb = fb + snd;
	fb = DelayC.ar(fb, 1.0, [0.1, 0.14] + (SinOsc.ar(0.3, [0, pi]) * 3e-4), 0.6);
	fb = AllpassC.ar(fb, 0.034, 0.034 * [1, 1.2], 1);
	fb = AllpassC.ar(fb, 0.076, 0.076 * [1.3, 1.2], 0.8);
	fb = fb + snd.reverse;
	fb = DelayC.ar(fb, 1.0, [0.15, 0.1] + (SinOsc.ar(0.6, [0.3pi, 0]) * 2e-4), 0.7);
	fb = AllpassC.ar(fb, 0.022, 0.022 * [1.4, 1.3], 0.4);
	fb = AllpassC.ar(fb, 0.016, 0.016 * [0.8, 1.6], 0.6);
	fb = fb + snd.reverse;
	fb = fb + LPF.ar(PitchShift.ar(fb * -16.dbamp, [0.2, 0.3], 2, 0.001), 1000);
	fb = fb + PitchShift.ar(fb * -16.dbamp, [0.34, 0.13], 0.5, 0.001);
	fb = LPF.ar(fb, 4000);
	fb = HPF.ar(fb, 100);
	fb = fb.reverse * -4.dbamp;
	LocalOut.ar(fb);
	// feedback loop end

	snd = snd + fb;
	snd = Limiter.ar(snd); // Limiter since Im dealing with feedback
	Out.ar(\out.kr(0), snd);
}).add;
)


(
~fxBus = Bus.audio(nil, 2);
)

~fxBus.index;

(
var s, beat, fx;
s = Server.default;
beat = 60 / 110;

fx = Synth.tail(nil, \fxUnit, [in: ~fxBus, out: 0]);

Routine({
	var dur, note;
	dur = beat/2;
	fork {
		loop {
			[0, 7, 8, 2, 0, 2, 7, 3].do { |interval|
				note = 42 + interval + (12 * [2, 3].choose);
				s.bind { Synth(\sine, [freq: note.midicps, out: ~fxBus]); };
				dur.wait;
			}
		};
	};
}).play;

)


// ALLPASS DOCS //////////////////////////////////////////////////////


// Since the allpass delay has no audible effect as a resonator on
// steady-state sound ...

{ AllpassC.ar(WhiteNoise.ar(0.1), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

// ...these examples add the input to the effected sound and compare variants so that you can hear
// the effect of the phase comb:

({
    z = WhiteNoise.ar(0.2) ! 2;
    z + AllpassN.ar(z, 0.1, XLine.kr(0.0001, 1, 2), 0.2)
}.play)


({
    z = WhiteNoise.ar(0.2) ! 2;
    z + AllpassL.ar(z, 0.1, XLine.kr(0.0001, 1, 2), 0.1)
}.play)

({
    z = WhiteNoise.ar(0.2) ! 2;
    z + AllpassC.ar(z, 0.1, XLine.kr(0.0001, 1, 2), 0.1)
}.play)


// used as an echo - doesn't really sound different than Comb,
// but it outputs the input signal immediately (inverted) and the echoes
// are lower in amplitude.
{ AllpassC.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;


// EFFECTS //////////////////////////////////////////////////////

(
SynthDef(\sinePitch, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = PitchShift.ar(snd, 0.1, 1.0 + (LFNoise2.ar(8) * 0.5));
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

(
SynthDef(\sineComb, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd + CombC.ar(snd, 0.1, [0.1, 0.14] + (SinOsc.ar(8, [0, pi]) * 0.3e-3),1) * -3.dbamp;
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

(
SynthDef(\sineRhpf, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = RLPF.ar(snd, LFNoise2.ar(8).linexp(-1, 1, 200, 3000), 0.1) * -10.dbamp;
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd ! 2);
}).play;
)

// EFFECTS //////////////////////////////////////////////////////




