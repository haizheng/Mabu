//
//  AppDelegate.m
//  FrontEnd
//
//  Created by Diekai Zeng on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize viewController1;
@synthesize viewController2;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [viewController1 release];
    [viewController2 release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    viewController1 = [[FirstViewController alloc] init] ;
    viewController2 = [[SecondViewController alloc] init] ;
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate =self;//实现委托,切换tab可以重载tableview
   
    self.tabBarController.viewControllers = [[[NSArray alloc]initWithObjects:viewController1,viewController2, nil]autorelease];
    self.tabBarController.selectedIndex =0;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isEqual:self.viewController2 ] ) {
        [self.viewController2 TReloadData];
    }
}


/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

@end
