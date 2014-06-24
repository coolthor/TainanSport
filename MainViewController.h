//
//  MainViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/20.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLParseRawData.h"
#import "Exercise.h"
#import "viewControllerData.h"
#import "NearByViewController.h"
#import "MedicalViewController.h"
#import "SearchViewController.h"

@interface MainViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,WithDelegateViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray * array;
@property (strong,nonatomic) NSMutableDictionary * dictionary;
@property (strong,nonatomic) NSMutableArray * viewControllerArray;
@end
