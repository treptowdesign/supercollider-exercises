/*

ref tracks (via Lofi Girl):
Le Metroid - Blackhole
Indo Silver - Liminal

*/

(
SynthDef(\kick, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(
		Env.perc(0, 0.15, curve: -6).ar.linexp(0, 1, 59, 200) *
		XLine.ar(2, 1, 0.01) *
		XLine.ar(1, 0.5, 0.5) * [1, 1.4, 2.1]
	);
    snd = snd * Env.perc(0.001, [0.9, 0.4, 0.05]).ar * [0, -14, -22].dbamp;
    snd = snd.sum;
    snd = snd * (1 + Env.perc(0.001, 0.1).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2230, 0.3) * Env.perc(0.01, 0.02).ar * -8.dbamp);
    snd = snd + (SinOsc.ar(XLine.ar(3500, 500, 0.01)) * Env.perc(0.001, 0.01).ar * -8.dbamp);
	snd = (snd * 2.dbamp).tanh;
    snd = BLowShelf.ar(snd, 100, 0.3, 3);
    snd = snd * (1 + (0.5 * Env.perc(0.001, 0.05).ar));
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd, 0.05, [27e-3, 45e-3]) * -30.dbamp, 3000), 200);
    snd = snd * -10.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    OffsetOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
    var snd, duration;
    duration = \duration.kr(1);
    snd = SinOsc.ar(220 * XLine.ar(1.3, 1, 0.01) * [1, 2.3, 1.5]);
    snd = snd * Env.perc(0.001, [0.05, 0.01, 0.005]).ar;
    snd = snd.sum;
    snd = snd.tanh;
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 0), 2230, 0.3) * Env.perc(0.05, 0.12).ar * 1.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 1), 1230, 0.5) * Env.perc(0.03, 0.30).ar * 1.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 2), 1530, 0.5) * Env.perc(0.02, 0.15).ar * 1.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 3), 2530, 0.3) * Env.perc(0.03, 0.05).ar * -5.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 4), 3230, 0.5) * Env.perc(0.1, 0.20, curve: -6).ar * -7.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 0), 730, 0.3) * Env.perc(0.05, 0.1).ar * -4.dbamp);
    snd = snd.clip2;
    snd = LPF.ar(snd, 9000) + LPF.ar(HPF.ar(GVerb.ar(snd * -5.dbamp, 120, 2), 300), 2500);
    snd = snd + HPF.ar(LPF.ar(DelayC.ar(snd, 0.05, [37e-3, 95e-3]) * -30.dbamp, 3000), 200);
    snd = snd * Line.ar(0, 1, 0.02).squared;
    snd = snd * -4.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
    OffsetOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
    var snd, duration, v;
    duration = \duration.kr(1);
    snd = Hasher.ar(Sweep.ar(Impulse.ar(90 * [0.45, 0.78, 0.92, 1.02])));
    snd = LeakDC.ar(snd);
    snd = FreqShift.ar(snd, [63, 231, 92, 42]);
    snd = Splay.ar(snd, 0.9);
    v = (0..12).normalize;
    snd = BPF.ar([snd], v.linexp(0, 1, 6000, 16e3), 0.05) * 5.dbamp;
    snd = snd * Env.perc(v.linexp(0, 1, 0.04, 0.03), v.linexp(0, 1, 0.9, 0.05)).ar;
    snd = snd.sum;
    snd = HPF.ar(snd, 3000);
    snd = HPF.ar(snd, 3000);
    snd = snd * Env.perc(0.001, 0.5).ar;
    snd = snd * -12.dbamp;
    snd = snd * Env.linen(0.0, duration - 0.03, 0.03, curve: -4).ar(Done.freeSelf);
    OffsetOut.ar(\out.kr(0), snd);
}).add;

// sustained
SynthDef(\arp, {
    var snd, gate, freq, trigger, n;
    gate = \gate.kr(1);
    freq = \freq.kr(440);
    trigger = T2A.ar(\trigger.tr(0));
    n = 7;
    snd = Pulse.ar(
        freq * [-0.2, -12.1, 0 + 0.1, 0, 0 - 0.1, -12 + 0.1, 0.2].midiratio * (LFNoise2.ar(20 ! n) * 0.12).midiratio,
        LFNoise2.ar(0.3 ! n).linlin(-1, 1, 0.1, 0.9)
    );
    snd = snd + CombC.ar(snd * -5.dbamp, 0.05, 1 / ExpRand(30 ! n, 90), -0.35);
    snd = Splay.ar(snd, 0.7);
    snd = snd * Env.perc(0.01, 0.3).ar(gate: trigger);
    snd = snd * (1 + Env.perc(0.001, 0.01).ar(gate: trigger));
    snd = RLPF.ar(
        snd,
        Env.perc(0.01, 0.3, curve: -8).ar(gate: trigger).linexp(0, 1, 500, 3500)
        * SinOsc.ar(0.23).linexp(-1, 1, 0.5, 2),
        0.6
    );
    snd = snd * 3.dbamp;
    snd = BHiShelf.ar(snd, 1200, 0.3, -4);
    snd = BLowShelf.ar(snd, 200, 0.3, -5);
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -20.dbamp;
    snd = snd * Env.asr(0.01, 1.0, 0.01, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\arpFx, {
    var snd, fb, beat;
    beat = \beat.kr(1);
    snd = In.ar(\in.kr(0), 2);
    snd = snd + DelayC.ar(snd * -20.dbamp, 0.2, SinOsc.ar(0.2, [0, pi]).linlin(-1, 1, 0, 1e-3));
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, beat * 2, beat - ControlDur.ir + (SinOsc.ar(0.3, [0, pi]) * 0.001));
    fb = fb * -3.dbamp;
    fb = LPF.ar(fb, 3000);
    fb = HPF.ar(fb, 200);
    LocalOut.ar(fb);
    snd = snd + fb;
    snd = snd + GVerb.ar(snd.sum * -14.dbamp, 50, 3);
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sidechainFx, {
    var snd, trigger;
    trigger = T2A.ar(\trigger.tr(0));
    snd = In.ar(\in.kr(0), 2);
	snd = snd * (1 - (Env.perc(0.001, 0.4, curve: 3).ar(gate: trigger) * 0.8));
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sub, {
    var snd, gate, freq, trigger;
    gate = \gate.kr(1);
    freq = \freq.kr(60);
    trigger = T2A.ar(\trigger.tr(0));
	snd = SinOsc.ar(freq, mul: 0.2);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * 12.dbamp;
    snd = snd.tanh;
    snd = BLowShelf.ar(snd, 200, 0.3, 2);
    snd = snd * -14.dbamp ! 2;
    snd = snd * Env.asr(0.01, 1.0, 0.01, curve: -4).ar(Done.freeSelf, gate);
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lead, {
    var snd, gate, freq, fb, timbreEnv, combLfo;
    gate = \gate.kr(1);
    freq = \freq.kr(440).cpsmidi.lag(\lag.kr(0.01)).midicps;
    freq = freq * (SinOsc.ar(4.34) * 0.02).midiratio;
    freq = freq * (SinOsc.ar(0.5) * 0.1).midiratio;

	timbreEnv = Env.asr(2.0, 1.0, 1.0, curve: -8).ar(gate: gate);
	combLfo = SinOsc.ar(0.25, pi).linlin(-1, 1, 62, 68);

	snd = SinOsc.ar(freq * [1, 0.5]) * timbreEnv * SinOsc.ar(0.45, [0, pi]).linexp(-1, 1, 6, 8);
    snd = SinOsc.ar(freq, snd % 2pi);
    snd = snd * [0, -8].dbamp;
    snd = snd.sum * -15.dbamp;
    snd = snd * Env.asr(0.01, 1.0, 3.0, curve: -4).ar(Done.none, gate);

	snd = snd + FreqShift.ar(CombC.ar(FreqShift.ar(snd, -32), 0.2, 1 / combLfo, 0.22), 32, mul: -4.dbamp);

    snd = LPF.ar(snd, 2600);


	// delay...
    fb = snd;
    fb = fb + LocalIn.ar(2);
    fb = DelayC.ar(fb, 1.0, [0.35, 0.45] + (SinOsc.ar(0.5, [0, pi]) * 1e-3));
    fb = LPF.ar(fb, 2000);
    fb = HPF.ar(fb, 100);
    fb = fb * -3.dbamp;
    LocalOut.ar(fb);

    snd = snd + fb;

    Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\marker, {
	var snd, freq, rel;
	freq = \freq.kr(110);
	rel = \rel.kr(6.0);
	snd = (freq * (1..8) * \ratio.kr(1)).collect { |freq, index|
		var snd;
		var amp = (1 / (index + 1)).sqrt;
		snd = LFTri.ar(freq * (LFNoise2.kr(8 ! 2) * 0.2).midiratio, mul: amp) * LFNoise2.kr(2 ! 2);
		snd = [snd[0] + snd[1], snd[0] - snd[1]] / sqrt(2); // midsides
		snd;
	};
	snd = snd.sum;
	snd = snd * (1 + (2 * Env.perc(0, 0.3).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.1, rel, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * -12.dbamp * \amp.kr(1);
	Out.ar(\out.kr, snd);
}).add;

)




(
var s, beat, play, playP, wait;
var noteToFreq;
s = Server.default;
beat = 60 / 98;

playP = { |synthDef, duration, args = #[]|
    s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
};

play = { |synthDef, duration, args = #[]|
    s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
    (duration * beat).wait;
};

wait = { |duration|
    (duration * beat).wait;
};

noteToFreq = { |note, octave = 0|
    var midiNote;
    midiNote = 63 + note + (octave * 12);
    1 / ((1 / (midiNote.midicps - 1e-3)) + 5e-6)
};

Routine({
    var arpBus, sidechainBus, sidechainFx, pump;
    var drumsA, drumsAFill, drumsB, drumsBFill;

    s.bind {
        arpBus = Bus.audio(nil, 2);
        sidechainBus = Bus.audio(nil, 2);
        Synth.tail(nil, \arpFx, [in: arpBus, out: sidechainBus, beat: beat]);
        sidechainFx = Synth.tail(nil, \sidechainFx, [in: sidechainBus, out: 0]);
    };

    pump = {
        s.bind { sidechainFx.set(\trigger, 1) };
    };

	fork {
		loop {
			[-12, 3, 7-12, 10, 14].sort.do { |int, index|
				[-1, 0].do { |oct|
					playP.(\marker, 8, [
						freq: noteToFreq.(int, oct),
						amp: index.linlin(0, 4, 1, 0.5),
						rel: beat * 8,
						out: arpBus
					]);
				};
			};
			wait.(8);
		};
	};

    fork {
		var lead;
		s.bind {
			lead = Synth(\lead, [out: sidechainBus]);
			lead.set(\freq, noteToFreq.(0, 1), \gate, 0); // set initial freq...
		};
		loop {
			[
				// 8 beats
				[2.5, \],
				[0.25, 5],
				[0.75, 3],
				[0.5, -2],
				[0.75, 7, \port],
				[0.75, 8],
				[2.5, 2],

				// 8 beats
				[2.5, \],
				[0.25, 8],
				[0.25, 7],
				[0.25, 5, \port],
				[0.25, 3],
				[0.5, -2],
				[0.75, 7],
				[0.75, 8, \port],
				[2.5, 2],

				// 8 beats
				[2.5, \],
				[0.25, 5],
				[0.75, 3],
				[0.5, -2 + 12, \port],
				[0.75, 7],
				[0.75, 8, \port],
				[2.5, 2],

				// 8 beats
				[2.5, \],
				[0.25, 8],
				[0.25, 7],
				[0.25, 5, \port],
				[0.25, 3],
				[0.5, -2],
				[0.75, 7, \port],
				[0.75, 8],
				[2.5, 2],

			].do { |spec|
                var freq, duration, lag;
                # duration, freq = spec;
				lag = if(spec[2..].includes(\port), 0.35, 0.01);
                if(freq == \) {
                    s.bind {
                        lead.set(\gate, 0);
                    };
                } {
                    s.bind {
                        lead.set(\freq, noteToFreq.(freq, 1), \gate, 1, \lag, lag);
                    };
                };
                wait.(duration);
            };
        };
        s.bind {
            lead.set(\gate, 0);
        };
    };

	fork {
        var sub;
        var synths, playChord, setSub;
        s.bind {
            sub = Synth(\sub, [out: sidechainBus]);
            synths = 4.collect { Synth(\arp, [out: arpBus]) };
        };
        playChord = { |chord|
            s.bind {
                synths.do { |synth, i|
                    synth.set(\trigger, 1, \freq, noteToFreq.(chord[i]));
                };
            };
        };
        setSub = { |note|
            s.bind {
                sub.set(\trigger, 1, \freq, noteToFreq.(note, octave: -2));
            };
        };
        loop {
            [
				// 8 beats
                [0, 3],
                [5, 1],
                [-2, 2],
                [-5, 1],
				[0, 1],
				// 8 beats
                [0, 3],
                [7, 1],
                [-4, 2],
                [-5, 1],
				[0, 1],
            ].do { |spec|
                var root, duration;
                # root, duration = spec;
                setSub.(root);
				wait.(duration);
            };
        };
    };






	//////////////////////////////////////////////////////////
	// DRUMS
	//////////////////////////////////////////////////////////

    drumsA = {
        pump.();
        play.(\kick, 1);
        playP.(\snare, 1);
        pump.();
        play.(\kick, 1);
    };

    drumsAFill = {
        pump.();
        play.(\kick, 1);
        playP.(\snare, 1);
        pump.();
        play.(\kick, 1 / 2);
        pump.();
        play.(\kick, 1 / 2);
    };

    drumsB = {
        fork {
            wait.(1 / 2);
            play.(\hat, 1 / 2);
            wait.(1 / 2);
            play.(\hat, 1 / 2);
        };
        pump.();
        play.(\kick, 1);
        playP.(\snare, 1);
        pump.();
        play.(\kick, 1);
    };

    drumsBFill = {
        fork {
            wait.(1 / 2);
            play.(\hat, 1 / 2);
            wait.(1 / 2);
            play.(\hat, 1 / 2);
        };
        pump.();
        play.(\kick, 1);
        playP.(\snare, 1);
        pump.();
        play.(\kick, 1 / 2);
        pump.();
        play.(\kick, 1 / 2);
    };

	loop {
		// wait.(16);
		1.do {
			7.do {
				drumsA.();
			};
			drumsAFill.();
		};
		1.do {
			7.do {
				drumsB.();
			};
			drumsBFill.();
		};
	};
}).play;
)




///////////////////////////////////////////////////////////


s.makeWindow;






///////////////////////////////////////////////////////////



[-12, 2, 7-12, 10, 17].sort;




///////////////////////////////////////////////////////////
// SCALES

// by memory
[0, 2, 4, 5, 7, 9, 11] // Ionian (major)
[0, 2, 3, 5, 7, 8, 10] // Aeolian (minor)
[0, 1, 3, 5, 7, 8, 10] // Phrygian
[0, 2, 3, 5, 7, 9, 10] // Dorian
[0, 1, 3, 5, 6, 8, 10] // Locrian
[0, 2, 4, 6, 7, 9, 11] // Lydian
[0, 2, 4, 5, 7, 9, 10] // Mixolydian

// test em
[0, 2, 4, 5, 7, 9, 11] == Scale.ionian.degrees;
[0, 2, 3, 5, 7, 8, 10] == Scale.aeolian.degrees;
[0, 1, 3, 5, 7, 8, 10] == Scale.phrygian.degrees;
[0, 2, 3, 5, 7, 9, 10] == Scale.dorian.degrees;
[0, 1, 3, 5, 6, 8, 10] == Scale.locrian.degrees;
[0, 2, 4, 6, 7, 9, 11] == Scale.lydian.degrees;
[0, 2, 4, 5, 7, 9, 10] == Scale.mixolydian.degrees;













// endfile...
