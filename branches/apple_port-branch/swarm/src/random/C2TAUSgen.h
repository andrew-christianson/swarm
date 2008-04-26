// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
// 
// The Swarm Development Group can be reached via our website at:
// http://www.swarm.org/

/*
Name:            C2TAUSgen.h
Description:     Combined Tausworthe generator
Library:         random
Original Author: Sven Thommesen
Date:		 1997-09-01 (v. 0.7)

Modified by:	 Sven Thommesen
Date:		 1998-10-08 (v. 0.8)
Changes:	 Code cleanup related to signed/unsigned comparisons.
		 Code rearranged for create-phase compatibility.
		 Added -reset method.
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

#import "random.h"
#import "SwarmObject.h"


#define COMPONENTS 2U
#define SEEDS      2U

@interface C2TAUSgen: SwarmObject <SimpleRandomGenerator>

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
   unsigned (*getUnsignedSample) (id, SEL);
}


CREATING

// Unpublished (private) methods:
- runup: (unsigned)streak;
- initState;
+ createBegin: (id <Zone>)aZone;
- createEnd;

// @protocol Simple
+ createWithDefaults: (id <Zone>)aZone;

// @protocol SingleSeed
+ create: (id <Zone>)aZone setStateFromSeed: (unsigned)seed;

// @protocol MultiSeed
+ create: (id <Zone>)aZone setStateFromSeeds: (unsigned *)seeds;

SETTING

// Unpublished (private) methods:
- setState;
- generateSeeds;
- generateSeedVector;

// @protocol Simple
- setAntithetic: (BOOL) antiT;

// @protocol SingleSeed
- setStateFromSeed: (unsigned)seed;

// @protocol MultiSeed
- setStateFromSeeds: (unsigned *)seeds;

USING

// Unpublished (private) methods:

// @protocol InternalState
- (unsigned)getStateSize;		// size of buffer needed
- (void)putStateInto: (void *)buffer;	// save state data for later use
- (void)setStateFrom: (void *)buffer;	// set state from saved data
- (void)describe: outStream;	        // prints ascii data to stream
- (const char *)getName;		// returns name of object
- (unsigned)getMagic;			// object's 'magic number'

// @protocol SimpleOut
- (unsigned)getUnsignedMax;

- (unsigned)getUnsignedSample;
- (float)getFloatSample;
- (double)getThinDoubleSample;
- (double)getDoubleSample;
- (long double)getLongDoubleSample;

// @protocol Simple
- (BOOL)getAntithetic;
- (unsigned long long int)getCurrentCount;
- reset;

// @protocol SingleSeed
- (unsigned)getMaxSeedValue;		// min is 1
- (unsigned)getInitialSeed;

// @protocol MultiSeed
- (unsigned)lengthOfSeedVector;
- (unsigned *)getMaxSeedValues;		// min is 1
- (unsigned *)getInitialSeeds;

@end


@interface C2TAUS1gen: C2TAUSgen <SimpleRandomGenerator, CREATABLE>

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

CREATING

- initState;

+ create: (id <Zone>)aZone setStateFromSeed:  (unsigned)   seed;
+ create: (id <Zone>)aZone setStateFromSeeds: (unsigned *) seeds;
+ createWithDefaults: (id <Zone>)aZone;

SETTING

USING

@end

@interface C2TAUS2gen: C2TAUSgen <SimpleRandomGenerator, CREATABLE>

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

CREATING

- initState;
+ create: (id <Zone>)aZone setStateFromSeed:  (unsigned)   seed;
+ create: (id <Zone>)aZone setStateFromSeeds: (unsigned *) seeds;
+ createWithDefaults: (id <Zone>)aZone;

SETTING

USING

@end

@interface C2TAUS3gen: C2TAUSgen <SimpleRandomGenerator, CREATABLE>

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

CREATING

- initState;
+ create: (id <Zone>)aZone setStateFromSeed:  (unsigned)   seed;
+ create: (id <Zone>)aZone setStateFromSeeds: (unsigned *) seeds;
+ createWithDefaults: (id <Zone>)aZone;

SETTING

USING

@end
