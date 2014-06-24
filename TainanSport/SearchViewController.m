//
//  SearchViewController.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/22.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    
    _myTableView.dataSource =self;
    _myTableView.delegate =self;
    _mySearchBar.delegate = self;
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

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.title contains[cd] %@",
                                    searchText];
    
    _searchResult = [self.array filteredArrayUsingPredicate:resultPredicate];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView ==self.searchDisplayController.searchResultsTableView) {
        return [_searchResult count];
    }else{
        return self.array.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
    
    Exercise * ex;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ex = _searchResult[indexPath.row];
    } else {
        ex = self.array[indexPath.row];
    }
    cell.textLabel.text = ex.title;
    cell.detailTextLabel.text = ex.address;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Exercise * _currentExercise;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _currentExercise = _searchResult[indexPath.row];
    } else {
        _currentExercise = self.array[indexPath.row];
    }
    
    UIView * subView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 300, 530)];
    subView.backgroundColor = [UIColor colorWithRed:0.928 green:0.793 blue:0.710 alpha:0.900];
    [self.view addSubview:subView];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 260, 40)];
    title.font = [UIFont fontWithName:@"Helvetica" size:22.0];
    title.shadowColor = [UIColor grayColor];
    title.shadowOffset = CGSizeMake(0.8, 0.8);
    title.text =  [NSString stringWithFormat:@"%@",_currentExercise.title];
    title.backgroundColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.cornerRadius = 10.0f;
    UITextView *  opentime = [[UITextView alloc]initWithFrame:CGRectMake(20, 70, 280, 120)];
    opentime.text =  [NSString stringWithFormat:@"開放時間: %@",_currentExercise.opentime];
    opentime.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    opentime.editable = NO;
    opentime.backgroundColor = [UIColor clearColor];
    
    _myMapView = [[MKMapView alloc]initWithFrame:CGRectMake(10, 200, 280, 200)];
    _myMapView.showsUserLocation = YES;
    _myMapView.delegate = self;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([_currentExercise.lat doubleValue], [_currentExercise.lon doubleValue]);
    MKAnnonation * annonation = [[MKAnnonation alloc]initWithLocaton:coord];
    annonation.title = _currentExercise.title;
    annonation.subtitle = _currentExercise.address;
    _currentMKA = annonation;
    [_myMapView addAnnotation:annonation];
    
    MKCoordinateRegion TargetRegion;
    TargetRegion.center = coord;
    TargetRegion.span.latitudeDelta =  0.01;
    TargetRegion.span.longitudeDelta = 0.01;
    [_myMapView setRegion:TargetRegion];
    
    [subView addSubview:_myMapView];
    
    UIButton * closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake( 10, 470, 280, 50);
    [closeButton setTitle:@"關閉" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor colorWithRed:0.059 green:0.125 blue:0.759 alpha:1.000];
    [closeButton addTarget:self action:@selector(closePOPWindowTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * NavButton =[UIButton buttonWithType:UIButtonTypeCustom];
    NavButton.frame = CGRectMake( 10, 410, 280, 50);
    [NavButton setTitle:@"帶我去這裡" forState:UIControlStateNormal];
    NavButton.backgroundColor = [UIColor colorWithRed:0.179 green:0.806 blue:0.064 alpha:1.000];
    [NavButton addTarget:self action:@selector(NativeTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView beginAnimations:@"textView" context:nil];
    [UIView setAnimationDuration:1];
    
    [subView addSubview:title];
    [subView addSubview:opentime];
    [subView addSubview:NavButton];
    [subView addSubview:closeButton];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f ;   //時間間隔
    animation.fillMode = kCAFillModeForwards ;
    animation.type = kCATransitionMoveIn;   //動畫效果
    animation.subtype = kCATransitionFromBottom ;   //動畫方向
    [subView.layer addAnimation :animation forKey : @"animation" ];
    
    [UIView commitAnimations];
}
-(void)closePOPWindowTapped:(id)sender event:(id)event{
    [self.view.subviews[self.view.subviews.count-1] removeFromSuperview];
}
-(void)NativeTapped:(id)sender event:(id)event{
    [self callAppleMap];
}
-(void)callAppleMap{
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey :
                                  MKLaunchOptionsDirectionsModeWalking
                              };
    
	MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:_myMapView.userLocation.location.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"現在位置"];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:_currentMKA.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:_currentMKA.title];
    
    NSArray *directionsItems = @[srcMapItem, distMapItem];
    [MKMapItem openMapsWithItems:directionsItems launchOptions:options];
}
@end
