//
//  UWSP Virtual Tours
//  Poi.h
//  Created by Jonathan Christian on 2/18/13.
//

#import <UIKit/UIKit.h>



//Model holds necessary POI information for each location
@interface Poi : NSObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * description;
@property int poiId;
@property double lat;
@property double lon;
@property bool visited;

@end