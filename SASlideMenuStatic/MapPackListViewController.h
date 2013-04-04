//
//  MapPackListViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDUploadProgressView.h"
#import "Reachability.h"
#import "EGORefreshTableHeaderView.h"


@interface MapPackListViewController :  UITableViewController<EGORefreshTableHeaderDelegate, UITableViewDataSource, UITabBarControllerDelegate, WDUploadProgressDelegate>
    
{
    
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;

    NSArray *tableData;
    NSDictionary *item;

}  
@property (nonatomic, retain) Reachability * reach;
@property (nonatomic, retain) NSArray *tableData;
@property (assign, nonatomic) BOOL ascending;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
