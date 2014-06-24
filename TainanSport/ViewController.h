//
//  ViewController.h
//  TainanSport
//
//  Created by Thor Lin on 2014/6/14.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLJSONParse.h"
#import "TLParseRawData.h"
#import "Exercise.h"

@interface ViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray * array;
@property (strong,nonatomic) NSMutableDictionary * dictionary;
@end
