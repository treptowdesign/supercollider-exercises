// Phaser

(
SynthDef(\simplePhaser, {
    arg freq = 440, lfoRate = 0.2, feedback = 0.5, stages = 4, depth = 200, out = 0;
    var signal, mod, phaser, i;

    // Input signal
    signal = Pulse.ar(freq, 0.5, 0.8);

    // LFO modulating the center frequency of the all-pass filters
    mod = SinOsc.kr(lfoRate, 0, depth, 4000);  // Frequency range: 200 Hz to 600 Hz

    // Initialize phaser with the input signal
    phaser = signal;

    // Apply a chain of all-pass filters with feedback
    stages.do {
        phaser = AllpassC.ar(phaser + (signal * feedback), 0.1, mod / SampleRate.ir, 1);
    };

	phaser = Limiter.ar(phaser);

    // Output the processed signal
    Out.ar(out, (phaser * 0.1).dup);  // Stereo output
}).add;
)

x = Synth(\simplePhaser, [\freq, 220, \lfoRate, 0.2, \feedback, 0.7, \stages, 6, \depth, 200]);



// Flanger

(
{
	var snd;
	snd = Pulse.ar(330);
	// snd = snd * Env.perc(0.001, 1).ar;
	snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(0.1, [0, pi]).linlin(-1, 1, 0, 1) * 4e-3);
	snd * -20.dbamp ! 2;
}.play;
)
