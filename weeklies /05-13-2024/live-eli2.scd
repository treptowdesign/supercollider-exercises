///////////////////////////////////////////////////////////////
// Ndefs (node proxy definitions
///////////////////////////////////////////////////////////////


[72, 62, 65, 69] +.x [0, 0.1];


Ndef(\pad).play;
Ndef(\pad).clear;
Ndef(\pad).fadeTime_(0.5).vol_(0.4);

Ndef(\pad, { Mix.ar( VarSaw.ar(([72, 62, 65, 69] +.x [0, 0.137]).midicps) * 0.1) ! 2 });

(
Tdef(\npat, {
	loop {
		[0, 3, -2, 5].do { |n|
			Ndef(\pad, { Mix.ar( VarSaw.ar(([72, 62, 65, 69] + n +.x [0, 0.137]).midicps) * 0.0.5) ! 2 });
			2.wait;
		}
	}
}).play;
)

Tdef(\npat).play;


Ndef(\bass).play;
Ndef(\bass).vol_(0.2);
Ndef(\bass, { RLPF.ar(Pulse.ar(38.midicps), Saw.kr(1).range(0, 1).linexp(0, 1, 20, 4000), 0.3) ! 2});


Ndef(\impulse, {Impulse.ar((110/60) * [2, 5] / 4)});

Ndef(\ring, {Ringz.ar(Ndef(\impulse), [72.midicps, 62.midicps] * 3, 1.2)});
Ndef(\ring).play;
Ndef(\ring).vol_(0.2);

Ndef(\comb, {CombN.ar(CombL.ar(Ndef(\impulse), 0.1, 1/[1892, 931]/5, 10), 0.1, 0.03, 2)});
Ndef(\comb).play;
Ndef(\comb).vol_(0.4);