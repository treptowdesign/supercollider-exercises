(
SynthDef(\synth, {
	var freq, snd, rel, spread, vol;
	spread = \spread.kr(1);
	vol = \vol.kr(0);
	freq = \freq.kr(440) * ([0, 0.1, 0.03, -0.13, -0.01] * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = VarSaw.ar(freq, 0, 0);
	// snd = snd.sum;
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 16000, 0.2);
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.06, rel, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd * -25.dbamp * vol.dbamp ! 2);
}).play;
)

Synth(\synth);


(
var s, bpm, beat, root, scale, playChord;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.dorian.degrees;

playChord = { |chord, octave, dur, args = #[]|
	chord.do {|deg|
		var note = (root + deg + (12 * octave)).midicps;
		s.bind { Synth(\synth, [freq: note] ++ args); };
	};
	dur.wait;
};

Routine({
	var dur, octave, note;
	dur = beat / 4; // tatum
	loop {
		playChord.([-2, 0, 3, 7], 1, beat * 1, [rel: 1.8, spread: 1, vol: -5]); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3, [rel: 0.5, spread: 0.85, vol: -6]); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3, [rel: 0.5, spread: 0.85, vol: -7]); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3, [rel: 0.5, spread: 0.85, vol: -5]); // i
		playChord.([2, 5, 9, 12], 1, beat * 1, [rel: 1.8, spread: 1, vol: -5]); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1/3, [rel: 0.5, spread: 0.85, vol: -6]); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1/3, [rel: 0.5, spread: 0.85, vol: -7]); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1/3, [rel: 0.5, spread: 0.85, vol: -5]); // ii
		playChord.([-2, 2, 5, 9], 1, beat * 2, [rel: 2.2, spread: 1.35, vol: -5]); // vii
		playChord.([2, 5, 7, 10], 1, beat * 2, [rel: 2.2, spread: 0.8, vol: -5]); // v

		/*playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([2, 5, 9, 12], 1, beat * 1); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1); // ii
		playChord.([-2, 2, 5, 9], 1, beat * 2); // vii
		playChord.([2, 5, 7, 10], 1, beat * 2); // v

		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1); // i
		playChord.([2, 5, 9, 12], 1, beat * 1/3); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1/3); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1/3); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1); // ii
		playChord.([-2, 2, 5, 9], 1, beat * 2); // vii
		playChord.([2, 5, 7, 10], 1, beat * 2); // v

		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([-2, 0, 3, 7], 1, beat * 1/3); // i
		playChord.([2, 5, 9, 12], 1, beat * 1); // ii
		playChord.([2, 5, 9, 12], 1, beat * 1); // ii
		playChord.([-2, 2, 5, 9], 1, beat * 2); // vii
		playChord.([2, 5, 7, 10], 1, beat * 2); // v*/
	};
}).play;
)






(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
root = 42;
scale = Scale.dorian.degrees;
Routine({
	var dur, octave, note;
	dur = beat * 2;
	loop {
		octave = 1;
		[
			[0, 2, 7, 10], // root
			[-2, 2, 5, 9], // 7th
		].do { |chord|
			chord.do {|deg|
				note = (root + deg + (12 * octave)).midicps;
				Synth(\synth, [freq: note, rel: 2.25, spread: 1, vol: -7]);
			};
			dur.wait;
		};
	};
}).play;
)











(
SynthDef(\synthChorus, {
	var freq, snd, rel, spread, vol, delay, modFreq, modDepth;
	spread = \spread.kr(0.6);
	vol = \vol.kr(0);
	freq = \freq.kr(330) * ([0, 0.12, 0.033, -0.137, -0.014] * spread).midiratio;
	rel = \rel.kr(1.2);
	modFreq = 0.2;
	modDepth = 0.01;
	snd = VarSaw.ar(freq, 0, 0);
	snd = Splay.ar(snd);
	delay = DelayL.ar(snd, 0.03, SinOsc.kr(modFreq, 0, modDepth, 0.02));
	delay = delay + DelayL.ar(snd, 0.03, SinOsc.kr(modFreq, 2pi/3, modDepth, 0.02));
	delay = delay + DelayL.ar(snd, 0.03, SinOsc.kr(modFreq, 4pi/3, modDepth, 0.02));
	snd = snd + (delay * -5.dbamp);
	snd = MoogFF.ar(snd, 16000, 0);
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.06, rel, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd * -25.dbamp * vol.dbamp ! 2);
}).play;
)


(
SynthDef(\synthChorusArray, {
	var freq, snd, rel, spread, vol, numDelays, delayTimes, delays, modFreq, modDepth;
	spread = \spread.kr(0.6);
	vol = \vol.kr(0);
	freq = \freq.kr(330) * ([0, 0.12, 0.033, -0.137, -0.014] * spread).midiratio;
	rel = \rel.kr(1.2);
	numDelays = 3;
	modFreq = 0.2;
	modDepth = 0.01;
	snd = VarSaw.ar(freq, 0, 0);
	snd = Splay.ar(snd);
	delayTimes = Array.fill(numDelays, { |i| SinOsc.kr(modFreq, (2pi / numDelays) * i, modDepth, 0.02) });
	delays = delayTimes.collect { |delayTime| DelayL.ar(snd, 0.03, delayTime) };
	snd = Mix.new([snd] ++ delays);
	snd = MoogFF.ar(snd, 16000, 0);
	snd = snd * (1 + (3 * Env.perc(0.001, 0.02).ar));
	snd = snd * Env.perc(0.06, rel, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd * -25.dbamp * vol.dbamp ! 2);
}).play;
)



(
SynthDef(\synthTriChorus, {
	var freq, snd, rel, spread, vol;
	spread = \spread.kr(1.5);
	vol = \vol.kr(0);
	freq = \freq.kr(440) * ([0, 0.12, 0.033, -0.137, -0.014] * spread).midiratio;
	rel = \rel.kr(0.6);
	snd = VarSaw.ar(freq, 0, 0.5);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 14000, 1) * 5.dbamp;
	snd = snd * (1 + (3.5 * Env.perc(0.001, 0.06).ar));
	snd = snd * Env.perc(0.06, rel, curve: -4).ar(Done.freeSelf);
	Out.ar(0, snd * -15.dbamp * vol.dbamp ! 2);
}).play;
)





(
SynthDef(\unisonSynth, {
	var freq, snd, rel, spread, vol;
	spread = \spread.kr(1.3);
	vol = \vol.kr(0);
	freq = \freq.kr(110) * (([0, 0.2, 0.04, -0.13, -0.05]) * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = VarSaw.ar(freq, 0, 0);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 12e3, 0);
	snd = (snd * 5.dbamp).tanh;
	snd = snd * (1 + (4 * Env.perc(0.001, 0.03).ar));
	snd = snd * Env.perc(0.04, rel, curve: -2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -25.dbamp * vol.dbamp ! 2);
}).play;
)

(
SynthDef(\unisonSynthPLs, {
	var freq, snd, rel, spread, vol;
	spread = \spread.kr(1.5);
	vol = \vol.kr(0);
	freq = \freq.kr(110) * (([0, 0.2, 0.026, -0.13, -0.05]) * spread).midiratio;
	rel = \rel.kr(1.2);
	snd = Pulse.ar(freq, Line.kr(0.1, 0.8, rel));
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, 8e3, 1) * 5.dbamp;
	snd = (snd * 5.dbamp).tanh;
	snd = snd * (1 + (2 * Env.perc(0.005, 0.05).ar));
	snd = snd * Env.perc(0.04, rel, curve: -2).ar(Done.freeSelf);
	snd = LeakDC.ar(snd);
	Out.ar(0, snd * -15.dbamp * vol.dbamp ! 2);
}).play;
)














// end....