//  ImageViewController.h
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


#import <UIKit/UIKit.h>


@interface ImageViewController : UITableViewController
{
    NSArray *mediaList;
    NSString * locationName;
    int mediaIndex;
    int videoCount;
    UIView *mediaView;
}

//Location named is pulled from the previous controller
//Example in mapViewController where this controller is called and "kivc"
// kivc.locationName = marker.title;

@property (strong, nonatomic) NSArray *mediaList;
@property (nonatomic, copy) NSString * locationName;
@property (nonatomic, assign) int mediaIndex;
@property (nonatomic, assign) int videoCount;
@property (strong, nonatomic) UIView *mediaView;

@end