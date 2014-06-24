//
//  SearchViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/22.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDelegateViewController.h"
#import "Exercise.h"
#import <MapKit/MapKit.h>
#import "MKAnnonation.h"

@interface SearchViewController : WithDelegateViewController<WithDelegateViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,MKMapViewDelegate>
@property NSArray * searchResult;
@property MKMapView *myMapView;
@property MKAnnonation * currentMKA;

@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)ClickDismiss:(id)sender;

@end
