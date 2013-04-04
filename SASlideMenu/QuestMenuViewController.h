//
//  QuestMenuViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASlideMenuViewController.h"
#import "SASlideMenuDataSource.h"
#import "Poi.h"

@interface QuestMenuViewController :SASlideMenuViewController<SASlideMenuDataSource,SASlideMenuDelegate>
{
    NSMutableArray *users;
    NSMutableArray * tours;
}
@property (nonatomic, strong) Poi * poi;
@end
