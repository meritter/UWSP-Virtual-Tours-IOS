//
//  AugmentedRealityController.h
//  AR Kit
//
//  Modified by Niels W Hansen on 12/31/11.
//  Modified by Ed Rackham (a1phanumeric) 2013
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Radar.h"
#import "RadarViewPortView.h"

@class ARCoordinate;

@interface AugmentedRealityController : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	
@private
	double	latestHeading;
	double  degreeRange;
	
	BOOL	debugMode;
   
    float	viewAngle;
	float   prevHeading;
    int     cameraOrientation;
    
	NSMutableArray              *coordinates;
    
    AVCaptureSession            *captureSession;
    AVCaptureVideoPreviewLayer  *previewLayer;
    
    UIAccelerometer             *accelerometerManager;
	CLLocation                  *centerLocation;
	UIView                      *displayView;
    UILabel                     *radarNorthLabel;
}

@property BOOL scaleViewsBasedOnDistance;
@property BOOL rotateViewsBasedOnPerspective;
@property BOOL debugMode;

@property double maximumScaleDistance;
@property double minimumScaleFactor;
@property double maximumRotationAngle;

@property (nonatomic, assign, setter = setShowsRadar:) BOOL showsRadar;
@property (nonatomic, assign, setter = setShowsSlider:) BOOL showsSlider;

@property (nonatomic, retain) UIAccelerometer           *accelerometerManager;
@property (nonatomic, retain) CLLocationManager         *locationManager;
@property (nonatomic, retain) ARCoordinate              *centerCoordinate;
@property (nonatomic, retain) CLLocation                *centerLocation;
@property (nonatomic, retain) UIView                    *displayView;
@property (nonatomic, retain) UIView                    *cameraView;
@property (nonatomic, retain) UIViewController          *rootViewController;
@property (nonatomic, retain) AVCaptureSession          *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;

@property (assign, nonatomic) BOOL                      onlyShowItemsWithinRadarRange;
@property (strong, nonatomic) Radar                     *radarView;
@property (strong, nonatomic) RadarViewPortView         *radarViewPort;
@property (assign, nonatomic) float                     radarRange;

@property (strong, nonatomic) UISlider                  *sliderView;

@property (nonatomic, weak) NSObject<UIAccelerometerDelegate> *accelerometerDelegate;

@property (nonatomic, assign) id<ARDelegate> delegate;

@property (nonatomic,retain) NSMutableArray		*coordinates;

@property (nonatomic, retain) UILabel                   *label;
@property (nonatomic, retain) UIButton                  *button;

- (id)initWithViewController:(UIViewController *)theView withDelgate:(id<ARDelegate>) aDelegate;

- (void) updateLocations;
- (void) stopListening;

// Adding coordinates to the underlying data model.
- (void)addCoordinate:(ARGeoCoordinate *)coordinate;

// Removing coordinates
- (void)removeCoordinate:(ARGeoCoordinate *)coordinate;
- (void)removeCoordinates:(NSArray *)coordinateArray;


@end
