//
//  ProfileViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIViewExt.h"
#import "WeiBoFrameLayout.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "WeiboTableView.h"
#import "ProfileHeadView.h"
#import "MJRefresh.h"

@interface ProfileViewController ()<SinaWeiboRequestDelegate>
{
    WeiboTableView *_tableView;
    WeiboModel *_weiBo;
    ProfileHeadView *_headView;
    NSMutableArray *_data;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _getData];
    [self _createTableView];
}

-(void)_getData {
    
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:@"count"];
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:user_timeline
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    request.tag = 100;
}
//加载最新数据
-(void)_loadNewData {
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:@"count"];
    
    if (_data.count != 0) {
        WeiBoFrameLayout *layout = _data[0];
        WeiboModel *model = layout.model;
        NSString *sinceId = model.weiboIdStr;
        [params setObject:sinceId forKey:@"since_id"];
    }
    
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:user_timeline
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    request.tag = 102;
}


//加载更多数据
-(void)loadMoreData {
    
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:@"count"];
    
    if (_data.count > 0) {
    WeiBoFrameLayout *layout = [_data lastObject];
    WeiboModel *model = layout.model;
    [params setObject:model.weiboIdStr forKey:@"max_id"];
    }
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:user_timeline
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    request.tag = 101;
}

-(SinaWeibo *)sinaWeibo {
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegete.sinaWeibo;
    return sinaWeibo;
}

-(void)_createTableView {
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeadView" owner:nil options:nil] lastObject];
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.tableHeaderView = _headView;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //解析数据
    NSArray *statusesArray = [result objectForKey:@"statuses"];
    NSMutableArray *weiboArray = [NSMutableArray array];
    for (NSDictionary *dic in statusesArray) {
        _weiBo = [[WeiboModel alloc] initWithDataDic:dic];
        WeiBoFrameLayout *layout = [[WeiBoFrameLayout alloc] init];
        layout.model = _weiBo;
        [weiboArray addObject:layout];
    }
    _headView.weiBo = _weiBo;
    if (request.tag == 100) {
        _data = weiboArray;
    }else if (request.tag == 101){
        if (_data == nil) {
            _data = weiboArray;
        }else {
            [_data removeLastObject];
            [_data addObjectsFromArray:weiboArray];
        }
    }else if (request.tag == 102){
        
    }
    if (_data.count != 0) {
        _tableView.data = _data;
        [_tableView reloadData];
    }
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}


@end
