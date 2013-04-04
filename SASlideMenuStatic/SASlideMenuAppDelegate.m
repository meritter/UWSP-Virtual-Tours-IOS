//
//  SASlideMenuAppDelegate.m
//  SASlideMenuStatic
//  Created by Stefano Antonelli on 12/3/12.
//  Edited by Jonathan Christian on 2/18/13.
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
    //Google API Key
    [GMSServices provideAPIKey:@"AIzaSyBy6x3X8S_tf_folhpgrkz9iI6A9DHiJZU"];
    
   NSUserDefaults * deviceStoredValues;
   NSString       * currentMapPack;
   NSString       * currentMode;
   NSMutableArray * parsedMapPack;
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
           
            parsedMapPack = [[NSMutableArray alloc] init];
            
            //Find the .xml file associated to the currentMapPack
            NSString * stringURL = [NSString stringWithFormat:@"%@%@", currentMapPack, @".xml"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:stringURL];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
        
            XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
            
            //get pois points from array in XML starting with <poi> tag
            parser.rowElementName = @"poi";
            parser.elementNames = [NSArray arrayWithObjects: @"description", @"id", @"lat", @"long", @"title", nil];
        
                       
            BOOL success = [parser parse];
            
            //If parse was successful send items to Array
            if (success)
            {
              parsedMapPack = [parser items];
            }
            
            
            for (int i = 0; i < [parsedMapPack count]; i++)
            {
                //Create a dictionary and set to the count of i
              NSDictionary *tempObjectDict = [parsedMapPack objectAtIndex:i];
                
                //Create and initialize a poi object
                 Poi * poi = [[Poi alloc] init];
                
                //Assign based upon dictionary key value pairs
                 poi.title = [tempObjectDict objectForKey:@"title"];
                 poi.lat = [tempObjectDict objectForKey:@"lat"];
                 poi.lon = [tempObjectDict objectForKey:@"long"];
                
                //Add poi to singleton for App use
                 [[Singleton sharedSingleton].locationsArray  addObject:poi];

                for ( Poi * poi in [Singleton sharedSingleton].locationsArray)
                {
                    NSLog(@"Poi:  %@", poi.title);
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
