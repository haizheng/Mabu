//
//  AppDelegate.h
//  FrontEnd
//
//  Created by Diekai Zeng on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstViewController;
@class SecondViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    FirstViewController  *viewController1;
    SecondViewController *viewController2 ;
}


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) FirstViewController  *viewController1;
@property (retain, nonatomic) SecondViewController  *viewController2;

@end
