//
//  Singleton.m
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) UWSP GIS All rights reserved.
//


#import "Singleton.h"

@implementation Singleton
@synthesize locationsArray;
@synthesize selectedMapPack;
@synthesize selectedMode;

static Singleton *sharedSingleton = nil;

+ (Singleton*)sharedSingleton
{
    if (sharedSingleton == nil) {
        sharedSingleton = [[super allocWithZone:NULL] init];
    }
    return sharedSingleton;
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

