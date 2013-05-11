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
}



- (void)viewWillAppear:(BOOL)animated
{
    mapPackName = [Singleton sharedSingleton].selectedMapPack;
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
            
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Having these two controllers here probably isn't the best to code but it works for now
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPacks"];
    UIViewController *controller2 = [self.storyboard instantiateViewControllerWithIdentifier:@"mapMode"];

        //depending on what is selected push a view controller 
        switch (indexPath.section) {
            case 0:
                [self.navigationController pushViewController:controller animated:YES];
                break;
            case 1:
                     [self.navigationController pushViewController:controller2 animated:YES];
                     break;
            
        }
}


@end
