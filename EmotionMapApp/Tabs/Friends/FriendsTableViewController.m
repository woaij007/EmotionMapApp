//
//  FriendsTableViewController.m
//  EmotionMapApp
//
//  Created by wayne on 14-6-30.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "FriendsTableViewController.h"

static NSString *friendsTableCell = @"FriendsCell";

@interface FriendsTableViewController ()

@property (copy, nonatomic) NSDictionary *names;
@property (copy, nonatomic) NSMutableArray *keys;

@end

@implementation FriendsTableViewController
{
    NSMutableArray *filterNames;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestName" ofType:@"plist"];
    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.names allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    filterNames = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    if (tableView.tag == 1)
        return [self.keys count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if (tableView.tag == 1) {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.names[key];
        return [nameSection count];
    }
    return [filterNames count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1)
        return self.keys[section];
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsTableCell forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (tableView.tag == 1) {
        NSString *key = self.keys[indexPath.section];
        NSArray *nameSection = self.names[key];
    
        cell.textLabel.text = nameSection[indexPath.row];
    }
    else {
        cell.textLabel.text = filterNames[indexPath.row];
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 1)
        return self.keys;
    return  nil;
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


#pragma mark - UISearchBar Delegate
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:friendsTableCell];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filterNames removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *name, NSDictionary *b) {
        NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
        return range.location != NSNotFound;
    }];
    
    for (NSString *key in self.keys) {
        NSArray *matches = [self.names[key] filteredArrayUsingPredicate:predicate];
        [filterNames addObjectsFromArray:matches];
    }
    return YES;
}

@end
