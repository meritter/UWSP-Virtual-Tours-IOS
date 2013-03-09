//
//  TutorialViewController.h
//  UWSP Virtual Tours
//
//  Created by Jonathan Christian on 3/8/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
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