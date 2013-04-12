//
//  MapViewController.m
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) UWSP GIS All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Singleton.h"
#import "Poi.h"
#import "DMRNotificationView.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    ARViewController    * _arViewController;
    MapViewController * mvc;
    NSArray             *_mapPoints;
    GMSMapView *mapView;

}


@synthesize titleView, subtitleView, button, myLocation, poi;


- (void)loadView {

    double lat = [poi.lat doubleValue];
    double longitude = [poi.lon doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:longitude
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.mapType = kGMSTypeHybrid;
    
    //Allows you to tap a marker and have camera pan to it
    mapView.delegate = self;
    
    
    
   /* GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    //options.position = CLLocationCoordinate2DMake(longitude,lat);
    options.title =  poi.title;
    options.snippet = @"Test Text";
    options.icon =  [UIImage imageNamed:@"flag-red.png"];
    NSLog(poi.title);
    [mapView addMarkerWithOptions:options];*/
    
     

   /*     
    //NSLog(poi);
    
     //If Free Roam Mode
    /*for (Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
                         options.position = CLLocationCoordinate2DMake(lat,longitude);
        options.title =  poi.title;
        options.snippet = @"Test Text";
        //We can chnage icon colors here
        if(poi.visited == false)
        {
           options.icon =  [UIImage imageNamed:@"flag-green.png"];

        }*/

        
    /*NSMutableArray *array = [NSMutableArray arrayWithObjects:@"12.981902,80.266333",@"12.982902,80.266363", nil];
    
    CLLocationCoordinate2D pointsToUse[5];
    
    for (int i = 0; i < [array count]; i++)
    {
        pointsToUse[i] = CLLocationCoordinate2DMake([[[[array objectAtIndex:0]  componentsSeparatedByString:@","] objectAtIndex:0] floatValue],[[[[array objectAtIndex:0]  componentsSeparatedByString:@","] objectAtIndex:1] floatValue]);
        
        [array removeObjectAtIndex:0];
        
        GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
        options.position = pointsToUse[i];
        [mapView animateToLocation:pointsToUse[i]];
        [mapView addMarkerWithOptions:options];
    }*/
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}



#pragma mark - GMSMAPKitDelegate

//                      otherButtonTitles:nil] show];
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
    


-(IBAction)tapped:(id)sender
{
    
    [DMRNotificationView showInView:self.view
                              title:@"DUC Disovered"
                           subTitle:@"Tap the camera button the right to see more"];
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
[_arViewController setRadarRange:1.0];
 [_arViewController setOnlyShowItemsWithinRadarRange:YES];
 [self.navigationController pushViewController:_arViewController animated:YES];
 }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
    {
         // NSLog(@"Did update user location: %f,%f", mapView.myLocation.coordinate.latitude, mapView.myLocation.coordinate.longitude);
        
       // [mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude
                                                                                 //longitude:mapView.myLocation.coordinate.longitude
                                                                                   //   zoom:16]];
        
        
        
        CLLocation* ourUserLocation = [[CLLocation alloc]
                                       initWithLatitude:myLocation.coordinate.latitude
                                       longitude:myLocation.coordinate.longitude];
        CLLocation* loc= [[CLLocation alloc]
                                   initWithLatitude:44.528856
                                   longitude:-89.569766];
       // CLLocationDistance distance = [ourUserLocation distanceFromLocation:pinLocation] / 1000;
        
                
        //CLLocation *loc = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude];
        
       // NSLog(@"LOC  = %f, %f", loc.coordinate.latitude,  loc.coordinate.longitude);
        //NSLog(@"LOC2 = %f, %f", loc2.coordinate.latitude, loc2.coordinate.longitude);
        
        CLLocationDistance dist = [loc distanceFromLocation:loc2] / 1000;
        
        //CLLocationDistance kilometers = [newLocation distanceFromLocation:oldLocation] / 1000;
        
       // CLLocationCoordinate2D newCoordinate = [ourUserLocation coordinate];
       // CLLocationCoordinate2D oldCoordinate = [pinLocation coordinate];
        
        //CLLocationDistance kilometers = [newCoordinate distanceFromLocation:oldCoordinate] / 1000; // Error ocurring here.
       // CLLocationDistance meters = [newCoordinate distanceFromLocation:oldCoordinate]; // Error ocurring here.
        
        //CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate: distance altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        
        //42.081917,-50.031738
        //44.528856,-89.569766
        //SCI CORD
        if (dist < 0.01) {
            
            [DMRNotificationView showInView:self.view
                                      title:@"DUC Disovered"
                                   subTitle:@"Tap the camera button the right to see more"];

        
        }
        
         //for (int x = 0; x < [alertedForTag count]; x++) {
         
      /*(   if ([[alertedForTag objectAtIndex:x]isEqualToNumber:[NSNumber numberWithInt:i]]) {
         
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

        
        
       // if (myLocation) {
         //   <#statements#>
       // }
  }

}


- (void)viewWillAppear:(BOOL)animated{
    _arViewController = nil;
    
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
   
    
    double lat = [poi.lat doubleValue];
    double longitude = [poi.lon doubleValue];
    
   

    
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(longitude,lat);
     options.title =  poi.title;
     options.snippet = @"Test Text";
     options.icon =  [UIImage imageNamed:@"flag-red.png"];
     NSLog(poi.title);
     [mapView addMarkerWithOptions:options];
    
    
    [mapView animateToLocation:options.position];
    [mapView animateToBearing:0];
    [mapView animateToViewingAngle:0];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];   
    [mapView removeObserver:self forKeyPath:@"myLocation"];
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
    
    
    [Singleton sharedSingleton].locationsArray = locationArray;
    return [Singleton sharedSingleton].locationsArray;
}

-(void)locationClicked:(ARGeoCoordinate *)coordinate{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Root"];
    [self.navigationController pushViewController:controller animated:YES];

}


@end
