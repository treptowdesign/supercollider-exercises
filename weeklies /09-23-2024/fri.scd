
// DEMAND DOCS
(
{
    var trig, seq, freq;
    trig = Impulse.kr(24);
    seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000);
    freq = Demand.kr(trig, 0, seq * 100);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
}.play;
)


(
{
    var trig, seq, freq;
    trig = Impulse.kr(12);
    seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000) * Drand([1,2,4,8],2000);
    freq = Demand.kr(trig, 0, seq * 100);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
}.play;
)

(
{
    var freq, trig, reset, seq;
    trig = Impulse.kr(10);
    seq = Diwhite(60, 72, inf).midicps;
    freq = Demand.kr(trig, 0, seq);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)

(
{
    var freq, trig, reset, seq;
    trig = Impulse.kr(10);
    seq = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
    freq = Demand.kr(trig, 0, seq);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)


(
{
    var freq, trig, reset, seq;
    trig = Impulse.kr(10);
    seq = Dswitch1(
        [
            Diwhite(60, 72, inf),
            Dseq([72, 75, 79, Drand([82,84,86])], inf)
        ],
        LFPulse.kr(0.2)
    );
    freq = Demand.kr(trig, 0, seq.midicps);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)


(
{
    var freq, trig, reset, seq1, seq2;
    trig = Impulse.kr(10);
    seq1 = Drand([72, 75, 79, 82] - 12, inf).midicps;
    seq2 = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
    freq = Demand.kr(trig, 0, [seq1, seq2]);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)

(
{
    var trig, seq;
    trig = Impulse.kr(8);
    seq = Drand([
        Dseq([4,0,0,1,2,1,0,1]),
        Dseq([4,0,2,0,1,0,1,1]),
        Dseq([4,0,0,2,0,0,1,1]),
        Dseq([4,0,1,2,0,1,2,0]),
        Dseq([4,1,1,1,2,2,3,3]),
        Dseq([4,1,0,1,0,1,0,1])
    ], inf);
    trig = Demand.kr(trig, 0, seq * 0.4) * trig;
    {LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
}.play;
)







(
{
    var freq, trig, reset, seq1, seq2;
    trig = Impulse.kr(8);
    seq1 = Drand([72, 75, 79, 82] - 12, inf).midicps;
    seq2 = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
    freq = Demand.kr(trig, 0, [seq1, seq2]);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
{
    var trig, seq;
    trig = Impulse.kr(8);
    seq = Drand([
        Dseq([4,0,0,1,2,1,0,1]),
        Dseq([4,0,2,0,1,0,1,1]),
        Dseq([4,0,0,2,0,0,1,1]),
        Dseq([4,0,1,2,0,1,2,0]),
        Dseq([4,1,1,1,2,2,3,3]),
        Dseq([4,1,0,1,0,1,0,1])
    ], inf);
    trig = Demand.kr(trig, 0, seq * 0.4) * trig;
    {LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
}.play;
)





(
{
    var trig, seq, freq;
    trig = Impulse.kr(8);
    seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], inf);
    freq = Demand.kr(trig, 0, seq * 100);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
{
    var trig, seq;
    trig = Impulse.kr(8);
    seq = Drand([
        Dseq([4,0,0,1,2,1,0,1]),
        Dseq([4,0,2,0,1,0,1,1]),
        Dseq([4,0,0,2,0,0,1,1]),
        Dseq([4,0,1,2,0,1,2,0]),
        Dseq([4,1,1,1,2,2,3,3]),
        Dseq([4,1,0,1,0,1,0,1])
    ], inf);
    trig = Demand.kr(trig, 0, seq * 0.4) * trig;
    {LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
}.play;
)


(
SynthDef(\analog2, {
	var snd, freq, duration;
	freq = \freq.kr(440) * Demand.ar(
		Impulse.ar(10),
		0,
		Dseq([3, 5, 2, 3, 0, -5], inf)
	).lag(0.01).midiratio;
	snd = Pulse.ar(freq, SinOsc.ar(0.23).linlin(-1, 1, 0.5, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.1).linexp(-1, 1, 200, 3000), 3.4) * 5.dbamp;
	snd = snd.tanh;
	snd = Pan2.ar(snd, 0);
	snd = snd * -15.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(10.0), 0.2, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).play;
)

(
{
    var snd, freq;
	freq = 440 * Demand.ar(
		Impulse.ar(8),
		0,
		Dseq([3, 5, 2, 3, 0, -5], inf)
	).lag(0.01).midiratio;
	snd = Pulse.ar(freq, SinOsc.ar(0.2).linlin(-1, 1, 0.5, 0.6));
	snd = MoogFF.ar(snd, SinOsc.ar(0.1).linexp(-1, 1, 200, 3000), 3.4) * 5.dbamp;
	snd = snd.tanh;
	snd = Pan2.ar(snd, 0);
	snd = snd * -20.dbamp;
}.play;
{
    var trig, seq;
    trig = Impulse.kr(8);
    seq = Drand([
        Dseq([4,0,0,1,2,1,0,1]),
        Dseq([4,0,2,0,1,0,1,1]),
        Dseq([4,0,0,2,0,0,1,1]),
        Dseq([4,0,1,2,0,1,2,0]),
        Dseq([4,1,1,1,2,2,3,3]),
        Dseq([4,1,0,1,0,1,0,1])
    ], inf);
    trig = Demand.kr(trig, 0, seq * 0.4) * trig;
    {LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
}.play;
)



(
{
    var trig, seq;
    trig = Impulse.kr(8);
    seq = Drand([
        Dseq([4,0,0,1,2,1,0,1])
    ], inf);
    trig = Demand.kr(trig, 0, seq * 0.4) * trig;
    {LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
}.play;
)


(
SynthDef(\pink, {
	var snd, trig, seq;
	trig = Impulse.kr(8);
	seq = Drand([
        Dseq([4,0,0,1,2,1,0,1]),
        Dseq([4,0,2,0,1,0,1,1]),
        Dseq([4,0,0,2,0,0,1,1]),
        Dseq([4,0,1,2,0,1,2,0]),
        Dseq([4,1,1,1,2,2,3,3]),
        Dseq([4,1,0,1,0,1,0,1])
    ], inf);
	trig = Demand.kr(trig, 0, seq * 0.4) * trig;
	snd = LPF.ar(PinkNoise.ar, 5000) * Decay.kr(trig, 0.5);
	Out.ar(0, snd ! 2);
}).play;
)





