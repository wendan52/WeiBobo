//
//  WeiboTableView.h
//  WeiBobo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *data;
@end
