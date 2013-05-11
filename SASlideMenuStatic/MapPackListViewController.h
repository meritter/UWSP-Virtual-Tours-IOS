//
//  UWSP Virtual Tours
//  MapPackListViewController.h
//  Created by Jonathan Christian on 2/18/13.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "EGORefreshTableHeaderView.h"


@interface MapPackListViewController :  UITableViewController<EGORefreshTableHeaderDelegate, UITableViewDataSource, UITabBarControllerDelegate>
    
{
    

	EGORefreshTableHeaderView *_refreshHeaderView;
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
