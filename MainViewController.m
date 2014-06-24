//
//  MainViewController.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/20.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize collectionView;
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
    // Do any additional setup after loading the view.
    
    [self ParseData];
    
    
    //依照功能填好需要的資料（為之後可以動態產生collectionViewCell的部份作準備）
    
    _viewControllerArray = [[NSMutableArray alloc]init];
    
    viewControllerData * funcView = [[viewControllerData alloc]init];
    funcView.title =@"在我附近";
    funcView.imageName = @"placeholder8";
    NearByViewController * nearByViewController = [[NearByViewController alloc]initWithNibName:@"NearByViewController" bundle:nil];
    funcView.viewController = nearByViewController;
    funcView.nibName = @"NearByViewController";
    
    [_viewControllerArray addObject:funcView];
    
    funcView =[[viewControllerData alloc]init];
    funcView.title =@"緊急救護";
    funcView.imageName = @"first2";
    MedicalViewController * medicalViewController = [[MedicalViewController alloc]initWithNibName:@"MedicalViewController" bundle:nil];
    funcView.viewController = medicalViewController;
    funcView.nibName = @"MedicalViewController";
    
    [_viewControllerArray addObject:funcView];
    
    funcView =[[viewControllerData alloc]init];
    funcView.title =@"搜尋地點";
    funcView.imageName = @"search7";
    SearchViewController * searchViewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    funcView.viewController = searchViewController;
    funcView.nibName = @"SearchViewController";
    
    [_viewControllerArray addObject:funcView];
}

-(void)ParseData{
    NSString * url = [NSString stringWithFormat:@"http://odata.tn.edu.tw/tnsport.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSError *error;
    NSData *urldata =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSString* exerciseRawString = [[NSString alloc]initWithData:urldata encoding:NSUTF16LittleEndianStringEncoding];
    _array = [TLParseRawData ParseRawDataFromString:exerciseRawString];
    
    _dictionary = [[NSMutableDictionary alloc]init];
    for (Exercise *ex  in _array) {
        NSString * distriction = [[NSString alloc]init];
        if([ex.country isEqualToString:@""] && ![ex.city isEqualToString:@"台南市"]){
            distriction = ex.city;
        }else{
            distriction = ex.country;
        }
        
        if(![_dictionary objectForKey:distriction]){
            NSMutableArray * countryArray  =[[NSMutableArray alloc]init];
            [_dictionary setObject:countryArray forKey:distriction];
        }
        [_dictionary[distriction] addObject:ex];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
 

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _viewControllerArray.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView * cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyHeaderCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.638 green:0.906 blue:0.324 alpha:1.000];
    UILabel * myHeader = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 280, 40)];
    myHeader.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    myHeader.textColor = [UIColor whiteColor];
    myHeader.shadowColor = [UIColor colorWithWhite:0.450 alpha:0.800];
    myHeader.shadowOffset = CGSizeMake(1.0f, 1.0f);
    myHeader.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:myHeader];
    myHeader.text = @"~府城運動地圖~";
    return cell;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5.0f;
    UIImageView *image;
    UILabel * lab =[[UILabel alloc]init];
    lab.frame = CGRectMake(17, 75, 100, 17);
    lab.shadowColor =[UIColor colorWithWhite:0.450 alpha:0.800];
    lab.shadowOffset= CGSizeMake(1.0f, 1.0f);
    lab.textAlignment = UIControlContentVerticalAlignmentCenter;
    viewControllerData *func =_viewControllerArray[indexPath.row];
    lab.text = func.title;
    image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:func.imageName]];
    image.frame = CGRectMake(25,20,50,50);
    
    [cell addSubview:image];
    [cell addSubview:lab];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    viewControllerData * func = _viewControllerArray[indexPath.row];
//    func.viewController =[[NSClassFromString(func.nibName) alloc] init];
    func.viewController.delegate = self;
    func.viewController.array = _array;
    func.viewController.dic =_dictionary;
    
    [self presentViewController:func.viewController animated:YES completion:nil];
}

-(void)WithDelegateViewControllerDidClickDismissButton:(WithDelegateViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
