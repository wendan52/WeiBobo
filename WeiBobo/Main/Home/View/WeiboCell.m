//
//  WeiboCell.m
//  WeiBobo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"

@implementation WeiboCell

- (void)awakeFromNib {
    [self _createSubView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)_createSubView {
    _weiboView = [[WeiboView alloc] init];
    [self.contentView addSubview:_weiboView];
}

-(void)setLayout:(WeiBoFrameLayout *)layout {
    if (_layout != layout) {
        _layout = layout;
        _weiboView.layout = _layout;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboModel *_model = _layout.model;
    //头像
    NSURL *url = [NSURL URLWithString:_model.userModel.profile_image_url];
    [_headImageView sd_setImageWithURL:url];
    //昵称
    _userName.text = _model.userModel.screen_name;
    //转发数
    _relayNumber.text = [NSString stringWithFormat:@"转发:%li",[_model.repostsCount integerValue]];
    //评论数
    _commentNumber.text = [NSString stringWithFormat:@"评论:%li",[_model.commentsCount integerValue]];
    //来源
    _sourceLabel.text = _model.source;
    
    //对weiboView 进行布局 显示
    _weiboView.frame = _layout.frame;
}

@end
