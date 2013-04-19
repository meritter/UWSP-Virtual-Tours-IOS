//
//  QuestMenuViewController.m
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
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

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyOnMapModeChange:) name:@"MapModeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyOnMapPackChange:) name:@"MapPackChange" object:nil];

    settings = [[NSMutableArray alloc] init];
    visitedLocations = [[NSMutableArray alloc] init];
    currentQuest = [[NSMutableArray alloc] init];
  
    //[tours addObject:@"Place Holder 1"];
    
    [settings addObject:@"Settings"];
    [settings addObject:@"About"];
    
   /* for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        [users addObject:poi];
    }*/
    
    int i = 1;
    for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        
        if(poi.visited)
        {
            [visitedLocations addObject:poi];
        }
        else if (i == 1 && poi.visited == false)
        {
            [currentQuest addObject:poi];
            i++;
        }
        
    }
    
  

}



- (void)NotifyOnMapPackChange:(NSNotification*)note {
     [currentQuest removeAllObjects];
     [visitedLocations removeAllObjects];

    
    int i = 1;
    for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        
        if(poi.visited)
        {
            [visitedLocations addObject:poi];
        }
        else if (i == 1 && poi.visited == false)
        {
            [currentQuest addObject:poi];
            i++;
        }
        
    }

    [MyTableView reloadData];
  /*
    [visitedLocations removeAllObjects];
    
    for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        
        if(poi.visited)
        {
            [visitedLocations addObject:poi];
        }
        else if (i == 1)
        {
            [currentQuest addObject:poi];
            i++;
        }
        
    }
    [MyTableView reloadData];*/
}




- (void)NotifyOnMapModeChange:(NSNotification*)note {
    
    if([[Singleton sharedSingleton].selectedMode isEqual:@"Free Roam Mode"])
    {
       // [users removeAllObjects];
       // [tours removeAllObjects];
        
    }
    [MyTableView reloadData];
}

- (void)awakeFromNib
{
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //We want 2 columns for completed/active, show user nothing in free roam mode
    //return self.menuItems.count;
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
    else
    {
        label.backgroundColor = [UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1] ;
         view.backgroundColor = [UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1] ;
    }
    
   
    [view addSubview:label];
    view.opaque = YES;
    return view;
}




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
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(133/255.0) green:(176/255.0) blue:(0/255.0) alpha:1] ;
    [cell setSelectedBackgroundView:bgColorView]; 
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
     //item  = [serverMapPacks objectAtIndex:indexPath.row];
 
    switch (indexPath.section) {
        case 0:
            
            if([currentQuest count] == 0)
            {
                   cell.textLabel.text = @"All Quests Completed";
            }
            else
            {
                poi = [currentQuest objectAtIndex:indexPath.row];
                cell.imageView.image = [UIImage imageNamed:@"flag-white-larger.png"];
                cell.textLabel.text = poi.title;
            }
            break;
        case 1:
            if([visitedLocations count] != 0)
            {
                poi = [visitedLocations  objectAtIndex:indexPath.row];
                 cell.imageView.image = [UIImage imageNamed:@"flag-white-larger.png"];
                cell.textLabel.text = poi.title;
            }

           break;
        case 2:
            cell.textLabel.text  = [settings objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
        return cell;
     
}

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
    return [NSIndexPath indexPathForRow:0 inSection:0];
}



-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath{
    
    
    if([Singleton sharedSingleton].selectedMapPack == nil)
    {
        return @"tutorial";
    }
    else if (indexPath.section < 2) {
        return @"map";
    }
    
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            return @"settings";
            
        }else if (indexPath.row == 1){
            return @"about";
        }
    }
    return 0;

   
}

-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//TODO configure disabled state icon
// This is used to configure the menu button. The beahviour of the button should not be modified
-(void) configureMenuButton:(UIButton *)menuButton{
    menuButton.frame = CGRectMake(0, 0, 40, 29);
    [menuButton setImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu copy2.png"] forState:UIControlStateNormal]; 
    [menuButton setAdjustsImageWhenHighlighted:NO];
    [menuButton setAdjustsImageWhenDisabled:NO];
    
}

-(CGFloat) leftMenuVisibleWidth{
    return 280;
}

-(void) prepareForSwitchToContentViewController:(UINavigationController *)content{
    UIViewController* controller = [content.viewControllers objectAtIndex:0];
    if ([controller isKindOfClass:[MapViewController class]])
    {
        MapViewController* mapViewController = (MapViewController*)controller;
        mapViewController.poi =  poi;
        mapViewController.menuViewController = self;
    }
}





-(void) slideMenuDidSlideIn{
    NSLog(@"slideMenuDidSlideIn");
}
-(void) slideMenuWillSlideToSide{
    NSLog(@"slideMenuWillSlideToSide");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveListener" object:self];
    //Here
}

@end
