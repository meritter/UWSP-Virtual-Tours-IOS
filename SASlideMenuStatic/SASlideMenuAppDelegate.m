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
    [GMSServices provideAPIKey:@"AIzaSyBy6x3X8S_tf_folhpgrkz9iI6A9DHiJZU"];
    
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
