//
//  SunsetEntry.h
//  SunsetWatch
//
//  Created by Paul on 1/9/14.
//  Copyright (c) 2014 Paul Dapolito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunsetEntry : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIImage *image;
@property int rowID;

- (id) initWithDate:(NSString *)date andLocation:(NSString *)location andImage:(UIImage *)image andRowID:(int)rowID;

@end
