//
//  EntryViewController.h
//  Splendor
//
//  Created by Paul on 6/4/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface EntryViewController : UIViewController

@property (strong, nonatomic) UIImageView *imageViewer;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UILabel *cityAndStateLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIButton *backButton;

- (id) initWithImage:(UIImage *)image AndDateString:(NSString *)dateString AndLocationString:(NSString *)locationString;

- (void) viewDidLoad;

- (void) didReceiveMemoryWarning;

@end
