//
//  CombBoxView.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-3.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CombBoxChoose.h"

#define SECTION_BTN_TAG_BEGIN   1000

@interface CombBoxView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSInteger currentExtendSection;
@property (nonatomic) int selectEventID;
@property (nonatomic) int selectPlaceID;

@property (nonatomic, strong) UIView *mSuperView;
@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, assign) id<CombBoxChooseDelegate> combBoxDelegate;
@property (nonatomic, assign) id<CombBoxChooseDataSource> combBoxDataSource;

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate;

@end
