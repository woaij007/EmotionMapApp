//
//  GetNotification.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "GetNotification.h"
#import "APIDelegate.h"

@implementation GetNotification

@synthesize uID, lat, lng, deviceID, currentTime, notificationList;

- (void)getNotification
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=getNotifications&parameter={ "
                       "\"createtime\":%@, " //Get all of the notifications before current time
                       "\"device\":\"%@\", "
                       "\"lat\":%f, "
                       "\"lng\":%f, "
                       "\"uid\":%d "
                       "}", currentTime, deviceID, lat, lng, uID];
    
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
    NSLog(@"Response for getting notification");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSArray *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
    Notification *myNotification;
    notificationList = [[NSMutableArray alloc]init];
    for (NSDictionary *diction in data) {
        NSString *bottleID = [diction objectForKey:@"bottleid"];
        NSString *createTime = [diction objectForKey:@"createtime"];
        NSString *notificationDescription = [diction objectForKey:@"description"];
        NSString *ID = [diction objectForKey:@"id"];
        NSString *locationID = [diction objectForKey:@"locationid"];
        NSString *type = [diction objectForKey:@"type"];
        NSString *userID = [diction objectForKey:@"userid"];
        
        myNotification = [[Notification alloc]init];
        myNotification.bottleID = [bottleID intValue];
        myNotification.createTime = createTime;
        myNotification.ID = [ID intValue];
        myNotification.locationID = [locationID intValue];
        myNotification.type = [type intValue];
        myNotification.notificationDescription = notificationDescription;
        myNotification.userID = userID;
        
        [notificationList addObject:myNotification];
    }

}

@end
