//
//  APIDelegate.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/18/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIDelegate : NSObject{

@private
NSMutableSet *mDelegates;
NSMutableData *mData;
}

- (void) addDelegate:(id)delegate;
- (void) removeDelegate:(id)delegate;

@end
