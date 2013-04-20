//
//  UWSP Virtual Tours
//  Singleton.m
//  Created by Jonathan Christian on 2/18/13.
//



#import "Singleton.h"

@implementation Singleton
@synthesize locationsArray;
@synthesize selectedMapPack;
@synthesize selectedMode;

static Singleton* sharedSingleton;

+ (Singleton*)sharedSingleton
{
    if (!sharedSingleton)
    {
        sharedSingleton = [[Singleton alloc] init];
    }
    return sharedSingleton;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        locationsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (sharedSingleton == nil)
		{
			sharedSingleton = [super allocWithZone:zone];
			return sharedSingleton;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end







