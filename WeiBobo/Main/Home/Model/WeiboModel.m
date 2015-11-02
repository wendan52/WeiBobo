//
//  WeiboModel.m
//  XSWeibo
//
//  Created by gj on 15/9/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel


- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    return mapAtt;
}

-(void)setAttributes:(NSDictionary *)dataDic {
    //调用父类的设置方法
    [super setAttributes:dataDic];
    
    //  <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
    
    //01 微博来源处理
    if (_source != nil) {
        NSString *regx = @">.+<";
        NSArray *array = [_source componentsMatchedByRegex:regx];
        if (array.count != 0) {
            NSString *str = array[0];
            str = [str substringWithRange:NSMakeRange(1, str.length-2)];
            _source = [NSString stringWithFormat:@"来源:%@",str];
        }
    }
    
    //用户信息解析
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        _userModel = [[UserModel alloc] initWithDataDic:userDic];
    }
    //被转发的微博
    NSDictionary *reWeiBoDic = [dataDic objectForKey:@"retweeted_status"];
    if (reWeiBoDic != nil) {
        _reWeiboModel = [[WeiboModel alloc] initWithDataDic:reWeiBoDic];
        
        //转发名字处理，拼接字符串
        NSString *name = _reWeiboModel.userModel.name;
        _reWeiboModel.text = [NSString stringWithFormat:@"@%@:%@",name,_reWeiboModel.text];
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
