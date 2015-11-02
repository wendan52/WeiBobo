//
//  CommentModel.m
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "CommentModel.h"
#import "RegexKitLite.h"

@implementation CommentModel

-(void)setAttributes:(NSDictionary *)dataDic {
    
    [super setAttributes:dataDic];
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    self.user = user;
    
    NSDictionary *status = [dataDic objectForKey:@"status"];
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:status];
    self.weibo = weibo;
    
    NSDictionary *commentDic = [dataDic objectForKey:@"reply_comment"];
    if (commentDic != nil) {
        CommentModel *sourceComment = [[CommentModel alloc] initWithDataDic:commentDic];
        self.sourceComment = sourceComment;
    }
    
    //－－－－表情处理－－－－－
    //[兔子]
    NSString *regxt = @"\\[\\w+\\]";
    NSArray *faceItems = [_text componentsMatchedByRegex:regxt];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceConfigArray = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString *faceName in faceItems) {
        //faceName '兔子'
        //谓词
        NSString *pre = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:pre];
        NSArray *items = [faceConfigArray filteredArrayUsingPredicate:predicate];
        if (items.count > 0) {
            NSString *imageName = [items[0] objectForKey:@"png"];
            
            NSString *urlStr = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            _text = [_text stringByReplacingOccurrencesOfString:faceName withString:urlStr];
        }
    }

    
    
    
}

@end
