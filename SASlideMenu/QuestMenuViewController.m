
//
//  UWSP Virtual Tours
//  QuestMenuViewController.m
//  Created by Jonathan Christian on 2/18/13.
//

#import <QuartzCore/QuartzCore.h>
#import "QuestMenuViewController.h"
#import "MapViewController.h"
#import "Singleton.h"
#import "Poi.h"

@interface QuestMenuViewController ()
@property (nonatomic, strong) NSMutableArray  * settings;

@end

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation QuestMenuViewController
{
    
}
@synthesize poi, currentQuest;

@synthesize settings;
-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        // Assign self to the slideMenuDataSource because self will implement SASlideMenuDatSource 
        self.slideMenuDataSource = self;
        self.slideMenuDelegate = self;
    }
    return self;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        // Assign self to the slideMenuDataSource because self will implement SASlideMenuDataSource
        self.slideMenuDataSource = self;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //Listen for notifications comming from MapPackListViewController for a mapModeChange and mapPackChange
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyOnMapModeChange:) name:@"MapModeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyOnMapPackChange:) name:@"MapPackChange" object:nil];

    settings = [[NSMutableArray alloc] init];
    visitedLocations = [[NSMutableArray alloc] init];
    currentQuest = [[NSMutableArray alloc] init];
    
    [settings addObject:@"Settings"];
    [settings addObject:@"Help"];
    [settings addObject:@"About"];
    
    
    if([[Singleton sharedSingleton].selectedMode isEqual:@"Free Roam Mode"])
    {
         [currentQuest removeAllObjects];
         [visitedLocations removeAllObjects];
        
    }
    else
    {
        //We only want one active quest so this flag will change
        bool hasActiveQuest = false;
        for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
        {
            //If a location has not be visited and the flag is still false
            if (!hasActiveQuest && !tempPoi.visited)
            {
                [currentQuest addObject:tempPoi];
                //set has Quest to true once an active Quest has been found under the conditions above
                hasActiveQuest = true;
            }
            //else if a location is visited show it under Completed Quests in the table
            else if(tempPoi.visited)
            {
                [visitedLocations addObject:tempPoi];
            }
        }
    
        //When app starts up and all visited locations are loaded with now current Quest- lets notify the person the tour is complete
        if ([currentQuest count] == 0 && [visitedLocations count] != 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tour Completed"
                                                       message:@"Start this tour again?"
                                                      delegate:self
                                                        cancelButtonTitle:@"No"
                                                        otherButtonTitles:@"Yes",nil];
            [alert show];
        }
    }
    
  

}


- (void)reloadTour
{
    //We only want one active quest so this flag will change 
    bool hasActiveQuest = false;
    for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
    {
        //If a location has not be visited and the flag is still false 
        if (!hasActiveQuest && !tempPoi.visited)
        {
            [currentQuest addObject:tempPoi];
            //set has Quest to true once an active Quest has been found under the conditions above
            hasActiveQuest = true;
        }
        //else if a location is visited show it under Completed Quests in the table
        else if(tempPoi.visited)
        {
            [visitedLocations addObject:tempPoi];
        }
    }
    [MyTableView reloadData];
}


//Listen for MapMode Change
- (void)NotifyOnMapModeChange:(NSNotification*)note {
    [currentQuest removeAllObjects];
    [visitedLocations removeAllObjects];
    
    if([[Singleton sharedSingleton].selectedMode isEqual:@"Quest Mode"])
    {
        //We only want one active quest so this flag will change
        bool hasActiveQuest = false;
        for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
        {
            //If a location has not be visited and the flag is still false
            if (!hasActiveQuest && !tempPoi.visited)
            {
                [currentQuest addObject:tempPoi];
                //set has Quest to true once an active Quest has been found under the conditions above
                hasActiveQuest = true;
            }
            //else if a location is visited show it under Completed Quests in the table
            else if(tempPoi.visited)
            {
                [visitedLocations addObject:tempPoi];
            }
        }
        //If we cant find any active Quest and the Completed Quest has at least 1 element
        //prompt the user of the Tour being complete
        if ([currentQuest count] == 0 && [visitedLocations count] != 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tour Completed"
                                                           message:@"Start this tour again?"
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes",nil];
            
            [alert show];
            
        }
    }
    else{
        
    }
    
    [MyTableView reloadData];
}

//Listen for MapPack Change
- (void)NotifyOnMapPackChange:(NSNotification*)note {
    [currentQuest removeAllObjects];
    [visitedLocations removeAllObjects];

    if([[Singleton sharedSingleton].selectedMode isEqual:@"Quest Mode"])
    {
        
        //We only want one active quest so this flag will change
        bool hasActiveQuest = false;
        for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
        {
            //If a location has not be visited and the flag is still false
            if (!hasActiveQuest && !tempPoi.visited)
            {
                [currentQuest addObject:tempPoi];
                //set has Quest to true once an active Quest has been found under the conditions above
                hasActiveQuest = true;
            }
            //else if a location is visited show it under Completed Quests in the table
            else if(tempPoi.visited)
            {
                [visitedLocations addObject:tempPoi];
            }
        }
        
        //If we cant find any active Quest and the Completed Quest has at least 1 element
        //prompt the user of the Tour being complete
       if ([currentQuest count] == 0 && [visitedLocations count] != 0)
       {
           
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tour Completed"
                                                       message:@"Start this tour again?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];

        [alert show];

       }
    }
       else{
           
       }

    [MyTableView reloadData];
}

//If the user said "Yes" to restart Tour
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //REMOVE ALL OBJECTS
    [currentQuest removeAllObjects];
    [visitedLocations removeAllObjects];

	// 1 = Tapped yes
    // Set all locations to visited = NO/False
	if (buttonIndex == 1)
	{
        for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
        {
            tempPoi.visited = false;
           
        }

	}
    
    //Reload the Tour
    [self reloadTour];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel* label = [[UILabel alloc] initWithFrame:(CGRect) { 10, 0, 75, 80 }];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textColor = [UIColor whiteColor];
    label.opaque = YES;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.5];
     UIView* view = [[UIView alloc] initWithFrame:(CGRect) { 0, 0, 75, 80 }];
    
    
    //Set up the Green color with text for active and completed quests
    if(section == 0)
    {
        label.text = @"Active Quest";
        label.backgroundColor = UIColorFromRGB(0X008080);
         view.backgroundColor = UIColorFromRGB(0X008080);
    }
    else if(section == 1)
    {
        label.text = @"Completed Quests";
        label.backgroundColor = UIColorFromRGB(0X008080);
         view.backgroundColor = UIColorFromRGB(0X008080);
    }
    
    //This is a blank section to provide room for settings, help, about etc.
    else
    {
        //I had an issues using the UIColorFromRGB here to get purple so I am using the traditional way
        label.backgroundColor = [UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1] ;
         view.backgroundColor = [UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1] ;
    }
    
   
    [view addSubview:label];
    view.opaque = YES;
    return view;
}



//Set up the number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [visitedLocations count];
            break;
        case 2:
            return [settings count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //Cell set up
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(133/255.0) green:(176/255.0) blue:(0/255.0) alpha:1] ;
    [cell setSelectedBackgroundView:bgColorView]; 
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    
    switch (indexPath.section) {
        case 0:
            //if the Array has 0 elements
            if([currentQuest count] == 0)
            {
                //Dont show an image and set the color to gray
                 cell.imageView.image = nil;
                 cell.textLabel.textColor = [UIColor grayColor];
                //Depending what mode we are in show what is appropiate
                 if([[Singleton sharedSingleton].selectedMode  isEqualToString:@"Free Roam Mode"])
                 {
                    cell.textLabel.text = @"In Free Roam Mode";
                 }
                 else
                 {
                     cell.textLabel.text = @"All Quests Completed";
                 }
            }
            //else if we have at lest 1 element
            else
            {
                //Set the poi to the current quest object
                poi = [currentQuest objectAtIndex:indexPath.row];
                //Show flag
                cell.imageView.image = [UIImage imageNamed:@"flag-white-larger.png"];
                cell.textLabel.text = poi.title;
            }
            break;
        
        case 1:
            //Make sure we have visited locations
            if([visitedLocations count] != 0)
            {
                //Set the poi to the current quest object
                poi = [visitedLocations  objectAtIndex:indexPath.row];
                cell.imageView.image = [UIImage imageNamed:@"flag-white-larger.png"];
                cell.textLabel.text = poi.title;
            }
           break;
        case 2:
            //set the titles of the other elements in settings
            cell.textLabel.text  = [settings objectAtIndex:indexPath.row];
            cell.imageView.image = nil;
            break;
        }
    
        return cell;
     
}


/*
 section 0 - Active Quest
 section 1 - Completed Quest
 When selection is made  - set the poi object pointer of this controller to the object the user selected
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0 && [currentQuest count]!= 0) {
        poi = [currentQuest objectAtIndex:indexPath.row];
       
    }
    else if (section==1 && [visitedLocations  count]!= 0){
        poi = [visitedLocations  objectAtIndex:indexPath.row];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}



#pragma mark -
#pragma mark SASlideMenuDataSource
// The SASlideMenuDataSource is used to provide the initial segueid that represents the initial visibile view controller and to provide eventual additional configuration to the menu button

// This is the indexPath selected at start-up
-(NSIndexPath*) selectedIndexPath{
    return 0;
}


-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath
{
    //If we dont have a mapPack (This would be the first run of the app) show tutorial view
    if([Singleton sharedSingleton].selectedMapPack == nil)
    {
        return @"tutorial";
    }
    
    //Else dirrect the user to the map
    else if (indexPath.section < 2) {
        return @"map";
    }
    
    //Or the other options
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            return @"settings";
        }else if (indexPath.row == 1){
            return @"help";
        }else if (indexPath.row == 2){
            return @"about";
        }
    }
    return 0;

   /*
    Note: Each view in MainStoryboard.storyboard has a viewcontroller named
    tutorial
    map
    settings
    help
    about
    
    and uses a "Slide menu content" special seque function to push view controllers
    */
    
}

//I dont use caching but it is an option I have seen no difference in app functionality
-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

//This disables the swipe between the controllers - I disable this because the map interferes with Gestures
-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


// This is used to configure the menu button on the left. The beahviour of the button should not be modified
-(void) configureMenuButton:(UIButton *)menuButton{
    menuButton.frame = CGRectMake(0, 0, 40, 29);
    [menuButton setImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu copy2.png"] forState:UIControlStateNormal]; 
    [menuButton setAdjustsImageWhenHighlighted:NO];
    [menuButton setAdjustsImageWhenDisabled:NO];
    
}

//This sets the visiblilty of the other controller when button is pressed
-(CGFloat) leftMenuVisibleWidth{
    return 280;
}


//When the user taps a item in the table we prepare to switch it
//I pass the poi of this current controller which is set above in the didSelectRowAtIndexPath method
//This is only set i quest mode
-(void) prepareForSwitchToContentViewController:(UINavigationController *)content{
    UIViewController* controller = [content.viewControllers objectAtIndex:0];
    if ([controller isKindOfClass:[MapViewController class]])
    {
        MapViewController* mapViewController = (MapViewController*)controller;
         if([[Singleton sharedSingleton].selectedMode isEqual:@"Quest Mode"])
         {
             mapViewController.poi =  poi;
         }
        
        mapViewController.menuViewController = self;
    }
}


//On a slide out of the map I remove the listener to track a users location to keep only one in memory
//It does throw an exception if I move to 'about' or 'help' controllers which is to be expected since its not a google map type
//I just log the exception and keep moving along
//The remove listener is in mapView it is an NSNotification called "RemoveListener"
-(void) slideMenuWillSlideToSide{
    @try {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveListener" object:self];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

@end
