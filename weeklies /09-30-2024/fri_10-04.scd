// FM Synthesis
// https://depts.washington.edu/dxscdoc/Help/Tutorials/Mark_Polishook_tutorial/18_Frequency_modulation.html
// messing with this tutorial

(
SynthDef("fm1", { arg bus = 0, freq = 440, carPartial = 1, modPartial = 1, index = 3, mul = 0.05;

    // index values usually are between 0 and 24
    // carPartial :: modPartial => car/mod ratio

    var mod, car;

    mod = SinOsc.ar(
        freq * modPartial,
        0,
        freq * index * LFNoise1.kr(5.reciprocal).abs
    );

    car = SinOsc.ar(
        (freq * carPartial) + mod,
        0,
        mul
    );

    Out.ar(
        bus,
        car
    )
}).add;
)

(
Synth("fm1", [\bus, 0, \freq, 440, \carPartial, 1, \modPartial, 2.4]);
Synth("fm1", [\bus, 1, \freq, 442, \carPartial, 1, \modPartial, 2.401]);
)

(
SynthDef("fm2", { arg bus = 0, freq = 440, carPartial = 1, modPartial = 1, index = 3, mul = 0.05;

    var mod, car;

    mod = SinOsc.ar(
        freq: freq * modPartial,
        phase: 0,
        mul: freq * index * LFNoise1.kr(1/5).abs
    );

    car = SinOsc.ar(
        freq: (freq * carPartial) + mod,
        phase: 0,
        mul: mul
    );

    Out.ar(0, car ! 2);
}).add;
)

(
Synth("fm2", [freq: 440, carPartial: 1, modPartial: 2.4, index: 3]);
)









(
s.queryAllNodes;
)