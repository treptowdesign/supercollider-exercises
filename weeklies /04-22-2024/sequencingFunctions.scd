// sequencing functions
(
var noteToFreq, play, playParallel, wait;

noteToFreq = { |note|
	var scale;
	scale = [0, 2, 4, 5, 7, 9, 11];
	(60 - 4 + scale.wrapAt(note) + (12 * (note.div(scale.size)))).midicps;
};

// version A (durations in beats)
wait = { |durationInBeats|
	var duration;
	duration = durationInBeats * beat;
	duration.wait;
};

playParallel = { |synthDef, durationInBeats, args = #[]|
	var duration;
	duration = durationInBeats * beat;
	s.bind { Synth(synthDef, [duration: duration] ++ args) };
};

play = { |synthDef, durationInBeats, args = #[]|
	var duration;
	duration = durationInBeats * beat;
	s.bind { Synth(synthDef, [duration: duration] ++ args) };
	duration.wait;
};

// version B (durations in beats)

wait = { |duration|
	(duration * beat).wait;
};

playParallel = { |synthDef, duration, args = #[]|
	Routine({
		(1.0.rand.squared * 0.1).wait;
		s.bind { Synth(synthDef, [duration: duration * beat] ++ args) };
	}).play;
};

play = { |synthDef, duration, args = #[]|
	playParallel.(synthDef, duration, args);
	wait.(duration);
};

)