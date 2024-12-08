// headcube 1
{LocalOut.ar(a=CombN.ar(BPF.ar(LocalIn.ar(2)*7.5+Saw.ar([32,33],0.2),2**LFNoise0.kr(4/3,4)*300,0.1).distort,2,2,40));a}.play

// This is the tweet rewritten in a longer, more "readable" way:
(
{LocalOut.ar(
  a = CombN.ar(
	  in: BPF.ar(in: LocalIn.ar(2)*7.5 + Saw.ar([32,33], 0.2), // BPF in
		     freq: LFNoise0.kr(4/3).exprange(18.75, 4800), // BPF freq
		     rq: 0.1				           // BPF rq
		    ).distort,					   // distort BPF
	  maxdelaytime:	2,	// CombN max delay time
	  delaytime: 2,		// CombN delay time
	  decaytime: 40)	// CombN decay time
	    ); // end of LocalOut parentheses
  a; // last thing to be returned, ie., it gets played
}.play
)


// headcube 2
play{GVerb.ar(VarSaw.ar(Duty.ar(1/5,0,Dseq(a=[[4,4.5],[2,3,5,6]];flat(a*.x allTuples(a*.x a)*4).clump(2)++0)),0,0.9)*LFPulse.ar(5),99,5)/5}


