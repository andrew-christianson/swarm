extern void *_collections_[];

externvar id Offsets;
externvar id ForEach;
externvar id ForEachKey;
externvar id Index;
externvar id PermutedIndex;
externvar id SwarmCollection;
externvar id DefaultMember;
externvar id MemberBlock;
externvar id Array;
externvar id ListIndex;
externvar id List;
externvar id CompareFunction;
externvar id KeyedCollection;
externvar id KeyedCollectionIndex;
externvar id MemberSlot;
externvar id _Set;
externvar id Set;
externvar id OrderedSet;
externvar id MapIndex;
externvar id Map;
externvar id OutputStream;
externvar id InputStream;
externvar id ArchiverKeyword;
externvar id ArchiverArray;
externvar id ArchiverValue;
externvar id ArchiverPair;
externvar id ArchiverList;
externvar id ArchiverQuoted;
externvar id String;
externvar id ListShuffler;
externvar id PermutationItem;
externvar id Permutation;

#ifdef DEFINE_CLASSES
#if SWARM_OSX
#import "collections_classes.h"
#else
#import <collections/classes.h>
#endif
#endif
