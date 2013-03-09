//
//  Singleton.h
//  XML
//
//  Created by Jonathan Christian on 2/10/13.
//  Copyright (c) 2013 Jonathan Christian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
/*
@interface Singleton : NSObject
{
    NSMutableArray *locationsArray;
}
@property (nonatomic, retain) NSMutableArray * locationsArray;
@property (nonatomic, retain) NSString * SelectedMapPack;

+ (Singleton *)sharedSingleton;
@end*/



@interface Singleton : NSObject
{
    NSMutableArray *locationsArray;
}

@property (nonatomic, retain) NSMutableArray * locationsArray;
@property (nonatomic, retain) NSString * selectedMapPack;


+ (Singleton *)sharedSingleton;
@end