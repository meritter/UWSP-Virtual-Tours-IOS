//
//  TutorialSecondViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import "TutorialSecondViewController.h"
#import "Singleton.h"

@interface TutorialSecondViewController ()


@property (nonatomic, strong) NSMutableArray  * settings;
@property(retain) NSIndexPath* lastIndexPath;
@end


@implementation TutorialSecondViewController

@synthesize settings;

- (void)awakeFromNib
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    users = [[NSMutableArray alloc] init];
    [users addObject:@"Quest Mode"];
    [users addObject:@"Free Roam Mode"];
    
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
    
    cell.textLabel.text  = [users objectAtIndex:indexPath.row];
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

// UITableView Delegate Method
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