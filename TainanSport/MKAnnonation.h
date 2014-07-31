//
//  MKAnnonation.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKAnnonation : NSObject <MKAnnotation>
//{
//    NSString * title;
//    NSString *subtitile;
//}
@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property (nonatomic) UIImage  * image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(id)initWithLocaton:(CLLocationCoordinate2D)coord;
@end
