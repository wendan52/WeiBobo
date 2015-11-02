//
//  DetailCommentTableView.h
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboView.h"

@interface DetailCommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    //微博视图
    WeiboView *_weiboView;
    //头视图
    UIView *_headView;
}
@property(nonatomic,strong)NSArray *commentDataArray;
@property(nonatomic,strong)WeiboModel *weiboModel;
@property(nonatomic,strong)NSDictionary *commentDic;
@end
