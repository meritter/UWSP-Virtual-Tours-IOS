//
//  UWSP Virtual Tours
//  MapViewController.m
//  Created by Jonathan Christian on 2/18/13.
//


#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Singleton.h"
#import "Poi.h"
#import "DMRNotificationView.h"
#import "ImageViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController
{
    ARViewController    * _arViewController;
    MapViewController * mvc;
    NSArray             *_mapPoints;
    GMSMapView *mapView;

}


@synthesize titleView, subtitleView, button, myLocation, poi, discovered;


- (void)loadView {
    
    
  
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:poi.lat
                                                            longitude:poi.lon
                                                                 zoom:16];
    

    
    //Sets up the ability to remove the "myLocation" observer for GPS purposes see below in code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveListener:) name:@"RemoveListener" object:nil];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.mapType = kGMSTypeHybrid;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    //Allows you to tap a marker and have camera pan to it
    mapView.delegate = self;
    
    
    
    /* This is the button that can simulate a location being discovered
    button = [UIButton buttonWithType:UIButtonTypeCustom];

    CGRect frame = CGRectMake(10, 10, 60, 12);
    button.frame = frame;
    button.clipsToBounds = YES;
    [button setBackgroundColor:[UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1]];
    button.layer.cornerRadius = 5;//half of the width
    button.titleLabel.text = @"hello";
    button.center = CGPointMake(160, 406);
    [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    */
    
    
    [self setUpHeaderTitle];
    
    
    //If we are in free roam mode clear the map and load all markers
    if([[Singleton sharedSingleton].selectedMode isEqual: @"Free Roam Mode"])
    {
        [mapView clear];
        for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
        {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(tempPoi.lat, tempPoi.lon);
            GMSMarker * marker = [GMSMarker markerWithPosition:position];
            marker.title = tempPoi.title;
            marker.icon = [UIImage imageNamed:@"flag.png"];
            marker.snippet = tempPoi.description;
            marker.map = mapView;
            
            [mapView animateToLocation:position];
            [mapView animateToBearing:0];
            [mapView animateToViewingAngle:0];
        }
    }
    else
    {

    //else  in quest mode - on initial app load up show and alert to guide our user in doing quests
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alert"]]){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"alert"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to UWSP Virtual Tours"  message: [NSString stringWithFormat: @"%C First Tap the left button at the top to view quests  \n %C Next tap the current Active Quest to view your first location on the map\n %C Repeat these steps for every location in the tour", (unichar) 0x2022, (unichar) 0x2022, (unichar) 0x2022]
                              delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [alert show];
        }
        
    }
}


//Listen for a notification from QuestMenuViewController to remove our observer so we only keep one observer in play
- (void)RemoveListener:(NSNotification*)note {
    
    @try {
           [mapView removeObserver:self forKeyPath:@"myLocation"];
    }
    @catch (NSException *exception) {
          NSLog(@"Exception: %@", exception);
    }

}


//Handle orientation changes
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustLabelsForOrientation:toInterfaceOrientation];
}


//If we do change the orintation set the title and subtitles font appropiately 
- (void) adjustLabelsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
            titleView.font = [UIFont boldSystemFontOfSize:15];
            subtitleView.font = [UIFont boldSystemFontOfSize:9];
             
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
            titleView.font = [UIFont boldSystemFontOfSize:17];
            subtitleView.font = [UIFont boldSystemFontOfSize:12];
    }
}


/* This Logic is here if you want to simulate a location change with the button code above just uncomment this and the code above
 -(IBAction)tapped:(id)sender
{
    NSString * discoveredLocationName = [NSString stringWithFormat:@"%s%@","Discovered ", poi.title];
    
    [DMRNotificationView showInView:self.view
                              title:discoveredLocationName
                           subTitle:@"Tap the camera button the right to see more"];
    
    
    poi.visited = true;
  [self loadMap];
    //if(!poi.visited)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MapPackChange" object:self];
    }
    
 
    count++;
}*/


//Show the AR view 
- (IBAction)cameraButonTap:(id)sender
{
    //First check if AR is supported on device
 if([ARKit deviceSupportsAR]){
 _arViewController = [[ARViewController alloc] initWithDelegate:self];
 _arViewController.showsCloseButton = false;
     //Set radar range - currently set to 1km
 [_arViewController setRadarRange:1.0];
 [_arViewController setOnlyShowItemsWithinRadarRange:YES];
 [self.navigationController pushViewController:_arViewController animated:YES];
 }
}


//Observes the myLocation change when a user walks with GPS enabledå
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
    {
        
        //The destination location using the poi information passed from the questViewController upon prepareForSwitchToContentViewController method
        CLLocation* destinationLocation = [[CLLocation alloc]  initWithLatitude:poi.lat longitude:poi.lon];
        
        //Let us know we made it here
        NSLog(@"HIt observer for the location");
        
        //get our current location
        CLLocation * currentLocation = [[CLLocation alloc] initWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude];
        CLLocationDistance dist = [destinationLocation distanceFromLocation:currentLocation] / 1000;
        
        if (dist < 0.012 && !discovered)
        {
            NSString * discoveredLocationName = [NSString stringWithFormat:@"%s%@","Discovered ", poi.title];
            
            [DMRNotificationView showInView:self.view
                                      title:discoveredLocationName
                                   subTitle:@"Tap the camera button the right to see more"];
            
           
            //set location to visited
             poi.visited = true;
            
            //reload our map
             [self loadMap];
            
            //let the QuestModeViewController know we had a change and need to update the active quest
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapPackChange" object:self];
            
            
            //Change this location to discovered so this doesn't fire again
            discovered = true;
        }
    }

}


//set up our header to the Name of the app and the current Mode we are in  add and it to the view
- (void)setUpHeaderTitle
{
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = YES;

    CGRect titleFrame = CGRectMake(0, 2, 200, 24);
    titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:17];
    titleView.textAlignment = UITextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.shadowColor = [UIColor darkGrayColor];
    titleView.shadowOffset = CGSizeMake(0, -1);
    titleView.text = @"UWSP Virtual Tours";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];

    CGRect subtitleFrame = CGRectMake(0, 24, 200, 44-24);
    subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:12];
    subtitleView.textAlignment = UITextAlignmentCenter;
    subtitleView.textColor = [UIColor whiteColor];
    subtitleView.shadowColor = [UIColor darkGrayColor];
    subtitleView.shadowOffset = CGSizeMake(0, -1);
    subtitleView.text = [Singleton sharedSingleton].selectedMode;
    subtitleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:subtitleView];

    _headerTitleSubtitleView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                             UIViewAutoresizingFlexibleRightMargin |
                                             UIViewAutoresizingFlexibleTopMargin |
                                             UIViewAutoresizingFlexibleBottomMargin);

    self.navigationItem.titleView = _headerTitleSubtitleView;
}





- (void)viewWillAppear:(BOOL)animated{
    _arViewController = nil;
    
   
    [self setUpHeaderTitle];
    
    //Clear the map, load all markers 
    if([[Singleton sharedSingleton].selectedMode isEqual: @"Free Roam Mode"])
    {
        [mapView clear];
        for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
        {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(tempPoi.lat, tempPoi.lon);
            GMSMarker * marker = [GMSMarker markerWithPosition:position];
            marker.title = tempPoi.title;
            marker.icon = [UIImage imageNamed:@"flag.png"];
            marker.snippet = tempPoi.description;
            marker.tappable = YES;

            marker.map = mapView;
        
            [mapView animateToLocation:position];
            [mapView animateToBearing:0];
            [mapView animateToViewingAngle:0];
        }
    }
    
    else
    {

    //On each viewAppear I re-add the mylocation observer
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    
    discovered = false;
        
    [self loadMap];
    }
    
}

//If a user taps the white information window push the details controller and pass the title of the current poi
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    ImageViewController * kivc = [[ImageViewController alloc] init];
    kivc.locationName = marker.title;
    [self.navigationController pushViewController:kivc animated:YES];
}

-(void)loadMap
{
    [mapView clear];
    
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(poi.lat, poi.lon);
    GMSMarker * marker = [GMSMarker markerWithPosition:position];
    marker.title = poi.title;
    marker.snippet = poi.description;
    
    if(!poi.visited)
    {
        marker.icon = [UIImage imageNamed:@"flag.png"];
    }
    else
    {
        marker.icon =  [UIImage imageNamed:@"flagGreen.png"];
    }
    marker.map = mapView;
    
    
    [mapView animateToLocation:position];
    [mapView animateToBearing:0];
    [mapView animateToViewingAngle:0];


}

//Creates the locations for the augmented reality controller
- (NSMutableArray *)geoLocations{
  
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation       *tempLocation;

    //foreach poi in our singleton
    for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
    {
        //add the title, lat, and lon
        NSString * name = tempPoi .title;
        tempLocation = [[CLLocation alloc] initWithLatitude:tempPoi .lat longitude:tempPoi .lon];
        tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:name];
        //tempCoordinate.inclination = 100;
        [locationArray addObject:tempCoordinate];

    }
    return locationArray;
}

//If we click a location in the augmented reality controller push the details controller and pass the title of the coordinate poi
-(void)locationClicked:(ARGeoCoordinate *)coordinate
{
    ImageViewController * kivc = [[ImageViewController alloc] init];
    kivc.locationName = coordinate.title;
    [self.navigationController pushViewController:kivc animated:YES];
}

@end
