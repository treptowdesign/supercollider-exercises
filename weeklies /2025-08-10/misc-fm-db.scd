

(
SynthDef(\fbTest, {
	var snd, freq, env, fb;
	freq = \freq.kr(220);
	env = Env.perc(0.001, 5).ar(Done.freeSelf);
	snd = Pulse.ar(freq, mul: -10.dbamp);

	snd = Pan2.ar(snd * env, \pan.kr(0), \amp.kr(1));

	snd = snd + LocalIn.ar(2);
	fb = snd * -2.dbamp;
	// Saturation
	fb = (fb + Line.ar(0, 0.1, 0.2)).tanh;
	fb = MoogFF.ar(fb, 10e3, 0);
	fb = HPF.ar(fb, 50);
	LocalOut.ar(fb);


	snd = MoogFF.ar(snd, 8e3, 0);


	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd);
}).play;
)


///////////////////////////////////////////////////////////////////////
// SinOscFB

(
SynthDef(\fbFM_easy, {
    var freq = \freq.kr(110);
	var fb   = \fb.kr(0.3);
    var env  = Env.perc(0.001, 5).ar(Done.freeSelf);
    var y    = SinOscFB.ar(freq, fb);
    var sig = y * env;
    sig = MoogFF.ar(sig, 12000, 0);
    sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(1));
    sig = Limiter.ar(sig, 0.99);
    Out.ar(\out.kr(0), sig);
}).play;
)

x = Synth(\fbFM_easy, [\freq, 220, \fb, 0.8]);



///////////////////////////////////////////////////////////////////////
// Local In/Out... not sure whats up here


(
SynthDef(\fbPM_loop, {
    var freq = \freq.kr(220);
    var idx  = \index.kr(0.4);     // phase index (radians)
    var env  = Env.perc(0.001, 5).ar(Done.freeSelf);

    var fb  = LocalIn.ar(1);       // feedback phase signal (radians)
    var osc = SinOsc.ar(freq, fb); // phase is audio-rate, so this is PM

    var send = (osc * idx);        // scale to radians
	var sig;
    // keep phase well-behaved; optional soft-limit is nicer than hard wrap:
    send = tanh(send) * pi;        // confine roughly ±π
    LocalOut.ar(send);             // back into next block’s phase

    sig = osc * env;
    sig = MoogFF.ar(sig, 8000, 0);
    sig = HPF.ar(sig, 50);
    sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(1));
    sig = Limiter.ar(sig, 0.99);
    Out.ar(\out.kr(0), sig);
}).play;
)

x = Synth(\fbPM_loop, [\freq, 220, \index, 1.2]);

///////////////////////////////////////////////////////////////////////
// Local In/Out... not sure whats up here

(
SynthDef(\fbFM_loop, {
    var freq = \freq.kr(220);
    var env  = Env.perc(0.001, 5).ar(Done.freeSelf);
    var idx  = \dev.kr(800);

    var fb   = LocalIn.ar(1);
    var instFreq = (freq + (fb * idx)).max(0.0);
    var osc  = SinOsc.ar(instFreq);
	var sig;

    LocalOut.ar(osc);                    // feed back the raw osc

    sig = osc * env;
    sig = MoogFF.ar(sig, 8000, 0);
	sig = HPF.ar(sig, 50);
    sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(1));
    // sig = Limiter.ar(sig, 0.99);
    Out.ar(\out.kr(0), sig);
}).play;
)

x = Synth(\fbFM_loop, [\freq, 110, \dev, 150]);

