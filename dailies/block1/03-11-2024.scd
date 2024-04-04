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
SynthDef(\chirp, {
	var snd, lfo;
	lfo = Pulse.ar(Line.ar(18, 4, \rel.kr(0.8)), Env.perc(0.6, 0.2, 1).ar, Env.perc(0.4, 0.3, 8).ar, 8);
	snd = Pulse.ar(\freq.kr(440) * lfo);
	snd = snd * Env.perc(0.01, \rel.kr(0.8)).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\chirp, [freq: 440, rel: 0.8]);

(
SynthDef(\arp, { | lfoRate=6, lfoScale=3, lfoDir=0 |
	var snd, lfo;
	lfo = VarSaw.ar(lfoRate, 0, lfoDir, lfoScale, (1 + lfoScale));
	snd = Pulse.ar(\freq.kr(440) * lfo.round(1));
	snd = snd * Env.perc(0.01, 0.8).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\arp, [freq: 110, lfoRate: 3, lfoScale: 3, lfoDir: 0]);
Synth(\arp, [freq: 110, lfoRate: 3, lfoScale: 3, lfoDir: 1]);
Synth(\arp, [freq: 110, lfoRate: 1.5, lfoScale: 6]);
Synth(\arp, [freq: 110, lfoRate: 2, lfoScale: 8, lfoDir: 0]);
Synth(\arp, [freq: 110, lfoRate: 25, lfoScale: 2, lfoDir: 1]);
Synth(\arp, [freq: 110, lfoRate: 10, lfoScale: 2, lfoDir: 1]);


(
SynthDef(\pwm, { | rel=0.8 |
	var snd, lfo;
	lfo = VarSaw.ar(rel, 0, 1);
	snd = Pulse.ar(\freq.kr(110), width: lfo);
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
	snd = snd + (snd * 18.dbamp).tanh;
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\pwm);

(
SynthDef(\pls, {
	var snd;
	snd = Pulse.ar(\freq.kr(110));
	snd = snd * Env.perc(0.01, 0.6).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\pls);


(
SynthDef(\exp, {
	var snd;
	snd = Pulse.ar(\freq.kr(110) * SinOsc.ar(6).range(-0.5, 0.5).midiratio);
	snd = snd * Env.perc(0.03, 1.2, curve: -1).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\exp);

0.25.midiratio;

(
SynthDef(\exp2, {
	var snd, env;
	snd = Pulse.ar(\freq.kr(110) * SinOsc.ar(Line.kr(4, 16, \rel.kr(1.2))).range(-0.25, 0.25).midiratio);
	snd = snd * Env.perc(0.05, \rel.kr(1.2), curve: -1).ar(Done.freeSelf);
	snd = (snd * Line.kr(2, 8, \rel.kr(1.2)).dbamp).tanh;
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\exp2, [freq: 220]);

(
SynthDef(\pitch, {
	var snd;
	snd = Pulse.ar(XLine.kr(\freq.kr(440), \freq.kr(440) / 8, \rel.kr(0.8)));
	snd = snd * Env.perc(0.01, \rel.kr(0.8), curve: 4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pitchWobble, {
	var snd;
	snd = Pulse.ar(
		XLine.kr(\freq.kr(440), \freq.kr(440) / 8, \rel.kr(0.8)) *
		SinOsc.kr(4).range(1, 2)
	);
	snd = snd * Env.perc(0.01, \rel.kr(0.8), curve: 4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\pitch);
Synth(\pitchWobble);


(
SynthDef(\filt, {
	var snd;
	snd = Pulse.ar(\freq.kr(440));
	snd = RLPF.ar(snd, Env.perc(0.01, \rel.kr(0.8), curve: -2).kr().exprange(80, 16000), rq: 0.2);
	snd = snd * Env.perc(0.01, \rel.kr(0.8), curve: -2).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\filt, [freq: 110, rel: 0.4]);

(
SynthDef(\sinePbend, {
	var snd;
	snd = SinOsc.ar(
		XLine.ar(\freq.kr(440), \freq.kr(440) * 2, \rel.kr(0.5)) *
		SinOsc.kr(Line.kr(20, 0.1, \rel.kr(0.5))).exprange(1, 8);
	);
	snd = snd * Env.perc(0.01, \rel.kr(0.5)).ar(Done.freeSelf);
	snd = (snd * 16.dbamp).tanh;
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\sinePbend, [freq: 110, rel: 1.2]);


(
SynthDef(\basic, {
	var snd, dry;
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.perc(0.01, \rel.kr(0.5)).ar(Done.freeSelf);
	dry = snd;
	// snd = FreqShift.ar(snd, Rand(-30, 30));
	// snd = snd + PitchShift.ar(snd, Rand(0.02, 0.05), 1 + Amplitude.ar(snd, 0.01, 0.1));
	// snd = snd + (LPF.ar(GVerb.ar(snd, Rand(30, 50), Rand(1, 3)), 3000) * -10.dbamp);
	snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(Rand(0.1, 0.3), [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	// snd = snd + BPF.ar(snd, LFNoise2.kr(2).linexp(-1, 1, 440, 10000), 0.1);
	snd = (dry * 4.dbamp) + (snd * (1 - (0.5 * Amplitude.ar(dry, 0.01, 0.1))).clip(0, 1));
	snd = HPF.ar(snd, 20);
	snd = LeakDC.ar(snd);
	snd = snd * -12.dbamp;
	snd = Limiter.ar(snd);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\basic, [freq: 330, rel: 1.2]);


(
SynthDef(\modifiedSine, { |freq = 110, out = 0, pan = 0, rel=0.8|
    var snd, foldx, foldy;
	foldx = Env.new([0.7, 0.3, 0.7], [(rel * 0.01), (rel * 0.5)], curve: 1).kr;
	foldy = Env.new([0.1, 0.45, 0.1], [(rel * 0.25), (rel * 0.75)], curve: -4).kr;
    snd = SinOsc.ar(freq);
	snd = (snd * Line.kr(5, 0.25, rel).dbamp) + (snd.fold2(-1 * foldx, foldx) * 1.5) * 1.dbamp;
	snd = (snd * Line.kr(2, 0.5, rel).dbamp) + (snd.fold2(-1 * foldy, foldy) * 0.95) * 1.dbamp;
	snd = LeakDC.ar(snd);
	snd = (snd * 6.dbamp).tanh;
	snd = snd * -10.dbamp;
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
    snd = Pan2.ar(snd, pan);
    Out.ar(out, snd);
}).add;
)

Synth(\modifiedSine);




/////////////////////////////
// Routine: Arp + PWM Bass
/////////////////////////////
(
var bpm, beat, root, scale;
bpm = 130;
beat = 60 / bpm;
root = 42;
scale = Scale.choose(8).degrees;
Routine({
	var note, octave, dur, inst, lfoDir, lfoScale, lfoRate;
	loop {
		dur = beat / [0.5, 1, 2, 4, 8].choose;
		inst = [1, 2, 3, 4, 5, 6, 7, 8].choose;
		inst.postln;
		if(inst == 1, {
			lfoDir = [0, 0.5, 1].choose;
			lfoScale = [2, 3, 4, 5].choose;
			lfoRate = [0.5, 1, 2, 3, 4, 30].choose;
			octave = [0, 1, 2].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\arp, [freq: note.midicps, lfoRate: lfoRate, lfoScale: lfoScale, lfoDir: lfoDir]);
		});
		if(inst == 2, {
			octave = [0, 1, 2].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\exp2, [freq: note.midicps, rel: dur]);
		});
		if(inst == 3, {
			octave = -1;
			note = (root + scale.choose + (12 * octave));
			Synth(\pwm, [freq: note.midicps, rel: dur]);
		});
		if(inst == 4, {
			octave = [0, 1].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\pitch, [freq: note.midicps, rel: dur]);
		});
		if(inst == 5, {
			octave = [0, 1, 2].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\chirp, [freq: note.midicps, rel: dur]);
		});
		if(inst == 6, {
			octave = [-1, 0].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\modifiedSine, [freq: note.midicps, rel: dur]);
		});
		if(inst == 7, {
			octave = [0, 1, 2].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\sinePbend, [freq: note.midicps, rel: dur]);
		});
		if(inst == 8, {
			octave = [0, 1, 2].choose;
			note = (root + scale.choose + (12 * octave));
			Synth(\filt, [freq: note.midicps, rel: dur]);
		});
		dur.wait;
	};
}).play;
)


/////////////////////////////
// Routine: Two Arps
/////////////////////////////
(
var bpm, beat, root, scale;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.ionian.degrees;
Routine({
	var note,dur;
	loop {
		dur = beat / [1, 2].choose;
		note = (root + scale.choose + (12 * [-1, 0, 1].choose));
		Synth(\arp, [freq: note.midicps, lfoRate: [1, 2, 3, 4].choose, lfoScale: [2, 3, 4].choose, lfoDir: [0, 1].choose]);
		note = (root + scale.choose + (12 * [-1, 0, 1].choose));
		Synth(\arp, [freq: note.midicps, lfoRate: [1, 2, 3, 4].choose, lfoScale: [2, 3, 4].choose, lfoDir: [0, 1].choose]);
		dur.wait;
	};
}).play;
)


/////////////////////////////
// Routine: VibroPulse
/////////////////////////////
(
var bpm, beat, root, scale;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.ionian.degrees; // [ 0, 2, 4, 5, 7, 9, 11 ]
Routine({
	var note,dur;
	loop {
		dur = beat / [1, 2].choose;
		note = (root + scale.choose + (12 * [-1, 0, 1].choose));
		Synth(\exp2, [freq: note.midicps, rel: dur]);
		dur.wait;
	};
}).play;
)












// end...