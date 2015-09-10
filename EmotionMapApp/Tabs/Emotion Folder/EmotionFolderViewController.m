//
//  EmotionFolderViewController.m
//  EmotionMapApp
//
//  Created by wayne on 14-7-18.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "EmotionFolderViewController.h"
#import "EmotionFolderCell.h"
#import "RecommendTableViewCell.h"
#import "MyTabBarViewController.h"

static NSString *collectionCellIdentifier = @"EmotionFolderCell";
static NSString *tableViewCellIdentifier = @"RecommendCell";

@interface EmotionFolderViewController ()

@property (copy, nonatomic) NSArray *collectionImageArray;
@property (copy, nonatomic) NSArray *recommendImageArray;

@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;

- (IBAction)backToLastView:(id)sender;

@end

@implementation EmotionFolderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionImageArray = [NSArray arrayWithObjects:@"Alert", @"Excited", @"Elated", @"Happy",
                                 @"Calm", @"Relaxed", @"Serene", @"Contented",
                                 @"Tense", @"Nervous", @"Stressed", @"Upset",
                                 @"Fatigued", @"Bored", @"Depressed", @"Sad", nil];
    
    self.recommendImageArray = [NSArray arrayWithObjects:@"book", @"food", @"movie", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)[self.collectionImageArray count]);
    return [self.collectionImageArray count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmotionFolderCell *cell = (EmotionFolderCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.emotionLabel.textColor = [UIColor redColor];
    [self.recommendTableView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmotionFolderCell *cell = (EmotionFolderCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.emotionLabel.textColor = [UIColor whiteColor];
}

#pragma mark - CollectionView Datasource Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmotionFolderCell *cell = (EmotionFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    
    NSString *imageToLoad = [NSString stringWithFormat:@"orange_%@.png", self.collectionImageArray[indexPath.row]];
    cell.emotionImage.image = [UIImage imageNamed:imageToLoad];
    cell.emotionLabel.text = self.collectionImageArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recommendImageArray count];
}

#pragma mark - UITableView Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTableViewCell *cell = (RecommendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier forIndexPath:indexPath];
    
    NSString *imageToLoad = [NSString stringWithFormat:@"%@.png", self.recommendImageArray[indexPath.row]];
    cell.recommendCatIcon.image = [UIImage imageNamed:imageToLoad];
    cell.recommendContentLabel.text = @"This is a test!";
    [cell.recommendContentLabel sizeToFit];

    [cell.likeButton setImage:[UIImage imageNamed:@"grey_heart.png"] forState:UIControlStateNormal];
    [cell.likeButton setImage:[UIImage imageNamed:@"red_heart.png"] forState:UIControlStateSelected];
    [cell.likeButton addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - All object methods

// Change button select image.
- (void)checkBoxClick: (UIButton *)btn
{
    btn.selected = !btn.selected;
}

#pragma mark - All buttons action methods

// Cancel back to last view.
- (IBAction)backToLastView:(id)sender
{
    [self.tabBarController setSelectedIndex:((MyTabBarViewController *)self.tabBarController).lastSelectedIndex];
}

@end
