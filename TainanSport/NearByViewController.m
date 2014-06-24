//
//  NearByViewController.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/21.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "NearByViewController.h"

@interface NearByViewController ()

@end

@implementation NearByViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)showCurrentLoc:(id)sender {
    MKCoordinateRegion currentRegion;
    currentRegion.center = _myMapView.userLocation.location.coordinate;
    currentRegion.span.latitudeDelta =  0.01;
    currentRegion.span.longitudeDelta = 0.01;
    [_myMapView setRegion:currentRegion];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myMapView.showsUserLocation = YES;
    _myMapView.delegate = self;
    _IsFirstinitLocate = YES;
    
}



- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    if(_IsFirstinitLocate){
        MKCoordinateRegion currentRegion;
        currentRegion.center = _myMapView.userLocation.location.coordinate;
        currentRegion.span.latitudeDelta =  0.01;
        currentRegion.span.longitudeDelta = 0.01;

        for (Exercise  * ex in self.array) {
            //計算與現有地距離
            CLLocation * targetLocation = [[CLLocation alloc]initWithLatitude:[ex.lat doubleValue] longitude:[ex.lon doubleValue]];
            double distanceMeter = [targetLocation distanceFromLocation:_myMapView.userLocation.location];
            ex.distance = distanceMeter;
        }
        
        //sorting
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        _sortedArray = [self.array sortedArrayUsingDescriptors:sortDescriptors];
        
        for (int i = 0 ; i<300; i++) {
            Exercise * ex = _sortedArray[i];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([ex.lat doubleValue], [ex.lon doubleValue]);
            MKAnnonation * annonation = [[MKAnnonation alloc]initWithLocaton:coord];
            annonation.title = ex.title;
            annonation.subtitle = ex.address;
            [_myMapView addAnnotation:annonation];
        }

        [_myMapView setRegion:currentRegion];
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 250, 320, 250) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate =self;
        _IsFirstinitLocate = NO;
        
        [self.view addSubview:_myTableView];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickDismiss:(id)sender {
    if ( self .delegate && [ self .delegate respondsToSelector: @selector (WithDelegateViewControllerDidClickDismissButton:)]) {
        [self.delegate WithDelegateViewControllerDidClickDismissButton:self];
    }
}

-(void)WithDelegateViewControllerDidClickDismissButton:(WithDelegateViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 300;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor colorWithRed:0.400 green:1.000 blue:0.568 alpha:1.000];
    }
    Exercise *ex = _sortedArray[indexPath.row];
    cell.textLabel.text = ex.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"距離%d公尺",(int)ex.distance];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Exercise *ex = _sortedArray[indexPath.row];
    MKCoordinateRegion currentRegion;
    currentRegion.span.latitudeDelta =  0.01;
    currentRegion.span.longitudeDelta = 0.01;

    currentRegion.center.latitude = [ex.lat doubleValue];
    currentRegion.center.longitude = [ex.lon doubleValue];

    [_myMapView setRegion:currentRegion];

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([ex.lat doubleValue], [ex.lon doubleValue]);
    
    for (int i = 0 ; i< _myMapView.annotations.count; i++) {
        MKAnnonation * mka = _myMapView.annotations[i];
        if (mka.coordinate.longitude == coord.longitude &&mka.coordinate.latitude == coord.latitude && mka.title == ex.title) {
            [_myMapView selectAnnotation:_myMapView.annotations[i] animated:YES];
            break;
        }
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    _currentMKA = view.annotation;
    for (Exercise *ex in _sortedArray) {
        if ([ex.lat doubleValue] == _currentMKA.coordinate.latitude &&[ex.lon doubleValue] == _currentMKA.coordinate.longitude && ex.title==_currentMKA.title) {
            _currentExercise = ex;
            break;
        }
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

	MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
	newAnnotation.pinColor = MKPinAnnotationColorPurple;
	newAnnotation.animatesDrop = YES;
	//canShowCallout: to display the callout view by touch the pin
	newAnnotation.canShowCallout=YES;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	newAnnotation.rightCalloutAccessoryView=button;
    
	return newAnnotation;
}

- (void)checkButtonTapped:(id)sender event:(id)event{
    
    UIView * subView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 300, 530)];
    subView.backgroundColor = [UIColor colorWithRed:0.888 green:0.666 blue:0.428 alpha:0.710];
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
