(
SynthDef(\basicSynth, {
arg freq=440, pan=0, amp=1, atk=0.01, rel=0.6, gate=1;
var snd;
snd = SinOsc.ar(freq);
snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
Out.ar(0, Pan2.ar(snd * amp.dbamp, pan));
}).add;
SynthDef(\filteredcSynth, {
	arg freq=440, pan=0, amp=1, atk=0.01, rel=0.6, cutoff=7000, rq=0.5, gate=1;
	var snd;
	snd = VarSaw.ar(freq.lag(0.2), 0, 0.9);
	// snd = snd * Pulse.kr(20, 0.35).range(0, 1);
	snd = RLPF.ar(snd, cutoff, rq);
	snd = snd * EnvGen.kr(Env.perc(atk, rel), gate, doneAction: 2);
	Out.ar(0, Pan2.ar(snd * amp.dbamp, pan));
}).add;
)


Synth(\basicSynth);
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
	synth = Synth(\filteredcSynth, [\gate, 0, \freq, randomNote.(1)]);
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





// end...