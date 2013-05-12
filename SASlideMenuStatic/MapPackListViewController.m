//
//  UWSP Virtual Tours
//  MapPackListViewController.m
//  Created by Jonathan Christian on 2/18/13.
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
    NSArray * searchResults;
    NSMutableArray  * serverMapPacks;
    NSMutableArray * localMapPacks;
    
}

@synthesize tableData, reach, searchBar, isFiltered, filteredTableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set search bar from outlet to self
    searchBar.delegate = (id)self;
    
    serverMapPacks = [[NSMutableArray alloc] init];
    localMapPacks = [[NSMutableArray alloc] init];
    
    //Set up refreshView
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
    
    //load the list with server and local map packs
    [self getMapPacksFromServer];
    [self getLocalMapPAcks];
 
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

//When table is reloaded get the local and server map packs
-(void) reloadTableData
{
    [self getMapPacksFromServer];
    [self getLocalMapPAcks];
    [self.tableView reloadData];
}


//Logic to add if reachability (data on/off) has changed
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


//parses xml of all tours on server gets id,description,lat,long,and name
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


//When the user enters a new character into the textbox we take the search bar and then text entered
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        
        //if Length is at least one character filtered=true and a predicate function checks the text
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        text];
        //Filteed table data array is then set from what is yielded from the predicate function of array items returned from the localMapPacks array
       filteredTableData = [localMapPacks filteredArrayUsingPredicate:resultPredicate];
    }
    
    [self.tableView reloadData];
}

//When the table is being filtered we change the table header accordinaly 
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


//Once again is it is being filtered - set the number of rows to the count
//else do the server and local map packs
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
    
    //If its filtered I do not show the details text label
    if(isFiltered)
    {

    cell.textLabel.text = [filteredTableData objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    else
    {
        //Else show the details label and title for server map packs
    switch (indexPath.section)
    {
        case 0:
           [[cell textLabel] setText:[item objectForKey:@"name"]];
           [[cell detailTextLabel] setText:[item objectForKey:@"description"]];
            break;
            
            //Local map packs only have a title
        case 1:
            cell.textLabel.text  = [localMapPacks objectAtIndex:indexPath.row];
            break;
        
        default:
            break;
            }
    }
        return cell;
    
}

// Return NO if you do not want the specified item to be editable I have set them all to NO for now
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return NO;
            break;
        case 1:
            return NO;
            break;
        default:
            return NO;
            break;
    }
       return NO;
}

//If you want to delete a map pack saved under localMapPacks -  uncomment this code and return YES under case 1 in canEditRowAtIndexPath above
//This function will get the name of the cell you are trying to delete and then remove it from the docuemnts folder
/*-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
    
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    NSString * index;
    XMLDataAccess * da = [[XMLDataAccess alloc] init];
    
    //If we have cellular data, we can set the item instance to an object of our serverMapPacks array
    if([reach isReachable])
    {
        item  = [serverMapPacks objectAtIndex:indexPath.row];
        //Set the index to the ID of the mapPack so we know what mapPack to download later
        index = [item objectForKey:@"id"];
    }
    
    if (isFiltered)
    {
         [Singleton sharedSingleton].selectedMapPack = cellText;
         [self.navigationController  popViewControllerAnimated:YES];
    }
    else
    {
    //For right now if the map pack is in the serverMapPack section (0), we download it
    switch (indexPath.section) {
        case 0:
            //send the title:cellText and index set above
            [self saveMapPack:cellText:index];
            //set the singletons selectedMapPAck to what the user selects
            [Singleton sharedSingleton].selectedMapPack = cellText;
            //Download the images associated to the MapPack
            [da downloadImagesOfMapPack:cellText];
            //Alert the users that we have downloaded the mapPack
            [ZAActivityBar showSuccessWithStatus:@"Downloaded Tour"];
            [self reloadTableData];
        break;
        case 1:
            //If the section is (1) localMapPacks we once again set the selectedMapPack to the singleton
            [Singleton sharedSingleton].selectedMapPack = cellText;
            
            //using the XMLDataAccess set up the app with the new mapPack selection
            XMLDataAccess * da = [[XMLDataAccess alloc] init];
            [da setUpPOI:  [Singleton sharedSingleton].selectedMapPack];
            
            //Send a notification that the mapPackChanged which reloads the questViewController with the new Tour data
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapPackChange" object:self];
            //push the controller
            [self.navigationController  popViewControllerAnimated:YES];
        break;
        }
    }
}


//Upon didSelectRowAtIndexPath method above this method gets the selected indexPath and the name of the mapPack
- (void)saveMapPack:(NSString *)packName :(NSString *)selectedIndexPath
{
    //get the index of the mapPack and create a URL
    NSString * stringURL = [NSString stringWithFormat:@"%s%@%@","http://uwsp-gis-tour-data-test.herokuapp.com/tours/", selectedIndexPath, @".xml"];
    
    //Encode our URL
    NSString* escapedUrlString = [stringURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSURL  *url = [NSURL URLWithString:escapedUrlString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    //Save the file in the docuemntsdirectory with the MapPack name as the filename
    if (urlData)
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory, packName, @".xml"];
        [urlData writeToFile:filePath atomically:YES];
    }
    
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTableData:nil];
    [super viewDidUnload];
}

@end