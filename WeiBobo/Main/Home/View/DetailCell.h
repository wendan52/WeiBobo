//
//  DetailCell.h
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CommentModel.h"

@interface DetailCell : UITableViewCell<WXLabelDelegate>
{
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_headerImageView;
    WXLabel *_contentLabel;
}

@property(nonatomic ,strong)CommentModel *commentModel;

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
