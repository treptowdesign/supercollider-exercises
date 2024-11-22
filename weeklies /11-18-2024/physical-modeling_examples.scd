(
{
    var exciter = WhiteNoise.ar * EnvGen.ar(Env.perc(0.001, 0.1), doneAction: 2); // Exciter: noise burst
    var resonator = Ringz.ar(exciter, 100, 0.2) + Ringz.ar(exciter, 200, 0.2); // Resonator: resonant filters
    resonator * 0.1 // Adjust output volume
}.play;
)

(
{
    var freq = 220; // Frequency of the plucked string
    var decay = 5;  // Decay time in seconds
    var pluck = PinkNoise.ar(Decay2.ar(Impulse.ar(1), 0.001, 0.05)); // Exciter: short noise burst
    var string = CombL.ar(pluck, 1/freq, 1/freq, decay); // Resonator: delay line
    string * 0.1 // Adjust output volume
}.play;
)