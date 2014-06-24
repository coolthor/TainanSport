//
//  NearByViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDelegateViewController.h"
#import <MapKit/MapKit.h>
#import "Exercise.h"
#import "MKAnnonation.h"

@interface NearByViewController : WithDelegateViewController<WithDelegateViewControllerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong ,nonatomic) UITableView * myTableView;
//@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property BOOL IsFirstinitLocate;
@property NSArray * sortedArray;
@property MKAnnonation * currentMKA;
@property Exercise * currentExercise;
- (IBAction)ClickDismiss:(id)sender;

@end
