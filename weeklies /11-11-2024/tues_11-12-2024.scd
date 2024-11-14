// Eli Fieldsteel Tutorial
// https://youtu.be/lGs7JOOVjag?si=uzF65UzcwcvINjAN

(
SynthDef(\bpfSaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=440, cf=1500, rq=0.2, amp=1, out=0;
	var snd, env;
	env = EnvGen.kr(Env([0,1,1,0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	snd = Saw.ar(freq);
	snd = BPF.ar(snd, cf, rq);
	snd = snd * env * amp;
	Out.ar(out, snd);
}).play;
)
