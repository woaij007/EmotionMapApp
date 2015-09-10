//
//  SendHugOrComment.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "SendHugOrComment.h"
#import "APIDelegate.h"

@implementation SendHugOrComment

@synthesize followType, uID, locationID, lat, lng, deviceID, idStr, sendText, userName;

- (void)sendHugOrComment
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=addFollow&parameter={ "
                       "\"comment\":\"%@\", " // content of comment
                       "\"device\":\"%@\", "
                       "\"followtype\":%d, " // 1：add a hug 2: add a comment
                       "\"idStr\":\"%@\", "
                       "\"lat\":%f, "
                       "\"lng\":%f, "
                       "\"locationid\":%d, "
                       "\"username\":\"%@\", " //must to have
                       "\"uid\":%d "
                       "}", sendText, deviceID, followType, idStr, lat, lng, locationID, userName, uID];
    
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
    NSLog(@"Response for sending hug or comment");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSArray *data = [alldata objectForKey:@"message"];
    NSLog(@"%@",data);
    // Parse data here
}


@end
