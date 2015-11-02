//
//  FriendsListCell.m
//  WeiBobo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "FriendsListCell.h"
#import "UIImageView+WebCache.h"

@implementation FriendsListCell

- (void)awakeFromNib {
}

-(void)setModel:(UserModel *)model {
    if (_model != model) {
        _model = model;
        
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.masksToBounds = YES;
        //读值
        //1.头像
        NSString *urlString = _model.avatar_large;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"icon@3x"]];
        
        //2.名称
        _nameLabel.text = _model.name;
        //3.粉丝数
        _followersLable.text = [NSString stringWithFormat:@"%@粉丝",_model.followers_count];
    }
}

@end
