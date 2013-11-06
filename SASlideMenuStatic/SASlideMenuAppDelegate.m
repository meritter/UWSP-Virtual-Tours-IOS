//
//  SASlideMenuAppDelegate.m
//  SASlideMenuStatic
//  Created by Stefano Antonelli on 12/3/12.
//  Edited by Jonathan Christian on 2/18/13.
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



#import "SASlideMenuAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TutorialFirstViewController.h"
#import "Singleton.h"
#import "XMLDataAccess.h"
#import "Poi.h"
@implementation SASlideMenuAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Google API Key
    [GMSServices provideAPIKey:@"AIzaSyCYSU7qY8ei10C0xHRp-G9YJtG6lO3r5B8"];
    
   NSUserDefaults * deviceStoredValues;
   NSString       * currentMapPack;
   NSString       * currentMode;
   int launchCount;
    
    //get stored values on device
    deviceStoredValues = [NSUserDefaults standardUserDefaults];
    launchCount = [deviceStoredValues integerForKey:@"launchCount" ] + 1;
    [deviceStoredValues setInteger:launchCount forKey:@"launchCount"];
    //Sync the new launchCount value
    [deviceStoredValues synchronize];
        
    NSLog(@"number of times: %i this app has been launched", launchCount);
    
    //If count is 1 load the QuestMenuViewController will segue to (return @"tutorial") view
    //The tutorial view will guide the user to select an initial map pack and mode type
    if ( launchCount == 1 )
    {
        NSLog(@"this is the FIRST LAUNCH of the app");
    }
    else
    {
        NSLog(@"Post initial launch of the app");
        
        //Set the current mode and map pack
        currentMapPack = [deviceStoredValues valueForKey:@"CurrentMapPack"];
        currentMode = [deviceStoredValues valueForKey:@"CurrentMode"];
    
        if(currentMapPack != nil)
        {
            //set the singletons values for later use
            [Singleton sharedSingleton].selectedMapPack = currentMapPack;
            [Singleton sharedSingleton].selectedMode = currentMode;
            
            //Find our plist file if it contain data we set our singleton to that data
            //Otherwise parse the Tour with the setUpPOI methodand set up singleton
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [docDir stringByAppendingPathComponent:@"locationsArrayData.plist"];
            
            NSMutableArray * array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
            
            for (int i = 0; i < [array count]; i++)
            {
                //Create a dictionary and set to the count of i
                NSDictionary *tempObjectDict = [array objectAtIndex:i];
                
                //Create and initialize a poi object
                Poi * poi = [[Poi alloc] init];
                
                //Assign based upon dictionary key value pairs
                poi.title = [tempObjectDict objectForKey:@"title"];
                poi.lat = [[tempObjectDict objectForKey:@"lat"] doubleValue];
                poi.lon = [[tempObjectDict objectForKey:@"lon"] doubleValue];
                poi.description = [tempObjectDict objectForKey:@"description"];
                poi.poiId = [[tempObjectDict objectForKey:@"id"] integerValue];
                poi.visited = [[tempObjectDict objectForKey:@"visited"] boolValue];
                
                
                //Add poi to singleton for App use
                [[Singleton sharedSingleton].locationsArray  addObject:poi];
                
            }
        }
        
        // If we single has no locations (the plist file was empty) and we have a mapPack set - parse the xml using the XMLDataAccess class
        if ([[Singleton sharedSingleton].locationsArray count] == 0)
        {
            XMLDataAccess * da = [[XMLDataAccess alloc] init];
            [da setUpPOI:currentMapPack];
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
    //Store mapPack and Mode in device 
    NSUserDefaults * deviceStoredValues = [NSUserDefaults standardUserDefaults];
  
    [deviceStoredValues setValue:[Singleton sharedSingleton].selectedMapPack forKey:@"CurrentMapPack"];
    [deviceStoredValues synchronize];
    [deviceStoredValues setValue:[Singleton sharedSingleton].selectedMode  forKey:@"CurrentMode"];
    
    
    //Create a dictionary of each poi in singleton and store it in a plist file on the device
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    for (Poi * tempPoi in [Singleton sharedSingleton].locationsArray) {
        
        NSMutableDictionary * tempObjectDict = [[NSMutableDictionary alloc] init];
        [tempObjectDict setValue:tempPoi.title forKey:@"title"];
        [tempObjectDict setValue:tempPoi.description forKey:@"description"];
        [tempObjectDict setValue:[NSNumber numberWithDouble:tempPoi.lat]  forKey:@"lat"];
        [tempObjectDict setValue:[NSNumber numberWithDouble:tempPoi.lon] forKey:@"lon"];
        [tempObjectDict setValue:[NSNumber numberWithInt:tempPoi.poiId] forKey:@"poiId"];
        [tempObjectDict setValue:[NSNumber numberWithBool:tempPoi.visited]  forKey:@"visited"];
        [myArray addObject:tempObjectDict];

    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *prsPath = [documentsDirectory stringByAppendingPathComponent:@"locationsArrayData.plist"];   
    [myArray writeToFile:prsPath atomically:YES];
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
