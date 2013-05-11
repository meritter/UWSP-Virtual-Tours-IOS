//
//  UWSP Virtual Tours
//  TutorialSecondViewController.h
//  Created by Jonathan Christian on 2/18/13.
//

#import <UIKit/UIKit.h>

@interface TutorialSecondViewController :UIViewController <UITableViewDataSource, UITabBarControllerDelegate>
{
    NSMutableArray * tourModeArray;
}

@property (nonatomic, strong) NSMutableArray  * tourModeArray;

@end