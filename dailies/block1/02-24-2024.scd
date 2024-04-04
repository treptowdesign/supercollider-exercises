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
	snd = snd * -2.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(32 * (1 + (5 * Env.perc(0, 0.1, curve: -8).ar)) * (1 + (0.4 * Env.perc(0, 0.5, curve: -2).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6130, 0.3) * Env.perc(0.001, 0.02).ar * -12.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.5).ar);
	snd = (snd * 4.dbamp).tanh;
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 17210, 0.25);
	snd = snd.sign;
	snd = snd * Env.linen(0.0, \rel.kr(0.02), 0.0).ar(Done.freeSelf);
	snd = snd * \amp.kr(-20.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).add;
SynthDef(\fm, {
	var snd;
	snd = SinOsc.ar(ExpRand(900, 9000)) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(900, 9000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.5)).ar * Rand(1000, 8000);
	snd = SinOsc.ar(ExpRand(900, 9000) + snd);
	snd = (snd * 10).fold2;
	snd = snd.blend(Latch.ar(snd, Impulse.ar(ExpRand(800, 16e3))), Rand(0, 1));
	snd = snd * Env.adsr(0.001, ExpRand(0.01, 0.5), 0.0, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-15.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\chime, {
	arg freq=440, out=0, atk=0.01, rel=0.3, pan=0, vel=1;
	var snd;
	snd = Pulse.ar(freq);
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * vel;
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\pwidth, {
	arg freq=440, out=0, atk=0.01, rel=0.3, pan=0, vel=1;
	var snd;
	snd = Pulse.ar(freq, Line.kr(0, 1, rel));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * vel;
	snd = snd * -14.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\saw, {
	arg freq=440, out=0, atk=0.01, rel=0.3, pan=0, vel=1;
	var snd;
	snd = VarSaw.ar(freq, width: Line.kr(0, 1, rel));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * vel;
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\bend, {
	arg freq=440, freq2=440, out=0, atk=0.01, rel=0.3, pan=0, vel=1;
	var snd;
	snd = Pulse.ar(XLine.kr(freq, freq2, 0.1));
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * vel;
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;
SynthDef(\bass, {
	arg freq=440, out=0, atk=0.01, rel=0.3, pan=0, vel=1;
	var snd;
	snd = SinOsc.ar(freq);
	snd = snd * Env.perc(atk, rel).ar(Done.freeSelf);
	snd = snd * vel;
	snd = (snd * 14).tanh;
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

)


Synth(\chime, [freq: 440, rel: 0.6, out: 0, pan: 0]);
Synth(\saw, [freq: 440, rel: 0.6, out: 0, pan: 0]);
Synth(\bass, [freq: 110]);
Synth(\fm);
Synth(\clap);
Synth(\kick);
Synth(\bend, [ freq: 880, freq2: 220]);


(
var bpm, beat, root, scale, scaleIndex, scaleName, keyName;
bpm = rrand(60, 140);
beat = 60 / bpm;
root = rrand(24, 35); // C0 = 24, B0 = 35
keyName = switch(root,
	24, {'C'}, 25, {'C# / Db'}, 26, {'D'}, 27, {'D# / Eb'},
	28, {'E'}, 29, {'F'}, 30, {'F# / Gb'}, 31, {'G'},
	32, {'G# / Ab'}, 33, {'A'}, 34, {'A# / Bb'}, 35, {'B'}
);

"BPM: %".format(bpm).postln;
"Root: %".format(root).postln;
"Key: %".format(keyName).postln;

~scales = [
	Scale.ionian.degrees, // 0
	Scale.dorian.degrees, // 1
	Scale.phrygian.degrees, // 2
	Scale.lydian.degrees, // 3
	Scale.mixolydian.degrees, // 4
	Scale.aeolian.degrees, // 5
	Scale.locrian.degrees // 6
];
// Get scale: either mode or random 7/8 note scale
if( [true, false].choose, {
	scaleIndex = rrand(0, 6); // choose mode from 0-6 index
	scaleName = switch(scaleIndex,
		0, { 'Ionian' }, 1, { 'Dorian' }, 2, { 'Phrygian' }, 3, { 'Lydian' },
		4, { 'Mixolydian' }, 5, { 'Aeolian' }, 6, { 'Locrian' }
	);
	"Mode Scale: %".format(scaleName).postln;
	scale = ~scales[scaleIndex];
}, {
	scaleIndex = [5, 6, 7, 8].choose; // choose either a 7 or 8 tone scale
	"Random %-Tone Scale ".format(scaleIndex).postln;
	scale = Scale.choose(scaleIndex).degrees;
});
// scale = [ 0, 2, 4, 5, 7, 8, 11 ]; // Phrygian b4 mode / Harmonic Major Scale

"Scale Degrees: %".format(scale).postln;

// Function to generate a phrase
~generatePhrase = {
	var durations = [
		[beat],
		[beat/2, beat/2],
		[beat/2, beat/4, beat/4],
		[beat/4, beat/2, beat/4],
		[beat/4, beat/4, beat/2],
		[beat/4, beat/4, beat/4, beat/4]
	].wchoose([0.3, 0.4, 0.2, 0.2, 0.2, 0.4]);
	var intervals = durations.collect { |dur| scale.choose };
	var octaves = durations.collect { |dur| [2, 3, 4, 5].choose };
	var panning = durations.collect { |dur| rrand(-1.0, 1.0) };
	var velocity = durations.collect { |dur| rrand(0.5, 1.0) };
	[durations, intervals, octaves, panning, velocity]
};

// CHIME
Routine({
	var loopIndex = 0;
	var loopBars = [1, 2, 4, 8, 16, 32].choose();
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
			Synth(\chime, [ freq: freq, rel: dur, pan: pan / 2, vel: vel ]);
			dur.wait;
		};
		// increment loop index
		if(loopIndex == (loopBars -1), {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;

// PWIDTH
Routine({
	var loopIndex = 0;
	var loopBars = [1, 2, 4, 8, 16, 32].choose();
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
			Synth(\pwidth, [ freq: freq, rel: dur, pan: pan, vel: vel ]);
			dur.wait;
		};
		// increment loop index
		if(loopIndex == (loopBars -1), {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;

// SAW
Routine({
	var loopIndex = 0;
	var loopBars = [1, 2, 4, 8, 16, 32].choose();
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
			Synth(\saw, [ freq: freq, rel: dur, pan: pan, vel: vel ]);
			dur.wait;
		};
		// increment loop index
		if(loopIndex == (loopBars -1), {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;

// BEND
Routine({
	var loopIndex = 0;
	var loopBars = [1, 2, 4, 8, 16, 32].choose();
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
			var freq2 = freq;
			if([true, false].choose, {
				freq = freq;
				freq2 = freq / 2;
			}, {
				freq = freq / 2;
				freq2 = freq;
			});
			Synth(\bend, [ freq: freq, freq2: freq2, rel: dur, pan: 0, vel: vel ]);
			dur.wait;
		};
		// increment loop index
		if(loopIndex == (loopBars -1), {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;

// BASS
Routine({
	var loopIndex = 0;
	var loopBars = [1, 2, 4, 8, 16, 32].choose();
	var phrases = loopBars.collect { |i| ~generatePhrase.value };
	var octave = [0, 1].choose;
	loop {
		var phrase = phrases[loopIndex];
		var durations = phrase[0];
		var intervals = phrase[1];
		var octaves = phrase[2];
		var panning = phrase[3];
		var velocity = phrase[4];
		// var octave = [0, 1].choose;
		durations.size.do { |i|
			var dur = durations[i];
			var interval = intervals[i];
			// var octave = octaves[i];
			// var octave = 1;
			var pan = panning[i];
			var vel = velocity[i];
			var freq = (root + interval + (12 * octave)).midicps;
			Synth(\bass, [ freq: freq, rel: dur, pan: 0, vel: vel ]);
			dur.wait;
		};
		// increment loop index
		if(loopIndex == (loopBars -1), {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;

// FM
Routine({
	var loopIndex = 0;
	var hatSpeed = [4,2,1].wchoose([0.4, 0.2, 0.1]);
	loop {
		var vel = rrand(-12, -20);
		var rel = rrand(0.01, 0.03);
		Synth(\fm, [amp: vel.dbamp, rel: rel]);
		(beat/hatSpeed).wait;
		if(loopIndex == 7, {
			loopIndex = 0;
			hatSpeed = [8,4,2,1].wchoose([0.2,0.4, 0.2, 0.1]);
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;

// DRUMS
Routine({
	var loopIndex = 0;
	var hatSpeed = [8,4,2,1].wchoose([0.2, 0.4, 0.2, 0.1]);
	loop {
		var vel = rrand(-14, -20);
		var rel = rrand(0.01, 0.03);
		Synth(\hat, [amp: vel.dbamp, rel: rel]);
		(beat/hatSpeed).wait;
		if(loopIndex == 7, {
			loopIndex = 0;
			hatSpeed = [4,2,1].wchoose([0.4, 0.2, 0.1]);
		}, {
			loopIndex = loopIndex + 1;
		});
	};
}).play;
Routine({
	var loopIndex = 0;
	loop {
		switch(loopIndex,
			0, { Synth(\kick, [out: 0]); },
			1, { if([true, false].wchoose([0.5, 0.1]), { Synth(\kick, [out: 0]); }); },
			2, { if([true, false].wchoose([0.3, 1]), { Synth(\kick, [out: 0]); }); },
			3, { if([true, false].wchoose([0.3, 1]), { Synth(\kick, [out: 0]); }); },
			4, { Synth(\clap, [out: 0]); },
			5, { if([true, false].wchoose([0.5, 0.1]), { Synth(\clap, [out: 0]); }); },
			6, { if([true, false].wchoose([0.3, 1]), { Synth(\kick, [out: 0]); }); },
			7, { if([true, false].wchoose([0.5, 0.1]), { Synth(\clap, [out: 0]); }); }
		);
		(beat/2).wait;
		if(loopIndex == 7, {
			loopIndex = 0;
		}, {
			loopIndex = loopIndex + 1;
		});

	};
}).play;
)





















///////////////////////////////////////////////////////////////
// End...
///////////////////////////////////////////////////////////////