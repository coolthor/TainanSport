//
//  WithDelegateViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WithDelegateViewController;

@protocol WithDelegateViewControllerDelegate<NSObject>
-(void)WithDelegateViewControllerDidClickDismissButton:(WithDelegateViewController *)viewController;
@end

@interface WithDelegateViewController : UIViewController
@property (strong,nonatomic)NSMutableArray * array;
@property (strong,nonatomic)NSMutableDictionary * dic;

@property (nonatomic,weak) id<WithDelegateViewControllerDelegate> delegate;

@end
