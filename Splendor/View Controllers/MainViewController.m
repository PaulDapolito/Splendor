//
//  MainViewController.m
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set view background color
        [self.view setBackgroundColor:LIGHT_ORANGE];
        
        // y offset placeholder
        CGFloat yOffset = statusBarHeight;
        
        // configure sunlight world map image
        _worldMap = [[UIImageView alloc] initWithFrame:CGRectMake(0, yOffset, width, height/2 - height/8)];
        [_worldMap setContentMode:UIViewContentModeScaleToFill];
        [_worldMap setClipsToBounds:YES];
        
        // set the world sunlight map image viewer to the shadowless map while fetching data from the server
        _worldMapImage = [UIImage imageNamed:@"blankMap.png"];
        [_worldMap setImage:_worldMapImage];
        [self updateSunlightMapInBackground];
        [self.view addSubview:_worldMap];
        
        // setup timer to update sunlight map every 15 minutes
        _updateMap = [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(updateSunlightMapInBackground) userInfo:nil repeats:YES];
        
        // increment the y offset by the height of the world map image viewer
        yOffset += _worldMap.frame.size.height;

        // setup countdown label
        _countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, width, height/8 + height/48)];
        [_countdownLabel setFont:[UIFont fontWithName:@"Avenir" size:30.0]];
        [_countdownLabel setBackgroundColor:LIGHT_ORANGE];
        [_countdownLabel setAdjustsFontSizeToFitWidth:YES];
        [self.view addSubview:_countdownLabel];
        
        // setup timer to update countdown label each second
        _updateCountdown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setCountdown) userInfo:nil repeats:YES];
        
        // increment the y offset by the height of the countdown label
        yOffset += _countdownLabel.frame.size.height;
        
        // setup city and state label
        _cityAndStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, width, height/6)];
        [_cityAndStateLabel setFont:[UIFont fontWithName:@"Avenir" size:30.0]];
        [_cityAndStateLabel setBackgroundColor:DARK_ORANGE];
        [_cityAndStateLabel setAdjustsFontSizeToFitWidth:YES];
        [self.view addSubview:_cityAndStateLabel];
    
        // increment the y offset by the height of the city and state label
        yOffset += _cityAndStateLabel.frame.size.height;
        
        // setup sunrise label
        _sunriseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, width/2, height/6)];
        [_sunriseLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
        [_sunriseLabel setBackgroundColor:LIGHT_ORANGE];
        [_sunriseLabel setAdjustsFontSizeToFitWidth:YES];
        [self.view addSubview:_sunriseLabel];
        
        // setup sunset label
        _sunsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, yOffset, width/2, height/6)];
        [_sunsetLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
        [_sunsetLabel setBackgroundColor:LIGHT_ORANGE];
        [_sunsetLabel setAdjustsFontSizeToFitWidth:YES];
        [self.view addSubview:_sunsetLabel];
        
        // increment the y offset by the height of the sunrise and sunset labels
        yOffset += _sunsetLabel.bounds.size.height;
        
        // setup sunlight label
        _sunlightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, width, (int)(height/8 + height/48))];
        [_sunlightLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
        [_sunlightLabel setBackgroundColor:DARK_ORANGE];
        [_sunlightLabel setAdjustsFontSizeToFitWidth:YES];
        [self.view addSubview:_sunlightLabel];
        
        // initialize sunset notification variables
        _sunsetPassed = YES;
        _sunsetNotification = [UILocalNotification new];
        NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
        _sunsetNotificationsEnabled = [[userSettings objectForKey:@"sunsetNotifications"] boolValue];
        _notificationsInterval = [[userSettings objectForKey:@"intervalBefore"] intValue];
        
        // observe changes in the user's notification settings
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(updateNotifications)
                                              name:NSUserDefaultsDidChangeNotification
                                              object:nil];
        
        // start looking for location changes
        [self startSignificantChangeUpdates];
    }
    return self;
}

- (void) setCountdown
{
    // get current time
    NSDateFormatter *formatter =  [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    
    // get hours and minutes components
    NSString *currentHours = [timeString substringWithRange:NSMakeRange(0,2)];
    NSString *currentMinutes = [timeString substringWithRange:NSMakeRange(3, 2)];

    int hour = [currentHours intValue];
    int minute = [currentMinutes intValue];
    
    // determine whether or not the sunset has passed
    if (_sunset.hour - hour > 0 || (_sunset.hour - hour == 0 && _sunset.minute - minute >= 0)) {
        _sunsetPassed = NO;
    }
    else {
        _sunsetPassed = YES;
    }
    
    // determine the correct preposition to use
    NSString *preposition = (_sunsetPassed) ? @"after" : @"until";
    
    // calculate the hours and minutes differences
    int hoursDiff = (_sunsetPassed) ? (hour - (int)_sunset.hour) : ((int)_sunset.hour - hour);
    int minutesDiff = (_sunsetPassed) ? (minute - (int)_sunset.minute) : ((int)_sunset.minute - minute);
        
    // add 60 minutes to minutesDiff if it's negative
    if (minutesDiff < 0) {
        hoursDiff -= 1;
        minutesDiff += 60;
    }
    
    // determine the correct pluralization of the hours and minutes strings
    NSString *hoursString = (hoursDiff == 1) ? @"hour" : @"hours";
    NSString *minutesString = (minutesDiff == 1) ? @"minute" : @"minutes";

    // if the sunset is now, tell the user to enjoy the sunset
    if (hoursDiff == 0 && minutesDiff == 0) {
        [_countdownLabel setText:@"Enjoy the sunset!"];
    }
    // otherwise, show the countdown as usual
    else {
        [_countdownLabel setText:[NSString stringWithFormat:@"%d %@ and %d %@ %@ sunset",
                                                            hoursDiff, hoursString,
                                                            minutesDiff, minutesString,
                                                            preposition]];
    }
}

- (void) startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.pausesLocationUpdatesAutomatically = YES;

    // request proper permissions (iOS 8 only, uncomment for iOS8 release)
    /*
    if (([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])) {
        [self.locationManager requestAlwaysAuthorization];
    }*/
    
    // begin location updates
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // reverse geocode the user's location
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
        if (error) {
            NSLog(@"Error %@", error.description);
        }
        else {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            _city = [topResult locality];
            _state = [topResult administrativeArea];
            _shareView.city = _city;
            _shareView.state = _state;
            
            [self updateLabels];
            [self updateNotifications];
        }
    }];
    
    [self calculateTimesWithLatitude:newLocation.coordinate.latitude andLongitude:newLocation.coordinate.longitude];
}

// code for calculations taken from: https://github.com/erndev/EDSunriseSet
- (void) calculateTimesWithLatitude:(float)latitude andLongitude:(float)longitude
{
    // set the sunrise and sunset times
    EDSunriseSet *calculations = [EDSunriseSet sunrisesetWithTimezone:[NSTimeZone localTimeZone] latitude:latitude longitude:longitude];
    [calculations calculate:[NSDate date]];
    _sunrise = calculations.localSunrise;
    _sunset = calculations.localSunset;
    
    [self updateLabels];
}

- (void) updateLabels
{
    // update location labels
    [_cityAndStateLabel setText:[NSString stringWithFormat:@"%@, %@", _city, _state]];

    // update sunrise label
    NSString *upArrow = [NSString stringWithUTF8String:"\u25B2"];
    [_sunriseLabel setText:[NSString stringWithFormat:@"%@ %d:%d AM", upArrow, (int)_sunrise.hour, (int)_sunrise.minute]];
    
    // update sunset label
    NSString *downArrow = [NSString stringWithUTF8String:"\u25BC"];
    int hour = (int)_sunset.hour - 12;
    [_sunsetLabel setText:[NSString stringWithFormat:@"%@ %d:%d PM", downArrow, hour, (int)_sunset.minute]];
    
    // calculate the total hours of sunlight and update the sunlight label
    int hoursSunlight = (int)(_sunset.hour - _sunrise.hour);
    int minutesSunlight = (int)(_sunset.minute - _sunrise.minute);
    
    // if the minutes of sunlight is negative, add 60 to it
    if (minutesSunlight < 0) {
        hoursSunlight -= 1;
        minutesSunlight += 60;
    }
    
    // determine the correct pluralization of the hours and minutes strings
    NSString *hoursString = (hoursSunlight == 1) ? @"hour" : @"hours";
    NSString *minutesString = (minutesSunlight == 1) ? @"minute" : @"minutes";
    
    // update the sunlight label
    [_sunlightLabel setText:[NSString stringWithFormat:@"%d %@ and %d %@ of sunlight",
                                                       hoursSunlight, hoursString, minutesSunlight, minutesString]];
}

- (void) updateSunlightMap
{
    // grab a new sunlight map from the server
    _worldMapImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://paul:paul123@pauldapolito.com/sunlight/render.png"]]];
    [_worldMap setContentMode:UIViewContentModeScaleToFill];
    _worldMap.clipsToBounds = YES;
    
    // set the image viewer using an animation
    [UIView transitionWithView:_worldMap duration:2.0f options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _worldMap.image = _worldMapImage;
                    } completion:NULL];
}

- (void) updateSunlightMapInBackground
{
    // perform updateSunlightMap in a background thread
    [self performSelectorInBackground:@selector(updateSunlightMap) withObject:nil];
}

- (void) updateNotifications
{
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    _sunsetNotificationsEnabled = [[userSettings objectForKey:@"sunsetNotifications"] boolValue];
    _notificationsInterval = [[userSettings objectForKey:@"intervalBefore"] intValue];
    
    if (_sunsetNotificationsEnabled && !_sunsetPassed) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // create new fire date using today's date
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                    fromDate:[NSDate date]];
        NSDateComponents *fireDate = [NSDateComponents new];
        [fireDate setYear:today.year];
        [fireDate setMonth:today.month];
        [fireDate setDay:today.day];
        [fireDate setHour:_sunset.hour];
        [fireDate setMinute:_sunset.minute - _notificationsInterval];
        [_sunsetNotification setFireDate:[[NSCalendar currentCalendar] dateFromComponents:fireDate]];
        
        // create the notification body and schedule the notification
        NSString *intervalString;
        if (_notificationsInterval == 0) {
            intervalString = @"now";
        }
        else if (_notificationsInterval == 1) {
            intervalString = [NSString stringWithFormat:@"in %d minute", _notificationsInterval];
        }
        else {
            intervalString = [NSString stringWithFormat:@"in %d minutes", _notificationsInterval];
        }
        
        [_sunsetNotification setAlertBody:[NSString stringWithFormat:@"%@, %@ sunset %@!", _city, _state, intervalString]];
        [[UIApplication sharedApplication] scheduleLocalNotification:_sunsetNotification];
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end