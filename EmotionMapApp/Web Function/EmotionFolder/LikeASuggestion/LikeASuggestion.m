//
//  LikeASuggestion.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "LikeASuggestion.h"
#import "APIDelegate.h"

@implementation LikeASuggestion

@synthesize uID, lat, lng, deviceID, suggestionID;

- (void)likeASuggestion
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=likeSuggestion&parameter={ "
                       "\"device\":\"%@\", "
                       "\"lat\":%f, "
                       "\"lng\":%f, "
                       "\"suggestionId\":%d, " //must to have
                       "\"uid\":%d " //must to have
                       "}", deviceID, lat, lng, suggestionID, uID];
    
    NSString *url = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", url);
    
    NSURL *sendUrl = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:sendUrl];
    
    APIDelegate *apiRequest = [[APIDelegate alloc] init];
    [apiRequest addDelegate:self];
    
    (void)[[NSURLConnection alloc] initWithRequest:urlRequest delegate:apiRequest startImmediately:YES];
}


- (void)finishWithData:(NSData *)returnData
{
    NSLog(@"Response for liking a suggestion");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSArray *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
}

@end
