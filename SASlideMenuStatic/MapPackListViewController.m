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
    // [self.tableView setHidden:YES];
    serverMapPacks = [[NSMutableArray alloc] init];
    localMapPacks = [[NSMutableArray alloc] init];
    myArray2 = [[NSMutableArray alloc] init];
    
    //TODO make for loop for map packs in downloads folder
    
    [self parseJSONIOS5];
    
    //TODO also show no cellular for offline access
    
    //Hide search bar in iOS 5
    
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   // NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:documentsPath];
    
    NSString *filename;
    

    
    
    while ((filename = [direnum nextObject] ))
    {
        
        if ([filename hasSuffix:@".xml"]) {   //change the suffix to what you are looking for
            //NSLog(@"log");
            
            NSUInteger lastCharIndex = [filename length] - 4; // I assume string is not empty
            NSRange rangeOfLastChar = [filename rangeOfComposedCharacterSequenceAtIndex: lastCharIndex];
            NSString * myNewString = [filename substringToIndex: rangeOfLastChar.location];
            [localMapPacks addObject:myNewString];
            
        }
        
    }
   
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
   
}


    
    
- (void)editBtnClick
{
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      //  SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] //delegate];
        //[controller removeObjectFromListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)parseJSONIOS5 {
    
    NSLog(@"hit parsing");
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
  //  NSString *filename = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"xml"];
   // NSData *data = [NSData dataWithContentsOfFile:filename];
    
    // create and init NSXMLParser object
    XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
    parser.rowElementName = @"tour";
    parser.elementNames = [NSArray arrayWithObjects:@"description", @"lat", @"long", @"name", nil];
    
     NSLog(@"fnished parsing");
    BOOL success = [parser parse];
    //If fails we need to check this here
    // test the result
    if (success)
    {
        serverMapPacks = [parser items];
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
    
    NSDictionary *item = [serverMapPacks objectAtIndex:[indexPath row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        switch (indexPath.section) {
            case 0:
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
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
    
   /* // Get item from tableData
    NSDictionary *item = [users objectAtIndex:[indexPath row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    // Set text on textLabel
    [[cell textLabel] setText:[item objectForKey:@"name"]];
    
    // [[cell textLabel] setText:[item objectForKey:@"name"]];
    // Set text on detailTextLabel
    [[cell detailTextLabel] setText:[item objectForKey:@"description"]];*/
    
    return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    
    
    //For right now if the map pack is in the serverMapPack, we download it
    switch (indexPath.section) {
        case 0:
            [self saveMapPack:cellText];
            break;
        case 1:

            break;
    }
    [Singleton sharedSingleton].selectedMapPack = cellText;
    [self.navigationController  popViewControllerAnimated:YES];
    
}



- (void)saveMapPack:(NSString *)packName
{
    
    //NSString *stringURL = [NSString stringWithFormat: @"http://uwsp-gis-tour-data-test.herokuapp.com/tours/" ,packName, @".xml"];
      // NSLog(stringURL);
    NSString * stringURL = [NSString stringWithFormat:@"%s%@%@","http://uwsp-gis-tour-data-test.herokuapp.com/tours/", packName, @".xml"];
   // NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours/First%20Tour.xml";
    NSLog(stringURL);
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
       // NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.xml"];
        
        NSString * filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory, packName, @".xml"];
        [urlData writeToFile:filePath atomically:YES];
         NSLog(filePath);
        
        //[self parseXMLFileAtURL: @"/Users/Jonathan/Library/Application Support/iPhone Simulator/6.1/Applications//580FD371-2C90-455E-BB1F-//C2BB6AE615AA/Documents/filename.xml"];
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