//
//  DetailCell.m
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "DetailCell.h"
#import "WXLabel.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation DetailCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _contentLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.linespace = 5;
        _contentLabel.wxLabelDelegate = self;
        [self.contentView addSubview:_contentLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //头像
    NSString *urlString = _commentModel.user.profile_image_url;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //昵称
    _nameLabel.text = _commentModel.user.screen_name;
    //评论内容
    CGFloat height = [WXLabel getTextHeight:14
                                      width:240
                                       text:_commentModel.text
                                  linespace:5];
    _contentLabel.frame = CGRectMake(_headerImageView.right+10, _nameLabel.bottom+5, kScreenWidth-70, height);
    _contentLabel.text = _commentModel.text;
}

- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//链接字体颜色
-(UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    UIColor *linkColor = [[ThemeManager sharInstance] getThemeColor:@"Link_color"];
    return linkColor;
}

//手指经过颜色
-(UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor grayColor];
}

//计算文档高度
+ (float)getCommentHeight:(CommentModel *)commentModel{
    CGFloat height = [WXLabel getTextHeight:14
                                      width:kScreenWidth-70
                                       text:commentModel.text
                                  linespace:5];
    return height+40;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
