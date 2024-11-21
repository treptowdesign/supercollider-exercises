//adapted from 2.18 Vibrations of a Stiff String, p61, Thomas D. Rossing and Neville H. Fletcher (1995) Principles of Vibration and Sound. New York: Springer-Verlag

(

var modes,modefreqs,modeamps;

var mu,t,e,s,k,f1,l,c,a,beta,beta2,density;

var decaytimefunc;

var material;



material= \steel; // \steel



//don't know values of E and mu for a nylon/gut string

//so let's try steel



//radius 1 cm

a=0.01;



s=pi*a*a;



//radius of gyration

k=a*0.5;





if (material ==\nylon,{



e=2e+7;



density=2000;



},{//steel



e= 2e+11; // 2e+7; //2e+11 steel;



//density p= 7800 kg m-3

//linear density kg m = p*S



density=7800;

});



mu=density*s;



t=100000;



c= (t/mu).sqrt;	//speed of sound on wave



l=1.8;	//0.3



f1= c/(2*l);



beta= (a*a/l)*((pi*e/t).sqrt);



beta2=beta*beta;



modes=10;



modefreqs= Array.fill(modes,{arg i;

var n,fr;

n=i+1;



fr=n*f1*(1+beta+beta2+(n*n*pi*pi*beta2*0.125));



if(fr>21000, {fr=21000}); //no aliasing



fr

});



decaytimefunc= {arg freq;

var t1,t2,t3;

var m,calc,e1dive2;



//VS p 50 2.13.1 air damping



m=(a*0.5)*((2*pi*freq/(1.5e-5)).sqrt);



calc= 2*m*m/((2*(2.sqrt)*m)+1);



t1= (density/(2*pi*1.2*freq))*calc;



e1dive2=0.01; //a guess!



t2= e1dive2/(pi*freq);



//leave G as 1

t3= 1.0/(8*mu*l*freq*freq*1);



1/((1/t1)+(1/t2)+(1/t3))

};



modeamps=Array.fill(modes,{arg i; decaytimefunc.value(modefreqs.at(i))});



modefreqs.postln;

modeamps.postln;



{

var output;

//EnvGen.ar(Env.new([0.001,1.0,0.9,0.001],[0.001,0.01,0.3],'exponential'),WhiteNoise.ar)

//could slightly vary amps and phases with each strike?



output=EnvGen.ar(

Env.new([0,1,1,0],[0,10,0]),doneAction:2)*

//slight initial shape favouring lower harmonics- 1.0*((modes-i)/modes)

Mix.fill(modes,{arg i; XLine.ar(1.0,modeamps.at(i),10.0)*SinOsc.ar(modefreqs.at(i),0,1.0/modes)});



Pan2.ar(output,0)

}.play;



)






(

// this shows the building of the piano excitation function used below

{

	var strike, env, noise;

	strike = Impulse.ar(0.01);

	env = Decay2.ar(strike, 0.008, 0.04);

	noise = LFNoise2.ar(3000, env);

	[strike, K2A.ar(env), noise]

}.plot(0.03); //.scope

)


(

// hear the energy impulse alone without any comb resonation

{

	var strike, env, noise;

	strike = Impulse.ar(0.01);

	env = Decay2.ar(strike, 0.008, 0.04);

	noise = LFNoise2.ar(3000, env);

	10*noise

}.scope

)



(

{

	var strike, env, noise, pitch, delayTime, detune;

	strike = Impulse.ar(0.01);

	env = Decay2.ar(strike, 0.008, 0.04);



	pitch = (36 + 54.rand);



	Pan2.ar(

			// array of 3 strings per note

			Mix.ar(Array.fill(3, { arg i;

				// detune strings, calculate delay time :

				detune = #[-0.05, 0, 0.04].at(i);

				delayTime = 1 / (pitch + detune).midicps;

				// each string gets own exciter :

				noise = LFNoise2.ar(3000, env); // 3000 Hz was chosen by ear..

				CombL.ar(noise,		// used as a string resonator

					delayTime, 		// max delay time

					delayTime,			// actual delay time

					6) 				// decay time of string

			})),

			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right

		)



}.scope

)




(

// synthetic piano patch (James McCartney)

var n;

n = 6;	// number of keys playing

play({

	Mix.ar(Array.fill(n, {	// mix an array of notes

		var delayTime, pitch, detune, strike, hammerEnv, hammer;



		// calculate delay based on a random note

		pitch = (36 + 54.rand);

		strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key

		hammerEnv = Decay2.ar(strike, 0.008, 0.04); // excitation envelope

		Pan2.ar(

			// array of 3 strings per note

			Mix.ar(Array.fill(3, { arg i;

				// detune strings, calculate delay time :

				detune = #[-0.05, 0, 0.04].at(i);

				delayTime = 1 / (pitch + detune).midicps;

				// each string gets own exciter :

				hammer = LFNoise2.ar(3000, hammerEnv); // 3000 Hz was chosen by ear..

				CombL.ar(hammer,		// used as a string resonator

					delayTime, 		// max delay time

					delayTime,			// actual delay time

					6) 				// decay time of string

			})),

			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right

		)

	}))

})

)