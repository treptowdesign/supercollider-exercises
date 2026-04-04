

(
SynthDef(\src2, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 2, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 6.98) * 4;
	snd = SinOsc.ar(freq * 13.01, snd.mod(2pi)) * 0.3;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	snd = snd * (1 + (0.25 * Env.perc(0, 0.05).ar)); // transient
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\src, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, \rel.kr(3), curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 11.98) * 1;
	snd = SinOsc.ar(freq * 8.01, snd.mod(2pi)) * 0.5;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	snd = snd * (1 + (0.25 * Env.perc(0, 0.05).ar)); // transient
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\pluck, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 0.3, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 12.98) * 4;
	snd = SinOsc.ar(freq * 4.01, snd.mod(2pi)) * 0.8;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	snd = snd * (1 + (0.25 * Env.perc(0, 0.05).ar)); // transient
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\bass, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 3, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 5.98) * 1;
	snd = SinOsc.ar(freq * 2.001, snd.mod(2pi)) * 0.5;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	snd = snd * (1 + (0.5 * Env.perc(0, 0.05).ar)); // transient
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\src1, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 2, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 12) * 1;
	snd = SinOsc.ar(freq * 8, snd.mod(2pi)) * 0.5;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\chords1, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440);
	ampEnv = Env.perc(0.001, 4, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 8.991) * 0.1;
	snd = SinOsc.ar(freq * 4.009, snd.mod(2pi)) * 0.1;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\chords, {
	var snd, freq, ampEnv;
	freq = \freq.kr(440) * (1 - (1 * Env.perc(0, 0.4).ar));
	ampEnv = Env.perc(0.3, 4, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 13.991) * 1;
	snd = SinOsc.ar(freq * 4.009, snd.mod(2pi)) * 0.2;
	snd = SinOsc.ar(freq, snd.mod(2pi), -12.dbamp);
	// snd = (snd).tanh;
	snd = Pan2.ar(snd * ampEnv, \pan.kr(0), \amp.kr(1.0));
	Out.ar(\out.kr(0), snd);
}).add;
// drumz
SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(0.5);
	snd = SinOsc.ar(Env.perc(0, 0.1).ar.linexp(0, 1, 60, 500));
	snd = snd * Env.perc(0.001, 0.3).ar;
	snd = snd * 4.dbamp;
	snd = snd.tanh;
	snd = snd * -5.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.01).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(0.5);
	snd = Hasher.ar(Sweep.ar);
	snd = HPF.ar(snd, 3000);
	snd = snd * -5.dbamp;
	snd = snd * Env.perc(0.001, 0.03, curve: \lin).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\snare, {
	var snd, duration;
	duration = \duration.kr(0.5);
	snd = SinOsc.ar(250);
	snd = snd * Env.perc(0.001, 0.05).ar;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2523, 0.5) * 8.dbamp);
	snd = snd * Env.perc(0.001, 0.15).ar;
	snd = snd.tanh;
	snd = snd * -5.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.05).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = (BPF.ar(snd, [1223, 1500, 1950], 0.4) * [20, 10, 20].dbamp).sum;
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.015, 0.001, 0.015, 0.001, 0.07] * 0.9, curve: -8).ar;
	snd = snd.clip2;
	snd = snd + GVerb.ar(snd * -22.dbamp, 30, 1);
	snd = BHiShelf.ar(snd, 2300, 0.3, -3);
	snd = snd * (1 + (2 * Env.perc(0, 0.02).ar)); // transient
	snd = snd * Env.linen(0.0, 0.6, 0.9, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\kick);
Synth(\hat);
Synth(\snare);
Synth(\clap);


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
(
(32 + 2 + [0, 15, 19, 22]).sort.do { |int|
	[1, 2].do { |oct|
		Synth(\chords, [freq: (int + (12 * oct)).midicps, amp: 0.6]);
	};
};
)
(
(32 + 5 + [0, 16, 19, 11]).sort.do { |int|
	[1, 2].do { |oct|
		Synth(\chords, [freq: (int + (12 * oct)).midicps, amp: 0.6]);
	};
};
)
(
(32 + 0 + [0, 16, 19, 23]).sort.do { |int|
	[1, 2].do { |oct|
		Synth(\chords, [freq: (int + (12 * oct)).midicps, amp: 0.6]);
	};
};
)
(
(32 + 9 + [0, 15, 7, 10]).sort.do { |int|
	[1, 2].do { |oct|
		Synth(\chords, [freq: (int + (12 * oct)).midicps, amp: 0.6]);
	};
};
)
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////




(
(32 + 4 + [0, 15, 19, 10]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 *2)).midicps, amp: 0.6]);
};
)


(
(32 + 7 + [0, 16, 7, 11]).sort.do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)



(
(32 + [0, 16, 18, 23]).do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + [0, 15, 19, 22]).do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
(32 + [0, 15, 17, 22]).do { |int|
	Synth(\chords, [freq: (int + (12 * 2)).midicps, amp: 0.6]);
};
)

(
var s, bpm, beat, root, scale, play, makeSequence;
s = Server.default;
bpm = 130;
beat = 60 / bpm;
root = 32;
scale = Scale.ionian.degrees;
play = { |synth, duration, args = #[]|
	s.bind { Synth(synth, [duration: duration] ++ args) };
	(duration).wait;
};
makeSequence = { |length=8|
	var result;
	result = Array.fill(length, {
		(note: scale.choose, octave: (0..3).choose, duration: beat * [0.25, 0.5, 1].choose)
	});
};
Routine({
	loop {
		var dur, note, seq;
		seq = makeSequence.();
		seq.postln;
		dur = beat / 2;
		note = root + scale.choose + (12 * (0..3).choose);
		play.(\src, dur, [freq: note.midicps]);
	};
}).play;
)


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

(
var s, bpm, beat, bar, tatum, root, scale, play, makeSequence;
s = Server.default;
bpm = 130;
beat = 60 / bpm;
bar = beat * 4;
tatum = beat / 4;
root = 32;
scale = Scale.phrygian.degrees;
play = { |synth, duration, args=#[]|
	s.bind { Synth(synth, [duration: duration] ++ args) };
	(duration).wait;
};
makeSequence = { |length=8|
	Array.fill(length, {
		(note: (0..6).choose, octave: (-1..5).choose, duration: beat * 0.5)
	});
};
Routine({
	var seq, freq, amp;
	seq = Array.fill(6, { makeSequence.([4, 8, 16].choose) });
	loop {
		var active;
		active = seq.choose;
		[1, 2, 4].choose.do {
			active.do { |item|
				freq = (root + scale[item.note] + (12 * item.octave)).midicps;
				amp = item.octave.linlin(-1, 5, 0.8, 0.3);
				play.(\src, item.duration, [freq: freq, amp: amp]);
			};
		};
	};
}).play;
Routine({
	loop {
		// bar /////////////////////////////
		play.(\kick, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\hat, beat * 0.25);
		play.(\snare, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\kick, beat * 0.25);
		// bar /////////////////////////////
		play.(\kick, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\hat, beat * 0.25);
		play.(\snare, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\snare, beat * 0.25);
		////////////////////////////////////
	};
}).play;
)


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

(
var s, bpm, beat, bar, tatum, root, scale, play, playInline;
s = Server.default;
bpm = 87;
beat = 60 / bpm;
bar = beat * 4;
tatum = beat / 4;
root = 32;
scale = Scale.ionian.degrees;
play = { |synth, duration, args=#[]|
	s.bind { Synth(synth, [duration: duration] ++ args) };
	(duration).wait;
};
playInline = { |synth, duration, args=#[]|
	s.bind { Synth(synth, [duration: duration] ++ args) };
};
Routine({
	var dur = bar;
	loop {

		/*fork {
			var alt;
			[2, 5, 0, -3].do { |note|
				alt = [0, -5].choose;
				(beat * 2).wait;
				4.do {
					play.(\bass, beat/2, [freq: (root + note + alt + (12 * (0..1).choose)).midicps, amp: 1]);
				};
			};
		};*/

		fork {
			var oct, freq, amp, rel;
			[
				(2 + [0, 3, 7, 10]),
				(5 + [0, 4, 7, 11]),
				(0 + [0, 4, 7, 11]),
				(9 + [0, 3, 7, 10])
			].do { |notes|
				16.do { |item, index|
					oct = (0..5).choose;
					freq = (root + notes.choose + (12 * oct)).midicps;
					// amp = (index.linlin(0, 15, 0.001, 0.3)) * (oct.linlin(0, 5, 1, 0.3)) * [0.5, 1.25].choose;
					amp = (index.linlin(0, 15, 0.01, 0.3)) * (oct.linlin(0, 5, 1, 0.3)) * 1.25;
					rel = (1..4).choose;
					play.(\src, tatum, [freq: freq, amp: amp, rel: rel]);
				};
			};
		};

		[
			(notes: (2 + [0, 15, 19, 22]), length: bar),
			(notes: (5 + [0, 16, 19, 11]), length: bar),
			(notes: (0 + [0, 16, 19, 23]), length: bar),
			(notes: (9 + [0, 15, 7, 10]), length: bar/2),
			(notes: (0 + [0, 16, 19, 23]), length: bar/2)
		].do { |chord|
			var notes, length;
			// # notes, length = chord;
			notes = chord[\notes];
			length = chord[\length];
			notes.do { |note, index|
				[0, 1, 2].do { |oct, index|
					playInline.(\chords, length,
						[freq: (root + note + (12 * oct)).midicps, amp: index.linlin(0, 2, 0.4, 0.05)]
					);
				};
			};
			length.wait;
		};
	};
}).play;
Routine({
	loop {
		// bar /////////////////////////////
		play.(\kick, beat * 0.5);
		play.(\hat, beat * 0.5);
		play.(\clap, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\kick, beat * 0.25);
		// bar /////////////////////////////
		play.(\kick, beat * 0.25);
		play.(\kick, beat * 0.25);
		play.(\hat, beat * 0.5);
		play.(\clap, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\kick, beat * 0.25);
		// bar /////////////////////////////
		play.(\kick, beat * 0.5);
		play.(\hat, beat * 0.5);
		play.(\clap, beat * 0.5);
		play.(\hat, beat * 0.25);
		play.(\clap, beat * 0.25);
		// bar /////////////////////////////
		play.(\kick, beat * 0.25);
		play.(\kick, beat * 0.25);
		play.(\hat, beat * 0.25);
		play.(\kick, beat * 0.25);
		play.(\clap, beat * 0.5);
		play.(\hat, beat * 0.125);
		play.(\hat, beat * 0.125);
		play.(\hat, beat * 0.25);
		////////////////////////////////////
	};
}).play;
)


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
