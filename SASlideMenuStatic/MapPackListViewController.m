//
//  MapPackListViewController.m
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import "MapPackListViewController.h"
#import "XmlArrayParser.h"
#import "SettingsMasterViewController.h"
#import "Singleton.h"
#import "Reachability.h"
#import "XMLDataAccess.h"
#import "QuestMenuViewController.h"
#import "ZAActivityBar.h"


@implementation MapPackListViewController
{
    NSArray *searchResults;
    NSMutableArray  * serverMapPacks;
    NSMutableArray * localMapPacks;
    
}


@synthesize tableData, reach;
@synthesize searchBar;
@synthesize isFiltered;
@synthesize filteredTableData;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchBar.delegate = (id)self;
    
    serverMapPacks = [[NSMutableArray alloc] init];
    localMapPacks = [[NSMutableArray alloc] init];
    
    
       //     [ZAActivityBar showWithStatus:@"Checking for Updates..."];

    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                   });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
       
        });
    };
    
    [reach startNotifier];
    [self getMapPacksFromServer];
    [self getLocalMapPAcks];
    //Hide search bar in iOS
    //Handle updates for verison numbers Check for them
    //perhaps set the bar after map pack download but that can picky points later...
    
 
}




#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableData];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


-(void) reloadTableData
{
    [self getMapPacksFromServer];
    [self getLocalMapPAcks];
    [self.tableView reloadData];
}


-(void)reachabilityChanged:(NSNotification*)note
{
        //TODO make the pull unavliable in offline mode
    if([reach isReachable])
    {//
      //  notificationLabel.text = @"Notification Says Reachable";
    }
    else
    {
       // notificationLabel.text = @"Notification Says Unreachable";
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
   
}



- (void)getMapPacksFromServer {
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // create and init NSXMLParser object
    XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
    parser.rowElementName = @"tour";
    parser.elementNames = [NSArray arrayWithObjects:@"id", @"description", @"lat", @"long", @"name", nil];
    
    BOOL success = [parser parse];
    //If fails we need to check this here
    // test the result
    if (success)
    {
        serverMapPacks = [parser items];
    }
}


- (void)getLocalMapPAcks
{
    
    if(localMapPacks != nil)
    {
        [localMapPacks removeAllObjects];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:basePath];
    NSString *filename;


    //loop for map packs in downloads folder loads into array for UI
    while ((filename = [direnum nextObject] ))
    {
        //Look for .xml
        if ([filename hasSuffix:@".xml"])
        {
            // I assume string is not empty and remove .xml extension for UI
            NSUInteger lastCharIndex = [filename length] - 4;
            NSRange rangeOfLastChar = [filename rangeOfComposedCharacterSequenceAtIndex: lastCharIndex];
            NSString * myNewString = [filename substringToIndex: rangeOfLastChar.location];
            [localMapPacks addObject:myNewString];
        }
    }
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        text];
        
       filteredTableData = [localMapPacks filteredArrayUsingPredicate:resultPredicate];
    }
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if(section == 0 && !isFiltered)
        return @"Tours Near You";
    else
        return @"Downloaded Tours";
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isFiltered) {
        return 1;
        
    } else {
        return 2;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(self.isFiltered)
    {
        rowCount = filteredTableData.count;
    }
    else
        switch (section)
    {
        case 0:
            return [serverMapPacks count];
            break;
        case 1:
            return [localMapPacks count];
            break;
        default:
            break;
    }
    
    return rowCount;
}





// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    }
    
    
    //iOS 5 having issues here index 2 beyond bounds [0 .. 1]
    //Added try catch and catching exception.
    @try {
            if([reach isReachable])
             {
            item  = [serverMapPacks objectAtIndex:indexPath.row];
             }
     
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
               
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    

    if(isFiltered)
    {

    cell.textLabel.text = [filteredTableData objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    else
    {
    switch (indexPath.section)
    {
        case 0:
           [[cell textLabel] setText:[item objectForKey:@"name"]];
           [[cell detailTextLabel] setText:[item objectForKey:@"description"]];
            break;
        case 1:
            cell.textLabel.text  = [localMapPacks objectAtIndex:indexPath.row];
            break;
        
        default:
            break;
            }
    }
        return cell;
    
}

// Return NO if you do not want the specified item to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return NO;
            break;
        case 1:
            return YES;
            break;
        default:
            return NO;
            break;
    }
       return NO;
}







-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {            
        NSString * name =  [localMapPacks objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        
        NSString * stringURL = [NSString stringWithFormat:@"%@%@", name, @".xml"];
        // Delete the file using NSFileManager
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[documentsDirectoryPath stringByAppendingPathComponent:stringURL] error:nil];
        
    }
        [localMapPacks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    
     
     [self getLocalMapPAcks];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    NSString * index;
    XMLDataAccess * da = [[XMLDataAccess alloc] init];
    if([reach isReachable])
    {
    item  = [serverMapPacks objectAtIndex:indexPath.row];
    index = [item objectForKey:@"id"];
    }
    
    if (isFiltered) {
         [Singleton sharedSingleton].selectedMapPack = cellText;
         [self.navigationController  popViewControllerAnimated:YES];
    } else {
    
    //For right now if the map pack is in the serverMapPack, we download it
    switch (indexPath.section) {
        case 0:
               //[ZAActivityBar showWithStatus:@"Downloading Map Pack"];
           // [self showUploadView:cellText];
            [self saveMapPack:cellText:index];
            

             [Singleton sharedSingleton].selectedMapPack = cellText;
            [da downloadImagesOfMapPack:cellText];
         //   ownloadImagesOfMapPack:currentMapPack
        
            // make async
            [ZAActivityBar showSuccessWithStatus:@"Downloaded Map Pack"];
            [self reloadTableData];
        break;
        case 1:
             [Singleton sharedSingleton].selectedMapPack = cellText;
            
            XMLDataAccess * da = [[XMLDataAccess alloc] init];
            
            [da setUpPOI:  [Singleton sharedSingleton].selectedMapPack];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapPackChange" object:self];
          
                  [self.navigationController  popViewControllerAnimated:YES];
            
                        break;
        }
    }
}



- (void)saveMapPack:(NSString *)packName :(NSString *)selectedIndexPath
{
    NSString * stringURL = [NSString stringWithFormat:@"%s%@%@","http://uwsp-gis-tour-data-test.herokuapp.com/tours/", selectedIndexPath, @".xml"];
    
    //Encode our String
    NSString* escapedUrlString = [stringURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSURL  *url = [NSURL URLWithString:escapedUrlString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    
    if (urlData)
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory, packName, @".xml"];
        [urlData writeToFile:filePath atomically:YES];
    }
    
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    
    [self setSearchBar:nil];

    [self setTableData:nil];
    [super viewDidUnload];
}

@end