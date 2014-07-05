//
//  ShareViewController.m
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController () <UIActionSheetDelegate>

@end

@implementation ShareViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set background color of view
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:.765 blue:.451 alpha:1.0];
        
        // setup camera
        _camera = [UIImagePickerController new];
        _camera.delegate = self;
        _showedCamera = NO;
        
        // instantiate camera
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [_camera setSourceType:UIImagePickerControllerSourceTypeCamera];
            [_camera setCameraDevice:UIImagePickerControllerCameraDeviceRear];
            [_camera setShowsCameraControls:YES];
        }
        
        // initialize image viewer
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBarHeight, width, height - tabBarHeight)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:_imageView];
    }
    return self;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    _tabBarController.selectedViewController = _mainView;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // dismiss the camera
    _showedCamera = true;
    [_camera dismissViewControllerAnimated:YES completion:nil];
    
    // grab the image, save it to the photo reel, and display it in the image viewer
    _image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //UIImageWriteToSavedPhotosAlbum(_image, self, nil, nil);
    [_imageView setImage:_image];
    
    // create location and date strings
    NSString *location = [NSString stringWithFormat:@"%@, %@", _city, _state];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    // save the entry in the database
    [Database saveEntryWithDate:date andLocation:location andImage:_image];
    _collectionView.entries = [Database fetchAllEntries];
    [_collectionView.tableView reloadData];
    
    // show share and retake buttons
    [self showShareButton];
    [self showRetakeButton];
}

- (void) showShareButton
{
    // setup the share button
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _tabBarController.tabBar.frame.origin.y - tabBarHeight, width/2, tabBarHeight)];
    
    _shareButton.backgroundColor = [UIColor colorWithRed:1.0 green:.573 blue:0 alpha:1.0];
    [_shareButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
    
    [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shareButton setTitle:@"Share" forState:UIControlStateNormal];
    
    _shareButton.showsTouchWhenHighlighted = YES;
    [_shareButton addTarget:self action:@selector(sharePressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_shareButton];
}

- (void) showRetakeButton
{
    // setup the retake button
    _retakeButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2, _tabBarController.tabBar.frame.origin.y - tabBarHeight, width/2, tabBarHeight)];
    
    _retakeButton.backgroundColor = LIGHT_ORANGE;
    [_retakeButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
    
    [_retakeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_retakeButton setTitle:@"Retake" forState:UIControlStateNormal];
    
    _retakeButton.showsTouchWhenHighlighted = YES;
    [_retakeButton addTarget:self action:@selector(retakePressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_retakeButton];
}

- (void) sharePressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share via" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Email", @"Message", nil];
    
    [actionSheet showFromTabBar:_tabBarController.tabBar];
}

- (void) retakePressed
{
    // clear out image and image viewer, present camera again
    _image = nil;
    _imageView.image = nil;
    [self presentViewController:_camera animated:YES completion:^{}];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // facebook pressed
    if (buttonIndex == 0) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *facebookComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [facebookComposer setInitialText:[NSString stringWithFormat:@"Check out this sunset photo I just took in %@, %@! #Splendor", _city, _state]];
            [facebookComposer addImage:_image];
            
            [self presentViewController:facebookComposer animated:YES completion:nil];
        }
    }
    
    // twitter
    else if (buttonIndex == 1) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *twitterComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [twitterComposer setInitialText:[NSString stringWithFormat:@"Check out this sunset photo I just took in %@, %@! #Splendor", _city, _state]];
            [twitterComposer addImage:_image];
            
            [self presentViewController:twitterComposer animated:YES completion:nil];
        }
    }
    
    // email
    else if (buttonIndex == 2) {
        MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        
        emailController.mailComposeDelegate = self;
        NSData *imgData = UIImageJPEGRepresentation(_image, .7);
        
        [emailController addAttachmentData:imgData mimeType:nil fileName:@"image.jpeg"];
        
        [emailController setMessageBody:[NSString stringWithFormat:@"Hey, check out this sunset photo I just took in %@, %@!", _city, _state] isHTML:NO];
        
        [emailController setSubject:[NSString stringWithFormat:@"%@, %@ Sunset", _city, _state]];
        
        [self presentViewController:emailController animated:YES completion:nil];
    }
    
    // message
    else if (buttonIndex == 3) {
        MFMessageComposeViewController *messageController = [MFMessageComposeViewController new];
        
        messageController.messageComposeDelegate = self;
        
        NSData *imgData = UIImageJPEGRepresentation(_image, .7);
        BOOL didAttachImage = [messageController addAttachmentData:imgData typeIdentifier:@"public.data" filename:@"image.jpeg"];
        messageController.body = [NSString stringWithFormat:@"Hey, check out this sunset photo I just took in %@, %@!", _city, _state];
        
        if (didAttachImage) {
            [self presentViewController:messageController animated:YES completion:nil];
        }
        else {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:@"Failed to attach image"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
    }
    
    // cancel
    else {
        // do nothing
    }
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _tabBarController.selectedViewController = _mainView;
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _tabBarController.selectedViewController = _mainView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // show the camera if we haven't already, or if no image is currently present
    if(!_showedCamera || _image == nil){
        [self presentViewController:_camera animated:YES completion:^{}];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    // reset view controller when it is closed
    _showedCamera = NO;
    
    [_imageView setImage:nil];
    _image = nil;
    
    [_retakeButton removeFromSuperview];
    [_shareButton removeFromSuperview];
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
