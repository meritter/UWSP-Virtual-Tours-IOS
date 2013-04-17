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
#import "LocationDetailsController.h"
#import "GKLParallaxPicturesViewController.h"

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

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:poi.lat
                                                            longitude:poi.lon
                                                                 zoom:15];
    
    

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
        
        NSLog(poi.title);
               
        CLLocation * currentLocation = [[CLLocation alloc] initWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude];
        
       // NSLog(@"LOC  = %f, %f", loc.coordinate.latitude,  loc.coordinate.longitude);
        //NSLog(@"LOC2 = %f, %f", loc2.coordinate.latitude, loc2.coordinate.longitude);
        
        CLLocationDistance dist = [destinationLocation distanceFromLocation:currentLocation] / 1000;
        
        
        int count = 1;
        if (dist < 0.02 && count == 1) {
            
            [DMRNotificationView showInView:self.view
                                      title:@"DUC Disovered"
                                   subTitle:@"Tap the camera button the right to see more"];
            
            
            poi.visited = true;
            
            
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"MapPackChange" object:self];
            //set notificaiton to cycle points

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

    if(poi.visited == false)
    {
        NSLog(@"Set the observer for the map");
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    }
   
    

    
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
             /*poi.title = [tempObjectDict objectForKey:@"title"];
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
    
    
    [mapView clear];
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(poi.lat, poi.lon);
    options.title =  poi.title;
    options.snippet = poi.description;
    options.icon =  [UIImage imageNamed:@"flag-red.png"];
    [mapView addMarkerWithOptions:options];

    
    [mapView animateToLocation:options.position];
    [mapView animateToBearing:0];
    [mapView animateToViewingAngle:0];
    
    
        }


- (void)viewWillDisappear:(BOOL)animated
{
    
    [mapView removeObserver:self forKeyPath:@"myLocation"];
}



- (NSMutableArray *)geoLocations{
  
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation       *tempLocation;
    
    
    

    for (Poi * poi in [Singleton sharedSingleton].locationsArray)
        {

            NSString * name = poi.title;
            
          /*  tempLocation = [[CLLocation alloc] initWithLatitude:44.531575 longitude:-89.569221];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"May Roach Hall"];
            [locationArray addObject:tempCoordinate];*/

            tempLocation = [[CLLocation alloc] initWithLatitude:poi.lat longitude:poi.lon];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:name];
            //tempCoordinate.inclination = 100;
            [locationArray addObject:tempCoordinate];

        
    }
    
    return locationArray;
}

    
-(void)locationClicked:(ARGeoCoordinate *)coordinate
{
        
       LocationDetailsController * lvc = [[LocationDetailsController alloc] init];
        lvc.locationName = coordinate.title;
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Root"];
        [self.navigationController pushViewController:controller animated:YES];
        NSLog(@"%@", coordinate.title);
    //GKLParallaxPicturesViewController *paralaxViewController = [GKLParallaxPicturesViewController alloc];
    
      //UIView *testContentView = [[[UINib nibWithNibName:@"testContentView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
  //  GKLParallaxPicturesViewController *paralaxViewController = [[GKLParallaxPicturesViewController alloc] initWithImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"shovel"], //[UIImage imageNamed:@"shovel"], nil] andContentView:testContentView];

   //GKLParallaxPicturesViewController *paralaxViewController = [[GKLParallaxPicturesViewController alloc] init];    //	paralaxViewController.parallaxHeight = 150;
    //	paralaxViewController.contentScrollView.delegate = self;
    //self.viewController = paralaxViewController;
    //self.window.rootViewController = self.viewController;
    //[self.window makeKeyAndVisible];
    //[paralaxViewController addImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"shovel"], [UIImage imageNamed:@"shovel"], nil]];
  // [self.navigationController  pushViewController:paralaxViewController  animated:YES];
}
        
            
  /*  }
    for ( Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        NSLog(@"Poi:  %@", poi.title);
        NSLog(@"Poi:  %@", poi.description);
        
    }8/

    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.525967 longitude:-89.568972];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"DUC"];
    tempCoordinate.inclination = 100;
    [locationArray addObject:tempCoordinate];    
*/


@end
