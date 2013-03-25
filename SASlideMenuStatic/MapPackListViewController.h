//
//  MapPackListViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDUploadProgressView.h"
#import "Reachability.h"


@interface MapPackListViewController :  UITableViewController<UITableViewDataSource, UITabBarControllerDelegate, WDUploadProgressDelegate>
    
{

    NSArray *tableData;
    NSDictionary *item;

}  
@property (nonatomic, retain) Reachability * reach;
@property (nonatomic, retain) NSArray *tableData;
@property (assign, nonatomic) BOOL ascending;

@end
