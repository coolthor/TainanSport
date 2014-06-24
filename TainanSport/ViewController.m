//
//  ViewController.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/14.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dictionary[_dictionary.allKeys[section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dictionary.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _dictionary.allKeys[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    Exercise * ex = (Exercise *)_array[indexPath.row];
    cell.textLabel.text = ex.title;
    cell.detailTextLabel.text = ex.address;
    return cell;
}
@end
