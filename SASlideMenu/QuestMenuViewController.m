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
@synthesize poi;

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

    settings = [[NSMutableArray alloc] init];
    users = [[NSMutableArray alloc] init];
    tours = [[NSMutableArray alloc] init];
  
    [tours addObject:@"Place Holder 1"];
    
    [settings addObject:@"Settings"];
    [settings addObject:@"About"];

    for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        [users addObject:poi];
    }
    
    
       
    
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
            return [tours count];
            break;
        case 1:
            return [users count];
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
          cell.textLabel.text  = [tours objectAtIndex:indexPath.row];
            break;
        case 1:
        {
            poi = [users objectAtIndex:indexPath.row];
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
#pragma mark -
#pragma mark SASlideMenuDataSource
// The SASlideMenuDataSource is used to provide the initial segueid that represents the initial visibile view controller and to provide eventual additional configuration to the menu button

// This is the indexPath selected at start-up
-(NSIndexPath*) selectedIndexPath{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath
{
    @try {
    if([Singleton sharedSingleton].selectedMapPack == nil)
    {
        return @"tutorial";
    }
    else
    {
      
            switch (indexPath.section) {
                case 0:
                   /* if([Singleton sharedSingleton].selectedMapPack != nil)
                    {
                        poi = [users objectAtIndex:indexPath.row];
                    }*/
                    return @"map";
                    break;
                case 1:
                    /*if([Singleton sharedSingleton].selectedMapPack != nil)
                    {
                        poi = [users objectAtIndex:indexPath.row];
                    }*/
                    return @"map";
                    break;
                case 2:
                    if (indexPath.row == 0) {
                        return @"settings";
                        
                    }else if (indexPath.row == 1){
                        return @"about";
                    }
                    break;

             }
    }
        
    }
          @catch (NSException *exception) {
              NSLog(@"Hit exception");
          }
          @finally {
              
          }

    
    
    return 0;

}

-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
   // if (indexPath.row ==0) {
      //  return YES;
   //}
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
    if ([controller isKindOfClass:[MapViewController class]]) {
        MapViewController* mapViewController = (MapViewController*)controller;
        mapViewController.poi =  poi;
        mapViewController.menuViewController = self;
    }
}

@end
