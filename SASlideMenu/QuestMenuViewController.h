//
//  UWSP Virtual Tours
//  QuestMenuViewController.h
//  Created by Jonathan Christian on 2/18/13.
//

#import <UIKit/UIKit.h>
#import "SASlideMenuViewController.h"
#import "SASlideMenuDataSource.h"
#import "Poi.h"

@interface QuestMenuViewController :SASlideMenuViewController<SASlideMenuDataSource,SASlideMenuDelegate, UITableViewDelegate>
{
   // NSMutableArray *users;
    NSMutableArray * visitedLocations;
    int indexCount;
    IBOutlet UITableView  *MyTableView;
}

@property (nonatomic, strong) Poi * poi;
@property (nonatomic, strong)  NSMutableArray * currentQuest;
@end
