//
//  MedicalViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "WithDelegateViewController.h"
#import "Hospital.h"

@interface MedicalViewController : WithDelegateViewController<WithDelegateViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property NSMutableArray * hospitals;
- (IBAction)ClickDismiss:(id)sender;

@end
