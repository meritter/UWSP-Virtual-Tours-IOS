//
//  RootViewController.m
//  Created by haltink on 5/27/11.
//  Modified by Jonathan Christian 2/12/13
//  Copyright 2013. All rights reserved.
//

#import "RootViewController.h"

// if you use the generic parser, you need this one:
#import "XmlArrayParser.h"


@implementation RootViewController

@synthesize tableData;



- (void)viewDidLoad
{
                    
    [super viewDidLoad];
   
    users = [[NSMutableArray alloc] init];
    tours = [[NSMutableArray alloc] init];
   
    [tours addObject:@"Tour 2"];
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setToolbarHidden:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        [self parseJSONIOS5];
    else
        [self parseJSON];
    
    [super viewWillAppear:animated];

}

-(void) setToolbarITems: (NSArray *) toolbarItems animated: (BOOL) animated
{
    
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

    switch (indexPath.section) {
        case 0:
            [[cell textLabel] setText:[item objectForKey:@"name"]];
            [[cell detailTextLabel] setText:[item objectForKey:@"description"]];

            break;
        case 1:
            cell.textLabel.text  = [tours objectAtIndex:indexPath.row];
        default:
            break;
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
}
*/


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
        return @"Avaliable Tours";
    else
        return @"Downloaded Tours";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"Please download map pack"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
   // InitialSlidingViewController *detailViewController = [[InitialSlidingViewController alloc] initWithNibName:@"InitialSlidingViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
    //[detailViewController release];
	
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
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}



@end
