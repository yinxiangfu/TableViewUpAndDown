//
//  ViewController.m
//  下拉控制Demo
//
//  Created by yinxiangfu on 16/6/3.
//  Copyright © 2016年 xiangfu. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>

static CGFloat topHeight = 200.0f;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topHeight)];
    v.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:v];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topHeight, self.view.frame.size.width, self.view.frame.size.height-topHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
    self.tableView = tableView;

}

- (void)upRefresh
{
    [self.tableView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"----->%ld<-----", indexPath.row+1];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = self.view.bounds;
    CGFloat scorY = scrollView.contentOffset.y;

    if (rect.origin.y <= 0) {
        rect.origin.y = 0;
        self.view.bounds = rect;
        if (scorY < 0) return;
    }
    else if (rect.origin.y >= topHeight){
        rect.origin.y = topHeight;
        self.view.bounds = rect;
        if (scorY > 0) return;
    }

    //保存上次上拉距离
    rect.origin.y += scorY;
    self.view.bounds = rect;
    
    //设置tableView高度
    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.size.height = self.view.frame.size.height-topHeight+rect.origin.y;
    self.tableView.frame = tableViewRect;
    
    //滚动到底部
    self.tableView.contentOffset = CGPointZero;
}

@end
