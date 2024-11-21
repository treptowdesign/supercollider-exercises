// Thursday 11-14-2024

(
SynthDef(\synth, {
	var snd, freq, pan, amp, atk, rel, crv;
	freq = \freq.kr(110);
	pan = \pan.kr(0);
	amp = \amp.kr(-10.dbamp);
	atk = \atk.kr(0.01);
	rel = \rel.kr(1);
	crv = \crv.kr(-2);
	snd = Saw.ar(freq);
	snd = snd * Env.perc(atk, rel, 1, crv).ar(Done.freeSelf);
	snd = Pan2.ar(snd, pan, amp);
	Out.ar(0, snd);
}).play;
)

(
SynthDef(\synth, {
	var snd, env, freq, pan, amp, atk, rel, crv;
	freq = \freq.kr(220);
	pan = \pan.kr(0);
	amp = \amp.kr(-10.dbamp);
	atk = \atk.kr(0.01);
	rel = \rel.kr(1);
	crv = \crv.kr(-2);
	env = Env.perc(atk, rel, 1, crv).ar(Done.freeSelf);
	snd = Saw.ar(freq);
	snd = snd * env;
	snd = Pan2.ar(snd, pan, amp);
	Out.ar(0, snd);
}).play;
)

(
SynthDef(\synth, {
	var env, voices, freq, snd;
	voices = 10;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1), 1, \crv.kr(-2)).ar(Done.freeSelf);
	freq = \freq.kr(220) * (( {LFNoise2.kr(0.4) } ! voices) * 0.2).midiratio;
	snd = LFSaw.ar(freq, { Rand(0 , 2pi) } ! voices);
	snd = Splay.ar(snd * env, 1, \amp.kr(-20.dbamp));
	Out.ar(0, snd);
}).play;
)


////////////////////////////////////////////////////

(
SynthDef(\detSaw, {
	var voices, env, freq, snd;
	voices = 10;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1), 1, \crv.kr(-2)).ar(Done.freeSelf);
	freq = \freq.kr(110) * (({ LFNoise2.kr(\detRate.kr(0.4)) } ! voices) * \detAmt.kr(0.2)).midiratio;
	snd = LFSaw.ar(freq, { Rand(0.0, 2.0) } ! voices);
	snd = Splay.ar(snd * env, 1, \amp.kr(-20).dbamp);
	Out.ar(0, snd);
}).play;
)


(
SynthDef(\detSaw, {
	var voices, detune, env, freq, snd;
	voices = 10;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1), 1, \crv.kr(-4)).ar(Done.freeSelf);
	detune = ({ LFNoise2.kr(\detRate.kr(0.4)) } ! voices) * \detAmt.kr(0.2);
	freq = \freq.kr(220) * (detune).midiratio;
	snd = LFSaw.ar(freq, { Rand(0.0, 2.0) } ! voices);
	snd = Splay.ar(snd * env, \spread.kr(1), \amp.kr(-15).dbamp);
	Out.ar(0, snd);
}).play;
)

Synth(\detSaw, [freq: 110, detRate: 0.2, detAmt: 0.4, amp: -15, spread: 1]);



(
SynthDef(\detSaw, {
	var voices, detune, env, freq, snd;
	voices = 10;
	env = Env.linen(\atk.kr(0.1), \sus.kr(0.5), \rel.kr(0.2), 1, \crv.kr(-4)).ar(Done.freeSelf);
	detune = ({ LFNoise2.kr(\detRate.kr(0.4)) } ! voices) * \detAmt.kr(0.2);
	freq = \freq.kr(110) * (detune).midiratio;
	snd = LFSaw.ar(freq, { Rand(0.0, 2.0) } ! voices);
	snd = Splay.ar(snd * env, \spread.kr(1), \amp.kr(-20).dbamp);
	Out.ar(0, snd);
}).play;
)

















(
SynthDef(\detSaw, {
	var voices, env, freq, snd;
	voices = 10;
	env = Env.linen(\atk.kr(0.3), \sus.kr(0.5), \rel.kr(0.2), 1, \crv.kr(-4)).ar(Done.freeSelf);
	freq = (({ LFNoise2.kr(\detRate.kr(0.4)) } ! voices) * \detAmt.kr(0.2)).midiratio; // chorus
	freq = freq * (SinOsc.kr(\vibratoRate.kr(8)) * \vibratoAmt.kr(0)).midiratio; // vibrato
	freq = \freq.kr(110) * freq;
	snd = LFSaw.ar(freq, { Rand(0.0, 2.0) } ! voices);
	snd = Splay.ar(snd * env, \spread.kr(1), \amp.kr(-26).dbamp);
	Out.ar(0, snd);
}).add;
)






(
SynthDef(\detPulse, {
	var voices, env, freq, snd;
	voices = 10;
	env = Env.linen(\atk.kr(0.02), \sus.kr(0.5), \rel.kr(0.2), 1, \crv.kr(-4)).ar(Done.freeSelf);
	freq = \freq.kr(110); // base freq
	freq = freq * (({ LFNoise2.kr(\detRate.kr(0.4)) } ! voices) * \detAmt.kr(0.2)).midiratio; // chorus
	freq = freq * (SinOsc.kr(\vibratoRate.kr(8)) * \vibratoAmt.kr(0)).midiratio; // vibrato
	snd = LFPulse.ar(freq, { Rand(0.0, 2.0) } ! voices);
	snd = LPF.ar(snd, 10e3);
	snd = Splay.ar(snd * env, \spread.kr(1), \amp.kr(-26).dbamp);
	Out.ar(0, snd);
}).play;
)





(
SynthDef(\detSaw, {
	var voices, env, freq, snd;
	voices = 10;
	env = Env.linen(\atk.kr(0.3), \sus.kr(0.5), \rel.kr(0.2), 1, \crv.kr(-4)).ar(Done.freeSelf);
	freq = \freq.kr(110); // base freq
	freq = freq * (({ LFNoise2.kr(\detRate.kr(0.4)) } ! voices) * \detAmt.kr(0.2)).midiratio; // chorus
	freq = freq * (SinOsc.kr(\vibratoRate.kr(8)) * \vibratoAmt.kr(0)).midiratio; // vibrato
	snd = LFSaw.ar(freq, { Rand(0.0, 2.0) } ! voices);
	snd = LPF.ar(snd, 10e3);
	snd = Splay.ar(snd * env, \spread.kr(1), \amp.kr(-26).dbamp);
	Out.ar(0, snd);
}).add;
)


Synth(\detSaw, [freq: 110, amp: -15, spread: 1]);
Synth(\detSaw, [freq: 440, amp: -10, detAmt: 0.8, vibratoAmt: 0.3]);

(
Synth(\detSaw, [freq: (46 + 0 + (12 * 1)).midicps, amp: -15, spread: 1]);
Synth(\detSaw, [freq: (46 + 3 + (12 * 1)).midicps, amp: -15, spread: 1]);
Synth(\detSaw, [freq: (46 + 7 + (12 * 1)).midicps, amp: -15, spread: 1]);
)

(
var s, beat, root, scale;
s = Server.default;
beat = 60 / 90;
root = 46;
scale = Scale.major.degrees;
Routine({
	var duration, note, num;
	loop {
		duration = beat * [2, 4, 8].choose;
		num = (1..8).choose;
		num.do {
			note = (root + scale.choose + (12 * [-1, 0, 1, 2].choose)).midicps;
			s.bind {
				Synth(\detSaw,
					[
						freq: note, amp: [-20, -25, -30].choose,
						atk: duration, sus: duration, rel: duration, crv: [-4, -2, 2, 4].choose,
						vibratoAmt: [0, 0.1, 0.2, 0.3].wchoose([0.7, 0.1, 0.1, 0.1]),
						vibratoRate: [2, 4, 8].choose
					]
				);
			};
		};
		duration.wait;
	}
}).play;
)





























// endfile... 