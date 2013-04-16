//
//  LocationDetailsController.m
//  UWSP Virtual Tours
//
//  Created by Jonathan Christian on 4/15/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
//

#import "LocationDetailsController.h"



@interface LocationDetailsController()

@end



@implementation LocationDetailsController


@synthesize locationName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = locationName;
    NSLog(locationName);
    
}







@end
