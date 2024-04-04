///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)

// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

///////////////////////////////////////////////////////////////
// SynthDefs
///////////////////////////////////////////////////////////////


(
SynthDef(\sin, { |freq=440, rel=0.4, lfoRate=5 |
	var snd, lfo;
	lfo = VarSaw.kr(lfoRate, width: 1).range(1, 6);
	snd = Pulse.ar(freq * lfo.round(1));
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		69
		* (1 + (3 * Env.perc(0.0, 0.3, curve: -9).ar))
		* (1 + (3 * Env.perc(0.0, 0.03, curve: -4).ar))
		* [1, 2.3, 1.4]
	);
	snd = snd * (Env.perc(0, [3.0, 0.5, 0.1]).ar);
	snd = (snd * [0, -10, -15].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 12420, 0.3) * Env.perc(0.001, 0.015).ar * 5.dbamp);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 1.0).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		319
		* (1 + (0.5 * Env.perc(0.0, 0.1, curve: -9).ar))
		* (1 + (0.3 * Env.perc(0.0, 0.03, curve: -4).ar))
		* [0.56, 1, 2.3, 3.4]
	);
	snd = snd * (Env.perc(0, [0.3, 3.0, 0.2, 0.1]).ar);
	snd = (snd * [-5, 0, -5, -3].dbamp).sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), [2420, 5420, 8329], 0.5)
		* Env.perc(0.05, 0.2).ar * [5, 0, -8].dbamp).sum;
	snd = (snd * 8.dbamp).tanh;
	snd = snd * Env.perc(0.0005, 0.12, curve: -1).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 17210, 0.25);
	snd = snd.sign;
	snd = snd * Env.linen(0.0, \rel.kr(0.02), 0.0).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\dist, { | freq=440, rel=0.8 |
	var snd;
	snd = SinOsc.ar(freq);
	snd = (snd * (1 + ([8, 4, 6, 2] * Env.perc([0.1, 0.2, 0.4, 0.2], [0.3, 0.2, 0.05, 0.1], curve: [-2, 4, -8, -4]).kr).dbamp)).tanh;
	snd = snd.sum;
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, 0);
	Out.ar(0, snd);
}).add;
)


Synth(\sin, [freq: 330, rel: 0.8, lfoRate: 6]);
Synth(\kick);
Synth(\snare);
Synth(\hat);
Synth(\dist);



(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 98;
beat = 60 / bpm;
root = 48;
scale = Scale.lydian.degrees;

Routine({
	var idx, note, dur, lfoRate, inst;
	idx = 1;
	loop {
		inst = [1, 2].choose;
		lfoRate = [2, 4, 6].choose;
		note = root + scale.choose + (12 * [1, 2].choose);
		dur = beat / [2, 4].choose;
		if(inst == 1, {
			s.bind { Synth(\sin, [freq: note.midicps, rel: dur, lfoRate: lfoRate]); };
		});
		if(inst == 2, {
			s.bind { Synth(\dist, [freq: note.midicps, rel: dur * 1.6]); };
		});
		(dur).wait;
		idx = (idx % 4) + 1;
	};
}).play;

Routine({
	var idx, note, dur;
	idx = 1;
	loop {
		note = root + scale.choose + (12 * [-1, 0].choose);
		dur = beat / [2, 4].choose;
		s.bind { Synth(\dist, [freq: note.midicps, rel: dur * 1.6]); };
		(dur).wait;
		idx = (idx % 4) + 1;
	};
}).play;

Routine({
	var idx;
	idx = 1;
	loop {
		s.bind { Synth(\hat, [amp: -15.dbamp]); };
		(beat/4).wait;
		idx = (idx % 4) + 1;
	};
}).play;

Routine({
	var idx;
	idx = 1;
	loop {
		"x.x.-... x.x.-... xxxx-... x.x.-.x.".do{ |char|
			switch(char)
			{ $x } {
				s.bind { Synth(\kick); };
				(beat/8).wait;
			}
			{ $- } {
				s.bind { Synth(\snare); };
				(beat/8).wait;
			}
			{$.} {
				(beat/8).wait;
			};
			idx.postln; idx = (idx % 8) + 1;
		};
	};
}).play;

)











///////////////////////////////////////////////////////////////
// End...
///////////////////////////////////////////////////////////////




