//
//  UWSP Virtual Tours
//  TutorialFirstViewController.h
//  Created by Jonathan Christian on 2/18/13.
//
#import <UIKit/UIKit.h>

@interface TutorialFirstViewController : UIViewController <UITableViewDelegate, UITabBarControllerDelegate>
{    
    //Create table because we are using a UIView but inheriting from UITableViewDelegate
    IBOutlet UITableView  *MyTableView;
}

//Holds the mapPack Name
@property NSString * mapPackName;

@end