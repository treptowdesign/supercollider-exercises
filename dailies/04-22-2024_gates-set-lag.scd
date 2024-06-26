(
/*SynthDef(\basicSynth, {
var snd, freq, pan, amp, atk, rel, gate;
pan = \pan.kr(0);
amp = \amp.kr(1);
freq = \freq.kr(440);
atk = \atk.kr(0.01);
rel = \rel.kr(0.6);
snd = SinOsc.ar(freq);
snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
Out.ar(0, Pan2.ar(snd * amp.dbamp, pan));
}).add;*/
SynthDef(\filteredcSynth, {
	arg freq=440, pan=0, amp=1, atk=0.01, rel=0/6, cutoff=8000, rq=0.5, gate=1,
	var snd;
	snd = VarSaw.ar(freq.lag(0.2), 0, 0.9);
	snd = RLPF.ar(snd, cutoff, rq);
	snd = snd * EnvGen.kr(Env.perc(atk, rel), gate, doneAction: 2);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, pan));
}).add;
)


Synth(\mySynth);
Synth(\filteredcSynth);

(
var s, bpm, beat, root, scale;
var randomNote;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.dorian.degrees;
// functions
randomNote = { |octave|
	(root + scale.choose + (12 * octave)).midicps;
};
Routine({
	var synth, tatum;
	tatum = beat / 4;
	synth = Synth(\filteredcSynth, [\gate, 0, \freq, randomNote.(3)]);
	loop {
		synth.set(\gate, 1); // open the gate to start sound
		(tatum * 2).wait;
		synth.set(\freq, randomNote.(1)); // change frequency
		(tatum).wait;
		synth.set(\gate, 0); // close the gate to stop sound
		(tatum).wait;
	};
}).play;
)