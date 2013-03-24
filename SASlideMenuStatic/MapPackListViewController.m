//
//  MapPackListViewController..m
//  Created by haltink on 5/27/11.
//  Modified by Jonathan Christian 2/12/13
//  Copyright 2013. All rights reserved.
//

#import "MapPackListViewController.h"
#import "XmlArrayParser.h"
#import "SettingsMasterViewController.h"
#import "Singleton.h"
#import "DummyConnection.h"

@implementation MapPackListViewController
{
    NSArray *searchResults;
    NSMutableArray  * serverMapPacks;
    NSMutableArray * myArray2;
    NSMutableArray * localMapPacks;
}

@synthesize tableData;



- (void)viewDidLoad
{

    [super viewDidLoad];
    serverMapPacks = [[NSMutableArray alloc] init];
    localMapPacks = [[NSMutableArray alloc] init];
    myArray2 = [[NSMutableArray alloc] init];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    //refreshControl.tintColor = [UIColormagentaColor];
    //[refreshControl addTarget:sigaction:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    

    
    [self getMapPacksFromServer];
    
    [self getLocalMapPAcks];
    //TODO also show no cellular for offline access
    //Hide search bar in iOS
    //Handle updates for verison numbers
    //perhaps set the bar after map pack download
 
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
   
}




- (void)changeSorting
{
   /// NSSortDescriptor *sortDescriptor = [[NSSortDescriptor]alloc]
      //                                  initWithKey:nil ascending:self.ascending];
    
   // NSArray *sortDescriptors = @[sortDescriptor];
    [self getMapPacksFromServer];
    //_objects = [_objects sortedArrayUsingDescriptors:sortDescriptors];
    
    //_ascending = !_ascending;
     [self getLocalMapPAcks];
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];}

- (void)updateTable
{
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}



- (void)getMapPacksFromServer {
    
    NSLog(@"hit parsing");
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
  //  NSString *filename = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"xml"];
   // NSData *data = [NSData dataWithContentsOfFile:filename];
    
    // create and init NSXMLParser object
    XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
    parser.rowElementName = @"tour";
    parser.elementNames = [NSArray arrayWithObjects:@"id", @"description", @"lat", @"long", @"name", nil];
    
     NSLog(@"fnished parsing");
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                   predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];

    searchResults = [myArray2 filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                    selectedScopeButtonIndex]]];
    return YES;
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Tours Near You";
    else
        return @"Downloaded Tours";
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
        
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
       
    switch (section) {
        case 0:
            return [serverMapPacks count];
            break;
            case 1:
            return [localMapPacks count];
        default:
            break;
    }
    }
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
      item  = [serverMapPacks objectAtIndex:indexPath.row];
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
               
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        switch (indexPath.section)
        {
        case 0:
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        break;
        }
    }
    else
    {
    switch (indexPath.section) {
        case 0:
       
           [[cell textLabel] setText:[item objectForKey:@"name"]];
           [[cell detailTextLabel] setText:[item objectForKey:@"description"]];
           [myArray2 addObject:[item objectForKey:@"name"]];
            break;
        case 1:
            cell.textLabel.text  = [localMapPacks objectAtIndex:indexPath.row];
        default:
            break;
            }
    }
        return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
                return NO;
            break;
        case 1:
            return YES;
        default:
            break;
    }
    // Return NO if you do not want the specified item to be editable.

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
    //NSInteger selected = [tableView selectedRow];
    NSString *cellText = selectedCell.textLabel.text;
    //NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
   // NSTableCellView *selectedRow = [tableView viewAtColumn:0 row:sel makeIfNecessary:YES];
    
    //int rowIndex = indexPath.row + 1;

    
    NSString * index;
    item  = [serverMapPacks objectAtIndex:indexPath.row];
    index = [item objectForKey:@"id"];
    
    //For right now if the map pack is in the serverMapPack, we download it
    switch (indexPath.section) {
        case 0:
            [self showUploadView:cellText];
            [self saveMapPack:cellText:index];
        break;
        case 1:
            //
                [self.navigationController  popViewControllerAnimated:YES];
            break;
    }
    [Singleton sharedSingleton].selectedMapPack = cellText;
 
    
}


- (void)showUploadView: selectedMapPack {
	WDUploadProgressView *progressView = [[WDUploadProgressView alloc] initWithTableView:self.tableView cancelButton:YES];
	progressView.delegate = self;
	
	// Add Here an image to show
	//[progressView setPhotoImage:[UIImage imageNamed:@"flower"]];
	  NSString * stringURL = [NSString stringWithFormat:@"%s%@%@","Downloading ", selectedMapPack, @"..."];
	// Additionally you can set the message at any time (Default: Uploading...)
	[progressView setUploadMessage:stringURL];
	
	// You can customize the progress tint color
    //	[progressView setProgressTintColor:[UIColor whiteColor]];
	
	// Additionally you can customize the progress track color
    //	[progressView setProgressTrackColor:[UIColor darkGrayColor]];
	
	
	// Insert your connection library that will deal with the upload
	// and set the progress view as a delegate
	DummyConnection *connection = [[DummyConnection alloc] initWithDelegate:progressView];
	
	
}


- (void)uploadDidFinish:(WDUploadProgressView *)progressView {
	[progressView removeFromSuperview];
	[self.tableView setTableHeaderView:nil];
       [self.navigationController  popViewControllerAnimated:YES];
}

- (void)uploadDidCancel:(WDUploadProgressView *)progressView {
	[progressView removeFromSuperview];
	[self.tableView setTableHeaderView:nil];
}



- (void)saveMapPack:(NSString *)packName :(NSString *)selectedIndexPath
{
    //NSString * index;
     //item  = [serverMapPacks objectAtIndex:selectedIndexPath];
     // index = [item objectForKey:@"id"];
    
    NSString * stringURL = [NSString stringWithFormat:@"%s%@%@","http://uwsp-gis-tour-data-test.herokuapp.com/tours/", selectedIndexPath, @".xml"];

    //Encode our String
    NSString* escapedUrlString = [stringURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
    NSURL  *url = [NSURL URLWithString:escapedUrlString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    
    if (urlData)
    {
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
       // NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.xml"];
        
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
    [self setTableData:nil];
    //We dont want the array to keep duplicates of the items in it
    myArray2 = nil;
    [super viewDidUnload];

}

@end