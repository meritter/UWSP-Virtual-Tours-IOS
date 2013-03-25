//
//  MapViewController.m
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) UWSP GIS All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Singleton.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    ARViewController    * _arViewController;
    MapViewController * mvc;
    NSArray             *_mapPoints;
    GMSMapView *mapView;

}

@synthesize titleView, subtitleView, button, myLocation;


- (void)loadView {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:44.537923
                                                            longitude:-89.561448
                                                                 zoom:8];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.mapType = kGMSTypeHybrid;
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(44.537923, -89.561448);
    options.title = @"Point 1";
    options.snippet = @"Test Text";
    
    //We can chnage icon colors here
    options.icon =  [UIImage imageNamed:@"locate.png"];
    [mapView addMarkerWithOptions:options];
    
    
       
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(10, 10, 40, 32);
    button.frame = frame;
    button.clipsToBounds = YES;
    [button setBackgroundColor:[UIColor colorWithRed:(60/255.0) green:(6/255.0) blue:(94/255.0) alpha:1]];
    button.layer.cornerRadius = 5;//half of the width
    button.layer.borderColor=[UIColor blackColor].CGColor;
    button.layer.borderWidth=0.8f;
    button.center = CGPointMake(30, 392);
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
        //iPad
            button.center = CGPointMake(30, 930);
    }
    
    
   
    [self.view addSubview:button];
    
    

    
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

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustLabelsForOrientation:toInterfaceOrientation];
}


- (void) adjustLabelsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // set up the iPad-specific view
         button.center = CGPointMake(30, 680);
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



#pragma mark - MKMapKitDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
   // NSLog(@"didUpdateUserLocation = '%@'", userLocation);
    NSLog(@"Did update user location: %f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"hit"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    //CYCLE THROUGH PLACES ARRAY
    /*for (int i = 0; i < [placesArray count]; i++) {
     
     //GET 2 POINTS AND CALCULATE DISTANCE
     CLLocation* ourUserLocation = [[CLLocation alloc]
     initWithLatitude:userLocation.coordinate.latitude
     longitude:userLocation.coordinate.latitude];
     CLLocation* pinLocation = [[CLLocation alloc]
     initWithLatitude:[[[placesArray objectAtIndex:i]objectForKey:@"latitude"]floatValue]
     longitude:[[[placesArray objectAtIndex:i]objectForKey:@"latitude"]floatValue]];
     CLLocationDistance distance = [ourUserLocation distanceFromLocation:pinLocation];
     
     */
    
    /*if (distance < 100) {
     
     for (int x = 0; x < [alertedForTag count]; x++) {
     
     if ([[alertedForTag objectAtIndex:x]isEqualToNumber:[NSNumber numberWithInt:i]]) {
     
     } else {
     [self showAlertWithDictionary:[placesArray objectAtIndex:i]];
     [alertedForTag addObject:[NSNumber numberWithInt:i]];
     }
     }
     
     
     if ([alertedForTag count]==0) {
     
     [self showAlertWithDictionary:[placesArray objectAtIndex:i]];
     //  [alertedForTag addObject:[NSNumber numberWithInt:i]];
     }
     }*/
    
}

-(IBAction)tapped:(id)sender
{
    NSLog(@"hit");

    //mapView.
    
   // mapView.showsUserLocation = !mapView.showsUserLocation;
}



-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"Will start loading map");
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"Did finish loading map");
}

-(void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Will start locating user");
}

-(void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Did stop locating user");
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"Did fail loading map");
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied){
        NSLog(@"User refused location services");
    } else {
        NSLog(@"Did fail to locate user with error: %@", error.description);
    }
}


- (IBAction)revealUnderRight:(id)sender
{
    //We want to push camera here
 if([ARKit deviceSupportsAR]){
 _arViewController = [[ARViewController alloc] initWithDelegate:self];
 _arViewController.showsCloseButton = false;
// [_arViewController setHidesBottomBarWhenPushed:YES];
[_arViewController setRadarRange:1.0];
 [_arViewController setOnlyShowItemsWithinRadarRange:YES];
 [self.navigationController pushViewController:_arViewController animated:YES];
 }
}


- (void)viewDidAppear:(BOOL)animated{
    _arViewController = nil;
}

- (NSMutableArray *)geoLocations{
  
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation       *tempLocation;
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.525967 longitude:-89.568972];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"DUC"];
    tempCoordinate.inclination = 100;
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.532252 longitude:-89.568738];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Suites"];
    tempCoordinate.inclination = M_PI/10;
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.531575 longitude:-89.569221];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"May Roach Hall"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.528103 longitude:-89.570632];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Science Building SW"];
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.528631 longitude:-89.570771];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Science Building SE"];
    tempCoordinate.inclination = 200;
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude: 44.527762 longitude:-89.570187];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Science Building NW"];
    tempCoordinate.inclination = M_PI/40;
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.527782 longitude:-89.57068];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Science Building NW"];
    tempCoordinate.inclination = M_PI/100;
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.528611 longitude:-89.570305];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Hardees"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:48.856667 longitude:2.350987];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Paris"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:55.676294 longitude:12.568116];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Copenhagen"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:52.373801 longitude:4.890935];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Amsterdam"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:19.611544 longitude:-155.665283];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Hawaii"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:40.756054 longitude:-73.986951];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"New York City"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:42.35892 longitude:-71.05781];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Boston"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:49.817492 longitude:15.472962];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Czech Republic"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:53.41291 longitude:-8.24389];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Ireland"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:38.892091 longitude:-77.024055];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Washington, DC"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:45.545447 longitude:-73.639076];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Montreal"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:32.78 longitude:-117.15];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"San Diego"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:-40.900557 longitude:174.885971];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Munich"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:33.5033333 longitude:-117.126611];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Temecula"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:19.26 longitude:-99.8];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Mexico City"];
    [locationArray addObject:tempCoordinate];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:53.566667 longitude:-113.516667];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Edmonton"];
    tempCoordinate.inclination = 0.5;
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:50.458061 longitude:-3.597078];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Marldon"];
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:50.528717 longitude:-3.606691];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Newton Abbot"];
    [locationArray addObject:tempCoordinate];
    
    [Singleton sharedSingleton].locationsArray = locationArray;
    return [Singleton sharedSingleton].locationsArray;
}

-(void)locationClicked:(ARGeoCoordinate *)coordinate{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Root"];
    [self.navigationController pushViewController:controller animated:YES];

}


@end
