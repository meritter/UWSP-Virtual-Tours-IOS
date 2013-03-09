//
//  Singleton.m
//  XML
//
//  Created by Jonathan Christian on 2/10/13.
//  Copyright (c) 2013 Jonathan Christian. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
@synthesize locationsArray;
//@synthesize SelectedMapPack;

//+ (Singleton *)sharedSingleton
/*{
    static Singleton *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[Singleton alloc] init];
            NSMutableArray *locationArray = [[NSMutableArray alloc] init];
        return sharedSingleton;
    }
}

@end*/


static Singleton *sharedSingleton = nil;

+ (Singleton*)sharedSingleton
{
    if (sharedSingleton == nil) {
        sharedSingleton = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        //sharedSingleton.locationsArray = nil;
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

