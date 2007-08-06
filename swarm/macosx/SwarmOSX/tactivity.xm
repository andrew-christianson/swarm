#import <tactivity.h>
#import <objc/objc-api.h>


void *_tactivity_symbols[]={
0,
0};

externvardef id Group_test=0;
externvardef id ActionGroup_test=0;
externvardef id ConcurrentGroup_test=0;

void *_tactivity_types[]={
&Group_test,
&ActionGroup_test,
&ConcurrentGroup_test,
0,
@protocol(Group_test),
@protocol(ActionGroup_test),
@protocol(ConcurrentGroup_test),
0};

externvardef id id_ActionGroup_test_c=0;
externvardef id id_ConcurrentGroup_test_c=0;

void *_tactivity_classes[]={
&id_ActionGroup_test_c,
&id_ConcurrentGroup_test_c,
0};

@class ActionGroup_test_c;
@class ConcurrentGroup_test_c;

extern void _tactivity_implement(void);
extern void _tactivity_initialize(void);

void *_tactivity_[]=
{
0,
"tactivity",
(void *)_tactivity_implement,
(void *)_tactivity_initialize,
_tactivity_types,
_tactivity_symbols,
_tactivity_classes,
};


@interface Module_super_
+ self;
@end
@interface Module__tactivity_ : Module_super_
@end
@implementation Module__tactivity_
+ initialize
{
// initialize class id constants and link all classes into module
id_ActionGroup_test_c=[ActionGroup_test_c self];
id_ConcurrentGroup_test_c=[ConcurrentGroup_test_c self];

// return module object
return (id)_tactivity_;
}
@end
