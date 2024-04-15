///////////////////////////////////////////////////////////////
// Tools
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(450);
ServerOptions.outDevices;
Server.default.options.outDevice_("External Headphones");
// Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)
// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

// Memory Server Stuff
s.options.memSize;
s.options.memSize = 1048576; (original 8192)
s.options.numWireBufs;
s.options.numWireBufs = 128; (original 64)

//////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////

(
SynthDef(\kick09, {
	var snd;
	snd = SinOsc.ar(
		58
		* (1 + (3 * Env.perc(0, 0.03).ar))
		* (1 + (0.5 * Env.perc(0, 0.3).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd + (BPF.ar(WhiteNoise.ar.pow(9.0), 18e3, 0.3) * Env.perc(0.01, 0.03).ar);
	snd = snd * Env.perc().ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).play;
)

(
SynthDef(\harmSynthRLPF, {
	var snd, sub, freq, rel;
	freq = \freq.kr(80);
	rel = \rel.kr(0.6);
	sub = SinOsc.ar(freq) * 0.1;
	snd = (1..30).collect({ |harmonic, index|
		var width = (index % 3).linlin(1, 3, 0.1, 0.9);
		VarSaw.ar(freq * harmonic, 0, width, (1 / harmonic ** 2));
	}).sum;
	snd = sub + (snd + (snd * 1.5.dbamp).fold2 * 2.dbamp).tanh;
	snd = RLPF.ar(snd, XLine.kr(70, 1e4, 0.05), 0.6) * 5.dbamp;
	// snd = snd * (1 + (0.5 * Env.perc(0.001, 0.03).ar));
	snd = snd * Env.perc(0.001, rel).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, Pan2.ar(snd, 0) * -5.dbamp);
}).play;
)

(
SynthDef(\harmSynthPhase, {
	var snd, sub, freq, rel;
	freq = \freq.kr(220);
	rel = \rel.kr(0.6);
	sub = SinOsc.ar(freq) * 0.1;
	snd = [1, 2, 4, 5, 8, 9, 11, 13, 16].collect({ |harmonic, index|
		var phase = (index % 2).linlin(0, 3, 0, 1.5pi);
		VarSaw.ar(freq * harmonic, phase, 0.5, (1 / harmonic));
	}).sum;
	snd = sub + (snd + (snd * 1.5.dbamp).fold2 * 2.dbamp).tanh;
	// snd = snd * (1 + (0.5 * Env.perc(0.001, 0.03).ar));
	snd = snd * Env.perc(0.001, rel).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, Pan2.ar(snd, 0) * -5.dbamp);
}).play;
)

(
SynthDef(\phaseSynth, {
	var snd, freq, rel, env;
	freq = \freq.kr(220);
	rel = \rel.kr(1.2);
	env = Env.perc(0, rel).ar;
	snd = SinOsc.ar(freq, 0, 1);
	snd = snd + SinOsc.ar(freq * 2, 0, (1 / 2));
	snd = snd + SinOsc.ar(freq * 3, (pi / 2) * env, (1 / 5));
	snd = snd + SinOsc.ar(freq * 4.5, 0, (1 / 18));
	snd = snd + SinOsc.ar(freq * 5, 0, (1 / 4));
	snd = snd + SinOsc.ar(freq * 6, (pi / 8) * env, (1 / 9));
	snd = snd + SinOsc.ar(freq * 7, (pi / 3), (1 / 11));
	snd = snd + SinOsc.ar(freq * 8, 0, (1 / 8));
	snd = snd + SinOsc.ar(freq * 9, (pi / 2) * env, (1 / 9));
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, Pan2.ar(snd, 0) * -5.dbamp);
}).play;
)

(
SynthDef(\phaseSynth, {
	var snd, freq, rel, env;
	freq = \freq.kr(440);
	rel = \rel.kr(1.2);
	env = Env.perc(0, rel).ar;
	snd = SinOsc.ar(freq, 0, 1);
	snd = snd + SinOsc.ar(freq * 2, 0, 1);
	// snd = snd + SinOsc.ar(freq * 3, 0, (1 / 5));
	snd = snd + SinOsc.ar(freq * 4, (pi / 4), (1 / 8));
	snd = snd + SinOsc.ar(freq * 5, 0, (1 / 2));
	// snd = snd + SinOsc.ar(freq * 6, 0, (1 / 6));
	snd = snd + SinOsc.ar(freq * 7, (pi / 2), (1 / 21));
	snd = snd + SinOsc.ar(freq * 8, 0, (1 / 8));
	snd = snd + SinOsc.ar(freq * 9, 0, (1 / 9));
	snd = snd * Env.perc(0.01, rel).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, Pan2.ar(snd, 0) * -10.dbamp);
}).add;
)

Synth(\phaseSynth);

(
SynthDef(\addi01, {
	var freq, fund, snd;
	freq = \freq.kr(440);
	fund = SinOsc.ar(freq);
	snd = (2..16).collect({ |harmonic, index|
		var phase = if(index % 4 == 0, { 0 }, { pi });
		var mul = if(index % 5 == 0, { (1 / harmonic ** 2) }, { (1 / harmonic) });
		SinOsc.ar(freq * harmonic, phase, mul);
	}).sum;
	snd = fund + snd;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -10.dbamp);
}).add;
)

(
SynthDef(\addi02, {
	var freq, fund, snd;
	freq = \freq.kr(440);
	fund = SinOsc.ar(freq);
	snd = (2..16).collect({ |harmonic, index|
		var phase = 0, mul = (1 / harmonic);
		if(index % 2 != 0, { phase = pi });
		SinOsc.ar(freq * harmonic, phase, mul);
	}).sum;
	snd = fund + snd;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -15.dbamp);
}).add;
)

(
SynthDef(\addi03, {
	var freq, fund, snd;
	freq = \freq.kr(440);
	fund = SinOsc.ar(freq);
	snd = (1..16).collect({ |harmonic, index|
		var phase = if(index % 2 == 0, { 0 }, { pi });
		SinOsc.ar(freq * harmonic, phase, (1 / harmonic));
	}).sum;
	// snd = fund + snd;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -15.dbamp);
}).add;
)

(
SynthDef(\addi, {
	var freq, snd;
	freq = \freq.kr(440);
	snd = (1..24).collect({ |harmonic, index|
		var phase = 0, mul = (1 / harmonic);
		if(index % 4 != 0, { phase = pi });
		if(index % 3 != 0, { mul = (1 / harmonic / 2) });
		SinOsc.ar(freq * harmonic, phase, mul);
	}).sum;
	snd = snd * Env.perc(0.1, 0.6).ar(Done.freeSelf);
	Out.ar(0, Pan2.ar(snd, 0) * -10.dbamp);
}).add;
)


(2..16) % 2;

(
var s, bpm, beat, tatum, root;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
tatum = beat / 4;
root = 42;
Routine({
	loop {
		[
			0,\,7,\,7,19,\,7,
			0,\,7,3,7,19,\,0,
			0,\,7,\,7,19,\,7,
			0,\,7,3,7,19,\,0
		].do{ |note|
			if(note == \, {
				tatum.wait;
			}, {
				/*Synth(\addi, [freq: (root + note + (12 * 0)).midicps]);
				Synth(\addi02, [freq: (root + note + (12 * 1)).midicps]);
				Synth(\addi01, [freq: (root + note + (12 * 2)).midicps]);*/
				Synth(\addi, [freq: (root + note + (12 * 0)).midicps]);
				tatum.wait;
			});
		}
	};
}).play;
)


















// endfile
