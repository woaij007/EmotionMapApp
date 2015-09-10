//
//  CombBoxChoose.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-3.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CombBoxChooseDelegate <NSObject>

@optional
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index;

@end

@protocol CombBoxChooseDataSource <NSObject>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSString *)titleInSection:(NSInteger)section index:(NSInteger) index;
- (NSInteger)defaultShowSection:(NSInteger)section;

@end