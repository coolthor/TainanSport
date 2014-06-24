//
//  TLParseRawData.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/14.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

@interface TLParseRawData : NSObject

@property NSMutableArray * exerciseDatas;

+(NSMutableArray *) ParseRawDataFromString:(NSString *)RawString;

@end
