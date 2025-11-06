//////////////////////////////////////////////////////////////////////////////////
// Synths
//////////////////////////////////////////////////////////////////////////////////


(
SynthDef(\hat1, {
	var snd, freqs, amp;
	amp = \amp.kr(1);
	snd = Hasher.ar(Sweep.ar);
	freqs = ((0..20) * 134789).sin.linexp(-1, 1, 100, 3e3);
	snd = CombC.ar(snd, 1 / freqs, 1 / freqs, 0.1);
	snd = snd.sum * -15.dbamp;
	snd = FreqShift.ar(snd, -230);
	snd = HPF.ar(snd, 1000);
	snd = BPF.ar(snd, [8230, 5240, 1230, 6.5e3, 7243], 0.05);
	snd = snd * Env.perc(0.01, (2.2 * amp) * [1, 0.5, 0.9, 0.1, 0.2, 0.3]).ar;
	snd = snd.sum;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.clip2;
	snd = snd + PitchShift.ar(snd, 0.03, 2);
	snd = snd ! 2;
	snd = snd * Env.linen(0, \duration.kr(0.3), 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * (-22.dbamp * amp);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [60, 130, 245], 0.3);
	snd = snd.sum;
	snd = BPF.ar(snd, [8430, 10342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Splay.ar(snd, 0.3);
	snd = snd * -24.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.02, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat3, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = CombC.ar(snd, 0.1, 1 / [70, 330, 445], 0.3);
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = BPF.ar(snd, [5430, 7342] * XLine.ar(1, 1.1, 0.05), 0.2).sum * 7.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -22.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\keys, {
	var snd, pm, duration, freq;
	duration = \duration.kr(3.0);
	freq = \freq.kr(260) * ([-0.01, 0, 0.01] * LFNoise2.ar(30 ! 3)).midiratio;
	pm = SinOsc.ar(freq * 1.001) * 0.4  * (1 + Env.perc(0, 0.01).ar);
	snd = SinOsc.ar(freq, pm);
	snd = LeakDC.ar(snd);
	snd = Pan2.ar(snd.sum, \pan.kr(0), (-20.dbamp * \amp.kr(1)));
	snd = DelayC.ar(snd, 0.2, SinOsc.ar(0.5).linlin(-1, 1, 0, 1) * 2e-3);
	snd = snd * SinOsc.ar(Rand(0.1, 1.0), Rand(0.0, pi) + [0, pi]).linlin(-1, 1, 0.3, 1);
	snd = BHiShelf.ar(snd, 1200, 0.3, -2);
	snd = BLowShelf.ar(snd, 500, 0.3, -5);
	snd = (snd * 3.dbamp).tanh * 0.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 3);

	snd = HPF.ar(snd, 200);

	snd = Balance2.ar(snd[0], snd[1]);
	snd = snd * Env.perc(0.01, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0, duration, 0.01).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pad, {
	var snd, duration, freqs;
	duration = \duration.kr(3.0);
	freqs = \freq.kr(260) * (LFNoise2.ar(30 ! 10) * 0.3).midiratio;
	snd = SinOsc.ar(freqs, Rand(0 ! freqs.size, 2pi));
	snd = SinOsc.ar(freqs, snd * LFNoise2.ar(30).linlin(-1, 1, 0, 1) * 0.3);
	snd = Splay.ar(snd);
	snd = snd * -22.dbamp;
	snd = snd * Env.perc(0.001, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\sub, {
	var snd, duration, hi, freq;
	freq = \freq.kr(60);
	duration = \duration.kr(3.0);
	snd = SinOsc.ar(freq);
	snd = snd ! 2;
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.01, 5.0).ar;
	snd = snd * 5.dbamp;
	hi = HPF.ar((snd * 6).tanh * -5.dbamp, 4000);
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 3200, 0.5) * 5.dbamp));
	hi = hi + DelayC.ar(hi, 0.2, SinOsc.ar(0.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
	hi = hi * 5.dbamp;
	snd = (snd * 3).tanh + hi;
	snd = snd * -10.dbamp * \amp.kr(1);
	snd = snd * Env.perc(0.01, \rel.kr(4), curve: -4).ar;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;



SynthDef(\kick, { |

    mix = 0.5,          // 0=dry, 1=all compressed
    threshDB = -8,      // ~ -24..-12 is common
    ratio = 10,           // 4..10 for drums
    atkMs = 3,           // 3..10ms (let a little click through)
    relMs = 80,          // 60..160ms
    makeupDB = 0,        // +3..+9 usually
    outGainDB = -6        // post trim
|
    var snd, dry, ctrl, comp, mixed, velocity;
    var thresh = threshDB.dbamp;
    var slopeAbove = 1 / max(ratio, 1);
    var atk = atkMs / 1000;
    var rel = relMs / 1000;

	velocity = \velocity.kr(1);
	snd = SinOsc.ar(54 * (1 + (4 * Env.perc(0.001, 0.03).ar) * velocity) * (1 + (0.25 * Env.perc(0.001, 0.3).ar) * velocity));
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar * velocity));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar).pow(9.0), 6328, 0.3) * Env.perc(0.01, 0.04).ar * 5.dbamp);
	snd = snd.clip2;
	snd = snd.tanh;

	// distortion
    snd = BLowShelf.ar(snd, 200, 0.3, -3);
    snd = BHiShelf.ar(snd, 3200, 0.3, -3);
    snd = (snd * 6.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = BHiShelf.ar(snd, 3200, 0.3, 3);
    snd = snd * -4.dbamp;

	snd = snd * Env.perc(0.001, 0.3 * velocity, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp * \amp.kr(1) ! 2;

	// parallel compression
    dry = snd;
    ctrl = snd.sum; // HPF.ar(Mix(snd), 40);
    comp = Compander.ar(
        snd, ctrl,
        thresh,     // threshold (linear)
        1,          // slopeBelow (no expansion)
        slopeAbove, // slopeAbove (<1 compresses; 1/ratio)
        atk, rel    // attack / release
    );
    comp = comp * makeupDB.dbamp;

    // blend dry + smashed
    mixed = XFade2.ar(dry, comp, (mix * 2) - 1);

    // catch peaks safely
    mixed = Limiter.ar(mixed);

	Out.ar(\out.kr(0), mixed * outGainDB.dbamp);
}).play;


SynthDef(\clap, { |
    // parallel comp controls
    mix = 0.5,          // 0=dry, 1=all compressed
    threshDB = -12,      // ~ -24..-12 is common
    ratio = 4,           // 4..10 for drums
    atkMs = 20,           // 3..10ms (let a little click through)
    relMs = 60,          // 60..160ms
    makeupDB = 8,        // +3..+9 usually
    outGainDB = -8       // post trim
|
    var snd, dry, ctrl, comp, mixed, velocity;
    var thresh = threshDB.dbamp;
    var slopeAbove = 1 / max(ratio, 1);
    var atk = atkMs / 1000;
    var rel = relMs / 1000;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1320);
	snd = snd * 22.dbamp;
	snd = snd * Env([0, 1, 0.2, 0.9, 0.1, 0.8, 0], [1e-4, 0.004, 1e-4, 0.007, 1e-4, 0.08] * 0.8, -4).ar;

	snd = snd + GVerb.ar(snd * -30.dbamp, 10, 3);


	// mid-focused distortion
    snd = BLowShelf.ar(snd, 200, 0.3, -3);
    snd = BHiShelf.ar(snd, 1200, 0.3, -3);
    snd = (snd * 4.dbamp).tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 3);
    snd = BHiShelf.ar(snd, 1200, 0.3, 3);
    snd = snd * -2.dbamp;

	snd = snd * \amp.kr(0.2);

	snd = snd + PitchShift.ar(snd * -8.dbamp, 0.04, 1.5);

	// parallel compression
    dry = snd;
    ctrl = snd.sum; // HPF.ar(Mix(snd), 40);
    comp = Compander.ar(
        snd, ctrl,
        thresh,     // threshold (linear)
        1,          // slopeBelow (no expansion)
        slopeAbove, // slopeAbove (<1 compresses; 1/ratio)
        atk, rel    // attack / release
    );
    comp = comp * makeupDB.dbamp;

    // blend dry + smashed
    mixed = XFade2.ar(dry, comp, (mix * 2) - 1);

    // catch peaks safely

	snd = mixed * Env.perc(0.001, 0.25, curve: -8).ar(Done.freeSelf);

	Out.ar(\out.kr(0), mixed * outGainDB.dbamp);
}).add;

SynthDef(\rim, {
	var snd, ratio;
	ratio = \ratio.kr(1);
	snd = SinOsc.ar(780 * [0.34, 0.4, 0.5, 0.9, 1.3, 1.45, 1.7] * ratio);
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
	snd = snd * -12.dbamp;
	snd = snd * Env.perc(0.0, 0.1).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\percTst, {
	var snd;
	snd = SinOsc.ar(720 * [1, 1.6] * \ratio.kr(1)).sum;
	snd = snd * Env.perc(0.001, 0.02).ar(Done.freeSelf);
	snd = snd * -8.dbamp ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

// -------- FX UNITS --------
SynthDef(\reverbFx, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + GVerb.ar(snd.sum * -10.dbamp, 30, 2);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

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
	snd = CombC.ar(snd, 0.1, 1 / 114, 0.1);
	// snd = snd * Select.ar(Sweep.ar > 0.02, [ToggleFF.ar(Dust.ar(200)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -10.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.perc(0.03, duration * 14, curve: -8).ar(Done.freeSelf);
	snd = snd * -24.dbamp * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).play;
)


//////////////////////////////////////////////////////////////////////////////////
// Busses
//////////////////////////////////////////////////////////////////////////////////
(
~reverbBus = Bus.audio(nil, 2);
)
~reverbBus.index;

//////////////////////////////////////////////////////////////////////////////////
// Pattern
//////////////////////////////////////////////////////////////////////////////////
(
var s, beat, bar, tatum, root, noteHz, play, seq, subroutine;
s = Server.default;
beat = 60 / 112;
bar = beat * 4;
tatum = beat / 4;
root = 42; // 42=F#, 48=C, 50=D, 51=D#
noteHz = { |int=0, oct=1| (root + int + (12 * oct)).midicps; };
play = { |synth, dur, args=#[], latency=0.0|
	fork { latency.wait; s.bind { Synth(synth, [duration: dur] ++ args); }; };
};
seq = { |synth, dur, args=#[], latency=0.0|
	play.(synth, dur, args, latency); (dur).wait;
};
subroutine = { |num=1, sequence| fork { num.do { sequence.() }; }; };
Routine({
	var reverbFx;
	'Start Routine'.postln;

	reverbFx = Synth.tail(nil, \reverbFx, [in: ~reverbBus, out: 0, wet: 1]);

	loop {
		subroutine.(8, { // 8
			2.do {
				(beat * 1).wait;
				play.(\perc, (beat * 0.5) * 1, latency: 0.032);
				play.(\rim, beat * 1, latency: 0.0);
				play.(\clap, beat * 1, latency: 0.0);
				(beat * 1).wait;

			};
		});
		subroutine.(16, { // 16
			seq.(\hat1, (tatum * 2), [amp: 1]);
			3.do { |index| seq.(\hat1, (tatum * 2), [amp: rrand(0.4, 0.5)]); };
		});
		subroutine.(8, { // 8
			(tatum * 2).wait;
			seq.(\hat2, (tatum * 4), [amp: 1]);
			(tatum * 8).wait;
			seq.(\hat2, (tatum * 2), [amp: 0.5]);
		});
		subroutine.(16, { // 16
			[\, 1, 2, \, \, \, 1, 1].do { |index|
				if(index != \, {
					seq.(\hat3, (tatum * 1), [amp: rrand(0.8, 1.0)]);
				}, { tatum.wait; });
			};
		});
		subroutine.(1, { // 8
			[6, 8, 2].do { |dur|
				seq.(\kick, dur * tatum);
			};
		});

		subroutine.(1, { // 2
			[
				(2 + [0, 10, 15, 21]),
				(7 + [0, 10, 14, 16]),
				(2 + [0, 10, 15, 21]),
				(7 + [0, 10, 14, 16]),
				(4 + [0, 15, 19, 22]),
				(9 + [0, 10, 14, 16]),
				(2 + [0, 15, 22, 26]),
				(1 + [0, 18, 21, 27])
			].do { |chord|
				[6, 8, 2].do { |item|
					var dur = (item * tatum);
					play.(\sub, dur, [freq: noteHz.(chord.sort[0], -1), rel: 3]);
					chord.sort.postln.do { |int|
						play.(\pad, dur, [freq: noteHz.(int, 1), rel: 1, out: ~reverbBus]);
						play.(\keys, dur, [freq: noteHz.(int, 0), rel: 1, out: ~reverbBus]);
					};
					dur.wait;
				};
			};
		});
		subroutine.(1, { // 2
			[
				// [ 2, 0, 5, 11 ]
				[\, 10], [0, 4], [\, 2],
				// [ 7, 5, 9, 11 ]
				[\, 2], [11, 4], [5, 4], [7, 2], [9, 6],
				// [ 2, 0, 5, 11 ]
				[\, 10], [5, 6],
				// [ 7, 5, 9, 11 ]
				[\, 4], [9, 4], [11, 2], [9, 6],
				// [ 4, 7, 11, 2 ]
				// [ 9, 7, 11, 1 ]
				// [ 2, 5, 0, 4 ]
				// [ 1, 7, 10, 4 ]
			].do { |spec|
				var int, dur;
				# int, dur = spec;
				dur = dur * tatum;
				if(int != \, {
					// play.(\organ, dur, [freq: noteHz.(int, 1), amp: 0.5]);
					seq.(\organ, dur, [freq: noteHz.(int, 2), amp: 1]);
				}, { dur.wait; });
			};
		});
		// global wait //
		(bar * 8).wait;
	};
}).play;
)

// Notes
(2 + [0, 10, 15, 21]) % 12; // [ 2, 0, 5, 11 ]
(7 + [0, 10, 14, 16]) % 12; // [ 7, 5, 9, 11 ]
(2 + [0, 10, 15, 21]) % 12; // [ 2, 0, 5, 11 ]
(7 + [0, 10, 14, 16]) % 12; // [ 7, 5, 9, 11 ]
(4 + [0, 15, 19, 22]) % 12; // [ 4, 7, 11, 2 ]
(9 + [0, 10, 14, 16]) % 12; // [ 9, 7, 11, 1 ]
(2 + [0, 15, 22, 26]) % 12; // [ 2, 5, 0, 4 ]
(1 + [0, 18, 21, 27]) % 12; // [ 1, 7, 10, 4 ]
