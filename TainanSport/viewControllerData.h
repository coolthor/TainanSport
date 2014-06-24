//
//  viewControllerData.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithDelegateViewController.h"
@interface viewControllerData : NSObject
@property NSString * title;
@property NSString * imageName;
@property WithDelegateViewController * viewController;
@property NSString * nibName;
@end
