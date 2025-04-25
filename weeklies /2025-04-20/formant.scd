(
~vowels = (
    a: [800, 1150, 2900],
    e: [400, 1600, 2700],
    i: [350, 1700, 2700],
    o: [450, 800, 2830],
    u: [325, 700, 2530]
);

SynthDef(\formantLead, {
	arg freq = 220, amp = 0.3, vowel = 0, gate = 1;
	var source, env, formants, filtered;

	// Create a sawtooth base tone
	source = Saw.ar(freq) * 0.5;

	// Choose vowel formants from index (0 = "a", 1 = "e", etc)
	formants = Select.kr(vowel.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);

	// Use 3 bandpass filters to simulate vocal formants
	filtered = Mix.new([
		BPF.ar(source, formants[0], 0.1),
		BPF.ar(source, formants[1], 0.1),
		BPF.ar(source, formants[2], 0.1)
	]) * 10.dbamp;

	env = Env.adsr(0.01, 0.2, 0.5, 0.3).ar(gate, doneAction: 2);
	filtered = filtered * env * amp;

	Out.ar(0, Pan2.ar(filtered));
}).add;
)

// vowel: 0 = a, 1 = e, 2 = i, 3 = o, 4 = u
Synth(\formantLead, [\freq, 220, \vowel, 4, \amp, 0.8]);




(
SynthDef(\formantLead, {
	arg freq = 58, amp = 0.3, vowel = 4, vowelB = 1, gate = 1;
	var source, env, formants, formantsB, filtered;

	// Create a sawtooth base tone
	source = Saw.ar(freq) * 1;

	// Choose vowel formants from index (0 = "a", 1 = "e", etc)
	formants = Select.kr(vowel.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);
	formantsB = Select.kr(vowelB.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);

	// Use 3 bandpass filters to simulate vocal formants
	filtered = Mix.new([
		BPF.ar(source, SinOsc.kr(1).range(formants[0], formantsB[0]), 0.1),
		BPF.ar(source, SinOsc.kr(1).range(formants[1], formantsB[1]), 0.1),
		BPF.ar(source, SinOsc.kr(1).range(formants[2], formantsB[2]), 0.1)
	]) * 16.dbamp;

	filtered = HPF.ar(filtered, 600);

	env = Env.adsr(0.01, 0.2, 0.5, 0.3).ar(gate, doneAction: 2);
	filtered = filtered * env * amp;

	Out.ar(0, Pan2.ar(filtered));
}).play;
)


(
SynthDef(\formantLead, {
	arg freq = 110, amp = 0.3, vowel = 0, gate = 1;
	var source, env, formants, filtered;

	// Create a sawtooth base tone
	source = Pulse.ar(freq, SinOsc.ar(16).range(0.489, 0.501)) * 1;

	// Choose vowel formants from index (0 = "a", 1 = "e", etc)
	formants = Select.kr(vowel.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);

	// Use 3 bandpass filters to simulate vocal formants
	filtered = Mix.new([
		BPF.ar(source, formants[0], 0.1),
		BPF.ar(source, formants[1], 0.1),
		BPF.ar(source, formants[2], 0.1)
	]) * 10.dbamp;

	// filtered = RLPF.ar(filtered, Env.perc(0.01, 0.6).ar.range(9000, 100));

	env = Env.perc(0.01, 4, curve: -4).ar(Done.freeSelf);
	filtered = filtered * env * amp;

	Out.ar(0, Pan2.ar(filtered));
}).play;
)




(
SynthDef(\saw, {
	var snd, count, freq;
	count = 10;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(0.5) }! count) * 0.5).midiratio, { Rand(0,4) } ! count);
	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.asr(0.05, 1, 0.05).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-5.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\formantSwarm, {
	arg amp = 0.3, vowel = 0, vowelB = 4, gate = 1;
	var source, count, freq, env, formants, formantsB, filtered;

	count = 10;
	freq = \freq.kr(220) * Line.kr(\bend.kr(0), 0, 0.2).midiratio;
	source = LFSaw.ar(freq * (({LFNoise2.kr(0.5) }! count) * 0.5).midiratio, { Rand(0, 2pi) } ! count);
	// source = Splay.ar(source) * -10.dbamp;

	source = source.mean;

	// Choose vowel formants from index (0 = "a", 1 = "e", etc)
	formants = Select.kr(vowel.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);
	formantsB = Select.kr(vowelB.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);

	// Use 3 bandpass filters to simulate vocal formants
	filtered = Mix.new([
		BPF.ar(source, SinOsc.kr(0.3).range(formants[0], formantsB[0]), 0.1),
		BPF.ar(source, SinOsc.kr(0.3).range(formants[1], formantsB[1]), 0.1),
		BPF.ar(source, SinOsc.kr(0/3).range(formants[2], formantsB[2]), 0.1)
	]) * 20.dbamp;

	filtered = HPF.ar(filtered, 400);

	env = Env.adsr(0.01, 0.2, 0.5, 0.3).ar(gate, doneAction: 2);
	filtered = filtered * env * amp;

	Out.ar(0, Pan2.ar(filtered));
}).play;
)







(
~vowels = (
    a: [800, 1150, 2900],
    e: [400, 1600, 2700],
    i: [350, 1700, 2700],
    o: [450, 800, 2830],
    u: [325, 700, 2530]
);
)

(
SynthDef(\formantSwarmPulse, {
	arg amp = 0.2, vowel = 1, vowelB = 3, gate = 1;
	var source, count, freq, env, formants, formantsB, filtered, high;

	count = 8;
	freq = \freq.kr(58) * Line.kr(\bend.kr(0), 0, 0.1).midiratio;
	source = LFPulse.ar(freq * (({LFNoise2.kr(0.5) }! count) * 0.1).midiratio, {Rand(0, 2pi) } ! count);

	high = (Pulse.ar(\freq.kr(58) * [4, 8]) * [1, 0.1] * amp).mean ! 2;

	// source = Splay.ar(source) * -8.dbamp;
	source = Mix(source) * -14.dbamp;

	// Choose vowel formants from index (0 = "a", 1 = "e", etc)
	formants = Select.kr(vowel.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);
	formantsB = Select.kr(vowelB.clip(0, 4), [
		~vowels[\a], ~vowels[\e], ~vowels[\i], ~vowels[\o], ~vowels[\u]
	]);

	// Use 3 bandpass filters to simulate vocal formants
	filtered = Mix.new([
		BPF.ar(source, SinOsc.kr(0.1).range(formants[0], formantsB[0]), 0.04),
		BPF.ar(source, SinOsc.kr(0.1).range(formants[1], formantsB[1]), 0.04),
		BPF.ar(source, SinOsc.kr(0.1).range(formants[2], formantsB[2]), 0.04)
	]) * 28.dbamp;

	filtered = HPF.ar(filtered, 200);
	filtered = RLPF.ar(filtered, Env.perc(0.001, 0.4, curve: -2).kr.range(200, 6240), 0.2);
	filtered.tanh;

	env = XLine.kr(1, 0.6, \duration.kr(1)) * Env.linen(0.01, \duration.kr(1), 0.1).ar(Done.freeSelf);
	// filtered = (filtered ) * env * amp;
	filtered = (filtered + high) * env * amp;

	Out.ar(0, Pan2.ar(filtered));
}).add;
)


(
var s, beat, root;
s = Server.default;
beat = 60 / 110;
root = 30;
Routine({
	loop {
		[12, 0, 8, 7].do { |interval|
			s.bind {
				Synth(\formantSwarmPulse, [freq: (root + interval).midicps, duration: beat, bend: -7]);
			};
			(beat).wait;
		};
	};
}).play;
)














// endfile.... 