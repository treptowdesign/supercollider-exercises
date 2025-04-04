/////////////////////////////////////////////////////////////////////////
// Basic Compression
/////////////////////////////////////////////////////////////////////////
(
{
    var source = SinOsc.ar(440) * 0.5;
    var comp = Compander.ar(
        source,  // input signal
        source,  // control signal (same as input)
        thresh: 0.2,  // threshold
        slopeBelow: 1,  // ratio below threshold (1 = no change)
        slopeAbove: 0.5,  // ratio above threshold (0.5 = compression)
        clampTime: 0.01,
        relaxTime: 0.1
    );
    comp ! 2
}.play;
)

/////////////////////////////////////////////////////////////////////////
// Sidechain Compression
/////////////////////////////////////////////////////////////////////////
(
{
    var trig = Impulse.kr(2);  // trigger 2 times per second
    var kickEnv = EnvGen.kr(Env.perc(0.01, 0.2, 0.8), trig);
    var kick = SinOsc.ar(60, 0, kickEnv);  // synthesize kick drum
    var pad = Saw.ar(150) * 0.3;
    var compressedPad = Compander.ar(
        pad,
        kick,  // control signal (the kick)
        thresh: 0.05,
        slopeBelow: 1,
        slopeAbove: 0.2,  // heavy compression
        clampTime: 0.005,
        relaxTime: 0.2
    );
    (kick + compressedPad) ! 2
}.play;
)

/////////////////////////////////////////////////////////////////////////
// Multiband Compression
/////////////////////////////////////////////////////////////////////////
(
{
    var input = PinkNoise.ar(0.4);
    var low = LPF.ar(input, 200);
    var high = HPF.ar(input, 2000);
    var mid = input - low - high;  // subtractive band
    var lowComp = Compander.ar(low, low, 0.1, 1, 0.5, 0.01, 0.1);
    var midComp = Compander.ar(mid, mid, 0.1, 1, 0.6, 0.01, 0.1);
    var highComp = Compander.ar(high, high, 0.1, 1, 0.7, 0.01, 0.1);
	// var output = input;                     // original
    // var output = (low + mid + high);        // summed bands
    var output = lowComp + midComp + highComp; // multiband compressed
    output ! 2
}.play;
)


















// end file