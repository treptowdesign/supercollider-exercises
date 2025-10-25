


(
SynthDef(\kick, { |

    mix = 0.5,          // 0=dry, 1=all compressed
    threshDB = -12,      // ~ -24..-12 is common
    ratio = 10,           // 4..10 for drums
    atkMs = 4,           // 3..10ms (let a little click through)
    relMs = 80,          // 60..160ms
    makeupDB = 3,        // +3..+9 usually
    outGainDB = 0        // post trim
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
)


(

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
)

(
SynthDef(\inst, {
	var snd, osc1, osc2, freq, env, velocity;
	freq = \freq.kr(60);
	velocity = \velocity.kr(1) * LFNoise2.ar(3).linlin(-1, 1, 0.2, 2).min(1);
	env = Env.perc(0.001, 4).ar(Done.freeSelf);
	osc1 = VarSaw.ar(freq * ([-0.1, 0, 0.1] * LFNoise2.ar(10 ! 3)).midiratio , 0, 1, 0.2).sum;
	osc2 = Pulse.ar(freq * ([-0.1, 0, 0.1] * LFNoise2.ar(10 ! 3)).midiratio, 0.5, 0.2).sum;
	snd = XFade2.ar(osc1, osc2, 0.5);
	snd = MoogFF.ar(snd, Env.perc(0.01, velocity.linlin(0, 1, 0.05, 0.4)).ar.linexp(0, 1, 20, velocity.linexp(0, 1, 500, 3000)) * LFNoise2.ar(0.3).linexp(-1, 1, 0.5, 2), LFNoise2.ar(0.3).linexp(-1, 1, 1, 3.5));
	snd = LPF.ar(snd, 8000);
	snd = Pan2.ar(snd * env, \pan.kr(0), -8.dbamp);
	Out.ar(\out.kr(0), snd);
}).play;
)


(
SynthDef(\lead, {
	var snd, freq, trigger, velocity, timeSinceTrigger;
	velocity = \velocity.kr(1) * LFNoise2.ar(3).linlin(-1, 1, 0.2, 2).min(1);
	trigger = T2A.ar(\trigger.tr(1));
	timeSinceTrigger = Sweep.ar(trigger);
	freq = \freq.kr(440).cpsmidi.lag(0.1).midicps;
	freq = freq * (SinOsc.ar(timeSinceTrigger.linlin(0, 1, 3, 6)) * timeSinceTrigger.min(0.5) * 0.6).lag(0.01).midiratio;
	snd = LFTri.ar(freq);
	snd = snd.tanh;
	snd = RLPF.ar(snd, SinOsc.ar(0.5).linexp(-1, 1, 300, 3000), 0.4);
	snd = snd * freq.explin(440, 1000, 0, -5).dbamp;
	snd = snd * Env.perc(0.1, 3, curve: -4).ar(Done.none);
	snd = snd + HPF.ar(GVerb.ar(snd * -15.dbamp, 20, 3), 1000);
	snd = snd * -16.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\chime, {
	var snd, freq;
	freq = \freq.kr(260);
	snd = SinOsc.ar(freq * [3.04, 10.02, 34]) * Env.perc(0, [0.3, 0.5, 1.0]).ar * 3000;
	snd = SinOsc.ar((freq * [1.002, 2, 1]) + snd).sum;
	snd = snd * Env.perc(0.01, 3.0, curve: -4).ar;
	snd = snd * (1 + Env.perc(0.01, 0.1, curve: -4).ar);
	snd = snd * -10.dbamp;
	snd = snd.clip2;
	snd = snd * 0.dbamp;
	snd = snd + PitchShift.ar(snd * -10.dbamp, ExpRand(0.1, 0.3), 2);
	snd = snd + LPF.ar(HPF.ar(GVerb.ar(snd * -10.dbamp, 30, 10), 300), 6000);
	snd = snd * Env.perc(0.001, 10.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\acid, {
	var snd, freq, trigger, velocity, introLength;
	introLength = \introLength.kr(0);
	velocity = \velocity.kr(1) * LFNoise2.ar(3).linlin(-1, 1, 0.2, 2).min(1);
	trigger = T2A.ar(\trigger.tr(1));
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = MoogFF.ar(snd, Env.perc(0.01, velocity.linlin(0, 1, 0.05, 0.4)).ar(gate: trigger).linexp(0, 1, 20, velocity.linexp(0, 1, 500, 3000)) * LFNoise2.ar(0.3).linexp(-1, 1, 0.5, 2), LFNoise2.ar(0.3).linexp(-1, 1, 1, 3.5));
	snd = snd * velocity.linlin(0, 1, -5, 0).dbamp;
	snd = snd * Env.perc(0.001, velocity.linlin(0, 1, 0.25, 1.0)).ar(gate: trigger);
	snd = snd * 15.dbamp;
	snd = BLowShelf.ar(snd, 300, 0.3, -5);
	snd = BHiShelf.ar(snd, 3000, 0.3, -5);
	snd = snd.tanh + (snd.fold2 * -7.dbamp);
	snd = BLowShelf.ar(snd, 400, 0.3, 5);
	snd = snd * -3.dbamp;
	snd = snd * Line.ar(-5.dbamp, 1, introLength);
	snd = LPF.ar(snd, XLine.ar(1000, 16e3, introLength));
	snd = HPF.ar(snd, XLine.ar(8000, 10, introLength)) + HPF.ar(GVerb.ar(snd * XLine.ar(-10.dbamp, -25.dbamp, introLength), 20, 3), 200);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)