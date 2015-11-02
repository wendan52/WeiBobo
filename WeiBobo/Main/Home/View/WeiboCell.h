//
//  WeiboCell.h
//  WeiBobo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiBoFrameLayout.h"

@interface WeiboCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *relayNumber;
@property (strong, nonatomic) IBOutlet UILabel *commentNumber;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property(nonatomic,strong)WeiboView *weiboView;
//@property(nonatomic,strong)WeiboModel *model;
@property(nonatomic,strong)WeiBoFrameLayout *layout;
@end
