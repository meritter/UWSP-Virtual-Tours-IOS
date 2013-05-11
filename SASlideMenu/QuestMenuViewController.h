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
    NSMutableArray * visitedLocations;
    // Since this isn't a table view controller but a SASlideMenuViewController I have set up an outlet linking to my table in the Storyboard
    //The UITable is then refrenced here so I can call [myTableView ReloadTable] functions
    IBOutlet UITableView  *MyTableView;
    int indexCount;
}

@property (nonatomic, strong) Poi * poi;
@property (nonatomic, strong)  NSMutableArray * currentQuest;
@end
