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
	snd = Pulse.ar(freq);
	snd = snd ! 2;
	snd = BPF.ar(snd, freq, 0.1) * 5.dbamp;
	snd = snd * Env.perc(0.01, 0.2).ar;
	snd;
}.play;
)