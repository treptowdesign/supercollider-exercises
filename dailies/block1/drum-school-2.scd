// Kickoff
s.plotTree;
s.scope;
s.meter;
FreqScope.new(250);

//  https://youtu.be/xYc7_PbbtuE?si=gcvezg0IIqMHfFGh

// basic structure
(
SynthDef(\kick00, {
	var snd;
	// SIGNAL
	snd = SinOsc.ar(60 *
		(1 + (8 * Env.perc(0.001, 0.3, curve: -8).ar))
	);
	// AMP
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	// STEREO & OUT
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)
Synth(\kick00);


// second env (timestamp 5:56) "laser"
(
SynthDef(\kick01, {
	var snd;
	// SIGNAL
	snd = SinOsc.ar(60 *
		(1 + (8 * Env.perc(0.001, 0.3, curve: -8).ar)) *
		(1 + (8 * Env.perc(0, 0.001).ar)) // 2nd Env
	);
	// AMP
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	// STEREO & OUT
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)
Synth(\kick01);

// click??? (timestamp 7:15)

