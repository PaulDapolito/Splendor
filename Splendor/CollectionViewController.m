//
//  CollectionViewController.m
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.entries = [Database fetchAllEntries];
        
        // register the cell configuration
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.tableView setContentInset:UIEdgeInsetsMake(20,
                                                         self.tableView.contentInset.left,
                                                         self.tableView.contentInset.bottom,
                                                         self.tableView.contentInset.right)];
        // configure the table view visual components
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
        // set view background color
        [self.view setBackgroundColor:[UIColor colorWithRed:1.0 green:.573 blue:0 alpha:0.5f]];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // set inset so table cells do not overlap the status bar
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _entries.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create the cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // configure the cell to display newest entries first
    SunsetEntry *rowEntry = [self.entries objectAtIndex:([self.entries count] - indexPath.row - 1)];
    NSString *location = rowEntry.location;
    NSString *date = rowEntry.date;
    
    // setup cell text and background color
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", location, date]];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Avenir" size:20.0]];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell setBackgroundColor: DARK_ORANGE];
    
    // setup cell's selected view
    UIView *selectedView = [[UIView alloc] init];
    [selectedView setBackgroundColor:[UIColor colorWithRed:1 green:.573 blue:0 alpha:1]];
    [selectedView.layer setCornerRadius:10];
    [selectedView.layer setMasksToBounds:YES];
    [cell setSelectedBackgroundView:selectedView];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // allow users to delete entries from their collection
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [Database deleteEntry:[[self.entries objectAtIndex:([self.entries count] - indexPath.row - 1)] rowID]];
        self.entries = [Database fetchAllEntries];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // grab the sunset entry for the selected row
    SunsetEntry *selected = [self.entries objectAtIndex:([self.entries count] - indexPath.row - 1)];
    
    // create a view for the entry, set the image
    EntryViewController *entryView = [[EntryViewController alloc] initWithImage:selected.image AndDateString:selected.date AndLocationString:selected.location];
    
    // add target to the entry view's back button
    [entryView.backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];

    // push entry view controller
    [self presentViewController:entryView animated:YES completion:nil];
}

- (void)backPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
