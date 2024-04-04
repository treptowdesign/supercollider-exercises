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
SynthDef(\chime, {
	arg freq=440, out=0, atk=0.01, rel=0.3, pan=0;
	var snd;
	snd = SinOsc.ar(freq);
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
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
	snd = CombL.ar(snd, 0.2, 0.2, 2);
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
bpm = 84;
beat = 60 / bpm;
root = 30;
scale = Scale.aeolian.degrees;
// Functions


// Routines and Synths
Synth(\fx, [in: ~fxBus.index]);
Routine({
	var chordNotes, chordFreqs, bassNote, baseNoteOctave, scaleDegreeIndex, octave;
	octave = 2;
	loop {
		bassNote = scale.choose;
		scaleDegreeIndex = scale.indexOf(bassNote);
		chordNotes = [0, 2, 4, 6].collect({ |i|
			var noteIndex, noteValue, noteOctaveAdjustment;
			noteIndex = (scaleDegreeIndex + i) % scale.size;
			noteValue = scale[noteIndex];
			noteOctaveAdjustment = ((scaleDegreeIndex + i) / scale.size).floor; // Calculate octave adjustment
			(root + noteValue + ((octave + noteOctaveAdjustment) * 12));
		});
		chordFreqs = chordNotes.collect({ |i| i.midicps; });
		bassNote.postln;
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