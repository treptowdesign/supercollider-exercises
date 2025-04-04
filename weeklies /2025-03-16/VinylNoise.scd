///////////////////////////////////////////////////////////
// Vinyl
///////////////////////////////////////////////////////////

(
SynthDef(\vinylCrackle, { | amp=0.2, density=5 |
	var noise, clicks, crackle;
	noise = WhiteNoise.ar(0.01);
	clicks = Dust.ar(density);
	crackle = clicks * Decay.ar(clicks, 0.01, WhiteNoise.ar(0.5));
	crackle = HPF.ar(crackle, 1000);
	Out.ar(0, (noise + crackle) * amp ! 2);
}).add;
)

x = Synth(\vinylCrackle, [\amp, 0.6, \density, 10]);
// stop with x.free;

(
SynthDef(\n, {
	var snd, lfo;
	lfo = LFNoise1.kr(4, 200, 400);
	snd = SinOsc.ar(lfo, 0, 0.3);
	Out.ar(0, snd ! 2);
}).play;
)

{LFNoise1.kr(4)}.plot(4); // 0 to 1
{LFNoise1.kr(12).bipolar}.plot(4); // 0 to 1
{LFNoise1.kr(8, 0.1)}.plot(4);
{LFNoise1.kr(4, 200, 200)}.plot(4);
