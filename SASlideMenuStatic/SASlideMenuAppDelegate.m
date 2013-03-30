//
//  SASlideMenuAppDelegate.m
//  SASlideMenuStatic
//
//  Created by Stefano Antonelli on 12/3/12.
//  Copyright (c) 2012 Stefano Antonelli. All rights reserved.
//

#import "SASlideMenuAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TutorialFirstViewController.h"
#import "Singleton.h"
#import "XmlArrayParser.h"
#import "Poi.h"
@implementation SASlideMenuAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBy6x3X8S_tf_folhpgrkz9iI6A9DHiJZU"];
    
    NSUserDefaults      *padFactoids;
    int                 launchCount;
    NSString             *currentMapPack;
    NSString             *currentMode;
     NSMutableArray * parsedMapPack;
   NSMutableArray * testMapPack;
    
    padFactoids = [NSUserDefaults standardUserDefaults];
    launchCount = [padFactoids integerForKey:@"launchCount" ] + 1;
    [padFactoids setInteger:launchCount forKey:@"launchCount"];
    [padFactoids synchronize];
    
       parsedMapPack = [[NSMutableArray alloc] init];
     testMapPack = [[NSMutableArray alloc] init];
   
    NSLog(@"number of times: %i this app has been launched", launchCount);
    
    if ( launchCount == 1 )
    {
        NSLog(@"this is the FIRST LAUNCH of the app");
        
    }
    else
    {
        NSLog(@"Post initial launch of the app");
        // do stuff here as you wish
        
        currentMapPack = [padFactoids valueForKey:@"CurrentMapPack"];
        currentMode = [padFactoids valueForKey:@"CurrentMode"];

        
        if(currentMapPack != nil)
        {
            [Singleton sharedSingleton].selectedMapPack = currentMapPack;
            [Singleton sharedSingleton].selectedMode = currentMode;

            NSString * stringURL = [NSString stringWithFormat:@"%@%@", currentMapPack, @".xml"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:stringURL];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
        
            XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
        
            
            //get pois points from array in XML
            parser.rowElementName = @"poi";
            parser.elementNames = [NSArray arrayWithObjects: @"description", @"id", @"lat", @"long", @"title", nil];
        
                       
            BOOL success = [parser parse];
            // test the result
            if (success)
            {
              parsedMapPack = [parser items];
            }
            
            for (int i = 0; i < [parsedMapPack count]; i++)
            {
              NSDictionary *tempObjectDict = [parsedMapPack objectAtIndex:i];
                Poi * poi = [[Poi alloc] init];

                poi.title = [tempObjectDict objectForKey:@"title"];
                
                 [[Singleton sharedSingleton].locationsArray  addObject:poi];
                //[testMapPack addObject:poi];
                for ( Poi * poi in testMapPack) {
                    //do stuff here, or just print the object with something like the code below
                    NSLog(@"Transaction:  %@", poi.title);
                }
            }
        }
        
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSUserDefaults *padFactoids;
    padFactoids = [NSUserDefaults standardUserDefaults];
  
    [padFactoids setValue:[Singleton sharedSingleton].selectedMapPack forKey:@"CurrentMapPack"];
    [padFactoids synchronize];
    [padFactoids setValue:[Singleton sharedSingleton].selectedMode  forKey:@"CurrentMode"];
    [padFactoids synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
