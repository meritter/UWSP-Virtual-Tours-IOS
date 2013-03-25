//
//  MapViewController.h
//
//  Created by Jonathan Christian on 2/18/13.
//  Copyright (c) UWSP GIS All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SASlideMenuRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "ARKit.h"
#import <GoogleMaps/GoogleMaps.h>


@interface MapViewController : UIViewController  <ARLocationDelegate, GMSMapViewDelegate>
{

    
}
/**
 * If My Location is enabled, reveals where the user location dot is being
 * drawn. If it is disabled, or it is enabled but no location data is available,
 * this will be nil.  This property is observable using KVO.
 */
@property (nonatomic, strong, readonly) CLLocation *myLocation;

/** Updates with the display 'split view controller' button. */
@property (nonatomic, retain) IBOutlet UILabel * titleView;
@property (nonatomic, retain) IBOutlet UILabel * subtitleView;
@property (nonatomic, retain) IBOutlet UIButton * button;
@property (nonatomic,strong) SASlideMenuViewController* menuViewController;
-(IBAction)revealUnderRight:(id)sender;



@end
