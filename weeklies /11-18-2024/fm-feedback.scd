(
SynthDef(\fm_feedback, {
    |freq = 220, modIndex = 100, feedbackAmount = 0.2, amp = 0.5|

    // Carrier frequency
    var carrier = freq;

    // Feedback loop: Use a Delay to create feedback
    var feedback, modulator, sound;

    feedback = LocalIn.ar(1); // Feedback input
    modulator = SinOsc.ar(carrier + (feedback * feedbackAmount) * modIndex); // Modulator
    // FM synthesis
    sound = SinOsc.ar(carrier + (modulator * modIndex)); // Carrier modulated by modulator
    // Output sound and feed back into the feedback loop
    LocalOut.ar(sound);

    // Output with amplitude control
    Out.ar(0, sound * amp ! 2);
}).add;
)

// Play the synth
(
x = Synth(\fm_feedback, [
    \freq, 220,
    \modIndex, 200,   // Intensity of modulation
    \feedbackAmount, 0.3, // Feedback strength
    \amp, 0.3
]);
)

// Change parameters live
x.set(\feedbackAmount, 0.5);
x.set(\modIndex, 300);

// Free the synth
x.free;
