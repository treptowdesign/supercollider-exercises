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
// Basic Synth & Routine
///////////////////////////////////////////////////////////////

(
SynthDef(\clap, {
	var snd, env;
	env = Env([0, 1, 0.3, 1, 0.3, 1, 0], [0.001, 0.01, 0.001, 0.015, 0.001, 0.1], -4).ar(Done.freeSelf);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1240, 0.3) * 12.dbamp;
	snd = snd * env;
	snd = snd * 1.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(45 * (1 + (5 * Env.perc(0, 0.1, curve: -8).ar)) * (1 + (0.4 * Env.perc(0, 0.5, curve: -2).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6130, 0.3) * Env.perc(0.001, 0.02).ar * -12.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.5).ar);
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 17210, 0.25);
	snd = snd.sign;
	snd = snd * Env.linen(0.0, 0.02, 0.0).ar(Done.freeSelf);
	snd = snd * \amp.kr(-20.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).add;
SynthDef(\chime, {
	arg freq=440, out=0, atk=0.01, rel=0.3, pan=0, vel=1;
	var snd;
	snd = Pulse.ar(freq);
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * vel;
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

SynthDef(\pad, {
	arg freqs = #[440, 550, 660], out = 0, atk = 0.5, rel = 0.5, pan = 0, widthMod=1;
	var snd, env;
	env = Env.perc(atk, rel, curve: -4).ar(Done.freeSelf);
	snd = Mix.fill(freqs.size, { |i| VarSaw.ar(freqs[i], width: SinOsc.ar(widthMod)) * env });
	snd = snd * -20.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

SynthDef(\fx, {
	arg in, out=0;
	var snd;
	snd = In.ar(in, 2);
	snd = snd + (snd * 2.dbamp).tanh * -5.dbamp;
	// snd = CombL.ar(snd, 0.2, 0.2, 2);
	snd = FreeVerb.ar(snd, 0.2, 0.3, 0.2);
	Out.ar(out, snd);
}).add;
)

~fxBus = Bus.audio(s, 2);
~fxBus.index;
~fxBus.free;
Synth(\fx, [in: ~fxBus.index]);
Synth(\chime, [freq: 440, rel: 0.6, out: 0, pan: 0]);
Synth(\pad);


(
var bpm, beat, root, scale;
bpm = 152;
beat = 60 / bpm;
root = 37;
scale = Scale.dorian.degrees;
// Function to generate a phrase
~generatePhrase = {
	var durations = [
		[beat],
		[beat/2, beat/2],
		[beat/2, beat/4, beat/4],
		[beat/4, beat/2, beat/4],
		[beat/4, beat/4, beat/2],
		[beat/4, beat/4, beat/4, beat/4]
	].choose;
	var intervals = durations.collect { |dur| scale.choose };
	var octaves = durations.collect { |dur| [2, 3, 4, 5].choose };
	var panning = durations.collect { |dur| rrand(-1.0, 1.0) };
	var velocity = durations.collect { |dur| rrand(0.5, 1.0) };
	[durations, intervals, octaves, panning, velocity]
};
Synth(\fx, [in: ~fxBus.index]);
Routine({
	var loopIndex = 0;
	var loopBars = 16;
	var phrases = loopBars.collect { |i| ~generatePhrase.value };
	loop {
		var phrase = phrases[loopIndex];
		var durations = phrase[0];
		var intervals = phrase[1];
		var octaves = phrase[2];
		var panning = phrase[3];
		var velocity = phrase[4];
		durations.size.do { |i|
			var dur = durations[i];
			var interval = intervals[i];
			var octave = octaves[i];
			var pan = panning[i];
			var vel = velocity[i];
			var freq = (root + interval + (12 * octave)).midicps;

			Synth(\chime, [
				freq: freq,
				rel: dur,
				pan: pan,
				out: ~fxBus.index,
				vel: vel
			]);
			// increment index
			loopIndex.postln;
			if(loopIndex == (loopBars -1), {
				loopIndex = 0;
			}, {
				loopIndex = loopIndex + 1;
			});
			dur.wait;
		};
	};
}).play;
Routine({
	var loopIndex = 0;
	loop {
		Synth(\hat);
		if(loopIndex == 0 || (loopIndex == 1 && [true, false].wchoose([0.3, 0.7])), {
			Synth(\kick);
		});
		if(loopIndex == 2 || (loopIndex == 3 && [true, false].wchoose([0.2, 0.8])), {
			Synth(\clap);
		});

		if(loopIndex == 3, {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});
		(beat).wait;
	};
}).play;
)
























(
var bpm, beat, root, scale;
bpm = 84;
beat = 60 / bpm;
root = 30;
scale = Scale.aeolian.degrees;
Synth(\fx, [in: ~fxBus.index]);
Routine({
	var chordNotes, chordFreqs, baseNoteValue, baseNoteOctave, scaleDegreeIndex, octave;
	octave = 2;
	loop {
		baseNoteValue = scale.choose;
		scaleDegreeIndex = scale.indexOf(baseNoteValue);
		chordNotes = [0, 2, 4, 6].collect({ |i|
			var noteIndex, noteValue, noteOctaveAdjustment;
			noteIndex = (scaleDegreeIndex + i) % scale.size;
			noteValue = scale[noteIndex];
			noteOctaveAdjustment = ((scaleDegreeIndex + i) / scale.size).floor; // Calculate octave adjustment
			(root + noteValue + ((octave + noteOctaveAdjustment) * 12));
		});
		chordFreqs = chordNotes.collect({ |i| i.midicps; });
		baseNoteValue.postln;
		scaleDegreeIndex.postln;
		chordNotes.postln;
		chordFreqs.postln;
		Synth(\pad, [freqs: chordFreqs, widthMod: beat/2, out: ~fxBus.index]);
		(beat).wait;
	};
}).play;
Routine({
	var note, octave, rel, pan;
	loop {
		octave = [2, 3, 4].choose;
		note = root + scale.choose + (12 * octave);
		rel = [beat, beat/2, beat/4, beat*2].choose;
		pan = rrand(-1.0, 1.0);
		Synth(\chime, [freq: note.midicps, rel: rel, pan: pan, out: ~fxBus.index]);
		(beat/4).wait;
	};
}).play;
)




Scale.aeolian.degrees;