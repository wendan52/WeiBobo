//
//  WeiboDetailViewController.h
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"

@interface WeiboDetailViewController : BaseViewController

@property (nonatomic,strong) WeiboModel *weiboModel;
//评论列表数据
@property(nonatomic,strong)NSMutableArray *data;
@end
