//
//  UWSP Virtual Tours
//  MapModeListViewController.m
//  Created by Jonathan Christian on 4/9/13.
//

#import "MapModeListViewController.h"
#import "Singleton.h"

@interface MapModeListViewController ()

@property(retain) NSIndexPath* lastIndexPath;

@end

int count = 1;

@implementation MapModeListViewController


@synthesize mapMode, modes;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    modes = [[NSMutableArray alloc] init];
    [modes addObject:@"Quest Mode"];
    [modes addObject:@"Free Roam Mode"];
    
    mapMode = [Singleton sharedSingleton].selectedMode;
}



- (void)viewWillAppear:(BOOL)animated
{
    count = 1;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        return @"Tour Mode";
}


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
    
    
    NSString *cellValue = [[self modes] objectAtIndex:indexPath.row];
    
    // configure the cell
    cell.textLabel.text = cellValue;
    UITableViewCellAccessoryType accessory = UITableViewCellAccessoryNone;
    
    //run this once - when page activates we want to show the selected map pack once
    if (count ==1)
    {
        if ([cellValue isEqualToString:mapMode])
        {
            accessory = UITableViewCellAccessoryCheckmark;
        }
        cell.accessoryType = accessory;
        
        }

    else
    {
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame )
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    }
    return cell;
}

// UITableView Delegate Method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    count = 0;
    [Singleton sharedSingleton].selectedMode = cellText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MapModeChange" object:self];

    self.lastIndexPath = indexPath;
    
    
    [tableView reloadData];
}

@end