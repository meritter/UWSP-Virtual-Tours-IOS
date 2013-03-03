//
//  UnderRightViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "UnderRightViewController.h"
#import "RootViewController.h"

@interface UnderRightViewController()
{
    ARViewController    * _arViewController;
    NSArray             *_mapPoints;
}
@property (nonatomic, assign) CGFloat peekLeftAmount;

@end

@implementation UnderRightViewController
@synthesize peekLeftAmount;




- (void)viewDidLoad
{
    
  [super viewDidLoad];
    _arViewController = [[ARViewController alloc] initWithDelegate:self];
    [_arViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    //[self presentViewController:_arViewController animated:YES completion:nil];
    
    
    
}


- (void)viewDidAppear:(BOOL)animated{
     _arViewController = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startAR:(id)sender {
    //if([ARKit deviceSupportsAR]){
    _arViewController = [[ARViewController alloc] initWithDelegate:self];
    //[_arViewController setShowsRadar:YES];
    //[_arViewController setRadarBackgroundColour:[UIColor blackColor]];
    //[_arViewController setRadarViewportColour:[UIColor darkGrayColor]];
    //[_arViewController setRadarPointColour:[UIColor whiteColor]];
    [_arViewController setRadarRange:4000.0];
    [_arViewController setOnlyShowItemsWithinRadarRange:YES];
    [_arViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:_arViewController animated:YES completion:nil];
    //}
}

- (IBAction)startARWithoutCloseButton:(id)sender {
    //if([ARKit deviceSupportsAR]){
    _arViewController = [[ARViewController alloc] initWithDelegate:self];
    _arViewController.showsCloseButton = false;
    [_arViewController setRadarRange:4000.0];
    [_arViewController setOnlyShowItemsWithinRadarRange:YES];
    [_arViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:_arViewController animated:YES completion:nil];
    //}
}

- (IBAction)startARNothing:(id)sender {
    //if([ARKit deviceSupportsAR]){
    _arViewController = [[ARViewController alloc] initWithDelegate:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [_arViewController setRadarRange:4000.0];
    [_arViewController setOnlyShowItemsWithinRadarRange:YES];
    [_arViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:_arViewController animated:YES completion:nil];
    //}
}

- (IBAction)startARNavBar:(id)sender {
    //if([ARKit deviceSupportsAR]){
    _arViewController = [[ARViewController alloc] initWithDelegate:self];
    _arViewController.showsCloseButton = false;
    [_arViewController setHidesBottomBarWhenPushed:YES];
    [_arViewController setRadarRange:4000.0];
    [_arViewController setOnlyShowItemsWithinRadarRange:YES];
    [self.navigationController pushViewController:_arViewController animated:YES];
    //}
}

- (IBAction)startAREverything:(id)sender {
    //if([ARKit deviceSupportsAR]){
    _arViewController = [[ARViewController alloc] initWithDelegate:self];
    _arViewController.showsCloseButton = false;
    [_arViewController setRadarRange:4000.0];
    [_arViewController setOnlyShowItemsWithinRadarRange:YES];
    [self.navigationController pushViewController:_arViewController animated:YES];
    //}
}


- (NSMutableArray *)geoLocations{
    
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation       *tempLocation;
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:44.525967 longitude:-89.568972];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"DUC"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:39.550051 longitude:-105.782067];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Denver"];
    [locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:45.523875 longitude:-122.670399];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Portland"];
    [locationArray addObject:tempCoordinate];
    
    return locationArray;
}
    

//Push information.. video
- (void)locationClicked:(ARGeoCoordinate *)coordinate{
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

