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

@implementation SASlideMenuAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBy6x3X8S_tf_folhpgrkz9iI6A9DHiJZU"];
    
    NSUserDefaults      *padFactoids;
    int                 launchCount;
    
    padFactoids = [NSUserDefaults standardUserDefaults];
    launchCount = [padFactoids integerForKey:@"launchCount" ] + 1;
    [padFactoids setInteger:launchCount forKey:@"launchCount"];
    [padFactoids synchronize];
    
    NSLog(@"number of times: %i this app has been launched", launchCount);
    
    if ( launchCount == 1 )
    {
        NSLog(@"this is the FIRST LAUNCH of the app");
        
        /*UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlay.backgroundColor = [UIColor clearColor];
        overlay.userInteractionEnabled = YES;
        [keyWindow addSubview:overlay];
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(dismissTutorial)];
        CGFloat border = 10;
        CGRect frame = overlay.bounds;
        // 20 is the status bar height (sorry for using the number)
        frame = CGRectMake(border, border + 20, frame.size.width - border * 2, frame.size.height - border * 2 - 20);
        // the black view in the example is probably a scroll view
        UIView *blackView = [[UIView alloc] initWithFrame:frame];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.0;
        [overlay addSubview:dimView];
        // add all the subviews for your tutorial
        // make it appear with an animation
        [UIView animateWithDuration:0.3
                         animations:^{dimView.alpha = 1;}
                         completion:^(BOOL finished){[overlay addGestureRecognizer:tapRecognizer];}];
       //[TutorialViewController *imageViewController =[[TutorialViewController alloc]init];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        TutorialViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"tutorial"];
        [(UINavigationController*)self.window.rootViewController pushViewController:ivc animated:NO];*/
        
        
        /*UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        TutorialViewController *controller = (TutorialViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"tutorial"];
        [navigationController   pushViewController:controller animated:NO];
        //SomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeIdentifier"];
        //[self.navigationController presentModalViewController:controller animated:YES]
       /* UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            TutorialViewController *secondView = [[TutorialViewController alloc] init];
        [navigationController pushViewController:secondView animated:YES];
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorial"];
        [self.navigationController pushViewController:controller animated:YES];*/
        //[secondView openDetailView];
        //[Navigationcontroller pushViewController:secondView animated:YES];
         //imageViewController.imageString = param;
         //[root.navigationController pushViewController:imageViewController animated:YES
    }
    if ( launchCount == 2 )
    {
        NSLog(@"this is the SECOND launch of the damn app");
        // do stuff here as you wish
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
