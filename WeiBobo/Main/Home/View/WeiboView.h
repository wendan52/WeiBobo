//
//  WeiboView.h
//  WeiBobo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoFrameLayout.h"
#import "ThemeImageView.h"
#import "WXLabel.h"
#import "ZoomImageView.h"

@interface WeiboView : UIView<WXLabelDelegate>

@property (nonatomic,strong)WXLabel *textLabel;//微博文字
@property (nonatomic,strong)WXLabel *sourceLabel;//如果转发则：原微博文字
@property (nonatomic,strong)ZoomImageView  *imgView;// 微博图片
@property (nonatomic,strong)ThemeImageView *bgImageView;//原微博背景图片
@property (nonatomic,strong)WeiBoFrameLayout *layout;

@end
