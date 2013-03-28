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
@implementation SASlideMenuAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBy6x3X8S_tf_folhpgrkz9iI6A9DHiJZU"];
    
    NSUserDefaults      *padFactoids;
    int                 launchCount;
    NSString             *currentMapPack;
    NSString             *currentMode;
    
    padFactoids = [NSUserDefaults standardUserDefaults];
    launchCount = [padFactoids integerForKey:@"launchCount" ] + 1;
    [padFactoids setInteger:launchCount forKey:@"launchCount"];
    [padFactoids synchronize];
   
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
            //NSString *filename1 = @"First Tour";
            
            
            
            /*NSString *filename = [[NSBundle mainBundle] pathForResource:@"First Tour" ofType:@"xml"];
            NSData *data = [NSData dataWithContentsOfFile:filename];
            
            // create and init NSXMLParser object
            XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
            
          
            
            // create and init our delegate
            ///UsersParser *usersParser = [[UsersParser alloc] init];
            
            // set delegate
            //  [parser setDelegate:usersParser];
            
            // parsing...
            // create and init NSXMLParser object
            
            
            /*<?xml version="1.0" encoding="UTF-8"?>
             <tour>
             <id type="integer">1</id>
             <created-at type="datetime">2013-02-07T19:23:09Z</created-at>
             <description>This is a basic tour to help understand the system. Boom!</description>
             <lat type="decimal">44.53583</lat>
             <long type="decimal">-89.5611</long>
             <location>Stevens Point, WI</location>
             <name>First Tour</name>
             <updated-at type="datetime">2013-02-16T15:55:58Z</updated-at>
             <version>1361030158</version>
             <pois type="array">
             <poi>
             <description nil="true"/>
             <id type="integer">1</id>
             <lat type="decimal">44.525854</lat>
             <long type="decimal">-89.569151</long>
             <title>DUC</title>
             <category-id nil="true"/>
             </poi>
             </pois>
             <categories type="array"/>
             </tour>>*/
            
            
            NSString *filename = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"xml"];
            NSData *data = [NSData dataWithContentsOfFile:filename];
            
            // create and init NSXMLParser object
            XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
            parser.rowElementName = @"tour";
            parser.elementNames = [NSArray arrayWithObjects:@"created-at", @"description", @"id", @"lat", @"long", @"name", nil];
            
            
            BOOL success = [parser parse];
            
            // test the result
            if (success)
            {
              [Singleton sharedSingleton].locationsArray = [parser items];
            }
        }
    }

    
          /*   parser.rowElementName = @"tour";
             parser.elementNames = [NSArray arrayWithObjects:@"description", @"lat", @"long", @"name", @"poi", nil];
             
             NSLog(@"fnished parsing");
             
             BOOL success = [parser parse];
             //If fails we need to check this here
             // test the result
             if (success)
             {
             [Singleton sharedSingleton].locationsArray = [parser items];
             }
        }

        }*/
    return YES;
}


            
            
          /*  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            
            NSString * stringURL = [NSString stringWithFormat:@"%@%@", currentMapPack, @".xml"];
            
            
            NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:stringURL];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
            {
            
            NSLog(@"hit parsing");*/
            //NSString *stringURL = @"http://uwsp-gis-tour-data-test.herokuapp.com/tours.xml";
           // NSURL  *url = [NSURL URLWithString:stringURL];
            //NSData *data = [NSData dataWithContentsOfURL:url];
            
           
            //NSString *filename = [[NSBundle mainBundle] pathForResource:@"Schmeeckle" ofType:@"xml"];

            // NSData *data = [NSData dataWithContentsOfFile:myPathDocs];
            
            // create and init NSXMLParser object
        /*
            parser.rowElementName = @"tour";
            parser.elementNames = [NSArray arrayWithObjects:@"description", @"lat", @"long", @"name", @"poi", nil];
            
            NSLog(@"fnished parsing");
            
            BOOL success = [parser parse];
            //If fails we need to check this here
            // test the result
            if (success)
            {
                [Singleton sharedSingleton].locationsArray = [parser items];
            }
            }
        }

        }
        
        currentMode = [padFactoids valueForKey:@"CurrentMode"];
        
        if(currentMode != nil)
        {
            [Singleton sharedSingleton].selectedMode =  currentMode;
        }
        
    
    

      
    
   
    return YES;
}*/
							
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
