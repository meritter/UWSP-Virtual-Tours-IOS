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
#import <AVFoundation/AVFoundation.h>
#import "XmlArrayParser.h"
#import "XMLDataAccess.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL wrap;

@end


@implementation ImageViewController

@synthesize wrap;
@synthesize locationName;
@synthesize mediaList;
@synthesize mediaIndex;
@synthesize videoCount;
@synthesize mediaView;

#pragma mark - UIViewController Overrides

//***************************//
// horizontal scroll view viewDidLoad
//***************************//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mediaIndex = 0;
    self.videoCount = 0;
    NSMutableArray *parsedMapPack = [[NSMutableArray alloc] init];
    
    //Create a POI pointer
    Poi * poi = [[Poi alloc] init];
    
    //Foreach poi in our singleton
    //if our title matches a locationName
    //set the description of this views poi's description and set the ID
    for (Poi * loopPoi in [Singleton sharedSingleton].locationsArray)
    {
        
        if([loopPoi.title isEqual:locationName])
        {
            poi.description = loopPoi.description;
            poi.poiId = loopPoi.poiId;
        }
        
    }
    
    //parse XML
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"Schmeeckle" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    XmlArrayParser *videoParser = [[XmlArrayParser alloc] initWithData:xmlData];
    XmlArrayParser *imageParser = [[XmlArrayParser alloc] initWithData:xmlData];
    
    NSMutableArray *mediaListArray = [[NSMutableArray alloc] init];
    
    videoParser.rowElementName = @"video";
    videoParser.elementNames = [NSArray arrayWithObjects: @"url", @"poi-id", nil];
    imageParser.rowElementName = @"image";
    imageParser.elementNames = [NSArray arrayWithObjects: @"url", @"poi-id", nil];
    
    [videoParser parse];
    [imageParser parse];
    
    //check each video to see if it belongs to the current POI
    for (int i = 0; i < videoParser.items.count; i++)
    {
        NSDictionary *tempObjectDict = videoParser.items[i];
        int tempID = [[tempObjectDict objectForKey:@"poi-id"] integerValue];
        if (tempID == poi.poiId)
        {
            mediaListArray[mediaIndex] = [tempObjectDict objectForKey:@"url"];
            mediaIndex++;
            videoCount++;
        }
    }
    
    
    //check each image to see if it belongs to the current POI
    for (int i = 0; i < imageParser.items.count; i++)
    {
        NSDictionary *tempObjectDict = imageParser.items[i];
        int tempID = [[tempObjectDict objectForKey:@"poi-id"] integerValue];
        if (tempID == poi.poiId)
        {
            mediaListArray[mediaIndex] = [tempObjectDict objectForKey:@"url"];
            mediaIndex++;
        }
    }
    
    
    self.mediaList = mediaListArray;
    CGRect backgroundRect = CGRectMake(0, 0, 171.0f, 250.0f);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(backgroundRect)];
    scrollView.autoresizesSubviews = NO;
    
    //loadMedia
    for (int i = 0; i < mediaList.count; i++)
    {
        self.mediaIndex = i;
        [self loadMedia];
        [scrollView addSubview:mediaView];
    }
    int test = (mediaIndex * 350) + 325;
    scrollView.contentSize = CGSizeMake(test, 0);
    
    //creates and audioSession so that you can guarantee that audio will play for a video
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
    
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
    
    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:scrollView
                                                                     foregroundView:textView];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    parallaxView.backgroundHeight = 250.0f;
    
    parallaxView.backgroundColor = [UIColor blackColor];
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    parallaxView.scrollView.scrollsToTop = YES;
    parallaxView.scrollViewDelegate = self;
    [self.view addSubview:parallaxView];
}

- (void) loadMedia
{
    //if it is a video else it is an image
    if (self.mediaIndex < self.videoCount)
    {
        int contentOffset = (self.mediaIndex * 350);
        //load iframe media
        NSString *videoURL = self.mediaList[self.mediaIndex];
        CGRect backgroundRect = CGRectMake(contentOffset, 0, 325.0f, 250.0f);
        UIWebView *webView = [[UIWebView alloc] initWithFrame:(backgroundRect)];
        
        NSString *embedHTML = @"<html><head><style type=\"text/css\">iframe {position:absolute; top:50%%; margin-top:-130px;}body {background-color:#000; margin:0;}</style></head><body><iframe src=\"%@\" width=\"%0.0f\" height=\"%0.0f\" frameborder=\"0\" allowfullscreen></iframe></body></html>";
        
        NSString *htmlString = [NSString stringWithFormat:embedHTML, videoURL, self.view.frame.size.width, backgroundRect.size.height];
        
        [webView loadHTMLString:htmlString baseURL:nil];
        self.mediaView = webView;
        
    }
    else
    {
        int contentOffset = (self.mediaIndex * 350);
        //load image media
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.mediaList[self.mediaIndex] ofType:@"png"];
        
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        UIImage * backgroundImage = [[UIImage alloc] initWithData:imgData];
        
        CGRect backgroundRect = CGRectMake(contentOffset, 0, 325.0f, 250.0f);
        
        //This is a paralax view meaning the textbox moves along with the image The rest of the code sets this up
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
        backgroundImageView.image = backgroundImage;
        backgroundImageView.backgroundColor = [UIColor blackColor];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.mediaView = backgroundImageView;
    }
}

//Used to get the directory to the documents folder
-(NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

@end