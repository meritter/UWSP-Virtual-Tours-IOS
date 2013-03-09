//
//  LightViewController.h
//  SASlideMenu
//
//  Created by Stefano Antonelli on 2/18/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASlideMenuRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "ARKit.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SVSegmentedControl.h"

@interface LightViewController : UIViewController  <ARLocationDelegate, GMSMapViewDelegate>
{

    
}

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;


/** Updates with the display 'split view controller' button. */

@property (nonatomic,strong) SASlideMenuViewController* menuViewController;

-(IBAction)tap:(id)sender;
-(IBAction)revealUnderRight:(id)sender;



@end
