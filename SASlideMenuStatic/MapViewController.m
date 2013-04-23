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
                                                                 zoom:15];
    
     //[mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveListener:) name:@"RemoveListener" object:nil];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.mapType = kGMSTypeHybrid;
    
    //Allows you to tap a marker and have camera pan to it
    mapView.delegate = self;


    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(10, 10, 40, 32);
    button.frame = frame;
    button.clipsToBounds = YES;
    [button setBackgroundColor:[UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1]];
    button.layer.cornerRadius = 5;//half of the width
    button.layer.borderColor=[UIColor blackColor].CGColor;
    button.layer.borderWidth=0.8f;
    button.center = CGPointMake(30, 396);
    [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            //5
            
            button.center = CGPointMake(30, 480);
        }else{
            //not 5
            //button.center = CGPointMake(30, 392);
        }
    }else{
       UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIDeviceOrientationPortrait) {
               button.center = CGPointMake(30, 930);
        }
        else{
                button.center = CGPointMake(30, 682);
        }
        //iPad
       
    }

    [self.view addSubview:button];
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
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // set up the iPad-specific view
         button.center = CGPointMake(30, 682);
        }
        else {
            
            titleView.font = [UIFont boldSystemFontOfSize:15];
            subtitleView.font = [UIFont boldSystemFontOfSize:9];
             }
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            titleView.font = [UIFont boldSystemFontOfSize:17];
            subtitleView.font = [UIFont boldSystemFontOfSize:12];
           //button.center = CGPointMake(275.0f, 80.0f);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
           button.center = CGPointMake(30, 930);
        }
        else {
             }
    }
}


-(IBAction)tapped:(id)sender
{
    [mapView animateToLocation:mapView.myLocation.coordinate];
    [mapView animateToBearing:0];
    [mapView animateToViewingAngle:0];
}


- (BOOL)mapView:(GMSMapView *)mapViewMethod didTapMarker:(id<GMSMarker>)marker {
    if (marker != mapViewMethod.selectedMarker) {
        // This marker is about to become the selected marker; animate to it.
        [mapView animateToLocation:marker.position];
        [mapView animateToBearing:0];
        [mapView animateToViewingAngle:0];
    }
    return NO;  // the GMSMapView should handle this event normally
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
        
        
       
        if (dist < 0.015 && count == 1)
        {
            NSString * discoveredLocationName = [NSString stringWithFormat:@"%s%@","Discovered ", poi.title];
            
            [DMRNotificationView showInView:self.view
                                      title:discoveredLocationName
                                   subTitle:@"Tap the camera button the right to see more"];
            
            poi.visited = true;
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


    
   /* if([[Singleton sharedSingleton].selectedMode isEqual: @"Free Roam Mode"])
    {
    for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        // NSMutableArray *array = [NSMutableArray arrayWithObjects:@"12.981902,80.266333",@"12.982902,80.266363", nil];
     
         CLLocationCoordinate2D pointsToUse[[[Singleton sharedSingleton].locationsArray count]];
     
         for (int i = 0; i < [[Singleton sharedSingleton].locationsArray count]; i++)
         {
             
            
             NSDictionary *tempObjectDict = [[Singleton sharedSingleton].locationsArray objectAtIndex:i];
         
             //Create and initialize a poi object
             Poi * poi = [[Poi alloc] init];
         
             //Assign based upon dictionary key value pairs
             poi.title = [tempObjectDict objectForKey:@"title"];
             poi.lat = [tempObjectDict objectForKey:@"lat"];
             poi.lon = [tempObjectDict objectForKey:@"long"];
    
             
             double lat = [poi.lat doubleValue];
             double longitude = [poi.lon doubleValue];
             
             //pointsToUse[i] = CLLocationCoordinate2DMake([
             CLLocationCoordinate2D newCoord = CLLocationCoordinate2DMake(lat, longitude);
            // [array removeObjectAtIndex:0];*/
     
         /*    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
             options.position = pointsToUse[i];
             [mapView animateToLocation:pointsToUse[i]];
             options.snippet = @"Test Text";
             options.icon =  [UIImage imageNamed:@"flag-green.png"];
             [mapView addMarkerWithOptions:options];
         }
     }
    }
    else
        {*/

    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    
    count = 1;
    [mapView clear];
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(poi.lat, poi.lon);
    options.title =  poi.title;
    options.snippet = poi.description;
    
    if(!poi.visited)
    {
    options.icon =  [UIImage imageNamed:@"flag.png"];
    }
    else{
        options.icon =  [UIImage imageNamed:@"flagGreen.png"];

    }
    [mapView addMarkerWithOptions:options];

    
    [mapView animateToLocation:options.position];
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
            
          /*  tempLocation = [[CLLocation alloc] initWithLatitude:44.531575 longitude:-89.569221];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"May Roach Hall"];
            [locationArray addObject:tempCoordinate];*/

            tempLocation = [[CLLocation alloc] initWithLatitude:tempPoi .lat longitude:tempPoi .lon];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:name];
            //tempCoordinate.inclination = 100;
            [locationArray addObject:tempCoordinate];

        
    }
    
    return locationArray;
}

    
-(void)locationClicked:(ARGeoCoordinate *)coordinate
{
         ImageViewController       * kivc = [[ImageViewController alloc] init];
        kivc.locationName = coordinate.title;
        //UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Root"];
    [self.navigationController pushViewController:kivc animated:YES];
  //  [self.navigationController  pushViewController:paralaxViewController  animated:YES];
}
        
   /*
    tempLocation = [[CLLocation alloc] initWithLatitude:44.525967 longitude:-89.568972];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"DUC"];
    tempCoordinate.inclination = 100;
    [locationArray addObject:tempCoordinate];    
    */


@end
