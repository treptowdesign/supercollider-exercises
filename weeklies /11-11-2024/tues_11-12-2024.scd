// Eli Fieldsteel Tutorial
// https://youtu.be/lGs7JOOVjag?si=uzF65UzcwcvINjAN

// LFNoise

{ SinOsc.ar(60 + (LFNoise0.ar(1).range(1, 150)) ) * -10.dbamp ! 2}.play;
{ SinOsc.ar(60 + (LFNoise1.ar(1).range(1, 150)) ) * -10.dbamp ! 2}.play;
{ SinOsc.ar(60 + (LFNoise2.ar(1).range(1, 150)) ) * -10.dbamp ! 2}.play;
