//
//  AppDelegate.h
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "MainViewController.h"
#import "ShareViewController.h"
#import "CollectionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// tab bar controller
@property (strong, nonatomic) UITabBarController *tabBarController;

// view controllers
@property (strong, nonatomic) MainViewController *mainView;
@property (strong, nonatomic) ShareViewController *shareView;
@property (strong, nonatomic) CollectionViewController *collectionView;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) applicationWillResignActive:(UIApplication *)application;
- (void) applicationDidEnterBackground:(UIApplication *)application;
- (void) applicationWillEnterForeground:(UIApplication *)application;
- (void) applicationDidBecomeActive:(UIApplication *)application;
- (void) applicationWillTerminate:(UIApplication *)application;

@end
