//
//  ZoomImageView.m
//  WeiBobo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation ZoomImageView{
    NSURLConnection *_connection;
    double _lenght;
    NSMutableData *_data;
    MBProgressHUD *_hud;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        //添加手势
        [self initTap];
        //gif
        [self createIconView];
    }
    return self;
}

-(void)initTap {
    //01 打开交互
    self.userInteractionEnabled = YES;
    //02 创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)zoomIn {
    //通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    [self createView];
    //计算相对位置
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    //设置动画
    [UIView animateWithDuration:.3 animations:^{
        _fullImageView.frame = _scrollView.frame;
        _scrollView.alpha = 1;
        //加载大图
        [self downloadImage];
    }];
    
}


-(void)zoomOut {
    //通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    //取消网络下载
    [_connection cancel];
    //设置动画
    [UIView animateWithDuration:.3 animations:^{
        //计算相对位置
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        //如果scroll内容已经偏移，则偏移量也得计算
        _fullImageView.top += _scrollView.contentOffset.y;
        _scrollView.alpha = 0;
    }completion:^(BOOL finished) {
        //移除
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _hud = nil;
    }];
}

-(void)createIconView {
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconView];
    _iconView.hidden = YES;
}

-(void)createView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.alpha = 0;
    [self.window addSubview:_scrollView];
    
    _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    _fullImageView.image = self.image;
    [_scrollView addSubview:_fullImageView];
    
    //单击退出大图模式
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
    [_scrollView addGestureRecognizer:twoTap];
    
    //长按保存
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePicture:)];
    longPress.minimumPressDuration = 1;
    [_scrollView addGestureRecognizer:longPress];
}

//下载图片
-(void)downloadImage {
    if (self.fullImageUrl.length != 0) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        }
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        NSURL *url = [NSURL URLWithString:_fullImageUrl];
        
        NSURLRequest *requrst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        _connection = [NSURLConnection connectionWithRequest:requrst delegate:self];
    }
}

//保存图片
-(void)savePicture:(UILongPressGestureRecognizer *)longPress {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"保存图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [sheet showInView:_scrollView];
    }
    
}


#pragma mark - NSUrlConnectionData 代理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponce = (NSHTTPURLResponse *)response;
//    NSLog(@"%@",httpResponce);
    NSDictionary *headFields = [httpResponce allHeaderFields];
    
    //获取文件大小
    NSString *lengthStr = [headFields objectForKey:@"Content-Length"];
    _lenght = [lengthStr doubleValue];
    
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_data appendData:data];
    CGFloat progress = _data.length/_lenght;
    _hud.progress = progress;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    _hud.hidden = YES;
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    //尺寸处理
    // kScreenWidth/length = image.size.width/image.size.height
    CGFloat length = image.size.height/image.size.width*kScreenWidth;
    if (length > kScreenHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
        }];
    }
    
    if (_isGif) {
        [self showGif];
    }
}

-(void)showGif {
    
    //01 －－－－－WebView播放－－－－－－－－
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:webView];
    
    //02 三方 sdWebImage
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    //03 用ImageIO
    //创建图片源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    //得到图片个数
    size_t count = CGImageSourceGetCount(source);
    
    //把所有的图片 解析到数组中
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval duration = 0.0f;
    for (size_t i=0; i < count; i++) {
        //获取每一张图片 放到UIImage对象里面
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        duration += 0.1;
        [images addObject:[UIImage imageWithCGImage:image]];
        CGImageRelease(image);
    }
    
    //播放一
//    _fullImageView.animationImages = images;
//    _fullImageView.animationDuration = duration;
//    [_fullImageView startAnimating];
    
    //播放二
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    _fullImageView.image = animatedImage;
    
    CFRelease(source);
    
    //03 三方
//    [UIImage sd_animatedGIFWithData:_data];
    
}

#pragma mark - UIActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        UIImage *image = _fullImageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

#pragma mark - UIImagePickerController 代理方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    //提示下载成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    hud.mode = MBProgressHUDModeCustomView;
    //隐藏
    [hud hide:YES afterDelay:1.5];
}


@end
