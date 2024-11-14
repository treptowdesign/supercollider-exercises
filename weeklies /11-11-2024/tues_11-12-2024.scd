// Eli Fieldsteel Tutorial
// https://youtu.be/lGs7JOOVjag?si=uzF65UzcwcvINjAN

// LFNoise

{ SinOsc.ar(60 * (LFNoise0.ar(4).range(1, 30)) ) * -10.dbamp ! 2}.play;
{ SinOsc.ar(60 * (LFNoise1.ar(4).range(1, 30)) ) * -10.dbamp ! 2}.play;
{ SinOsc.ar(60 * (LFNoise2.ar(4).range(1, 30)) ) * -10.dbamp ! 2}.play;

//

(
{
	var snd, freq;
	freq = 440;
	snd = Saw.ar(freq);
	snd = BPF.ar(snd, LFNoise2.ar(32).range(freq, freq* 8), 0.1) * 0.dbamp;
	snd = snd * Env.perc(0.01, 6).ar;
	snd ! 2;
}.play;
)