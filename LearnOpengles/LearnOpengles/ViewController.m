//
//  ViewController.m
//  LearnOpengles
//
//  Created by gaojian on 2017/10/29.
//  Copyright © 2017年 gaojian. All rights reserved.
//

#import "ViewController.h"

static NSString *const kTableCellIdentifier = @"customTableCellIdentifier";
static NSString *const kTitleKey = @"title";
static NSString *const kControllerKey = @"controller";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
    self.dataArray = @[@{kTitleKey : @"session1", kControllerKey : @"SessionOneViewController"},
                       ];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row][kTitleKey];
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class class = NSClassFromString(self.dataArray[indexPath.row][kControllerKey]);
    UIViewController *vc = [[class alloc] init];
    vc.title = self.dataArray[indexPath.row][kTitleKey];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
