//
//  ProfileHeadView.h
//  WeiBobo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "SinaWeibo.h"

@interface ProfileHeadView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *gend_location;
@property (strong, nonatomic) IBOutlet UILabel *desLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followersCountLabel;

@property(nonatomic,strong)WeiboModel *weiBo;
//followers_count	int	粉丝数
//friends_count	int	关注数
- (IBAction)showFriends:(UIButton *)sender;
- (IBAction)showFollowers:(UIButton *)sender;

@end
