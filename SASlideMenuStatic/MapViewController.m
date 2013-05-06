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


@synthesize titleView, subtitleView, button, myLocation, poi, count;


- (void)loadView {
    
    
  
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:poi.lat
                                                            longitude:poi.lon
                                                                 zoom:16];
    
     //[mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveListener:) name:@"RemoveListener" object:nil];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.mapType = kGMSTypeHybrid;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    //Allows you to tap a marker and have camera pan to it
    mapView.delegate = self;
    
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
    
    
    
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alert"]]){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"alert"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to UWSP Virtual Tours"  message: [NSString stringWithFormat: @"%C First Tap the left button at the top to view quests  \n %C Next tap the current Active Quest to view your first location on the map\n %C Repeat these steps for every location in the tour", (unichar) 0x2022, (unichar) 0x2022, (unichar) 0x2022]
                              delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//message:@"   Next tap the active quest to view your first location" 
        
        [alert show];
        
    }
}

- (void)RemoveListener:(NSNotification*)note {
    
    @try {
           [mapView removeObserver:self forKeyPath:@"myLocation"];
    }
    @catch (NSException *exception) {
          NSLog(@"Exception: %@", exception);
    }

}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustLabelsForOrientation:toInterfaceOrientation];
}


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

    
    /*
    [mapView animateToLocation:mapView.myLocation.coordinate];
    [mapView animateToBearing:0];
    [mapView animateToViewingAngle:0];
  */
}




- (IBAction)revealUnderRight:(id)sender
{
    //We want to push camera here
 if([ARKit deviceSupportsAR]){
 _arViewController = [[ARViewController alloc] initWithDelegate:self];
 _arViewController.showsCloseButton = false;
// [_arViewController setHidesBottomBarWhenPushed:YES];
[_arViewController setRadarRange:2.0];
 [_arViewController setOnlyShowItemsWithinRadarRange:YES];
 [self.navigationController pushViewController:_arViewController animated:YES];
 }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
    {
        CLLocation* destinationLocation = [[CLLocation alloc]  initWithLatitude:poi.lat longitude:poi.lon];
        
        NSLog(@"HIt observer for the location");
               
        CLLocation * currentLocation = [[CLLocation alloc] initWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude];
        CLLocationDistance dist = [destinationLocation distanceFromLocation:currentLocation] / 1000;
        
        
       
        if (dist < 0.012 && count == 1)
        {
            NSString * discoveredLocationName = [NSString stringWithFormat:@"%s%@","Discovered ", poi.title];
            
            [DMRNotificationView showInView:self.view
                                      title:discoveredLocationName
                                   subTitle:@"Tap the camera button the right to see more"];
            
           
            
             poi.visited = true;
             [self loadMap];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapPackChange" object:self];
            
            
           
            count++;
        }
    }

}


- (void)viewWillAppear:(BOOL)animated{
    _arViewController = nil;
    
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

    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    
    count = 1;
        
        [self loadMap];
    }
    
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


- (NSMutableArray *)geoLocations{
  
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation       *tempLocation;

    for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray)
    {
        NSString * name = tempPoi .title;
        tempLocation = [[CLLocation alloc] initWithLatitude:tempPoi .lat longitude:tempPoi .lon];
        tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:name];
        //tempCoordinate.inclination = 100;
        [locationArray addObject:tempCoordinate];

    }
    return locationArray;
}


-(void)locationClicked:(ARGeoCoordinate *)coordinate
{
    ImageViewController * kivc = [[ImageViewController alloc] init];
    kivc.locationName = coordinate.title;
    [self.navigationController pushViewController:kivc animated:YES];
}

@end
