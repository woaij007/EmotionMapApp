//
//  SendEmotion.m
//  EmotionMapApp
//
//  Created by wayne on 14-7-8.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "SendEmotion.h"
#import "APIDelegate.h"

@implementation SendEmotion

@synthesize emotionID, eventID, placeID, level, anonymousFlag, lat, lng, sendText, idStr, address,responseText;

- (void)sendEmotionToServer
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=add&parameter={ "
                            "\"device\":\"065577820acc8ef8\", "
                            "\"idstr\":\"100007930481901,100007430075210,100007231501353,661149005,724130934,848845120,1085234071,1173644147,100000130793067100006283807652,100006588150856,166400861,506891389,12404593,100008006828530\", "
                            "\"lat\":%f, "
                            "\"lng\":%f, "
                            "\"location\":{ "
                                "\"address\":\"%@\", "
                                "\"anonymity\":%d, " // 0(no) or 1(yes)
                                "\"contactcount\":0, "
                                "\"description\":\"%@\", "
                                "\"eid\":%d, "
                                "\"eventId\":%d, "
                                "\"latitude\":%f, "
                                "\"level\":%d, "  // 3(public), 2(friend only), 1(private)
                                "\"longitude\":%f, "
                                "\"placeId\":%d, "
                                "\"uid\":1 "
                            "}, "
                            "\"uid\":1 "
                       "}", lat, lng, address, anonymousFlag, sendText, emotionID, eventID, lat, level, lng, placeID];
    
    NSString *url = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *sendUrl = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:sendUrl];
    
    APIDelegate *apiRequest = [[APIDelegate alloc] init];
    [apiRequest addDelegate:self];
    
    (void)[[NSURLConnection alloc] initWithRequest:urlRequest delegate:apiRequest startImmediately:YES];
}


- (void)finishWithData:(NSData *)returnData
{
    NSLog(@"Response for sending emotion");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSDictionary *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
    responseText = [data objectForKey:@"description"];
    NSLog(@"%@",responseText);
}
@end
