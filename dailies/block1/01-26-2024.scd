// scopes/plots
s.plotTree;
s.scope;
s.meter;
FreqScope.new(250);

// Devices
ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices; // output devices
// Server.default.options.inDevice("MacBook Pro Microphone");
// Server.default.options.outDevice("MacBook Pro Speakers");
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;


(
SynthDef(\woop, {
    var snd;
    snd = VarSaw.ar(Line.ar((\freq.kr(440) / 2), (\freq.kr(440)), 0.5));
    snd = snd * Env.perc(0.3, 0.75).ar(Done.freeSelf);
    snd = Pan2.ar(snd, \pan.kr(0));
    Out.ar(0, snd);
}).add;
)

Synth(\woop);

(
var s, bpm, beat, root, scale;
s = Server.default;
bpm = 142;
beat = 60 / bpm;
root = 50;
scale = Scale.lydian.degrees;
≥
Routine({
    var note;
    loop {
        note = (root + scale.choose() + (12 * 1)).midicps;
        Synth(\woop, [freq: note, pan: rrand(-1, 1)]);
        (beat/2).wait;
    };
}).play;

)