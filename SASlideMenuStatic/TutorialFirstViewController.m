//
//  UWSP Virtual Tours
//  TutorialFirstViewController.m
//  Created by Jonathan Christian on 2/18/13.
//


#import "TutorialFirstViewController.h"
#import "Singleton.h"

@interface TutorialFirstViewController ()

@end

@implementation TutorialFirstViewController

@synthesize mapPackName;


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void) viewDidAppear:(BOOL)animated
{
    [MyTableView reloadData];
    //Disable navigation item on left side
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if([Singleton sharedSingleton].selectedMapPack != nil)
    {
        //Enable right side navigation button when map pack is selected
        mapPackName = [Singleton sharedSingleton].selectedMapPack;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//Cell set up
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.5];
    [[cell  textLabel]  setText:@"No Tour Selected"];
    
    return cell;
}


//Since there is a  single button just push the MapPackListController with storyboard ID of "mapPacks"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPacks"];
    [self.navigationController pushViewController:controller animated:YES];
}

//If mapPack name from singleton is not nil - show selected map pack, else prompt user that one has not been selected
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(mapPackName != nil)
    {
      [[cell textLabel] setText:mapPackName];
    }
    else
    {
      [[cell  textLabel]  setText:@"No Tour Selected"];
    }
}


        



@end


