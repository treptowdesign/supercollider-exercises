///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
// Chords
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////


(
var getChordShape = { |scale, index, extensions = #[0, 2, 4, 6, 8, 10, 12]|
	var xScale, extendedScale;
	xScale = scale.copyRange(index, scale.size - 1) ++ (scale.copyRange(0, index - 1) + 12);
	extendedScale = xScale ++ (xScale + 12);
	extendedScale[extensions] - scale[index];
};

getChordShape.(Scale.aeolian.degrees, 0);
)





(
SynthDef(\lead, {
    var snd, gate, freq, fb, timbreEnv;
    gate = \gate.kr(1);
    freq = \freq.kr(440).cpsmidi.lag(\lag.kr(0.01)).midicps;
    freq = freq * (SinOsc.ar(4.34) * 0.02).midiratio * (SinOsc.ar(0.5) * 0.1).midiratio;
    timbreEnv = Env.asr(3.0, 1.0, 1.0, curve: -4).ar(gate: gate);
    snd = SinOsc.ar(freq * [1, 1 / 2]) * timbreEnv * SinOsc.ar(0.1, [0, pi]).linexp(-1, 1, 4, 7);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * [0, -10].dbamp;
    snd = snd.sum;
    snd = snd * -20.dbamp;
    snd = snd * Env.perc(0.01, 6.0, curve: -4).ar(Done.freeSelf);
    snd = LPF.ar(snd, 1500);
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, 1.0, [0.45, 0.35] + (SinOsc.ar(0.5, [0, pi]) * 1e-3));
    fb = LPF.ar(fb, 2000);
    fb = HPF.ar(fb, 100);
    fb = fb * -1.dbamp;
    LocalOut.ar(fb);
    snd = snd + fb;
    Out.ar(\out.kr(0), snd);
}).play;
)


( // maj 6
var key = 58;
var spec = [0, [0, 4, 7, 9]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (key + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (key + int + (12 * 0)).midicps]);
};
)

( //  9th, 11th
var key = 58;
var spec = [0, [0, 4, 7, 11, 14, 18]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (key + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (key + int + (12 * 0)).midicps]);
};
)


( //  dominant #5, #9
var key = 58;
var spec = [0, [0, 4, 8, 10, 15]];
var chord, root;
# root, chord = spec;
Synth(\lead, [freq: (key + root + (12 * -1)).midicps]);
chord.do { |int|
	Synth(\lead, [freq: (key + int + (12 * 0)).midicps]);
};
)































// endfile
