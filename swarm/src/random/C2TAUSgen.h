// Swarm library. Copyright (C) 1996 Santa Fe Institute. This library is
//   distributed without any warranty; without even the implied warranty
//   of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:            C2TAUSgen.h
Description:     Combined Tausworthe generator
Library:         random
Original Author: Sven Thommesen
Date:		 1997-09-01 (v. 0.7)
*/

/*
123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|
*/

/*
--------------- | Generator Documentation:
		| ------------------------

Generator name:	| C2TAUS

Description:	| Combined Tausworthe Generator
		| based on 2 component generators of periods 2^31-1 and 2^29-1

Reference:	| Shu Tezuka and Pierre L'Ecuyer,
		| "Efficient and Portable Combined Tausworthe
		| Random Number Generators."
		| ACM Transactions on Modeling and Computer Simulation,
		| vol. 1 no. 2, April 1991, pp. 99-112.

		| Original reference for the Tausworthe algorithm:
		| R. C. Tausworthe, "Random Numbers Generated by Linear
		| Recurrence modulo 2", Math. Comput. 19 (1965), 201-209.

Algorithm:	| state = seed, then:

(Each		| b = ((old << Q) ^ old) & mask
component:)	| new = ((old << S) ^ (b >> (P-S)) & mask

(Combination:)	| output = ((new1 ^ (new2 << (P1-P2))

Implementation:	| 

Parameters:	| int   P [2]			// word length
		| int   Q [2]			// 
		| int   S [2]			//
		| int PmS [2]			// P - S
		| int P1mP2			// P[0] - P[1]
		| unsigned int Mask[2]		// 2^P - 1

State:		| unsigned int state[2]		// state vector

Output types:	| unsigned int (we return the current state).
		| float in [0.0,1.0) using 1 iteration of the generator.
		| double in [0.0,1.0) using 1 or 2 iterations of the generator.
		| long double in [0.0,1.0) using 2 iterations of the generator.
		| (See the implementation file for more details.)

Output range:	| Any number in the range [0,2^31-1] may be returned
		| (i.e. [0,2147483647].)

Valid seeds:	| Using create:setStateFromSeed: in [1, 2^32-1]
		| Using create:setStateFromSeeds:
		| 	Seed[0] must be in [1,Mask[0]];
		| 	Seed[1] must be in [1,Mask[1]];

Cycles:		| These generators have a single full cycle 
		| of length Mask1 * Mask2 ~= 2^60 (1.15e18).

Output Quality:	| The authors conducted an exhaustive search among candidate
		| Tausworthe generators to find the combination that had the
		| best lattice structure. (Single Tausworthe generators do not
		| have acceptable properties.) The 3 generators implemented 
		| here were retained as the best found.

Reference for	| Tezuka and L'Ecuyer, op. cit.
output quality:	| 

C2TAUSgen	| On a 486/66, the following approximate measures were obtained:
speed:		|   -getUnsignedSample:                        4.078 uS
		|   -getFloatSample, getDoubleSample:          5.932 uS
		|   -getFatDoubleSample, getLongDoubleSample: 10.920 uS

Relative speed:	| Speed 0.907 (time 1.103) relative to MT19937 getUnsignedSample
--------------- | --------------------------------------------------------------
*/

#import <string.h>
#import <random.h>
#import <swarmobject/SwarmObject.h>


#define COMPONENTS 2
#define SEEDS      2

@interface C2TAUSgen: SwarmObject

{

// Generator personality:

   unsigned int stateSize;
   unsigned int genMagic;
   char genName[GENNAMESIZE];

// Characteristic constants:

   unsigned long long int countMax;	// largest value for currentCount
   unsigned int unsignedMax;		// largest integral value returned
   double invModMult;			// (1.0/unsignedMax+1)
   double invModMult2;			// (1.0/unsignedMax+1)^2

   unsigned int lengthOfSeedVector;	// if multiple seeds
   unsigned int maxSeedValues[SEEDS];	// if multiple seeds

// Parameters:

   BOOL antiThetic;			// see -getUnsignedSample

// Working variables:

   BOOL singleInitialSeed;		// created with 1 seed ?
   unsigned int initialSeed;		// starting seed used (if 1)
   unsigned int initialSeeds[SEEDS];	// starting seeds used (if > 1)

// Count of variates generated:

   unsigned long long int currentCount;	// variates generated so far

// -- 

// Generator parameters:

   unsigned int numComponents;

   unsigned int P      [COMPONENTS];	// word length
   unsigned int Mask   [COMPONENTS];	// 2^P-1
   unsigned int Q      [COMPONENTS];	// 
   unsigned int S      [COMPONENTS];	// 
   unsigned int PmS    [COMPONENTS];	// P - S
   unsigned int P1mP2;			// P1 - P2

// Fixed value working variables:

   // (none)

// Working variables:

   // (none)

// State variables:

   unsigned int state [SEEDS];		// state vector

   // unsigned int IS [COMPONENTS];	// initialSeeds
   // unsigned int I  [COMPONENTS];	// state vector

}

//                                                                      simple.h

// ----- Private methods: -----

-		runup: (unsigned) streak;
-		generateSeeds;
-		setState;

-		initState;
+		createBegin: (id) aZone;
-		setStateFromSeed:  (unsigned)   seed;
-		setStateFromSeeds: (unsigned *) seeds;
-		createEnd;

// NOTE: creation methods are found in the subclasses below

// ----- Single-seed creation: -----

// + 		create: aZone setStateFromSeed:  (unsigned)   seed;

// Limits on seed value supplied (minimum = 0):
- (unsigned)	getMaxSeedValue;

// Return generator starting value:
- (unsigned) 	getInitialSeed;

// ----- Multi-seed creation: -----

// +		create: aZone setStateFromSeeds: (unsigned *) seeds;

// Number of seeds required (size of array) (minimum = 1):
- (unsigned) 	lengthOfSeedVector;

// Limits on seed values supplied (minimum = 0):
- (unsigned *)	getMaxSeedValues;

// Return generator starting values:
- (unsigned *) 	getInitialSeeds;

// ----- Other create methods: -----

// Create with a default set of seeds and parameters:
// +		createWithDefaults: aZone;

-		setAntithetic: (BOOL) antiT;

// ----- Return values of parameters: -----
- (BOOL)	getAntithetic;

// ----- Return state values: -----

// Return count of variates generated:
- (unsigned long long int)	getCurrentCount;

// ----- Generator output: -----

// The maximum value returned by getUnsignedSample is:
- (unsigned)    getUnsignedMax;

// Return a 'random' integer uniformly distributed over [0,unsignedMax]:
- (unsigned)	getUnsignedSample;

// Return a 'random' floating-point number uniformly distributed in [0.0,1.0):

- (float)       getFloatSample;			// using 1 unsigned
- (double)      getThinDoubleSample;		// using 1 unsigned
- (double)      getDoubleSample;		// using 2 unsigneds
- (long double) getLongDoubleSample;		// using 2 unsigneds

// Warning: use of the last method is not portable between architectures.

// ----- Object state management: -----

- (unsigned)	getStateSize;		
- (void)	putStateInto: (void *) buffer;
- (void)	setStateFrom: (void *) buffer;
- (void)	describe: (id) outStream;
- (char *)      getName;		
- (unsigned)	getMagic;	

@end


@interface C2TAUS1gen: C2TAUSgen

{

/*
Parameters:	| P = 31 so Mask = 2^31-1
(component 1)	| S = 12 so PmS = 19
		| Q = 13

		| P = 29 so Mask = 2^29-1
(component 2)	| S = 17 so PmS = 12
		| Q =  2

Reference for	| These values recommended by Tezuka and L'Ecuyer,
parameters:	| op. cit., table I p. 107.

Cycles:		| With the chosen parameters, this generator
		| has a single full cycle of length ~ 2^60.

Output Quality:	| Good.

Reference for	| Tezuka and L'Ecuyer, op.cit.
output quality:	| 
*/

}

-initState;

+ 		create: aZone setStateFromSeed:  (unsigned)   seed;
+		create: aZone setStateFromSeeds: (unsigned *) seeds;
+		createWithDefaults: aZone;

@end

@interface C2TAUS2gen: C2TAUSgen

{

/*
Parameters:	| P = 31 so Mask = 2^31-1
(component 1)	| S = 21 so PmS = 10
		| Q =  3

		| P = 29 so Mask = 2^29-1
(component 2)	| S = 17 so PmS = 12
		| Q =  2

Reference for	| These values recommended by Tezuka and L'Ecuyer,
parameters:	| op. cit., table II p. 107.

Cycles:		| With the chosen parameters, this generator
		| has a single full cycle of length ~ 2^60.

Output Quality:	| Good.

Reference for	| Tezuka and L'Ecuyer, op.cit.
output quality:	| 
*/

}

-initState;

+ 		create: aZone setStateFromSeed:  (unsigned)   seed;
+		create: aZone setStateFromSeeds: (unsigned *) seeds;
+		createWithDefaults: aZone;

@end

@interface C2TAUS3gen: C2TAUSgen

{

/*
Parameters:	| P = 31 so Mask = 2^31-1
(component 1)	| S = 13 so PmS = 18
		| Q = 13

		| P = 29 so Mask = 2^29-1
(component 2)	| S = 20 so PmS =  9
		| Q =  2

Reference for	| These values recommended by Tezuka and L'Ecuyer,
parameters:	| op. cit., table III p. 107.

Cycles:		| With the chosen parameters, this generator
		| has a single full cycle of length ~ 2^60.

Output Quality:	| Good.

Reference for	| Tezuka and L'Ecuyer, op.cit.
output quality:	| 
*/

}

-initState;

+ 		create: aZone setStateFromSeed:  (unsigned)   seed;
+		create: aZone setStateFromSeeds: (unsigned *) seeds;
+		createWithDefaults: aZone;

@end

