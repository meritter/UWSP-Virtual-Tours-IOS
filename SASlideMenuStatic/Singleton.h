//
//  UWSP Virtual Tours
//  Singleton.h
//  Created by Jonathan Christian on 2/18/13.
//


@interface Singleton : NSObject
{
    NSMutableArray *locationsArray;
}


//Singleton holds the MapPack, MapMode, and all POI's stored in the XML as
//as a global access point

@property (atomic, retain) NSMutableArray * locationsArray;
@property (atomic, retain) NSString * selectedMapPack;
@property (atomic, retain) NSString * selectedMode;

+ (Singleton *)sharedSingleton;
@end