//
//  BaseViewController.h
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFHTTPRequestOperation;
@interface BaseViewController : UIViewController

-(void)setNavItem;

//自己写进度显示
-(void)showActiveView:(BOOL)show;

//第三方框架
-(void)showHud:(NSString *)title;
-(void)hidHud;
-(void)completeHud:(NSString *)title;

-(void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation;
@end
