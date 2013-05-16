//  ImageViewController.m
//
//  Copyright (c) 2012 modocache
//  Edited by Jonathan Christian on 4/20/13.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "ImageViewController.h"
#import "MDCParallaxView.h"
#import "Poi.h"
#import "Singleton.h"

@interface ImageViewController () <UIScrollViewDelegate>

@end


@implementation ImageViewController

@synthesize locationName;


#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set this views title to our location name pulled from the previous controller
    self.title = locationName;
    
    //Create a POI pointer
    Poi * poi = [[Poi alloc] init];

    /* Foreach poi in our singleton
     * if our title matches a locationName
     * set the description of this views poi's description and set the ID
     */
    for (Poi * loopPoi in [Singleton sharedSingleton].locationsArray)
    {
        
        if([loopPoi.title isEqual:locationName])
        {
            poi.description = loopPoi.description;
            poi.poiId = loopPoi.poiId;
        }
        
    }

    //Here I build the image name from the loop above which contains ID 
    NSString * stringURL = [NSString stringWithFormat:@"%d-%d%@", poi.poiId, 0, @".png"];
    
    //We do a search in the Documents Directory for any image for example 12-0.png
    // The 12 is the location ID
    // The 0 is the image number  - I use 0 for right now for only 1 image
    // .png is the image type
    NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:stringURL];
  

    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    UIImage * backgroundImage = [[UIImage alloc] initWithData:imgData];

    CGRect backgroundRect = CGRectMake(0, 0, self.view.frame.size.width, backgroundImage.size.height);
    
    //This is a paralax view meaning the textbox moves along with the image The rest of the code sets this up
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
    backgroundImageView.image = backgroundImage;
    backgroundImageView.backgroundColor = [UIColor blackColor];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;

    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width, 400.0f);
    UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
    textView.backgroundColor = [UIColor blackColor];
    
    
    //Set the text to our poi's desceiption
    textView.text = poi.description;
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.backgroundColor = [UIColor darkTextColor];
    textView.textColor = [UIColor whiteColor];
    textView.scrollsToTop = NO;
    textView.editable = NO;

    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:backgroundImageView
                                                                     foregroundView:textView];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //IF device does not have or this specific Poi does not contain images - I set the height of the background to 10
    if ([stringURL  isEqual:@"0-0.png"]) {
         parallaxView.backgroundHeight = 10.0f;
    }
    else
    {
            parallaxView.backgroundHeight = 250.0f;
    }
    
    parallaxView.backgroundColor = [UIColor blackColor];
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    parallaxView.scrollView.scrollsToTop = YES;
    parallaxView.scrollViewDelegate = self;
    [self.view addSubview:parallaxView];
}

//Used to get the directory to the documents folder
-(NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
    
}

#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

@end
