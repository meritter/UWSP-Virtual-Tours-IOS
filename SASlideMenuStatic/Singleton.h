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

@property (nonatomic, retain) NSMutableArray * locationsArray;
@property (nonatomic, retain) NSString * selectedMapPack;
@property (nonatomic, retain) NSString * selectedMode;

+ (Singleton *)sharedSingleton;
@end