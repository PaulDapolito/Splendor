//
//  MainViewController.h
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EDSunriseSet.h"
#import "ShareViewController.h"
#import "Globals.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) UIImageView *worldMap;
@property (strong, nonatomic) UIImage *worldMapImage;
@property (strong, nonatomic) NSTimer *updateMap;

@property (strong, nonatomic) UILabel *countdownLabel;
@property (strong, nonatomic) NSTimer *updateCountdown;

@property (strong, nonatomic) UILabel *cityAndStateLabel;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

@property (strong, nonatomic) UILabel *sunriseLabel;
@property (strong, nonatomic) UILabel *sunsetLabel;
@property (strong, nonatomic) NSDateComponents *sunrise;
@property (strong, nonatomic) NSDateComponents *sunset;

@property (strong, nonatomic) UILabel *sunlightLabel;

@property (strong, nonatomic) UILocalNotification *sunsetNotification;
@property bool sunsetNotificationsEnabled;
@property int notificationsInterval;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) ShareViewController *shareView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void) setCountdown;

- (void) startSignificantChangeUpdates;
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (void) calculateTimesWithLatitude:(float)latitude andLongitude:(float)longitude;

- (void) updateLabels;

- (void) updateSunlightMap;
- (void) updateSunlightMapInBackground;

- (void) notificationSettingsChange;

- (void) viewDidLoad;

- (void) didReceiveMemoryWarning;

@end
