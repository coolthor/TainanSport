//
//  TLJSONParse.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/14.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "TLJSONParse.h"

@implementation TLJSONParse

+(NSMutableArray *)ParseJSONUrlString:(NSString *)url{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSDictionary * _dic = [[NSDictionary alloc]init];
    NSURL *jsonUrl =[NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonUrl];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error;
//    NSLog(@"%@",data);
    _dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@",error);
    for (NSObject * o in _dic.allKeys) {
        [array addObject:o];
    }
    return array;
}

@end
