//
//  SunsetEntry.m
//  SunsetWatch
//
//  Created by Paul on 1/9/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import "SunsetEntry.h"

@implementation SunsetEntry

- (id) initWithDate:(NSString *)date andLocation:(NSString *)location andImage:(UIImage *)image andRowID:(int)rowID
{
    self = [super init];
    if (self) {
        self.date = date;
        self.location = location;
        self.image = image;
        self.rowID = rowID;
    }
    return self;
}

- (id) initWithDate:(NSString *)date andLocation:(NSString *)location andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.date = date;
        self.location = location;
        self.image = image;
    }
    return self;
}
@end
