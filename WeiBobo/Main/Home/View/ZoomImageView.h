//
//  ZoomImageView.h
//  WeiBobo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>

-(void)imageWillZoomIn:(ZoomImageView *)imageView;
-(void)imageWillZoomOut:(ZoomImageView *)imageView;

@end

@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIActionSheetDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
}
@property(nonatomic,weak)id<ZoomImageViewDelegate> delegate;
@property(nonatomic,copy)NSString *fullImageUrl;

@property(nonatomic,assign)BOOL isGif;
@property(nonatomic,strong)UIImageView *iconView;
@end
