///////////////////////////////////////////////////
// Functions
///////////////////////////////////////////////////

(
~block = { |x, y| 1.0 };
~lineUp = { |x, y| exp(((x - y) * 3).squared * -1) };
~lineDown = { |x, y| exp((((1 - x) - y) * 3).squared * -1) };
~stripes = { |x, y| ((x * 5) % 1) > 0.5 };
~pattern = { |x, y| (((x + y) * 30).cos + 1) / 2 };
~checkerboard = { |x, y| (((x + y) * 5) % 2) > 1 };
~radial = { |x, y| exp(((x - 0.5).squared + (y - 0.5).squared) * -1 * 10) };
~triangle1 = { |x, y| (x + y) > 1 };
~triangle2 = { |x, y| ((1 - x) + y) > 1 };
~triangle3 = { |x, y| (x + (1 - y)) > 1 };
~triangle4 = { |x, y| ((1 - x) + (1 - y)) > 1 };
~annulus = { |x, y| var radius; radius = hypot(x - 0.5, y -0.5) * 2; (radius > 0.5) * (radius < 1) };
~diamond = { |x, y| ((x - 0.5) + (y - 0.5)) < 0.5 };

// additional...
~annulus2 = { |x, y|
	var radius, inner, outer;
	radius = hypot(x - 0.5, y - 0.5) * 2;
	inner = ((radius - 0.5) * 1000).clip(0, 1);
	outer = ((1 - radius) * 1000).clip(0, 1);
	inner * outer;
};
~wave = { |x, y|
	var center;
	center = (x * 2pi).sin * 0.3 + 0.5;
	exp(((y - center) * 6).squared.neg);
};
~cross = { |x, y|
	var a, b;
	a = exp(((x - y) * 5).squared.neg);
	b = exp((((1 - x) - y) * 5).squared.neg);
	(a + b).clip(0, 1);
};
~pulseCenter = { |x, y|
	var vertical, pulse;
	vertical = exp(((y - 0.5) * 5).squared.neg);
	pulse = ((x * 5 * 2pi).cos + 1) / 2;
	vertical * pulse;
};
~pulseCenter2 = { |x, y|
	var vertical, pulse;
	vertical = exp(((y - 0.5) * 2).squared.neg);
	pulse = ((x * 2 * 2pi).cos + 1) / 2;
	vertical * pulse;
};
~expand = { |x, y|
	var distance;
	distance = (y - 0.5).abs;
	exp(((distance - (x * 0.5)) * 8).squared.neg);
};
~waveFast = { |x, y|
	var center;
	center = (x * 6pi).sin * 0.4 + 0.5;
	exp(((y - center) * 10).squared.neg);
};
~hourglass = { |x, y|
	var distance, target;
	distance = (y - 0.5).abs;
	target = (x - 0.5).abs;
	exp(((distance - target) * 8).squared.neg);
};
~bounce = { |x, y|
	var center;
	center = (x * 4 % 2 - 1).abs;
	exp(((y - center) * 8).squared.neg);
};
~ripple = { |x, y|
	var radius;
	radius = hypot(x - 0.5, y - 0.5);
	((radius * 8 * 2pi).cos + 1) / 2;
};
~pinch = { |x, y|
	var width, distance;
	distance = (y - 0.5).abs;
	width = (x - 0.5).abs.linlin(
		0, 0.5,
		0.08, 0.5
	);
	exp((distance / width).squared.neg);
};
)




///////////////////////////////////////////////////
// Synth
///////////////////////////////////////////////////

(
SynthDef(\fmCluster, {
	var snd, freqs, duration, n, x, y, func;
	func = ~triangle1;
	duration = \duration.kr(2.0);
	n = (0..20);
	x = Line.ar(0, 1, duration);
	y = n.normalize;
	freqs = y.linexp(0, 1, \minFreq.kr(440), \maxFreq.kr(880));
	snd = SinOsc.ar(freqs * \ratio.kr(1)) * \index.kr(1000);
	snd = SinOsc.ar(freqs + snd);
	snd = snd * func.(x, y).lag(0.01);
	snd = snd * freqs.explin(800, 1000, 0, -5).dbamp;
	snd = snd.sum;
	snd = LeakDC.ar(snd);
	snd = snd * Env.linen(0.0, duration, 0.001, curve: -4).ar;
	snd = Pan2.ar(snd, \pan.kr(0), -21.dbamp * \amp.kr(1.0));
	snd = snd + LPF.ar(DelayC.ar(snd * -10.dbamp, 0.1, [Rand(0.02, 0.04), Rand(0.03, 0.06)]), 3000);
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
var minFreq, maxFreq, index, ratio;
minFreq = [exprand(30, 100), exprand(30, 60)].choose;
maxFreq = [exprand(8000, 16000.0), minFreq * rrand(10, 30).midiratio].wchoose([0.7, 0.3]);
index = rrand(100, 4e3);
ratio = [1, 1, 2, 3, 3, 4, 8, 12, 10, 16].choose;
Synth(\fmCluster, [minFreq: minFreq, maxFreq: maxFreq, index: index, ratio: ratio]);
)

///////////////////////////////////////////////////
// Synth Harmonic
///////////////////////////////////////////////////

(
var n, y;
n = (0..20);
((n + 1) ** 0.997);
)

(
var fnArr;
fnArr = [
	~block, ~stripes, ~lineUp, ~lineDown,
	~pattern, ~checkerboard, ~radial,
	~triangle1, ~triangle2, ~triangle3, ~triangle4,
	~annulus, ~diamond,
	~annulus2, ~wave, ~cross, ~pulseCenter, ~expand,
	~hourglass, ~bounce, ~ripple, ~pinch
];
)

(
SynthDef(\fmClusterHarm, {
	var snd, freqs, duration, n, x, y, func;
	func = ~triangle1;
	duration = \duration.kr(2.0);
	n = (0..20);
	x = Line.ar(0, 1, duration);
	y = n.normalize;
	freqs = \freq.kr(110) * ((n + 1) ** \harm.kr(1));
	snd = SinOsc.ar(freqs * \ratio.kr(1)) * freqs * \index.kr(1);
	snd = SinOsc.ar(freqs + snd);
	snd = snd * func.(x, y).lag(0.01);
	snd = snd * freqs.explin(800, 1000, 0, -5).dbamp;
	snd = snd.sum;
	snd = LeakDC.ar(snd);
	// snd = snd + PitchShift.ar(snd * -10.dbamp, 0.04, LFNoise2.ar(0.1).linexp(-1, 1, 1, 3));
	snd = snd * Env.linen(0.0, duration, 0.001, curve: -4).ar;
	snd = Pan2.ar(snd, \pan.kr(0), -21.dbamp * \amp.kr(1.0));
	snd = snd + LPF.ar(DelayC.ar(snd * -10.dbamp, 0.1, [Rand(0.02, 0.04), Rand(0.03, 0.06)]), 3000);
	snd = snd * Env.linen(0.0, duration, 0.3, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var index, ratio;
(60 + [0, 3+12, 7-12, 10]).do { |int|
	Synth(\fmClusterHarm, [
		freq: (int + (12 * -1)).midicps,
		index: 0.6,
		ratio: 8,
		harm: 1 - 3e-4,
		amp: 0.5
	]);
};
)


///////////////////////////////////////////////////
// Plot
///////////////////////////////////////////////////


(
~plotFunc = { |func, resolution=100|
	var window, view;
	window = Window("Function Plot", Rect(100, 100, 600, 600));
	view = UserView(window, window.view.bounds).background_(Color.black);
	view.drawFunc = {
		var w, h;
		w = view.bounds.width / resolution;
		h = view.bounds.height / resolution;
		resolution.do { |xi|
			resolution.do { |yi|
				var x, y, value;
				x = xi / (resolution - 1);
				y = yi / (resolution - 1);
				value = func.(x, y);
				value = switch(value,
					true,  { 1.0 },
					false, { 0.0 },
					{ value }
				);
				value = value.clip(0, 1);
				Pen.fillColor = Color.gray(value);
				Pen.fillRect(
					Rect(
						xi * w,
						(resolution - 1 - yi) * h,
						w + 1,
						h + 1
					)
				);
			};
		};
	};
	window.front;
};
)

(
var fnArr;
fnArr = [
	~block, ~stripes, ~lineUp, ~lineDown,
	~pattern, ~checkerboard, ~radial,
	~triangle1, ~triangle2, ~triangle3, ~triangle4,
	~annulus, ~diamond,

	~wave, ~cross, ~pulseCenter, ~expand,
	~hourglass, ~bounce, ~ripple, ~pinch
];
)

~plotFunc.(~wave);






///////////////////////////////////////////////////
// Argument Values
///////////////////////////////////////////////////

(
~getMinFreq = { [exprand(30, 100), exprand(30, 60)].choose };
~getMaxFreq = { [exprand(8000, 16000.0), ~getMinFreq.() * rrand(10, 30).midiratio].wchoose([0.7, 0.3]) };
~getIndex = { rrand(100, 4e3) };
~getRatio = { [1, 1, 2, 3, 3, 4, 8, 12, 10, 16].choose };
)

~getMinFreq.();
~getMaxFreq.();
~getIndex.();
~getRatio.();




(
var fnArr;
fnArr = [
	~block, ~stripes, ~lineUp, ~lineDown,
	~pattern, ~checkerboard, ~radial,
	~triangle1, ~triangle2, ~triangle3, ~triangle4,
	~annulus, ~diamond,
];
)








///////////////////////////////////////////////////
// endfile
///////////////////////////////////////////////////