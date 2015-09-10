//
//  APIDelegate.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/18/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "APIDelegate.h"

@implementation APIDelegate

- (id)init {
    self = [super init];
    if(self != nil)
    {
        mDelegates = [NSMutableSet new];
        mData = [NSMutableData new];
    }
    return self;
}

- (void) addDelegate:(id)delegate {
    [mDelegates addObject:delegate];
}
- (void) removeDelegate:(id)delegate{
    [mDelegates removeObject:delegate];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mData appendData:data];
}

- (void) connectionDidFinishLoading : (NSURLConnection *) connection {
    SEL seltor = NSSelectorFromString(@"finishWithData:");
    NSSet * set = [[NSSet alloc] initWithSet:mDelegates];
    for (id del in set) {
        IMP imp = [del methodForSelector:seltor];
        void (*func)(id, SEL, NSData*) = (void*)imp;
        if ([del respondsToSelector:seltor])
            func(del,seltor,mData);
    }
}

@end
