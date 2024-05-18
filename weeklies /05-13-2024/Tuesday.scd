// Chorus effect

Ndef(\lfo, {Saw.kr(2).unipolar(1)});
Ndef(\s, {Mix.ar(VarSaw.ar(([72, 62, 65, 69] + 0 +.x [0, 0.135]).midicps) * 0.1) * (Ndef(\lfo)) ! 2});
Ndef(\s).play;

Ndef(\s).fadeTime = 0.3;

(
Tdef(\chords, {
    loop {
        [0, 3, 7, 0].do { |n|
            Ndef(\s, {
                var freqs = ([72, 62, 65, 69] + n +.x [0, 0.135]).midicps;
				var signal = VarSaw.ar(freqs)) * 0.1;
                Mix.ar(signal) * (Ndef(\lfo)) ! 2
            });
            1.wait;
        };
    };
});
)

Tdef(\chords).play;
