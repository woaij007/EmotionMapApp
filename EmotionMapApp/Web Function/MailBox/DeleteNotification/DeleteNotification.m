//
//  DeleteNotification.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "DeleteNotification.h"
#import "APIDelegate.h"

@implementation DeleteNotification

@synthesize uID, lat, lng, deviceID, nID, deleteResut;

- (void)deleteNotification
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=deleteNotification&parameter={ "
                       "\"device\":\"%@\", "
                       "\"lat\":%f, "
                       "\"lng\":%f, "
                       "\"nid\":%d, " // the notification id
                       "\"uid\":%d "
                       "}", deviceID, lat, lng, nID, uID];
    
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
    NSLog(@"Response for deleting notification");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSDictionary *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
    NSString *deleteResult = [data objectForKey:@"result"];
    self.deleteResut = [deleteResult intValue];
}
@end
