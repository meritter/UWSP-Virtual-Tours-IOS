//
//  MapPackListViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "EGORefreshTableHeaderView.h"


@interface MapPackListViewController :  UITableViewController<EGORefreshTableHeaderDelegate, UITableViewDataSource, UITabBarControllerDelegate>
    
{
    

	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;

    NSArray *tableData;
    NSDictionary *item;

}
@property (strong, nonatomic) NSArray* filteredTableData;
@property (nonatomic, retain) Reachability * reach;
@property (nonatomic, retain) NSArray *tableData;
@property (assign, nonatomic) BOOL ascending;
@property (nonatomic, assign) bool isFiltered;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
