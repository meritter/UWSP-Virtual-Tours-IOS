//
//  RootViewController.m
//  Created by haltink on 5/27/11.
//  Modified by Jonathan Christian 2/12/13
//  Copyright 2013. All rights reserved.
//

#import "RootViewController.h"

// if you use the generic parser, you need this one:
#import "XmlArrayParser.h"
#import "SettingsMasterViewController.h"
#import "Singleton.h"

@implementation RootViewController
{
     NSArray *searchResults;
    NSMutableArray  * users;
    NSMutableArray * myArray2;
      NSMutableArray  * filtered;
    
    
}

@synthesize tableData;



- (void)viewDidLoad
{
   //  myArray2 = [NSArray arrayWithObjects:@"foo",@"bar",@"baz",nil];
    // [self.navigationController setToolbarHidden:YES];
    [super viewDidLoad];
    //[self.navigationController setToolbarHidden:YES  animated:YES];
    users = [[NSMutableArray alloc] init];
    tours = [[NSMutableArray alloc] init];
 myArray2 = [[NSMutableArray alloc] init];
    [tours addObject:@"UWSP Campus Tour"];
    
    
    
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
    // [self.navigationController setToolbarHidden:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        [self parseJSONIOS5];
    else
        [self parseJSON];
    
    [super viewWillAppear:animated];

}

    
    
- (void)editBtnClick

       {
       }

/*
           if(self.editing)
               
           {
               
               [super setEditing:NO animated:NO];
               
               [Table setEditing:NO animated:NO];
               
               [Table reloadData];
               
               [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
               
               [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
               
           }
           
           else
               
           {
               
               [super setEditing:YES animated:YES];
               
               [Table setEditing:YES animated:YES];
               
               [Table reloadData];
               
               [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
               
               [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
               
           }
           
       }
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      //  SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] //delegate];
        //[controller removeObjectFromListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


//This bloody works
/*- (IBAction)startXMLTransfer:(id)sender;
{
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.xml"];
        [urlData writeToFile:filePath atomically:YES];
        // NSLog(filePath);
        
        [self parseXMLFileAtURL: @"/Users/Jonathan/Library/Application Support/iPhone Simulator/6.1/Applications//580FD371-2C90-455E-BB1F-C2BB6AE615AA/Documents/filename.xml"];
    }
    
}*/

//save xml into filename
/*- (IBAction)startXMLTransfer:(id)sender;
{
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.xml"];
        [urlData writeToFile:filePath atomically:YES];
        // NSLog(filePath);
        
        [self parseXMLFileAtURL: @"/Users/Jonathan/Library/Application Support/iPhone Simulator/6.1/Applications//580FD371-2C90-455E-BB1F-C2BB6AE615AA/Documents/filename.xml"];
    }
    
}*/


- (void)parseJSONIOS5 {
    
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
  //  NSString *filename = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"xml"];
   // NSData *data = [NSData dataWithContentsOfFile:filename];
    
    // create and init NSXMLParser object
    XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
    parser.rowElementName = @"tour";
    parser.elementNames = [NSArray arrayWithObjects:@"created-at", @"description", @"id", @"lat", @"long", @"name", nil];
    
    
    BOOL success = [parser parse];
    
    // test the result
    if (success)
    {
        users = [parser items];
        
        
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                   predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    
    
    
   // searchResults = [users filteredArrayUsingPredicate:resultPredicate];
    //return filtered;
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
            return [users count];
            break;
            case 1:
            return [tours count];
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
    
    NSDictionary *item = [users objectAtIndex:[indexPath row]];
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
            cell.textLabel.text  = [tours objectAtIndex:indexPath.row];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}*/



/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Tours Near You";
    else
        return @"Downloaded Tours";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;

    [Singleton sharedSingleton].selectedMapPack = cellText;
    
    NSLog([Singleton sharedSingleton].selectedMapPack);
    [self.navigationController  popViewControllerAnimated:YES];
    
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
    myArray2 = nil;
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end