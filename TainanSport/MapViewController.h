//
//  MapViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/20.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *myMap;
@end
