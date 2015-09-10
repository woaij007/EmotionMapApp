//
//  LoginToServer.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/17/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginToServer : NSObject

@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *middleName;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *deviceID;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *lastname;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userID;
@property (strong, nonatomic) NSMutableArray *friends;

-(void)loginToServer;

@end
