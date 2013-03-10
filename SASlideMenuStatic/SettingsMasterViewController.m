//
//  SettingsMasterViewController.m
//  UWSP Virtual Tours
//
//  Created by Jonathan Christian on 3/6/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
//

#import "SettingsMasterViewController.h"
#import "Singleton.h"

@interface SettingsMasterViewController ()

@end

@implementation SettingsMasterViewController

@synthesize mapPackName;
@synthesize mapMode;

  

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
    
    mapPackName = [Singleton sharedSingleton].selectedMapPack;
    mapMode = [Singleton sharedSingleton].selectedMode;
       
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Put this here so whenever this method gets hit to reset tables it fires
    
   //  mapPackName =  [Singleton sharedSingleton].SelectedMapPack;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    if(mapPackName != nil)
                    {
                        [[cell detailTextLabel] setText:mapPackName];
                    }
                    else
                    {
                        [[cell detailTextLabel]  setText:@"Not Selected"];
                    }
                    break;
                          
        case 1:
            if(mapMode != nil)
            {
                [[cell detailTextLabel] setText:mapMode];
            }
            else
            {
                [[cell detailTextLabel]  setText:@"Not Selected"];
            }
            break;
    }

            break;
    
        default:
            break;
    }
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
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

#pragma mark - Table view delegate



@end
