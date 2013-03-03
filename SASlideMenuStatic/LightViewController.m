//
//  LightViewController.m
//  SASlideMenu
//
//  Created by Stefano Antonelli on 2/18/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
//

#import "LightViewController.h"
#import "VBAnnotation.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LightViewController ()

@end

@implementation LightViewController
{
    ARViewController    * _arViewController;
    NSArray             *_mapPoints;
    GMSMapView *mapView;
}



- (void)loadView {

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:44.537923
                                                            longitude:-89.561448
                                                                 zoom:16];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.mapType = kGMSTypeHybrid;
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(44.537923, -89.561448);
    options.title = @"Point 1";
    options.snippet = @"Australia";
    [mapView addMarkerWithOptions:options];
}




-(IBAction)tap:(id)sender{
    [self.menuViewController selectContentAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] scrollPosition:UITableViewScrollPositionTop];
}



//@synthesize mapview;



/*-(IBAction)getLocation:(id)sender
{
    mapview.showsUserLocation=YES;
    
}*/


-(IBAction)getNoise:(id)sender
{
    NSString *title = [(UIBarButtonItem *)sender  title ];
    if ([title isEqualToString:@"Quest Mode"]){
        [self viewWillAppear];
        [sender setTitle:@"Free Roam Mode"];
    }
    else
    {
        [sender setTitle:@"Quest Mode"];
        
        //Run Quest Mode intilizations
    }
}

- (void)viewWillAppear
 {}

/*- (void)viewWillAppear
{
    
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    
    
    location.latitude = 44.537923;
    location.longitude = -89.561448;
    region.span = span;
    region.center = location;
    [mapview setRegion:region animated:YES];
    
    CLLocationCoordinate2D location2;
    location.latitude = 44.537923;
    location.longitude = -89.561448;
    VBAnnotation *ann = [[VBAnnotation alloc] initWithPosition:location2];
    [ann setCoordinate:location];
    ann.title = @"Test Point 1";
    ann.subtitle = @"Test Description";
    [mapview addAnnotation:ann];
    
    
    CLLocationCoordinate2D location3;
    location.latitude = 44.537927;
    location.longitude = -89.568449;
    VBAnnotation *ann2 = [[VBAnnotation alloc] initWithPosition:location3];
    [ann2 setCoordinate:location];
    ann2.title = @"Test Point 2";
    ann2.subtitle = @"Test Description";
    [mapview addAnnotation:ann2];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mapview.mapType=MKMapTypeSatellite;
    
    
    
}*/

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation = '%@'", userLocation);
    
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"Error parsing document!"
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


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    view.pinColor = MKPinAnnotationColorPurple;
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palmTree.png"]];
    view.leftCalloutAccessoryView = imageView;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}



- (IBAction)revealUnderRight:(id)sender
{
    //We want to push camera here
 //if([ARKit deviceSupportsAR]){
 _arViewController = [[ARViewController alloc] initWithDelegate:self];
 _arViewController.showsCloseButton = false;
 [_arViewController setHidesBottomBarWhenPushed:YES];
 [_arViewController setRadarRange:4000.0];
 [_arViewController setOnlyShowItemsWithinRadarRange:YES];
 [self.navigationController pushViewController:_arViewController animated:YES];
 //}
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
    tempCoordinate.inclination = M_PI/30;
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
    
    
    return locationArray;
}

-(void)locationClicked:(ARGeoCoordinate *)coordinate{
    // RootViewController *previewController = [[RootViewController alloc] init];
    // previewController.dataSource = self;
    // previewController.delegate = self;
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Root"];
    //controller.title = [[dao libraryItemAtIndex:indexPath.row] valueForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
    // start previewing the document at the current section index
    // previewController.currentPreviewItemIndex = indexPath.row;
    
    // [[self navigationController] pushViewController:previewController animated:YES];
}


@end
