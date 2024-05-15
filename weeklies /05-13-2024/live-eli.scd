///////////////////////////////////////////////////////////////
// NodeProxy
///////////////////////////////////////////////////////////////

// https://www.youtube.com/watch?v=6W8XRiFMiCs
// https://www.youtube.com/watch?v=9db7v1nEBm8

x = NodeProxy().play;

x.numChannels;
x.rate;

x.source_({SinOsc.ar([300, 302] * rrand(1.0, 2.0)) * LFPulse.kr(SinOsc.kr(0.2).range(1, 8)) });

x.source_({SinOsc.ar([300, 302] * rrand(1.0, 3.0)) * LFPulse.kr(5) });

x.source_({SinOsc.ar([300, 302] * rrand(1.0, 2.0)) * Saw.kr(2) });

x.fadeTime_(1);

x.source_(nil); // silence the proxy
x.stop; // stops and removes from server

x.play(vol: 0.2, fadeTime: 1.5); // play and set fadetime automatically


///////////////////////////////////////////////////////////////
// Ndef and Tdef
///////////////////////////////////////////////////////////////

Ndef(\n).fadeTime_(0.5).play(vol: 0.3);

Ndef(\n, {Splay.ar(BPF.ar(BrownNoise.ar(1), ([58, 60, 63, 65] + 0).midicps, 0.001, 100))});

Ndef(\n, {Splay.ar(BPF.ar(PinkNoise.ar(1), ([58, 60, 63, 65] + 0).midicps, 0.005, 100))});


(
Tdef(\npat, {
	loop {
		[0, 3, -2, 5].do { |n|
			Ndef(\n, {Splay.ar(BPF.ar(BrownNoise.ar(1), ([58, 60, 63, 65] + n).midicps, 0.001, 100))});
			2.wait;
		}
	}
}).play;
)

Tdef(\npat).stop;
Ndef(\n).end(2);

///////////////////////////////////////////////////////////////
// ProxySpace
///////////////////////////////////////////////////////////////

t = TempoClock(110/60).permanent_(true);

// 36:30
p = ProxySpace(clock: t).fadeTime_(4).quant_(1).push;

// 38:21
p.fadeTime_(0.02).quant_(nil);

~x.play(vol: 0.2);
~y.play();
~y.vol_(0.1);

~x = {Ringz.ar(~trig.ar, [782, 1032], 1.4)}
~y = {CombL.ar(~trig.ar, 0.5, 1/[792, 1031]/5, 0.2)};
~trig = {Impulse.ar(p.clock.tempo * [2, 5] / 4)};


~x.stop(fadeTime: 3);

// https://www.youtube.com/watch?v=dbwx31K02x0


///////////////////////////////////////////////////////////////
// Ndefs
///////////////////////////////////////////////////////////////

Ndef(\s).play;
Ndef(\lfo, { Pulse.kr(4, SinOsc.kr(1).range(0.2, 0.8)).unipolar });
Ndef(\lfo2, { Saw.kr(8).unipolar * Saw.kr(2).range(1, 4) });
Ndef(\s, { (SinOsc.ar([330, 331] * Ndef(\lfo2)) * Ndef(\lfo)).tanh });




///////////////////////////////////////////////////////////////
// Misc
///////////////////////////////////////////////////////////////



[72, 62, 65, 69] +.x [0, 0.1];


Ndef(\pad).play;
Ndef(\pad).fadeTime_(0.5);

Ndef(\pad, { Mix.ar( VarSaw.ar(([72, 62, 65, 69] +.x [0, 0.137]).midicps) * 0.1) ! 2 });

(
Tdef(\npat, {
	loop {
		[0, 3, -2, 5].do { |n|
			Ndef(\pad, { Mix.ar( VarSaw.ar(([72, 62, 65, 69] + n +.x [0, 0.137]).midicps) * 0.1) ! 2 });
			2.wait;
		}
	}
}).play;
)

Tdef(\npat).play;





///////////////////////////////////////////////////////////////
// end
///////////////////////////////////////////////////////////////

