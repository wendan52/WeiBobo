//
//  FriendsListCell.h
//  WeiBobo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface FriendsListCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *followersLable;

@property (nonatomic,strong)UserModel *model;
@end
