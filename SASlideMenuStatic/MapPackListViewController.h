//
//  RootViewController.h
//  xo-json
//
//  Created by haltink on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDUploadProgressView.h"

@interface MapPackListViewController :  UITableViewController<UITableViewDataSource, UITabBarControllerDelegate, WDUploadProgressDelegate>
    
{

    NSArray *tableData;
    NSDictionary *item;

}

@property (nonatomic, retain) NSArray *tableData;
@property (assign, nonatomic) BOOL ascending;

-(IBAction)editBtnClick;
- (void)parseJSONIOS5;
- (void)parseJSON;


@end
