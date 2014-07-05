//
//  CollectionViewController.h
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "EntryViewController.h"
#import "Globals.h"

@interface CollectionViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *entries;

- (id) initWithStyle:(UITableViewStyle)style;

- (void) viewDidLoad;

- (void) didReceiveMemoryWarning;

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
