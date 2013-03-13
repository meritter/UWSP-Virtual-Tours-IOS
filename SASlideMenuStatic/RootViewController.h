//
//  RootViewController.h
//  xo-json
//
//  Created by haltink on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController :  UITableViewController<UITableViewDataSource, UITabBarControllerDelegate>
    
{

    NSArray *tableData;
    NSMutableArray * tours;
}

@property (nonatomic, retain) NSArray *tableData;


-(IBAction)editBtnClick;
- (void)parseJSONIOS5;
- (void)parseJSON;


@end
