//
//  ShareViewController.h
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "SunsetEntry.h"
#import "Database.h"
#import "CollectionViewController.h"
#import "Globals.h"

@interface ShareViewController : UIViewController

@property (strong, nonatomic) UIImagePickerController *camera;
@property bool showedCamera;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) id mainView;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) CollectionViewController *collectionView;

@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *retakeButton;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void) showShareButton;
- (void) sharePressed;

- (void) showRetakeButton;
- (void) retakePressed;

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

- (void) viewDidLoad;
- (void) viewDidAppear:(BOOL)animated;
- (void) viewDidDisappear:(BOOL)animated;

- (void) didReceiveMemoryWarning;

@end
