//
//  FriendsListViewController.h
//  WeiBobo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"

@interface FriendsListViewController : BaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SinaWeiboRequestDelegate>

@property(nonatomic,strong)NSString *urlString;
@end
