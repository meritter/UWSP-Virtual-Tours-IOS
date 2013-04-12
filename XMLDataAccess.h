//
//  XMLDataAccess.h
//  UWSP Virtual Tours
//
//  Created by Jonathan Christian on 4/10/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//


@interface XMLDataAccess : NSObject


@property (nonatomic, strong) NSMutableArray * parsedMapPack;


-(void)setUpPOI:currentMapPack;

@end
