//
//  TutorialViewController.m
//  UWSP Virtual Tours
//
//  Created by Jonathan Christian on 3/8/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
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
    
    users = [[NSMutableArray alloc] init];
    [users addObject:@"Select Map Map"];
}


- (void) viewDidAppear:(BOOL)animated
{
    
    [ MyTableView reloadData];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if([Singleton sharedSingleton].selectedMapPack != nil)
    {
        mapPackName = [Singleton sharedSingleton].selectedMapPack;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
      
    }
    else
    {
        
        
       
    }
}



- (void)viewWillAppear:(BOOL)animated
{
  
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //We want 2 columns for completed/active, show user nothing in free roam mode
    //return self.menuItems.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [users count];
            break;

        default:
            break;
    }
}

//have not played much with this yet





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    
    // NSDictionary *item = [users objectAtIndex:[indexPath row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.5];
    switch (indexPath.section) {
        case 0:
            // [[cell textLabel] setText:[item objectForKey:@"name"]];
            // [[cell detailTextLabel] setText:[item objectForKey:@"description"]];
            cell.textLabel.text  = [users objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier;
    
    switch (indexPath.section) {
        case 0:
            NSLog(@"Hit at 0");
            //identifier =  @"FirstTop";
            
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPacks"];
            [self.navigationController pushViewController:controller animated:YES];
            // [[cell textLabel] setText:[item objectForKey:@"name"]];
            // [[cell detailTextLabel] setText:[item objectForKey:@"description"]];
            //cell.textLabel.text  = [users objectAtIndex:indexPath.row];
            break;
        }
    
    
 
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    if(mapPackName != nil)
                    {
                        [[cell textLabel] setText:mapPackName];
                    }
                    else
                    {
                        [[cell  textLabel]  setText:@"Map Pack Not Selected"];
                    }
                    break;
            }
            break;
            
        default:
            break;
    }
}


@end


