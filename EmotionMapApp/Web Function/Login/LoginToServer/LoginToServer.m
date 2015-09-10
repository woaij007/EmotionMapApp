//
//  LoginToServer.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/17/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "LoginToServer.h"

@implementation LoginToServer
{
    NSMutableData *allData;
    NSURLConnection *connection;
}

@synthesize lat, lng, userName, middleName, birthday, deviceID, email, firstName, gender, lastname, link, name, userID,friends;

-(void)loginToServer
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/user/information.do?method=login&parameter={ "
                       "\"username\":%@, "
                       "\"middlename\":%@, "
                       "\"birthday\":\"%@\", "
                       "\"device\":\"%@\", "
                       "\"deviceid\":\"%@\", "
                       "\"email\":\"%@\", "
                       "\"firstname\":\"%@\", "
                       "\"gender\":\"%@\", "
                       "\"lastname\":\"%@\", "
                       "\"lat\":%f, "
                       "\"link\":\"%@\", "
                       "\"lng\":%f, "
                       "\"name_\":\"%@\", "
                       "\"userid\":\"%@\", "
                       "\"friends\":%@ "
                       "}", userName, middleName, birthday, deviceID, deviceID, email, firstName, gender, lastname, lat, link, lng, name, userID, friends];
    
    NSString *url = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", url);
    
    NSURL *sendUrl = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:sendUrl];
    connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    if(connection)
    {
        allData = [[NSMutableData alloc]init];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [allData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [allData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Response for login to server");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:allData options:0 error:nil];
    NSLog(@"%@",alldata);
    NSArray *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
}

@end
