//
//  CombBoxView.m
//  EmotionMapApp
//
//  Created by wayne on 14-7-3.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "CombBoxView.h"
#import <QuartzCore/QuartzCore.h>

static NSInteger sectionInset = 10;

@implementation CombBoxView

@synthesize selectEventID, selectPlaceID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.currentExtendSection= -1;
        self.combBoxDelegate = delegate;
        self.combBoxDataSource = datasource;
        
        NSInteger sectionNum = 0;
        if ([self.combBoxDataSource respondsToSelector:@selector(numberOfSections)] )
            sectionNum = [self.combBoxDataSource numberOfSections];
        
        if (sectionNum == 0)
            self = nil;
        
        // Initialize the table view
        CGFloat sectionWidth = (1.0 * frame.size.width) / sectionNum - sectionInset;
        for (int i=0; i<sectionNum; i++) {
            UIButton *sectionButton = [[UIButton alloc] initWithFrame:CGRectMake(i * sectionWidth + 2 * i * sectionInset, 0, sectionWidth, frame.size.height)];
            
            // Set button respond.
            [sectionButton addTarget:self action:@selector(sectionButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            // Set button initialize tetxt.
            NSString *title = @"";
            if ([self.combBoxDataSource respondsToSelector:@selector(titleInSection:index:)]) {
                title = [self.combBoxDataSource titleInSection:i index:[self.combBoxDataSource defaultShowSection:i]];
            }
            [sectionButton setTitle:title forState:UIControlStateNormal];
            [sectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [sectionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            sectionButton.titleLabel.font = [UIFont systemFontOfSize:14];
            sectionButton.tag = SECTION_BTN_TAG_BEGIN + i;
            [self addSubview:sectionButton];
            
            // Set button image right.
            UIImageView *sectionButtonImage = [[UIImageView alloc]
                                               initWithFrame:CGRectMake(i * sectionWidth + 2 * i * sectionInset + (sectionWidth - 8), (self.frame.size.height - 10) / 2, 12, 12)];
            [sectionButtonImage setImage:[UIImage imageNamed:@"down_dark.png"]];
            [sectionButtonImage setContentMode:UIViewContentModeScaleToFill];
            sectionButtonImage.tag = i;
            [self addSubview: sectionButtonImage];
            
            // Set border.
            UIView *baseLineView = [[UIView alloc] initWithFrame:CGRectMake(i * sectionWidth + 2 * i * sectionInset, frame.size.height - 7, sectionWidth, 1)];
            baseLineView.backgroundColor = [UIColor blackColor];
            [self addSubview:baseLineView];
        }
        
    }
    return self;
}

- (void)sectionButtonTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    if (self.currentExtendSection == section)
        [self hideExtendedChooseView];
    else {
        self.currentExtendSection = section;
        [self showChooseListViewInSection:self.currentExtendSection choosedIndex:[self.combBoxDataSource defaultShowSection:self.currentExtendSection]];
    }
}

// Judge if show the combBox list.
- (BOOL)isShow
{
    if (self.currentExtendSection == -1)
        return NO;
    return YES;
}

// Hide the combBox list when select a table cell.
- (void)hideExtendedChooseView
{
    if (self.currentExtendSection != -1) {
        self.currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableView.alpha = 1.0f;
            self.mTableView.alpha = 0.2;
            self.mTableView.frame = rect;
        } completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
        }];
    }
}

- (void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height - 3, 0, 0) style:UITableViewStylePlain];
        self.mTableView.layer.borderWidth = 1;
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
    }
    
    // Set the frame of tableView.
    int sectionWidth = (self.frame.size.width) / [self.combBoxDataSource numberOfSections] - sectionInset;
    CGRect rect = self.mTableView.frame;
    rect.origin.x = 20 + section * (sectionWidth + 2 * sectionInset);
    rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.mTableView.frame = rect;
    [self.mSuperView addSubview:self.mTableView];
    
    // Move the UITableView to make CGRect frame visible.
    [self.mTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    // Set the animation.
    rect .size.height = 115;
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableView.alpha = 0.2;
        self.mTableView.alpha = 1.0;
        self.mTableView.frame = rect;
    }];
    
    [self.mTableView reloadData];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.combBoxDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
        NSString *chooseCellTitle = [self.combBoxDataSource titleInSection:self.currentExtendSection index:indexPath.row];
        
        UIButton *currentSectionButton = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + self.currentExtendSection];
        [currentSectionButton setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        [self.combBoxDelegate chooseAtSection:self.currentExtendSection index:indexPath.row];
        
        if (self.currentExtendSection == 0)
            selectPlaceID = indexPath.row;
        else if (self.currentExtendSection == 1)
            selectEventID = indexPath.row;
        
        [self hideExtendedChooseView];
    }
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.combBoxDataSource numberOfRowsInSection:self.currentExtendSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.combBoxDataSource titleInSection:self.currentExtendSection index:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
