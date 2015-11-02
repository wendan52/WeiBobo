//
//  WeiboTableView.m
//  WeiBobo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiBoFrameLayout.h"
#import "WeiboDetailViewController.h"
#import "UIView+UIViewController.h"

@implementation WeiboTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        //注册单元格
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    }
    return self;
}

#pragma mark - TableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    WeiBoFrameLayout *layout = _data[indexPath.row];
    cell.layout = layout;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以提前算出高度,model
    WeiBoFrameLayout *layout = _data[indexPath.row];
    return  layout.frame.size.height + 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
    WeiBoFrameLayout *layout = _data[indexPath.row];
    detailVC.weiboModel = layout.model;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}
@end
