//
//  EntryViewController.m
//  Splendor
//
//  Created by Paul on 6/4/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndImage:(UIImage *)image AndDateString:(NSString *)dateString AndLocationString:(NSString *)locationString
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // get full width and height of screen
        CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat fullHeight = [UIScreen mainScreen].bounds.size.height;
        
        // setup image viewer
        _imageViewer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, fullHeight - fullHeight/8)];
        _imageViewer.backgroundColor = [UIColor colorWithRed:1.0 green:.765 blue:.451 alpha:1.0];
        [_imageViewer setContentMode:UIViewContentModeScaleAspectFit];
        _imageViewer.clipsToBounds = YES;
        [_imageViewer setImage:image];
        [self.view addSubview:_imageViewer];
        
        // setup city and state label
        _cityAndStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fullHeight - fullHeight/8, width/2, fullHeight/16)];
        _cityAndStateLabel.backgroundColor = DARK_ORANGE;
        [_cityAndStateLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
        _cityAndStateLabel.textColor = [UIColor blackColor];
        _cityAndStateLabel.adjustsFontSizeToFitWidth = YES;
        _cityAndStateLabel.text = [NSString stringWithFormat:@"%@", locationString];
        [self.view addSubview:_cityAndStateLabel];
        
        // remove excess zeroes from date string
        NSString *date = dateString;
        if([[date substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]){
            date = [date substringWithRange:NSMakeRange(1, date.length -1)];
        }
        NSRange indexOfslash = [date rangeOfString:@"/"];
        if([[date substringWithRange:NSMakeRange(indexOfslash.location+1, 1)] isEqualToString:@"0"]) {
            date = [date stringByReplacingCharactersInRange:NSMakeRange(indexOfslash.location+1, 1) withString:@""];
        }
        
        // setup date label
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fullHeight - fullHeight/16, width/2, fullHeight/16)];
        _dateLabel.backgroundColor = DARK_ORANGE;
        [_dateLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.adjustsFontSizeToFitWidth = YES;
        _dateLabel.text = [NSString stringWithFormat:@"%@", date];
        [self.view addSubview:_dateLabel];
        
        // setup back button
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2, fullHeight - fullHeight/8, width/2, fullHeight/8)];
        _backButton.backgroundColor = LIGHT_ORANGE;
        [_backButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
        _backButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backButton.showsTouchWhenHighlighted = YES;
        [self.view addSubview:_backButton];
    }
    return self;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
