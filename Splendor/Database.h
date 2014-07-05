//
//  Database.h
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Harvey Mudd College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SunsetEntry.h"

@interface Database : NSObject

+ (void) createEditableCopyOfDatabaseIfNeeded;

+ (void) initDatabase;

+ (NSMutableArray *) fetchAllEntries;

+ (void) saveEntryWithDate:(NSString *)date andLocation:(NSString *)location andImage:(UIImage *)image;

+ (void) deleteEntry:(int)rowid;

+ (void) cleanUpDatabaseForQuit;

@end
