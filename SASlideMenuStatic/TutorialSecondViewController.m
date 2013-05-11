//
//  UWSP Virtual Tours
//  TutorialSecondViewController.m
//  Created by Jonathan Christian on 2/18/13.
//

#import "TutorialSecondViewController.h"
#import "Singleton.h"

@interface TutorialSecondViewController ()

@property(retain) NSIndexPath* lastIndexPath;
@end


@implementation TutorialSecondViewController

@synthesize tourModeArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tourModeArray = [[NSMutableArray alloc] init];
    [tourModeArray addObject:@"Quest Mode"];
    [tourModeArray addObject:@"Free Roam Mode"];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil )
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text  = [tourModeArray objectAtIndex:indexPath.row];
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// Logic if you select on button in the table set the mode to the singleton
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    
    [Singleton sharedSingleton].selectedMode = cellText;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.lastIndexPath = indexPath;
    
    [tableView reloadData];
}
@end