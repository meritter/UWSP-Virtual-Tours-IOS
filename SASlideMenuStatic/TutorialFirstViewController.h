//
//  TutorialFirstViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialFirstViewController : UIViewController <UITableViewDelegate, UITabBarControllerDelegate>
{
    
    NSMutableArray *users;
    NSMutableArray * tours;
    IBOutlet UITableView  *MyTableView;
    
    
}

//@property IBOutlet UITableView * tableView;



@property NSString * mapPackName;

@end