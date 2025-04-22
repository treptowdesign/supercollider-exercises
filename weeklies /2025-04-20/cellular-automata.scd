// synths

(
SynthDef(\sqr, {|freq=440, amp=1|
	var snd, env;
	env = Env.perc(1e-4, 1).ar(Done.freeSelf) ** 4;
	snd = Pulse.ar(freq, mul: 1);
	snd = Pan2.ar(snd * env, 0, amp);
	Out.ar(0, snd);
}).add;
)

(
SynthDef(\blipp, {|freq=440, amp=1|
	var snd, env;
	env = Env.perc(1e-4, 1).ar(Done.freeSelf) ** 4;
	snd = SinOsc.ar(freq*[0.9 ,0.988 , 1, 1.01, 1.2], mul: [0.05,0.2,1,0.2,0.05]).mean;
	snd = Pan2.ar(snd * env, 0, amp);
	Out.ar(0, snd);
}).add;
)

{Env.perc(1e-3, 1).ar(Done.freeSelf) ** 2}.plot(1);

(
SynthDef(\blipChord, {|freq=440, amp=1, duration=1|
	var snd, env;
	env = Env.perc(1e-3, 1).ar ** 1;
	snd = SinOsc.ar(freq*[0.9 ,0.988 , 1, 1.01, 1.2], mul: [0.05,0.2,1,0.2,0.05]).mean;
	snd = Pan2.ar(snd * env, 0, amp);
	snd = snd * Env.linen(0, duration, 0.1).ar(Done.freeSelf);
	Out.ar(0, snd);
}).add;
)

(
(0 + [0, 2, 7, 10]).do { |degree|
	var note = (60 + degree).midicps;
	Synth(\blipChord, [freq: note]);
};
)


(
(-2 + [0, 3, 7, 10]).do { |degree|
	var note = (60 + degree).midicps;
	Synth(\blipChord, [freq: note]);
};
)

(
var s, bpm, beat;
s = Server.default;
bpm = 110;
beat = 60 / bpm;
Routine({
	var octave = 5;
	loop {
		4.do { |index|
			(0 + [0, 2, 7, 10]).do { |degree| // i: sus2 min7
				var note = ((12 * octave) + degree).midicps;
				s.bind{ Synth(\blipChord,
					[freq: note, amp: index.linlin(0, 3, 1, 0.3), duration: beat/2]
				); };
			};
			(beat/2).wait;
		};
		2.do { |index|
			(1 + [0, 4, 7, 11]).do { |degree| // bII: Maj7
				var note = ((12 * octave) + degree).midicps;
				s.bind{ Synth(\blipChord,
					[freq: note, amp: index.linlin(0, 1, 1, 0.3), duration: beat/2]
				); };
			};
			(beat/2).wait;
		};
		2.do { |index|
			(-2 + [0, 3, 7, 10]).do { |degree| // bvii: min7
				var note = ((12 * octave) + degree).midicps;
				s.bind{ Synth(\blipChord, [
					freq: note, amp: index.linlin(0, 1, 1, 0.3), duration: beat/2]
				); };
			};
			(beat/2).wait;
		};
	};
}).play;
)





//////////////////////////////////////////////////////////////////
// Simple one-dimensional Cellular Automata
//////////////////////////////////////////////////////////////////

(
~cellularAutomata = { |ruleNum, cells|
	var rule = ruleNum.asBinaryDigits(8);  // Converts rule number to binary digits
	cells.collect{|cell, i|
		var left = cells.wrapAt(i - 1);
		var self = cells[i];
		var right = cells.wrapAt(i + 1);
		var idx = [left, self, right].sum { |b, j| b * (2 ** (2 - j)) };
		rule[7 - idx]; // next state from rule array
	};
};
)


(
SynthDef(\blipSqr, {|freq=440, amp=1|
	var snd, env;
	env = Env.perc(1e-4, 1).ar(Done.freeSelf) ** 2;
	snd = Pulse.ar(freq*[0.9,0.988,1,1.01,1.1], mul: [0.05,0.2,1,0.2,0.1]).mean;
	snd = Pan2.ar(snd * env, 0, amp);
	Out.ar(0, snd);
}).add;
)

// initial state (random binary pattern)
~cells = Array.fill(16, { [0, 1].choose });
~scale = Scale.lydian.degrees + 60;

// Good Rules:
// 30: standard good one
// 38: melodic

(
var s;
s = Server.default;
Routine({
	var rule, scaleLength;
	rule = 42;
	scaleLength = ~scale.size;
	"Rule: %".format(rule).postln;

	loop {

		/*if(0.08.coin, {
			"MUTATE".postln;
			rule = rrand(0, 255);
			"Rule: %".format(rule).postln;
		});*/

		if(~cells.sum == 0, {
			"All zero state - restarting cells".postln;
			~cells = Array.fill(16, { [0, 1].choose }); // reinitialize randomly
		});

		~cells.postln;

		~cells.do { |state, idx|
			if(state == 1, {
				var octaveShift = (idx.div(scaleLength)) * 12;
				var scaleDegree = (~scale.wrapAt(idx) + octaveShift).midicps;
				// s.bind{ Synth(\blipp, [freq: scaleDegree, amp: 1]); };
				s.bind{ Synth(\blipSqr, [freq: scaleDegree, amp: 0.4]); };
				0.1.wait;
			});
		};

		// evolve cells for next iteration
		~cells = ~cellularAutomata.(rule, ~cells);
	};
}).play;
)


