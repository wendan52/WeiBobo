//
//  ProfileHeadView.m
//  WeiBobo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ProfileHeadView.h"
#import "UIImageView+WebCache.h"
#import "FriendsListViewController.h"
#import "UIView+UIViewController.h"
#import "UserModel.h"
#import "AppDelegate.h"

@implementation ProfileHeadView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setWeiBo:(WeiboModel *)weiBo {
    _weiBo = weiBo;
    //头像
    NSURL *url = [NSURL URLWithString:_weiBo.userModel.avatar_large];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@" "]];
    //昵称
    self.name.text = _weiBo.userModel.name;
    //性别
    NSString *gender = @"女";
    if (![_weiBo.userModel.gender isEqualToString:@"f"]) {
        gender = @"男";
    }
    self.gend_location.text = [NSString stringWithFormat:@"%@ %@",gender,_weiBo.userModel.location];
    
    //简介
    //    _desLabel.text = _weiBo.userModel.description;
    self.desLabel.text = @"简介";
    
    //关注数
    self.friendsCountLabel.text = [_weiBo.userModel.friends_count stringValue];
    
    //粉丝数
    self.followersCountLabel.text = [_weiBo.userModel.followers_count stringValue];
}

- (IBAction)showFriends:(UIButton *)sender {
    //跳转关注列表
    FriendsListViewController *friendsVC = [[FriendsListViewController alloc]init];
    friendsVC.hidesBottomBarWhenPushed = YES;
    friendsVC.title = @"关注列表";
    friendsVC.urlString = friendships_friends;
    [self.viewController.navigationController pushViewController:friendsVC animated:YES];
    
}
- (IBAction)showFollowers:(UIButton *)sender {
    //跳转粉丝列表
    FriendsListViewController *friendsVC = [[FriendsListViewController alloc]init];
    friendsVC.hidesBottomBarWhenPushed = YES;
    friendsVC.title = @"粉丝列表";
    friendsVC.urlString = friendships_followers;
    [self.viewController.navigationController pushViewController:friendsVC animated:YES];
}


@end
