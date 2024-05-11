// synth
(
SynthDef(\synth, {
	var snd;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.001, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).add;
SynthDef(\fx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	// snd = GVerb.ar(snd, 20, 2, 0.9) * -10.dbamp;
	snd = FreeVerb.ar(snd) * 1.dbamp;
	Out.ar(\out.kr(0), snd * \amp.kr(1.dbamp));
}).add;
)


Synth(\synth);


(
SynthDef(\metalRise, {
	var snd;
	snd = Pulse.ar(\freq.kr(70), Line.kr(0.2, 0.9, 0.5));
	snd = MoogFF.ar(
		snd,
		Env.perc(0.35, 0.15).ar.linlin(0, 1, 60, 6000),
		Env.perc(0.35, 0.15).ar.linlin(0, 1, 1, 2)
	);
	// snd = CombN.ar(snd, 0.05, 0.05, 2);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)


(
SynthDef(\delayPWBass, {
	var snd;
	snd = Pulse.ar(\freq.kr(70), XLine.kr(0.2, 0.9, 0.5));
	snd = MoogFF.ar(
		snd,
		Env.perc(0.05, 0.35).ar.linlin(0, 1, 60, 9000),
		Env.perc(0.15, 0.15).ar.linlin(0, 1, 1, 2)
	);
	// snd = CombN.ar(snd, 0.2, 0.2, 3);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)




(
SynthDef(\delayBassSquare, {
	var snd;
	snd = Pulse.ar(\freq.kr(60));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.02).ar));
	snd = MoogFF.ar(
		snd,
		Env.perc(0.05, 0.55).ar.linlin(0, 1, 60, 4000),
		1
	);
	// snd = CombN.ar(snd, 0.1, 0.1, 2);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)

(
SynthDef(\delayBassSquare, {
	var snd;
	snd = Pulse.ar(\freq.kr(60));
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = MoogFF.ar(
		snd,
		Env.perc(0.01, 0.5).ar.linlin(0, 1, 60, 6000),
		1
	);
	// snd = CombN.ar(snd, 0.1, 0.1, 2);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)

(
SynthDef(\delayBassSquare2, {
	var snd;
	snd = Pulse.ar(\freq.kr(60));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.02).ar));
	snd = MoogFF.ar(
		snd, Env.perc(0.1, 0.5).ar.linexp(0, 1, 60, 4000), 0
	);
	// snd = snd + CombN.ar(snd, 0.3, 0.3, 1);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)

(
SynthDef(\delayBassSquare3, {
	var snd;
	snd = Pulse.ar(\freq.kr(60));
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = MoogFF.ar(
		snd, Env.perc(0.2, 1).ar.linexp(0, 1, 60, 6000), 2
	);
	// snd = snd + CombN.ar(snd, 0.3, 0.3, 1);
	snd = snd * Env.perc(0.001, 1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)




(
SynthDef(\delayHollowBass, {
	var snd;
	snd = Saw.ar(\freq.kr(60));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.02).ar));
	snd = BPF.ar(snd, (1..12).normalize.linexp(0, 1, 20, 4000), 0.1) * (1..12).linlin(1, 20, 12, 1).dbamp;
	snd = snd.sum;
	snd = (snd * 1.dbamp).tanh;
	snd = MoogFF.ar(
		snd,
		Env.perc(0.01, 0.55).ar.linlin(0, 1, 60, 2000),
		1
	);
	// snd = CombN.ar(snd, 0.2, 0.2, 2);
	snd = snd + ((snd * 2.dbamp).tanh * -10.dbamp);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)



(
SynthDef(\delayHollowBassSub, {
	var snd, sub;
	sub = SinOsc.ar(\freq.kr(60)) * 0.5;
	snd = Saw.ar(\freq.kr(60));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.02).ar));
	snd = BPF.ar(snd, (1..12).normalize.linexp(0, 1, 20, 4000), 0.1) * (1..12).linlin(1, 20, 12, 1).dbamp;
	snd = snd.sum;
	snd = (snd * 1.dbamp).tanh;
	snd = MoogFF.ar(
		snd,
		Env.perc(0.01, 0.55).ar.linlin(0, 1, 60, 2000),
		1
	);
	// snd = snd + CombN.ar(snd, 0.1, 0.1, 6);
	snd = sub + snd + ((snd * 2.dbamp).tanh * -10.dbamp);
	snd = snd * Env.perc(0.001, 2).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)





(
SynthDef(\delayPWBass, {
	var snd, env;
	env = Env.perc(0, 6, 1, -2).ar;
	snd = Pulse.ar(\freq.kr(60), env.linexp(0, 1, 0.2, 0.9));
	snd = snd * (1 + (1.35 * Env.perc(0.001, 0.02).ar));
	snd = MoogFF.ar(snd, env.linexp(0, 1, 60, 4000), 1.5);
	// snd = snd + (CombN.ar(snd, 0.2, 0.1, 6) * -5.dbamp);
	snd = snd * Env.perc(0.001, 5, 1, -8).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Pan2.ar(snd * \amp.kr(1.dbamp), \pan.kr(0)));
}).play;
)


// bussing
(
~fxBus = Bus.audio(s, 2);
)

~fxBus.index;


// routine
(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 90;
beat = 60 / bpm;
root = 42;
scale = Scale.dorian.degrees;

Synth.tail(nil, \fx, [in: ~fxBus]);


Routine({
	var tatum, dur, note, octave;
	// var freqs = Pseq([440, 550, 660, 880], inf).asStream;
	tatum = beat / 4;
	loop {
		dur = tatum  * [1, 2].choose;
		octave = [2, 3].choose;
		8.do {
			note = (root + scale.choose + (12 * octave)).midicps;
			// note = freqs.next;
			// s.bind { Synth(\delayPWBass, [freq: note, out: 0]); };
			s.bind { Synth(\synth, [freq: note, out: ~fxBus]); };
			// s.bind { Synth(\delayHollowBassSub, [freq: note, out: 0]); };
			dur.wait;
		};
	};
}).play;

Routine({
	var tatum, dur, note, octave;
	// var freqs = Pseq([440, 550, 660, 880], inf).asStream;
	tatum = beat / 4;
	loop {
		dur = tatum  * [4].choose;
		octave = [-1].choose;
		8.do {
			note = (root + scale.choose + (12 * octave)).midicps;
			// note = freqs.next;
			// s.bind { Synth(\delayPWBass, [freq: note, out: 0]); };
			// s.bind { Synth(\synth, [freq: note, out: ~fxBus]); };
			// s.bind { Synth(\delayHollowBassSub, [freq: note, out: 0]); };
			dur.wait;
		};
	};
}).play;

)



