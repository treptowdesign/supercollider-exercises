
(
/*SynthDef(\lead, {
	var snd, freq;
	freq = \freq.kr(220);
	snd = Pulse.ar(freq, 0.5, 1) + SinOsc.ar(freq/2, 0.5pi, 0.5);
	// snd = Saw.ar(freq, 1) + SinOsc.ar(freq/2, 0.5pi, 0.5);
	// snd = LeakDC.ar(((snd + 0.1) * 20.dbamp).tanh);
	snd = (BPF.ar(snd, freq * ((1..26) * 1), 0.25) * ((1 / (1..26).cbrt) * 26).dbamp).sum;
	snd = snd + DelayC.ar(snd * 0.dbamp, 0.3, SinOsc.ar(1).range(0, 3e-3)) * 0.dbamp;
	snd = LPF.ar(snd, 5000);
	snd = snd * Env.perc(\atk.kr(0.02), \rel.kr(1), curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1) * 0.025);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;*/
/*SynthDef(\lead, {
	var snd, freq;
	freq = \freq.kr(330);
	snd = SinOsc.ar(freq * [1, 2, 4, 5, 8]) * ([700, 2500, 2000, 1000, 1800] * Env.perc(0.001, 4).ar);
	snd = SinOsc.ar((freq * 2) + snd).sum;
	snd = snd + DelayC.ar(snd * -5.dbamp, 0.2, SinOsc.ar(1).range(0, 1e-3));
	snd = snd * Env.perc(\atk.kr(0.001), \rel.kr(1)).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.2));
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).play;*/
SynthDef(\lead, {
	var snd, duration, click, env;
	duration = \duration.kr(0.2);
	snd = Impulse.ar(\freq.kr(330) * 2 * (LFNoise2.kr(3) * 0.1).midiratio);
	snd = (ToggleFF.ar(PulseDivider.ar(snd, [1, 2])) / [1, 2]).sum + snd;
	snd = LeakDC.ar(snd);
	snd = snd * -10.dbamp;
	// snd = (BPF.ar(snd, [400, 1200, 2300, 3600, 4200], 0.35) * [10, 5, 5, 2, 0].dbamp).sum;
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(1));
	snd = (snd * 5.dbamp).tanh;

	/*2.do {
		snd = HPF.ar(snd, 80);
	};
	*/
	snd = LPF.ar(snd, 7000);
	snd = Balance2.ar(snd[0], snd[1]);
	snd = snd * Env.perc(0.005, 2, curve: -4).ar;
	snd = snd * Env.linen(0, duration, 0.05, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\fxReverb, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + GVerb.ar(snd.mean * -15.dbamp, 10, 2, 0.8);
	Out.ar(\out.kr(0), Limiter.ar(snd));
}).add;
)

(1 / (1..16).sqrt);
(1 / (1..16).cbrt);

(
~reverbBus = Bus.audio(nil, 2);
)

~reverbBus.index;


(
var s, beat, root, wait, play;
s = Server.default;
beat = 60 / 130;
root = 52;

wait = { |duration| duration.wait; };
play = { |synth, duration, args|
	s.bind { Synth(synth, [duration: duration] ++ args); };
	wait.(duration);
};

Routine({
	Synth.tail(nil, \fxReverb, [in: ~reverbBus]);
	loop {
		[
			[0, 0.5],
			[1, 0.5],
			[7, 0.5],
			[8, 1],
			[12, 0.5],
			[0, 0.5],
			[7, 0.5],
			[1, 1],
		].do { |note|
			var deg, length, hz;
			deg = note[0];
			length = note[1];
			hz = (root + deg + (12 * 1)).midicps;
			play.(\lead, length * beat, [freq: hz, out: ~reverbBus]);
		};
	};
}).play;

)