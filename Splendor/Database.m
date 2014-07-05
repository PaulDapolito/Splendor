//
//  Database.m
//  Splendor
//
//  Created by Paul on 6/2/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "Database.h"

@implementation Database

static sqlite3 *db;

static sqlite3_stmt *createEntries;
static sqlite3_stmt *fetchEntries;
static sqlite3_stmt *insertEntry;
static sqlite3_stmt *deleteEntry;
static sqlite3_stmt *updateEntry;

+ (void) createEditableCopyOfDatabaseIfNeeded
{
    BOOL success;
    
    // look for an existing sunsets database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"entries.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // if failed to find one, copy the empty entries database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"entries.sql"];
    
    NSLog(@"%@", defaultDBPath);
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}

+ (void) initDatabase
{
    // create the statement strings
    const char *createEntriesString = "CREATE TABLE IF NOT EXISTS entries (rowid INTEGER PRIMARY KEY AUTOINCREMENT, location TEXT, dateAdded TEXT, photo BLOB)";
    const char *fetchEntriesString = "SELECT * FROM entries";
    const char *insertEntryString = "INSERT INTO entries (location, dateAdded, photo) VALUES (?, ?, ?)";
    const char *deleteEntryString = "DELETE FROM entries WHERE rowid=?";
    
    // create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"entries.sql"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    //init table statement
    if (sqlite3_prepare_v2(db, createEntriesString, -1, &createEntries, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare entries create table statement");
    }
    
    // execute the table creation statement
    success = sqlite3_step(createEntries);
    sqlite3_reset(createEntries);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create entries table");
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchEntriesString, -1, &fetchEntries, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare entries fetching statement");
    }
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertEntryString, -1, &insertEntry, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare entry inserting statement");
    }
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteEntryString, -1, &deleteEntry, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare contact deleting statement");
    }
}

+ (NSMutableArray *)fetchAllEntries
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(fetchEntries) == SQLITE_ROW) {
        
        // query columns from fetch statement
        char *locationChars = (char *) sqlite3_column_text(fetchEntries, 1);
        char *dateChars = (char *) sqlite3_column_text(fetchEntries, 2);
        
        int len = sqlite3_column_bytes(fetchEntries, 3);
        NSData *imageData = [[NSData alloc] initWithBytes: sqlite3_column_blob(fetchEntries, 3) length: len];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        // convert to NSStrings
        NSString *location = [NSString stringWithUTF8String:locationChars];
        NSString *date = [NSString stringWithUTF8String:dateChars];
        
        //create Sunset object, notice the query for the row id
        SunsetEntry *temp = [[SunsetEntry alloc] initWithDate:date andLocation:location andImage:image andRowID:sqlite3_column_int(fetchEntries, 0)];
        [ret addObject:temp];
        
    }
        
    sqlite3_reset(fetchEntries);
    return ret;
}

+ (void) saveEntryWithDate:(NSString *)date andLocation:(NSString *)location andImage:(UIImage *)image
{
    // bind data to the statement
    sqlite3_bind_text(insertEntry, 1, [location UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertEntry, 2, [date UTF8String], -1, SQLITE_TRANSIENT);
    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, .7)];
    sqlite3_bind_blob(insertEntry, 3, [imageData bytes], (int)[imageData length], SQLITE_TRANSIENT);
    int success = sqlite3_step(insertEntry);
    sqlite3_reset(insertEntry);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert entry");
    }
}

+ (void) deleteEntry:(int)rowid
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deleteEntry, 1, rowid);
    int success = sqlite3_step(deleteEntry);
    sqlite3_reset(deleteEntry);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete entry");
    }

}

+ (void) cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchEntries);
    sqlite3_finalize(insertEntry);
    sqlite3_finalize(deleteEntry);
    sqlite3_finalize(createEntries);
    sqlite3_finalize(updateEntry);
    sqlite3_close(db);
}

@end