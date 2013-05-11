//
//  UWSP Virtual Tours
//  MapViewController.h
//  Created by Jonathan Christian on 2/18/13.
//



#import <UIKit/UIKit.h>
#import "SASlideMenuRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "ARKit.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Poi.h"


@interface MapViewController : UIViewController  <ARLocationDelegate, GMSMapViewDelegate>
{

    
}
/**
 * If My Location is enabled, reveals where the user location dot is being
 * drawn. If it is disabled, or it is enabled but no location data is available,
 * this will be nil.  This property is observable using KVO.
 */
@property (nonatomic, strong, readonly) CLLocation *myLocation;
@property(nonatomic, retain) Poi * poi;
@property int count;
/** Updates with the display 'split view controller' button. */
@property (nonatomic, retain) IBOutlet UILabel * titleView;
@property (nonatomic, retain) IBOutlet UILabel * subtitleView;
@property (nonatomic, retain) IBOutlet UIButton * button;
@property (nonatomic,strong) SASlideMenuViewController* menuViewController;
-(IBAction)cameraButonTap:(id)sender;



@end
