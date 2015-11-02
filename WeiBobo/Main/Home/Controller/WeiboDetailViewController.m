//
//  WeiboDetailViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "DetailCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "CommentModel.h"
#import "DetailCommentTableView.h"
#import "MJRefresh.h"

@interface WeiboDetailViewController ()<SinaWeiboRequestDelegate>
{
    DetailCommentTableView *_tableView;
    SinaWeiboRequest *_request;
}
@end

@implementation WeiboDetailViewController

//-(id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        NSLog(@"1");
//    }
//    return self;
//}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _getData];
    [self _createTabelView];
    
}

//获取评论数据
-(void)_getData {
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_weiboModel.weiboIdStr forKey:@"id"];
    _request = [sinaWeibo requestWithURL:comments
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    _request.tag = 100;
}

//加载更多数据
-(void)_loadMoreData {
    
    
//    NSString *weiboId = [self.weiboModel.weiboId stringValue];
    NSString *weiboId = self.weiboModel.weiboIdStr;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:weiboId forKey:@"id"];
    
    //分页加载
    CommentModel *cm = [self.data lastObject];
    if (cm == nil) {
        return;
    }
    NSString *lastId = cm.idstr;
    [params setObject:lastId forKey:@"max_id"];
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request = [sinaWeibo requestWithURL:comments
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    _request.tag = 101;
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeibo;
}

//创建tableView
-(void)_createTabelView {
    _tableView = [[DetailCommentTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.weiboModel = self.weiboModel;
    [self.view addSubview:_tableView];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
}


#pragma mark - SinaWeibo 代理
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{

    NSArray *array = [result objectForKey:@"comments"];
    NSMutableArray *commentArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dataDic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dataDic];
        [commentArray addObject:commentModel];
    }
    if (request.tag == 100) {
        self.data = commentArray;
    }else if (request.tag == 101){
        [_tableView.footer endRefreshing];
        if (commentArray.count > 1) {
            [commentArray removeObjectAtIndex:0];
            [self.data addObjectsFromArray:commentArray];
        }
    }else{
        return;
    }
    _tableView.commentDataArray = self.data;
    _tableView.commentDic = result;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
