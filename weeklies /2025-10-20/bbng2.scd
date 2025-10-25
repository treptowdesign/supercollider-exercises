(
SynthDef(\hatClosed, {
	var snd, ring;
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), 10320 * [0.7, 1.0, 1.2], 0.1);
	snd = snd.sum;
	ring = SinOsc.ar(3230);
	ring = ring * SinOsc.ar(9440);
	ring = ring * Env.perc(0.001, 0.02).ar * 5.dbamp;
	snd = snd + ring;
	snd = snd.clip2;
	snd = HPF.ar(snd, 6000);
	snd = snd * 5.dbamp;
	snd = snd * Env.perc(0.005, 0.03).ar(Done.freeSelf);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -25.dbamp, 0.1, [60e-3, 40e-3]), 1000), 8000);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\ring, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pulse.ar(freq) * SinOsc.ar(freq * [0.5, 2]);
	snd = snd.sum;
	snd = snd * Env.perc(0.001, 0.5).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.6);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\chip, {
	var snd, duration;
	duration = \duration.kr(2);
	snd = (LFPulse.ar(\freq.kr(260) * [1, 2, 4]) * 2) - 1;
	snd = snd.product;
	snd = BHiShelf.ar(snd, 3000, 0.3, -3);
	snd = snd * Env.perc(0.001, 0.5).ar;
	snd = snd * \velocity.kr(1);
	snd = snd + GVerb.ar(snd * -20.dbamp, 30, 4);
	snd = snd * -24.dbamp;
	snd = snd * Env.perc(0.001, 4).ar;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(740 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
	snd = snd * Env.perc(0.001, [0.01, 0.005, 0.001, 0.03, 0.023, 0.005, 0.015]).ar;
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6230 * ratio, 0.3) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230 * ratio, 0.3) * Env.perc(0.0, 0.003).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1230 * ratio, 0.3) * Env.perc(0.002, 0.03).ar * 4.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2130 * ratio, 0.4) * Env.perc(0.03, 0.1).ar * 4.dbamp);
	snd = snd.tanh;
	snd = BPeakEQ.ar(snd, 230, 1.2, 5);
	snd = snd + GVerb.ar(snd * -1.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.025, 1.9);
	snd = snd + PitchShift.ar(snd * -7.dbamp, 0.035, 1.5);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.015, 2.3);
	snd = snd * -14.dbamp;
	snd = snd * Env.perc(0.0, 0.3).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [60, 230, 345], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 10342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Splay.ar(snd, 0.3);
	snd = snd * -26.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.02, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

/////////////////////////////////////////////////////////////////
// Basic Routine
/////////////////////////////////////////////////////////////////


(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 138;
bar = beat * 4;
tatum = beat / 4;
root = 49; //
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork { latency.wait; s.bind { Synth(synth, [duration: dur] ++ args); }; };
};
seq = { |synth, dur, args=#[], latency=0.0|
	play.(synth, dur, args, latency); (dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	'Start Routine'.postln;
	loop {
		subroutine.(8, {
			seq.(\hat, (tatum * 2), [amp: 1]);
			3.do { |index| seq.(\hat, (tatum * 2), [amp: rrand(0.4, 0.6)]); };
		});
		subroutine.(4, {
			[6, 8, 2].do { |dur| seq.(\kick, dur * tatum); };
		});
		subroutine.(4, {
			1.do {
				(beat * 2).wait;
				seq.(\rim, beat * 2, latency: 0);
			};
		});
		subroutine.(1, { // 2
			[
				[\, 2.5], [7, 0.5], [5, 0.5], [3, 0.5],
				[0, 0.5], [-2, 0.5], [0, 0.5], [5, 1], [3, 1.5],
				[\, 3], [7, 0.5], [7, 0.5],
				[5, 0.5], [3, 0.5], [0, 0.5], [5, 1], [3, 1], [\, 0.5],
			].do { |spec|
				var int, dur;
				# int, dur = spec;
				dur = dur * beat;
				if(int != \, {
					play.(\organ, dur, [freq: noteHz.(int, 0), amp: 0.5]);
					seq.(\organ, dur, [freq: noteHz.(int, 1), amp: 1]);
				}, { dur.wait; });
			};
		});
		subroutine.(1, { // 2
			[
				(notes: (6 + [0, 11, 16, 19]), length: [8, 8], rel: [2, 1]), // bV#7
				(notes: (5 + [0, 14, 15, 22]), length: [8, 8], rel: [2, 1]), // iv9
				(notes: (0 + [0, 15, 22, 26]), length: [8, 8], rel: [2, 1]), // i9
				(notes: (0 + [0, 19, 22, 27]), length: [8], rel: [1]), // bi7
				(notes: (3 + [0, 16, 19, 23]), length: [8], rel: [1]), // III7
			].do { |chord|
				chord[\length].do { |len, index|
					var dur = len * tatum;
					var rel = chord[\rel][index];
					// play.(\sub, dur, [freq: noteHz.(chord[\notes].sort[0], -1), rel: rel]);
					chord[\notes].sort.postln.do { |int|
						play.(\pad, dur, [freq: noteHz.(int, 1), rel: rel * 2, out: 0]);
						play.(\keys, dur, [freq: noteHz.(int, 0), rel: rel * 2, out: 0]);
					};
					dur.wait;
				};
			};
		});
		// global wait ////////////////////////////////////////////////
		(bar * 4).wait;
	};
}).play;
)

(
// Kick with parallel compression (dry + smashed blend)
SynthDef(\kick, { |out = 0,
    // parallel comp controls
    mix = 0.25,          // 0=dry, 1=all compressed
    threshDB = -12,      // ~ -24..-12 is common
    ratio = 4,           // 4..10 for drums
    atkMs = 8,           // 3..10ms (let a little click through)
    relMs = 90,          // 60..160ms
    makeupDB = 8,        // +3..+9 usually
    outGainDB = -2        // post trim
|
    var snd, dry, ctrl, comp, mixed;
    var thresh = threshDB.dbamp;
    var slopeAbove = 1 / max(ratio, 1);
    var atk = atkMs / 1000;
    var rel = relMs / 1000;

    // --- your kick (unchanged) ---
    snd = SinOsc.ar(
        Env.perc(0, 0.1).ar().linexp(0, 1, 58, 500)
        * XLine.ar(2, 1, 0.005)
        * XLine.ar(1, 0.8, 0.1)
    );
    snd = snd * (1 + Env.perc(0, 0.01).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 5320, 0.3) * Env.perc(0.01, 0.022).ar * -8.dbamp);
    snd = snd.clip2;
    snd = snd * Env.perc(0.001, 0.4).ar;
    snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -45.dbamp, 0.1, [60e-3, 40e-3]), 200), 3000);
    snd = snd * Env.linen(0.0, 0.3, 0.01, curve: -4).ar(Done.freeSelf);
    snd = snd * -4.dbamp;
    // snd = (snd + LPF.ar(HPF.ar(GVerb.ar(snd.sum * -40.dbamp, 10, 1), 100), 3000)) * -2.dbamp;

    // mid-focused distortion (your chain)
    snd = BLowShelf.ar(snd, 200, 0.3, -3);
    snd = BHiShelf.ar(snd, 3200, 0.3, -3);
    snd = (snd * 10.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = BHiShelf.ar(snd, 3200, 0.3, 3);
    snd = snd * -10.dbamp;

    // --- parallel compression ---
    dry = snd;                              // keep the uncompressed path
    ctrl = HPF.ar(Mix(snd), 40);            // sidechain detector (mono, low-cut to avoid rumble)
    comp = Compander.ar(
        snd, ctrl,
        thresh,     // threshold (linear)
        1,          // slopeBelow (no expansion)
        slopeAbove, // slopeAbove (<1 compresses; 1/ratio)
        atk, rel    // attack / release
    );
    comp = comp * makeupDB.dbamp;

    // blend dry + smashed (XFade2: -1=dry, +1=wet)
    mixed = XFade2.ar(dry, comp, (mix * 2) - 1);

    // catch peaks safely
    mixed = Limiter.ar(mixed, 0.99);

    Out.ar(out, mixed * outGainDB.dbamp);
}).add;

// quick demo
// Synth(\kick);
)


(
SynthDef(\keys, {
	var snd, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.1, 0, 0.1] * LFNoise2.ar(30 ! 3)).midiratio;
	pm = SinOsc.ar(freq * 1.01) * 0.4 * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq, pm);
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-24.dbamp * \amp.kr(1)));
	snd = snd * SinOsc.ar(Rand(1.2, 0.8), Rand(0.0, pi) + [0, pi]).linlin(-1, 1, 0.5, 1);
	snd = CombC.ar(snd, 0.1, 1 / 34, 0.05);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 4.dbamp).tanh * 0.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);
	snd = Balance2.ar(snd[0], snd[1]);
	// snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	snd = snd * Env.perc(0.1, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

~playChord.(6 + [0, 11, 16, 19]); // bV#7 (root, 7th, 3rd, 5th)
~playChord.(5 + [0, 14, 15, 22]); // iv9 (root, 9th, b3rd, b7th)
~playChord.(0 + [0, 15, 22, 26]); // i9 (root, b3rd, b7th, 9th)
~playChord.(0 + [0, 19, 22, 27]); // i7 (root, 5th, b7th, b3rd)
~playChord.(3 + [0, 16, 19, 23]); // III7 (root, 3rd, 5th, 7th)

27 % 12;


(
~root = 49; // F#
~noteHz = { |int=0, oct=0| (~root + int + (12 * oct)).midicps };
~playChord = { |notes=#[]|
	var bassNote = notes.sort[0];
	bassNote.postln;
	((notes - bassNote) % 12).sort.postln;
	// Synth(\sub, [freq: ~noteHz.(notes[0], -1)]); // sub
	notes.do { |int|
		// Synth(\pad2, [freq: ~noteHz.(int, 1)]);
		// Synth(\pad, [freq: ~noteHz.(int, 1)]);
		Synth(\keys, [freq: ~noteHz.(int, 0)]);
	};
};
)



(
SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(\freq.kr(260) * [1, 2, 4, 8, 16] * (LFNoise2.kr(10 ! 5) * 0.2).midiratio);
	snd = snd * Env.perc(0, [5, 10, 1, 2, 1]).ar;
	snd = snd * [-2, 0, -10, -24, -30].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum;
	snd = LPF.ar(snd, XLine.ar(9000, 600, 2.0));
	snd = CombC.ar(snd, 0.1, 1 / 134, 0.1);
	// snd = snd * Select.ar(Sweep.ar > 0.02, [ToggleFF.ar(Dust.ar(200)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.perc(0.03, duration * 14, curve: -8).ar(Done.freeSelf);
	snd = snd * -18.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\lead, {
	var snd, freq, n, intensity, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(260).lag(0.02);
	intensity = LFNoise2.kr(3).linlin(-1, 1, 0, 1) * Line.kr(0, 1, 10);
	n = (1..32);
	snd = SinOsc.ar(freq * n * (LFNoise2.kr(8 * (1 + intensity)) * 0.5 * intensity).midiratio);
	snd = snd * (n.pow(1.3) * (LFNoise2.kr(1).linexp(-1, 1, 1, 1.1)) + (3 * LFNoise2.ar(intensity.linexp(0, 1, 1, 2)))).cos.pow(10);
	snd = snd * (1 + LFNoise2.ar(3 * n.sqrt));
	snd = snd / n;
	snd = snd.sum;
	snd = LPF.ar(snd, intensity.linexp(0, 1, 1000, 16e3));
	snd = snd * (1 + (LFNoise2.ar(LFNoise2.ar(3).linexp(-1, 1, 1, 16)) * 0.5));
	snd = snd * intensity.linlin(-1, 1, 0.2, 1);
	snd = snd * 10.dbamp;
	snd = snd.tanh;
	snd = PitchShift.ar(snd, 0.3, 0.5) * 10.dbamp;
	snd = snd + GVerb.ar(snd * -10.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.perc(0.03, duration * 4, curve: -8).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\vocal, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(260) * (LFNoise2.kr(3) * 0.1).midiratio;
	snd = SinOsc.ar(freq * [8, 9, 13]) * 2000 * (1 + Env.perc(0, 1).ar);
	snd = SinOsc.ar(freq + snd).sum * -8.dbamp;
	snd = snd + GVerb.ar(snd * -20.dbamp);
	snd = snd * Env.perc(0.02, duration * 4, curve: -8).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


(
SynthDef(\saw, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * (LFNoise2.kr(3 ! 8) * 0.3).midiratio);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 3000);
	snd = snd * Env.linen(0.03, duration, 0.03, curve: -8).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
SynthDef(\fmRandLead, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(260);
	snd = SinOsc.ar(freq * IRand(2, 4) * XLine.kr(2, 1, 0.01)) * Rand(1000, 4000);
	snd = SinOsc.ar(freq + snd);
	snd = MoogFF.ar(snd, 5000, 0) * 12.dbamp;
	snd = snd * Env.adsr(0.001, 0.01, 0.3, 0.05, curve: -10).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\acid, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2] * XLine.ar(2, 1, 0.01)).sum;
	snd = MoogFF.ar(snd, 400 * ExpRand(0.5, 2) * (Env.perc(0, duration * Rand(0.3, 3), curve: -4).ar * 12 * Rand(3, 8)).midiratio, 2) * 5.dbamp;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * 5.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.3, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\acid2, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * XLine.ar(2, 1, 0.01) * [1, 2]);
	snd = (snd * [1, 0.5]).sum;
	snd = MoogFF.ar(snd, { ExpRand(1000, 8000) } ! 3 * XLine.kr(2, 1, ExpRand(0.1, 0.9)), 3.4).sum * 7.dbamp;
	snd = snd.fold2;
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -3.dbamp;
	Out.ar(\reverbBus.kr(0), snd);
	Out.ar(\out.kr(0), snd);
}).play;
)




(
SynthDef(\dialup, {
	var snd, duration;
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(TIRand.ar(0, 5, Impulse.ar(100 ! 3)).linexp(0, 5, 200, 16050));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, XLine.ar(8000, 100, duration));
	snd = snd * Env.linen(0, duration, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\dialup, {
	var snd, duration, freq;
	freq = \freq.kr(330);
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(TIRand.ar(0, 5, Impulse.ar(60 ! 3)).linexp(0, 5, freq, freq * 12));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, XLine.ar(8000, 200, duration));
	snd = snd * Env.linen(0, duration, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\dialup, {
	var snd, duration, freq;
	freq = \freq.kr(330);
	duration = \duration.kr(0.3);
	snd = SinOsc.ar(TIRand.ar(0, 5, Impulse.ar(60 ! 3)).linexp(0, 5, freq, freq * 29));
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, XLine.ar(8000, 200, duration));
	snd = snd * Env.linen(0, duration, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)






// endfile...