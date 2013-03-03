//
//  RootViewController.m
//  Created by haltink on 5/27/11.
//  Modified by Jonathan Christian 2/12/13
//  Copyright 2013. All rights reserved.
//

#import "RootViewController.h"



@implementation RootViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSLog(@"[%@ viewDidLoad]",self);
}
//This bloody works
/*- (IBAction)startXMLTransfer:(id)sender;
{
    NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.xml"];
        [urlData writeToFile:filePath atomically:YES];
        // NSLog(filePath);
        
        [self parseXMLFileAtURL: @"/Users/Jonathan/Library/Application Support/iPhone Simulator/6.1/Applications//580FD371-2C90-455E-BB1F-C2BB6AE615AA/Documents/filename.xml"];
    }
    
}*/







@end
