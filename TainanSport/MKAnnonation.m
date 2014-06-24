//
//  MKAnnonation.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "MKAnnonation.h"

@implementation MKAnnonation
@synthesize coordinate,subtitle,title;

-(id)initWithLocaton:(CLLocationCoordinate2D)coord{
    self = [super init];
    if(self){
        coordinate = coord;
    }
    return self;
}

@end
