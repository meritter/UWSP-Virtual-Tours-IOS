//
//  Singleton.h
//  
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) UWSP GIS All rights reserved.
//


@interface Singleton : NSObject
{
    NSMutableArray *locationsArray;
}

@property (atomic, retain) NSMutableArray * locationsArray;
@property (atomic, retain) NSString * selectedMapPack;
@property (atomic, retain) NSString * selectedMode;

+ (Singleton *)sharedSingleton;
@end