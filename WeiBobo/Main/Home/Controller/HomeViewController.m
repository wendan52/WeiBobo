//
//  HomeViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiBoFrameLayout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()<SinaWeiboRequestDelegate>
{
    WeiboTableView *_tableView;
    NSMutableArray *_data;
    ThemeImageView *_barImageView;
    ThemeLabel *_barLabel;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化data
    _data = [NSMutableArray array];
    
    [self _createTableView];
    //设置导航左右键
    [self setNavItem];
    //加载数据
    [self _loadData];
    
}

//创建tabelView
-(void)_createTableView {
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    //since_id:若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    //max_id:若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    //count:单页返回的记录条数，最大不超过100，默认为20。
    
    //添加下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_downRefresh)];
    
    //添加上拉加载
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_upRefresh)];
}

//加载数据
-(void)_loadData{
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegete.sinaWeibo;
    if (sinaWeibo.isLoggedIn) {
        [self showHud:@"正在加载..."];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 100;
        return;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
    
}

//下拉刷新
-(void)_downRefresh {
    
    AppDelegate *delegete=  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegete.sinaWeibo;
    //已经登陆
    if (sinaWeibo.isLoggedIn) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        
        if (_data.count != 0) {
            WeiBoFrameLayout *layout = _data[0];
            WeiboModel *model = layout.model;
            NSString *sinceId = model.weiboIdStr;
            [params setObject:sinceId forKey:@"since_id"];
        }
            
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 101;
        return;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}

//上拉加载
-(void)_upRefresh {
    AppDelegate *delegete=  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegete.sinaWeibo;
    //已经登陆
    if (sinaWeibo.isLoggedIn) {
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        if (_data.count != 0) {
            WeiBoFrameLayout *layout = [_data lastObject];
            WeiboModel *model = layout.model;
            NSString *maxId = model.weiboIdStr;
            [params setObject:maxId forKey:@"max_id"];
        }
        
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 102;
        return;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //解析数据
    NSArray *statusesArray = [result objectForKey:@"statuses"];
    NSMutableArray *layoutArray = [NSMutableArray array];
    for (NSDictionary *dic in statusesArray) {
        
        WeiboModel *weiBo = [[WeiboModel alloc] initWithDataDic:dic];
        WeiBoFrameLayout *layout = [[WeiBoFrameLayout alloc] init];
        layout.model = weiBo;
        [layoutArray addObject:layout];
    }
    
    //处理数据
    if (request.tag == 100) {
        //初始数据
        _data = layoutArray;
//        [self hidHud];
        [self completeHud:@"加载完成"];
        
    }else if (request.tag == 101){
        //更新
        NSRange range = NSMakeRange(0, layoutArray.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [_data insertObjects:layoutArray atIndexes:indexSet];
        //显示微博更新提醒
        [self showNewWeiboCount:layoutArray.count];
        
    }else if(request.tag == 102){
        //更多
        [_data removeLastObject];
        [_data addObjectsFromArray:layoutArray];
    }
    
    if (_data.count != 0) {
        _tableView.data = _data;
        [_tableView reloadData];
    }
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}


-(void)showNewWeiboCount:(NSInteger)count {
    
    if (_barImageView == nil) {
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.textAlignment = NSTextAlignmentCenter;
        
        [_barImageView addSubview:_barLabel];
    }
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64+40+5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
            }];
        }];
        
        //播放声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        //注册系统声音
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundId);
        AudioServicesPlaySystemSound(soundId);
    }
}


@end
