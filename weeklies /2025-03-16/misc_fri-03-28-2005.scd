///////////////////////////////////////////////////////////
// Friday 03/28/2025
///////////////////////////////////////////////////////////

(
SynthDef(\synth, { |freq=440|
	var snd;
	snd = SinOsc.ar(freq);
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0, 0.3);
	Out.ar(0, snd);
}).play;
)

///////////////////////////////////////////////////////////
// Reese Bass
///////////////////////////////////////////////////////////
(
SynthDef(\reeseBass, {
    arg freq=50, detune=0.1, amp=0.5, cutoff=800;
    var osc1, osc2, sub, mix, filt;
    osc1 = Saw.ar(freq);
    osc2 = Saw.ar(freq * (1 + detune));
    sub = SinOsc.ar(freq/2) * 0.5;
    mix = Mix([osc1, osc2, sub]) * amp;
    filt = LPF.ar(mix, cutoff);
    Out.ar(0, [filt, filt]);
}).add;
)

// Play Reese Bass:
Synth(\reeseBass, [\freq, 80, \detune, 0.02, \amp, 0.4, \cutoff, 1200]);


///////////////////////////////////////////////////////////
// Acid Bass
///////////////////////////////////////////////////////////

(
SynthDef(\acidBass, {
	arg freq = 60, cutoff = 1000, res = 0.7, amp = 0.5, gate = 1;
	var osc, filt, env, filterEnv;
	// Single saw wave oscillator
	osc = Saw.ar(freq);
	// Quick envelope for amplitude (typical of acid bass)
	env = EnvGen.kr(Env.adsr(0.01, 0.2, 0.5, 0.1), gate, doneAction: 2);
	// Short envelope for filter modulation (accent effect)
	filterEnv = EnvGen.kr(Env.perc(0.01, 0.3), gate, levelScale: 800, levelBias: cutoff);
	// Resonant low-pass filter (Moog-style ladder filter)
	filt = RLPF.ar(osc, filterEnv.clip(100, 8000), res.linexp(0,1,0.5,0.99));
	// Output with envelope
	Out.ar(0, (filt * env * amp).dup);
}).add;
)

(
// Simple acid bass pattern
Pbind(
	\instrument, \acidBass,
	\scale, Scale.minor,
	\degree, Pseq([0, 0, 3, 5, 7, 3, 0, Rest()], inf),
	\octave, 3,
	\dur, 0.15,
	\cutoff, Pseq([600, 800, 1200, 900, 1100], inf),
	\res, 0.8,
	\amp, 0.4
).play;
)

///////////////////////////////////////////////////////////
// 808 Bass
///////////////////////////////////////////////////////////
(
SynthDef(\bass808, {
	arg freq=50, amp=0.8, gate=1, decay=1.5, pitchEnvAmt=40;
	var osc, pitchEnv, ampEnv;
	// Quick pitch drop envelope for punch
	pitchEnv = EnvGen.kr(
		Env.perc(0.001, 0.15),
		levelScale: pitchEnvAmt,
		doneAction: 0
	);
	// Sine oscillator with pitch envelope applied
	osc = SinOsc.ar(freq + pitchEnv);
	// Amplitude envelope (long decay)
	ampEnv = EnvGen.kr(
		Env.adsr(0.001, 0.2, 0.7, decay),
		gate,
		doneAction: 2
	);

	Out.ar(0, (osc * ampEnv * amp).dup);
}).add;
)

// Single deep note
Synth(\bass808, [\freq, 60, \amp, 0.9, \decay, 1.5]);

// Pattern Example
(
Pbind(
	\instrument, \bass808,
	\degree, Pseq([0, Rest(), Rest(), 0, Rest(), 3, -2, Rest()], inf),
	\scale, Scale.minor,
	\octave, 3,
	\dur, 0.5,
	\decay, 1.5,
	\amp, 0.8
).play;
)

///////////////////////////////////////////////////////////
// Basic Pad
///////////////////////////////////////////////////////////

(
SynthDef(\classicPad, {
	arg freq=440, amp=0.5, gate=1, lfoRate=0.2;
	var osc, lfo, filter, ampEnv;
	// Two sawtooth oscillators detuned slightly
	osc = Mix([
		Saw.ar(freq * [1, 1.005]),
		Saw.ar(freq * 2) * 0.3  // higher octave for shimmer
	]);
	// Slow LFO for gentle filter movement
	lfo = SinOsc.kr(lfoRate).range(600, 2000);
	// Gentle low-pass filter modulation
	filter = LPF.ar(osc, lfo);
	// Slow amplitude envelope
	ampEnv = EnvGen.kr(
		Env.adsr(attackTime: 0.01, decayTime: 1, sustainLevel: 0.7, releaseTime: 3),
		gate,
		doneAction:2
	);
	Out.ar(0, (filter * ampEnv * amp).dup);
}).add;
)



(
Pbind(
	\instrument, \classicPad,
	\dur, 4,
	\amp, 0.1,
	\degree, Pseq([[0,2,4],[5,7,9],[-2,0,3],[4,6,8]], inf),
	\octave, 4,
	\legato, 0.9
).play;
)


///////////////////////////////////////////////////////////
// Drum Kit
///////////////////////////////////////////////////////////

(
SynthDef(\kick, {
	arg amp=0.8, freq=60, decay=0.5;
	var env, pitchEnv, osc;
	pitchEnv = EnvGen.kr(Env.perc(0.001, 0.2), levelScale: freq*2, levelBias: freq);
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
	osc = SinOsc.ar(pitchEnv) * env * amp;
	Out.ar(0, osc.dup);
}).play;
)

(
SynthDef(\snare, {
	arg amp=0.5, decay=0.3;
	var noise, tone, env;
	env = EnvGen.kr(Env.perc(0.005, decay), doneAction:2);
	noise = WhiteNoise.ar() * 0.5;
	tone = SinOsc.ar(180) * 0.4;
	Out.ar(0, (noise + tone) * env * amp ! 2);
}).add;
)

(
SynthDef(\hihat, {
	arg amp=0.3, decay=0.1;
	var env, noise, hat;
	env = EnvGen.kr(Env.perc(0.001, decay), doneAction:2);
	noise = WhiteNoise.ar();
	hat = HPF.ar(noise, 7000);
	Out.ar(0, hat * env * amp ! 2);
}).add;
)

(
// Kick Pattern
Pbind(
	\instrument, \kick,
	\dur, Pseq([0.5, Rest(0.5), 0.5, Rest(0.5)], inf),
	\freq, 60,
	\amp, 0.9,
).play;
// Snare Pattern
Pbind(
	\instrument, \snare,
	\dur, Pseq([Rest(0.5), 0.5], inf),
	\amp, 0.5,
).play;
// Hi-hat Pattern
Pbind(
	\instrument, \hihat,
	\dur, 0.25,
	\amp, Pseq([0.3, 0.2, 0.3, 0.2], inf)
).play;
)


///////////////////////////////////////////////////////////
// Lead
///////////////////////////////////////////////////////////

(
SynthDef(\classicLead, {
	arg freq=440, amp=0.4, gate=1, vibRate=5, vibDepth=5;
	var osc, env, vibrato;
	// subtle vibrato
	vibrato = SinOsc.kr(vibRate, 0, vibDepth, freq);
	// single sawtooth oscillator
	osc = Saw.ar(vibrato);
	env = EnvGen.kr(
		Env.adsr(0.01, 0.1, 0.8, 0.2),
		gate,
		doneAction:2
	);
	Out.ar(0, (osc * env * amp).dup);
}).add;
)

(
Pbind(
	\instrument, \classicLead,
	\scale, Scale.minorPentatonic,
	\degree, Pseq([0, 2, 3, 2, 4, 3, 2, 0], inf),
	\dur, 0.25,
	\octave, 4,
	\vibRate, 5,
	\vibDepth, 5,
	\amp, 0.1
).play;
)

{SinOsc.kr(5, 0, 5, 440)}.plot(0.2);


///////////////////////////////////////////////////////////
// Moog Bass
///////////////////////////////////////////////////////////

(
SynthDef(\moogBass, {
	arg freq=60, amp=0.6, gate=1, cutoff=600, res=0.3, glide=0.05;
	var osc, filt, env, freqLag;
	// Portamento glide between notes
	freqLag = Lag.kr(freq, glide);
	// Two detuned sawtooth oscillators for thickness
	osc = Mix([
		Saw.ar(freqLag),
		Saw.ar(freqLag * 1.01)  // slight detune
	]) * 0.5;
	// Resonant low-pass filter (Moog ladder style)
	filt = RLPF.ar(osc, cutoff.clip(100, 5000), res.linexp(0,1,0.5,0.99));
	// Envelope (quick attack, punchy decay)
	env = EnvGen.kr(
		Env.adsr(attackTime: 0.01, decayTime: 0.3, sustainLevel: 0.6, releaseTime: 0.2),
		gate,
		doneAction:2
	);
	Out.ar(0, (filt * env * amp).dup);
}).add;
)

(
Pbind(
	\instrument, \moogBass,
	\scale, Scale.minor,
	\degree, Pseq([0, Rest(), 0, -2, -3, -2], inf),
	\dur, 0.25,
	\cutoff, Pseq([800, 600, 700, 650], inf),
	\res, 0.4,
	\octave, 4,
	\amp, 0.5,
	\glide, 0.03
).play;
)


///////////////////////////////////////////////////////////
// Vinyl
///////////////////////////////////////////////////////////

(
SynthDef(\vinylCrackle, {
	arg amp=0.2, density=5;
	var noise, clicks, crackle;
	// Background low-level white noise
	noise = WhiteNoise.ar(0.01);
	// Random impulse generator for pops and clicks
	clicks = Dust.ar(density); // Adjust density for more or fewer pops
	// Short percussive envelope on clicks
	crackle = clicks * Decay.ar(clicks, 0.01, WhiteNoise.ar(0.5));
	// High-pass filter to remove low-end, making it realistic
	crackle = HPF.ar(crackle, 1200);
	// Mix background noise and crackle pops
	Out.ar(0, (noise + crackle) * amp ! 2);
}).add;
)

x = Synth(\vinylCrackle, [\amp, 0.6, \density, 10]);
// stop with x.free;

///////////////////////////////////////////////////////////
// Tape Hiss
///////////////////////////////////////////////////////////

(
SynthDef(\tapeHiss, {
	arg amp=0.1;
	var noise;
	// White noise with subtle filtering
	noise = WhiteNoise.ar();
	// Gentle low-pass filtering to simulate tape frequency characteristics
	noise = LPF.ar(noise, 8000); // roll off high frequencies gently
	Out.ar(0, noise * amp ! 2);
}).add;
)

y = Synth(\tapeHiss, [\amp, 0.05]);
// stop with y.free;


///////////////////////////////////////////////////////////
// Choir Pads
///////////////////////////////////////////////////////////


(
SynthDef(\choirPad, {
	arg freq=220, amp=0.5, gate=1, lfoRate=0.1;
	var osc, pwm, formants, env, lfo;

	// LFO for pulse-width modulation (vocal-like texture)
	lfo = SinOsc.kr(lfoRate).range(0.3, 0.7);

	// Oscillator with pulse-width modulation
	pwm = Pulse.ar(freq * [1,1.01,0.995], width: lfo).mean;

	// Formant filtering (band-pass to emulate vowel resonances)
	formants = BPF.ar(pwm, [800, 1200, 2500], 0.2).mean;

	// Gentle amplitude envelope
	env = EnvGen.kr(
		Env.adsr(attackTime: 0.1, decayTime: 1.0, sustainLevel: 0.8, releaseTime: 3.0),
		gate,
		doneAction:2
	);

	Out.ar(0, formants * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \choirPad,
	\dur, 6,
	\amp, 0.4,
	\scale, Scale.major,
	\degree, Pseq([[0,2,4],[5,7,9],[-2,0,3],[4,6,8]], inf),
	\octave, 4,
	\legato, 1.1
).play;
)


///////////////////////////////////////////////////////////
// FM Bass
///////////////////////////////////////////////////////////

(
SynthDef(\fmBass, {
	arg freq=50, amp=0.6, modIndex=3, modRatio=2, gate=1;
	var carrier, modulator, env, modEnv;

	// Envelope for amplitude (short, percussive attack)
	env = EnvGen.kr(
		Env.adsr(attackTime:0.01, decayTime:0.2, sustainLevel:0.7, releaseTime:0.3),
		gate,
		doneAction:2
	);

	// Envelope for modulation index (stronger attack)
	modEnv = EnvGen.kr(Env.perc(0.01, 0.2), levelScale: modIndex);

	// Modulator oscillator at harmonic frequency ratio
	modulator = SinOsc.ar(freq * modRatio, 0, freq * modEnv);

	// Carrier oscillator frequency-modulated by modulator
	carrier = SinOsc.ar(freq + modulator);

	Out.ar(0, carrier * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \fmBass,
	\degree, Pseq([0, Rest(), 0, -2, Rest(), -3, -2, Rest()], inf),
	\scale, Scale.minor,
	\octave, 4,
	\dur, 0.25,
	\modIndex, Pseq([2,3,4],inf),
	\modRatio, 3,
	\amp, 0.4
).play;
)

///////////////////////////////////////////////////////////
// Juno Pad
///////////////////////////////////////////////////////////

(
SynthDef(\junoPad, {
	arg freq=440, amp=0.5, gate=1, cutoff=1200, res=0.2, chorusMix=0.3;
	var osc, filt, env, chorus;
	osc = Saw.ar(freq * [1,1.005,0.997]).mean;
	filt = RLPF.ar(osc, cutoff.clip(300,8000), res.linexp(0,1,0.5,0.99));
	env = EnvGen.kr(
		Env.adsr(attackTime:2.5, decayTime:1.5, sustainLevel:0.8, releaseTime:3.5),
		gate,
		doneAction:2
	);
	chorus = Mix.fill(2, { |i|
		DelayC.ar(filt, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.025))
	}).tanh;
	Out.ar(0, XFade2.ar(filt, chorus, chorusMix) * env * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \junoPad,
	\dur, 5,
	\amp, 0.2,
	\scale, Scale.phrygian,
	\degree, Pseq([[0,2,4],[5,7,9],[3,5,7],[4,6,8]], inf),
	\octave, 5,
	\cutoff, Pseq([1500, 1200, 1400, 1300], inf),
	\legato, 1.1
).play;
)

(
Pbind(
	\instrument, \junoPad,
	\dur, 5,
	\amp, 0.2,
	\scale, Scale.phrygian,
	\degree, Pseq([[0,2,4,6],[5,7,9,11]], inf),
	\octave, 5,
	\cutoff, Pseq([1500, 1200, 1400, 1300], inf),
	\legato, 1.1
).play;
)

(
Pbind(
	\instrument, \junoPad,
	\dur, 5,
	\amp, 0.2,
	\scale, Scale.dorian,
	\degree, Pseq([[0,2,4,6],[1,3,5,7]], inf),
	\octave, 4,
	\cutoff, Pseq([1500, 1200, 1400, 1300], inf),
	\legato, 1
).play;
)

(
Pbind(
	\instrument, \junoPad,
	\dur, 5,
	\amp, 0.2,
	\scale, Scale.aeolian,
	\degree, Pseq([[0,2,4,6],[1,3,5,7]], inf),
	\octave, 4,
	\cutoff, Pseq([1500, 1200, 1400, 1300], inf),
	\legato, 1
).play;
)

Scale.dorian;

///////////////////////////////////////////////////////////
// Organ
///////////////////////////////////////////////////////////


(
SynthDef(\organ, {
	arg freq=440, amp=0.4, gate=1, vibRate=5, vibDepth=0.003;
	var osc, env, vibrato, mix;
	osc = Mix([
		SinOsc.ar(freq, 0, 0.5),       // Fundamental
		SinOsc.ar(freq*2, 0, 0.3),     // Octave
		SinOsc.ar(freq*3, 0, 0.2),     // Fifth above octave
		SinOsc.ar(freq*4, 0, 0.1)      // Two octaves above
	]);
	vibrato = osc * SinOsc.kr(vibRate, 0, vibDepth, 1);
	env = EnvGen.kr(Env.asr(0.01, 1.0, 0.5), gate, doneAction:2);
	mix = (vibrato * env).tanh;
	Out.ar(0, mix * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \organ,
	\dur, 0.5,
	\degree, Pseq([[0,2,4],[3,5,7],[4,6,8],[2,4,6]], inf),
	\scale, Scale.mixolydian,
	\octave, 4,
	\amp, 0.3,
	\legato, 0.9
).play;
)

///////////////////////////////////////////////////////////
// Clavinet
///////////////////////////////////////////////////////////

(
SynthDef(\clavinet, {
	arg freq=440, amp=0.5, gate=1, cutoff=1200, res=0.3;
	var osc, filt, env, pluck;

	// Sharp saw oscillator for twang
	osc = Saw.ar(freq);

	// Short, percussive envelope
	env = EnvGen.kr(
		Env.perc(attackTime:0.001, releaseTime:0.3),
		gate,
		doneAction:2
	);

	// Resonant band-pass filter (wah-like effect)
	filt = BPF.ar(osc, cutoff.clip(400,4000), res.linlin(0,1,0.1,0.9));

	// Combine filtered osc and envelope
	pluck = filt * env;

	Out.ar(0, pluck * amp ! 2);
}).add;
)


(
Pbind(
	\instrument, \clavinet,
	\dur, 0.25,
	\degree, Pseq([0,Rest(),3,0,-2,Rest(),3,5], inf),
	\scale, Scale.minorPentatonic,
	\octave, 4,
	\cutoff, Pseq([1200,1500,1800,1300],inf),
	\amp, 0.5
).play;
)

///////////////////////////////////////////////////////////
// Electric Piano - Rhodes
///////////////////////////////////////////////////////////

(
SynthDef(\rhodes, {
	arg freq=440, amp=0.5, gate=1, vibRate=6, vibDepth=0.004;
	var osc, env, vibrato, tone;

	// Bell-like FM synthesis (modulator slightly detuned)
	osc = SinOsc.ar(freq) + SinOsc.ar(freq * 2.01, 0, 0.4);

	// Gentle vibrato for warmth
	vibrato = osc * SinOsc.kr(vibRate, 0, vibDepth, 1);

	// Smooth amplitude envelope
	env = EnvGen.kr(
		Env.adsr(attackTime:0.01, decayTime:0.5, sustainLevel:0.7, releaseTime:1.2),
		gate,
		doneAction:2
	);

	// Mild saturation for warmth
	tone = (vibrato * env).tanh;

	Out.ar(0, tone * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \rhodes,
	\degree, Pseq([[0,2,4],[3,5,7],[4,6,8],[1,3,5]], inf),
	\dur, 1,
	\scale, Scale.major,
	\octave, 4,
	\amp, 0.4,
	\legato, 0.8
).play;
)

///////////////////////////////////////////////////////////
// Electric Piano - Wurlitzer
///////////////////////////////////////////////////////////

(
SynthDef(\wurlitzer, {
	arg freq=440, amp=0.5, gate=1;
	var osc, env, tone;

	// Slightly distorted pulse and saw wave mix for reediness
	osc = Mix([Pulse.ar(freq,0.3), Saw.ar(freq * 1.005, 0.5)]);

	// Percussive envelope (short attack and decay)
	env = EnvGen.kr(
		Env.adsr(attackTime:0.005, decayTime:0.2, sustainLevel:0.6, releaseTime:0.6),
		gate,
		doneAction:2
	);

	// Band-pass filtering to accentuate midrange punch
	tone = BPF.ar(osc, 1200, 0.5) * env;

	// Subtle saturation for analog warmth
	tone = tone.tanh;

	Out.ar(0, tone * amp ! 2);
}).add;
)

(
Pbind(
	\instrument, \wurlitzer,
	\degree, Pseq([0,2,Rest(),3,4,Rest(),2,0], inf),
	\dur, 0.5,
	\scale, Scale.minor,
	\octave, 4,
	\amp, 0.5,
	\legato, 0.7
).play;
)

///////////////////////////////////////////////////////////
// Analog String Pads
///////////////////////////////////////////////////////////

(
SynthDef(\analogStrings, {
	arg freq=440, amp=0.5, gate=1, cutoff=2000, res=0.2, lfoRate=0.15;
	var osc, filt, env, chorus;

	// Multiple detuned saw oscillators
	osc = Mix(Saw.ar(freq * [0.995, 1.0, 1.007, 2.01])) * 0.25;

	// Gentle low-pass filtering with slow modulation
	filt = RLPF.ar(osc, SinOsc.kr(lfoRate).range(cutoff*0.8, cutoff), res.linexp(0,1,0.5,0.95));

	// Smooth ADSR envelope for pad swell
	env = EnvGen.kr(
		Env.adsr(attackTime:2.0, decayTime:1.0, sustainLevel:0.8, releaseTime:3.0),
		gate,
		doneAction:2
	);

	// Chorus effect using modulated stereo delay lines
	chorus = Mix.fill(2, { |i|
		DelayC.ar(filt, 0.03, SinOsc.kr(0.2 + (0.05 * i)).range(0.015,0.025))
	});

	Out.ar(0, (chorus * env * amp).tanh ! 2);
}).add;
)

(
Pbind(
	\instrument, \analogStrings,
	\dur, 2,
	\amp, 0.2,
	\scale, Scale.minor,
	\degree, Pseq([[0,2,4],[5,7,9],[3,5,7],[-2,0,3]], inf),
	\octave, 4,
	\cutoff, Pseq([1800,1500,1700,1600],inf),
	\legato, 1.1
).play;
)



///////////////////////////////////////////////////////////
// CS-80 Brass (iconic Yamaha CS-80 Blade Runner brass)
///////////////////////////////////////////////////////////

(
SynthDef(\cs80Brass, {
	arg freq=440, amp=0.5, gate=1, cutoff=1200, res=0.2, vibRate=5, vibDepth=0.005;
	var osc, filt, env, vibrato, chorus;

	// Vibrato (gentle pitch modulation)
	vibrato = SinOsc.kr(vibRate, 0, vibDepth, 1);

	// Detuned sawtooth oscillators
	osc = Mix(Saw.ar(freq * vibrato * [0.995, 1.0, 1.007, 1.5])) * 0.25;

	// Warm analog-style low-pass filter
	filt = RLPF.ar(osc, cutoff.clip(300,6000), res.linexp(0,1,0.5,0.95));

	// Brass envelope (slow attack, expressive sustain)
	env = EnvGen.kr(
		Env.adsr(attackTime:1.5, decayTime:0.8, sustainLevel:0.9, releaseTime:2.0),
		gate,
		doneAction:2
	);

	// Chorus effect using modulated stereo delays
	chorus = Mix.fill(2, { |i|
		DelayC.ar(filt, 0.03, SinOsc.kr(0.2 + (0.1 * i)).range(0.01,0.02))
	});

	Out.ar(0, (chorus * env * amp).tanh ! 2);
}).add;
)

(
Pbind(
	\instrument, \cs80Brass,
	\dur, 6,
	\amp, 0.4,
	\scale, Scale.minor,
	\degree, Pseq([[0,2,4], [-3,0,2], [-5,-3,0], [2,4,7]], inf),
	\octave, 4,
	\cutoff, Pseq([2000,1500,1700,1600],inf),
	\legato, 1.1
).play;
)

///////////////////////////////////////////////////////////
// Ambient Drone Pads
///////////////////////////////////////////////////////////

(
SynthDef(\ambientDrone, {
	arg freq=110, amp=0.4, cutoff=1000, res=0.3, lfoRate=0.05, panRate=0.03;
	var osc, filt, lfo, pan, chorus, sig;

	// Multiple slow-detuned oscillators for thick, evolving texture
	osc = Mix.fill(4, {|i|
		Saw.ar(freq * (1 + LFNoise1.kr(0.02).range(-0.005, 0.005)))
	}) * 0.25;

	// Slow-moving LFO for cutoff modulation
	lfo = LFNoise1.kr(lfoRate).exprange(cutoff * 0.5, cutoff * 2);

	// Resonant low-pass filter
	filt = RLPF.ar(osc, lfo.clip(200, 4000), res.linlin(0,1,0.1,0.9));

	// Slow amplitude modulation for breathing motion
	sig = filt * SinOsc.kr(0.03).range(0.7, 1);

	// Stereo panning modulation
	pan = Pan2.ar(sig, SinOsc.kr(panRate));

	// Subtle chorus/delay effect for spaciousness
	chorus = pan + DelayC.ar(pan, 0.03, LFNoise1.kr(0.2).range(0.01, 0.03), 0.3);

	Out.ar(0, (chorus * amp).tanh);
}).add;
)

(
Pbind(
	\instrument, \ambientDrone,
	\degree, Pseq([0,-3,-5,-2], inf),  // slow-moving harmonic shifts
	\scale, Scale.minor,
	\octave, 4,
	\dur, 5,        // long duration to allow full evolution
	\cutoff, 1200,
	\res, 0.3,
	\amp, 0.4,.
	\legato, 1.2     // overlapping notes for seamless drones
).play;
)


(
// Ambient reverb effect (added after the drone synth)
SynthDef(\ambientReverb, {
	var in = In.ar(0, 2);
	var rev = FreeVerb.ar(in, mix: 0.4, room: 0.8, damp: 0.5);
	ReplaceOut.ar(0, rev);
}).play(addAction:\addToTail);
)















// endfile...

