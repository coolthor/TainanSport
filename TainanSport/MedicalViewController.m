//
//  MedicalViewController.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "MedicalViewController.h"

@interface MedicalViewController ()

@end

@implementation MedicalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _hospitals = [[NSMutableArray alloc]init];
    [self getDataFromDB];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    
}

-(void)getDataFromDB{
    NSString *url = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"sample.sqlite"];
    sqlite3 *database = nil;
    
    if (sqlite3_open([url UTF8String], &database) == SQLITE_OK) {
//        NSLog(@"DB OK");
        //這裡寫入要對資料庫操作的程式碼
        //查閱所有資料內容
        //建立 Sqlite 語法
        const char *sql = "select * from hospital where Address like  '臺南%'";
        
        //stm將存放查詢結果
        sqlite3_stmt *statement =nil;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Hospital *hospital  = [[Hospital alloc]init];
                
                hospital.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                hospital.phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                hospital.address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [_hospitals addObject: hospital];
            }
            
            //使用完畢後將statement清空
            sqlite3_finalize(statement);
        }
//        NSLog(@"%d",sqlite3_prepare_v2(database, sql, -1, &statement, NULL));
        //使用完畢後關閉資料庫聯繫
        sqlite3_close(database);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickDismiss:(id)sender{
    if ( self .delegate && [ self .delegate respondsToSelector: @selector (WithDelegateViewControllerDidClickDismissButton:)]) {
        [self.delegate WithDelegateViewControllerDidClickDismissButton:self];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _hospitals.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
    Hospital * hospital = _hospitals[indexPath.row];
    cell.textLabel.text = hospital.name;
    cell.detailTextLabel.text = hospital.phone;
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"緊急救護";
}
@end
