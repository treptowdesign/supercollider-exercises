(
SynthDef(\synth, {
	var snd;
	snd = Pulse.ar(440);
	snd = Pluck.ar(snd, Impulse.kr(50), 0.01, 0.01, 10);
	snd = snd * Env.perc(0.2, 1).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\guitarPluck, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pluck.ar(SinOsc.ar(XLine.ar(2000, 50, 0.01) * ExpRand(0.5, 1)) + WhiteNoise.ar, Impulse.ar(0), 0.2, 1 / freq, 20, 0.2);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 60), 0.2, 1 / 120, 0.1), -60);
	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, 60), 0.2, 1 / 280, 0.1), -60);
	snd = snd.tanh;
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.08, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
[0, 7, 16].do { |interval|
	var note = (38 + interval + (12 * 1)).midicps;
	Synth(\guitarPluck, [freq: note]);
};
)


// From the Docs
// excitation signal is WhiteNoise, triggered twice a second with varying OnePole coef
(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play;
)
s.quit;
// a group of angry fretless mandolin players
(
    {
        var freq, numparts;
        numparts = 50;
        freq = SinOsc.kr(Array.fill(numparts, {Rand(0.05, 0.2)}),
            Array.fill(numparts, {Rand(0, 1.0)})).range(1000, 3000);
        LeakDC.ar(
            Pan2.ar(
                Pluck.ar(
                    WhiteNoise.ar(0.1).dup(numparts),
                    Impulse.kr(Array.fill(numparts, {Rand(10, 12)})),
                    100.reciprocal, freq.reciprocal, 2, Rand(0.01, 0.2), mul: 1),
                Array.fill(numparts, {Rand.new(-1.0, 1.0)}))
            .sum
            );
        }.play(s);
)