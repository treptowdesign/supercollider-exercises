(
SynthDef(\shaker, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = CombC.ar(WhiteNoise.ar, 0.2, 1 / 20, 0.1);
	snd = BPF.ar(snd, [12120, 16230] * XLine.kr(0.5, 1, 2) * velocity, 0.3).sum;
	snd = HPF.ar(snd, 1000);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 1, 0.1, 0], [0.1, 0.1, 0.001, 0.01], curve: [2, 0.1, -2]).ar;
	snd = snd * Env.perc(0, 0.3 * velocity).ar(Done.freeSelf);
	snd = snd * -6.dbamp * velocity;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, beat, bar, root, wait, play;
s = Server.default;
beat = 60 / 118;
bar = beat * 4;
root = 56;

wait = { |duration=1|
	(duration).wait;
};

play = { |synthDef, duration, args = #[], latency = 0.0|
	fork {
		latency.wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	};
	wait.(duration);
};

Routine({
	loop {
		[1, 0.7, 0.9, 0.8, 0.6, 0.9, 0.8, 0.7].do { |vel, index|
			var late;
			late = if(index % 2 == 1) { 0 } { 0.01 };
			play.(\shaker, beat * 0.25, [velocity: vel], late);
		};
	};
}).play;
)