//
//  ThemeManager.h
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotification @"kThemeDidChangeNotification"
#define kThemeName  @"kThemeName"

@interface ThemeManager : NSObject

@property (nonatomic,copy) NSString *themeName;//主题名字

//单例方法
+ (ThemeManager *)sharInstance;

-(UIImage *)getThemeImage:(NSString *)imageName;

-(UIColor *)getThemeColor:(NSString *)colorName;
@end
