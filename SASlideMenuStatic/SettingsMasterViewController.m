//
//  UWSP Virtual Tours
//  SettingsMasterViewController.m
//  Created by Jonathan Christian on 2/27/13.
//

#import "SettingsMasterViewController.h"
#import "Singleton.h"
#import "MapModeListViewController.h"
#import "MapPackListViewController.h"

@interface SettingsMasterViewController ()

@end

@implementation SettingsMasterViewController


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
    
    mapMode = [Singleton sharedSingleton].selectedMode;
}



- (void)viewWillAppear:(BOOL)animated
{
    
    mapMode = [Singleton sharedSingleton].selectedMode;
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
    switch (indexPath.section) {
                     
                case 0:
                    if(mapMode != nil)
                    {
                        [[cell detailTextLabel] setText:mapMode];
                    }
                    else
                    {
                        [[cell detailTextLabel]  setText:@"Not Selected"];
                    }       
                    break;
            
   
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *controller2 = [self.storyboard instantiateViewControllerWithIdentifier:@"mapMode"];

        //Push mapMode view controller
        switch (indexPath.section) {
            case 0:
                [self.navigationController pushViewController:controller2 animated:YES];
                break;

        }
}


@end
