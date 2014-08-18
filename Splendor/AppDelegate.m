//
//  AppDelegate.m
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // setup the application window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // get the width and height of the screen, set the global variables
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    // get the height of the status bar, set the global variable, and subtract it from the height of the screen
    statusBarHeight =  [UIApplication sharedApplication].statusBarFrame.size.height;
    height -= statusBarHeight;
    
    // create the tab bar controller
    _tabBarController = [UITabBarController new];
    [_tabBarController.tabBar setTranslucent:NO];
    [_tabBarController.tabBar setBarTintColor: LIGHT_ORANGE];
    
    // get the height of the tab bar, set the global variable, and subtract it from the height of the screen
    tabBarHeight = _tabBarController.tabBar.bounds.size.height;
    height -= tabBarHeight;
    
    // create and/or initialize application database
    [Database createEditableCopyOfDatabaseIfNeeded];
    [Database initDatabase];
    
    // create the main view controller and configure its tab bar item
    _mainView = [MainViewController new];
    UIImage *sunImage = [UIImage imageNamed:@"sun"];
    sunImage = [sunImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _mainView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:sunImage tag:1];
    
    // create the share view controller and configure its tab bar item
    _shareView = [ShareViewController new];
    UIImage *cameraImage = [UIImage imageNamed:@"camera"];
    cameraImage = [cameraImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _shareView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Capture" image:cameraImage tag:2];
    
    // create the collection view controller and configure its tab bar item
    _collectionView = [CollectionViewController new];
    UIImage *collectionImage = [UIImage imageNamed:@"collection"];
    collectionImage = [collectionImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _collectionView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Collection" image:collectionImage tag:3];
    
    // add view controllers to the tab bar controller
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:_mainView, _shareView, _collectionView, nil] animated:YES];
    
    // allow view controllers to point to one another
    _mainView.shareView = _shareView;
    _shareView.mainView = _mainView;
    _shareView.collectionView = _collectionView;

    // give the share view controller access to the tab bar controller
    _shareView.tabBarController = _tabBarController;
    
    // setup UILabel text alignment for entire app
    [[UILabel appearance] setTextAlignment:NSTextAlignmentCenter];
    
    // initialize default settings
    NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaultDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"NO", @"sunsetNotifications",
                                       @"10", @"intervalBefore",
                                       @"YES", @"savePhotosToCameraRoll",
                                       nil];
    [defaultSettings registerDefaults:defaultDictionary];
    [defaultSettings synchronize];
    
    // add the tab bar controller as the root view for the app
    [self.window setRootViewController:_tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // update the world sunlight map
    [_mainView updateSunlightMapInBackground];
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
