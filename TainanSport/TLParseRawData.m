//
//  TLParseRawData.m
//  TainanSport
//
//  Created by Thor Lin on 2014/6/14.
//  Copyright (c) 2014年 Thor Lin. All rights reserved.
//

#import "TLParseRawData.h"

@implementation TLParseRawData
+(NSMutableArray *) ParseRawDataFromString:(NSString *)RawString{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSRange range = [RawString rangeOfString:@"\"table\": ["];
    NSInteger datalength = RawString.length - (range.location+ range.length)-1;
    NSString *datastr =[RawString substringWithRange:NSMakeRange(range.location+range.length, datalength)];
    
    NSArray *strArray = [datastr componentsSeparatedByString:@"["];
    NSMutableArray * modifyArray = [[NSMutableArray alloc]init];
    
    for(int i =0 ;i<strArray.count ;i++){
        
        NSString * curstr = [strArray[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"{" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"]" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"," withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"\"-name\"" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"\"#text\"" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        curstr = [curstr stringByReplacingOccurrencesOfString:@"\"x50c_addresses_links\"\"column\":" withString:@""];
        if([curstr rangeOfString:@"lid"].length != 0){
            [modifyArray addObject:curstr];
        }
    }
    
    NSMutableArray * keyWord = [NSMutableArray arrayWithObjects:@"lid",@"cid",@"title",@"address",@"zip",@"city",@"country",@"lon",@"city",@"country",@"lon",@"lat",@"zoom",@"phone",@"mobile",@"fax",@"contemail",@"opentime",@"logourl",@"submitter",@"status",@"date",@"hits",@"rating",@"votes",@"comments",nil];
    
    for (NSString *str in modifyArray) {
        NSArray * detailarray = [str componentsSeparatedByString:@":"];
        Exercise * ex  = [[Exercise alloc]init];
        for (int i =0; i<detailarray.count; i++) {
            if([keyWord containsObject:detailarray[i]]){
                if ([detailarray[i] isEqualToString:@"opentime"]) {
                    NSString * opentime =@"";
                    
                    for (int j = i+1; j<detailarray.count; j++) {
                        if (![keyWord containsObject:detailarray[j]]) {
                            if ([opentime isEqualToString:@""]) {
                                opentime = (NSString *)detailarray[j];
                            }else{
                                opentime = [NSString stringWithFormat:@"%@:%@",opentime,(NSString *)detailarray[j]];
                            }
                            i++;
                        }else{
                            [ex setValue:opentime forKey:@"opentime"];
                            break;
                        }
                        
                    }
                }else if(![keyWord containsObject:detailarray[i+1]]){
                    [ex setValue:detailarray[i+1] forKey:detailarray[i]];
                    i++;
                }else{
                    [ex setValue:@"" forKey:detailarray[i]];
                }
            }
        }
        
        [array addObject:ex];
    }
    
//    NSLog(@"array count:%lu",(unsigned long)array.count);
    return array;
}
@end
