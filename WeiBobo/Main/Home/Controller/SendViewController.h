//
//  SendViewController.h
//  WeiBobo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"

@interface SendViewController : BaseViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>{
    
    //1 文本编辑栏
    UITextView *_textView;
    //2 工具栏
    UIView *_editorBar;
    //3 显示缩略图
    ZoomImageView *_zoomImageView;
    //4 位置管理
    CLLocationManager *_locationManager;
    UILabel *_locLabel;
    
    //5 表情面板
    FaceScrollView *_faceViewPannel;
}

@end
