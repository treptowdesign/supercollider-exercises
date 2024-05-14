(
SynthDef(\acidBass, {
    arg freq = 110, res = 0.9, cutoff = 1000, amp = 0.5, gate = 1;
    var env, osc, filter, ampEnv;
    ampEnv = EnvGen.kr(Env.adsr(0.01, 0.1, 0.7, 0.2), gate, doneAction: 2);
    osc = Saw.ar(freq);
    filter = RLPF.ar(osc, cutoff, res);
    Out.ar(0, filter * ampEnv * amp ! 2);
}).add;
)

(
Pdef(\acid).clear;
Pdef(\acid,
    Pbind(
        \instrument, \acidBass,
        \dur, 0.25,
        \freq, Pseq([110, 220, 165, 130], inf),
        \cutoff, Pseq([1000, 800, 1200, 1500], inf),
        \res, 0.9,
        \amp, 0.5
    )
).play;
)


(
SynthDef(\pad, {
    arg freq = 440, detune = 0.005, amp = 0.5, gate = 1, attack = 2, release = 3, cutoff = 800;
    var env, osc1, osc2, osc3, mix, filter;
    env = EnvGen.kr(Env.adsr(attack, 0.5, 0.7, release), gate, doneAction: 2);
    osc1 = Saw.ar(freq);
    osc2 = Saw.ar(freq * (1 + detune));
    osc3 = Saw.ar(freq * (1 - detune));
    mix = (osc1 + osc2 + osc3) / 3;
    filter = LPF.ar(mix, cutoff);
    Out.ar(0, filter * env * amp);
}).add;
)

(
Pdef(\pad).clear;
Pdef(\pad,
    Pbind(
        \instrument, \pad,
        \dur, Pseq([2, 2, 4, 4], inf),
        \freq, Pseq([220, 330, 440, 550], inf),
        \attack, 2,
        \release, 3,
        \cutoff, 800,
        \amp, 0.3
    )
).play;
)

(
SynthDef(\pulseChorusPad, {
    arg freq = 440, width = 0.5, amp = 0.5, gate = 1, attack = 2, release = 3, depth = 0.3, rate = 0.25;
    var env, osc, chorus, lfo;

    // Amplitude envelope
    env = EnvGen.kr(Env.adsr(attack, 0.5, 0.7, release), gate, doneAction: 2);

    // Pulse wave oscillator
    osc = Pulse.ar(freq, width);

    // LFO for chorus effect
    lfo = SinOsc.kr(rate, 0, depth, 1);
    chorus = DelayC.ar(osc, 0.03, lfo * 0.015 + 0.015);

    // Output
    Out.ar(0, (osc + chorus) * env * amp * 0.5 ! 2); // Mixing original and chorus signals
}).add;
)

// Example usage
(
Pdef(\pulseChorusPad).clear;
Pdef(\pulseChorusPad,
    Pbind(
        \instrument, \pulseChorusPad,
        \dur, Pseq([2, 2, 4, 4], inf),
        \freq, Pseq([220, 330, 440, 550], inf),
        \attack, 2,
        \release, 3,
        \width, 0.5,
        \depth, 0.3,
        \rate, 0.25,
        \amp, 0.3
    )
).play;
)


