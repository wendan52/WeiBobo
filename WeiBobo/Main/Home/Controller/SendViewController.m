//
//  SendViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "DataService.h"
#import "MMDrawerController.h"

@interface SendViewController (){
    UIImage *_sendImage;
}
@end

@implementation SendViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送微博";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createNavButtons];
    [self createTextView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //弹出键盘
    [_textView becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏不透明，当导航栏不透明的时候 ，子视图的y的0位置在导航栏下面
//    self.navigationController.navigationBar.translucent = NO;
//    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    //弹出键盘
    [_textView becomeFirstResponder];
}

#pragma  mark - 创建子视图
-(void)createNavButtons {
    //button_icon_close.png
    //button_icon_ok.png
    
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftButton.normalImageName = @"button_icon_close.png";
    [leftButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightButton.normalImageName = @"button_icon_ok.png";
    [rightButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(void)createTextView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.editable = YES;
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    //2 编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    NSArray *array = @[@"compose_toolbar_1",
                       @"compose_toolbar_4",
                       @"compose_toolbar_3",
                       @"compose_toolbar_5",
                       @"compose_toolbar_6"];
    for (int i = 0; i < 5; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        button.normalImageName = array[i];
        button.tag = i + 10;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editorBar addSubview:button];
    }

    //创建label 显示位置信息
    _locLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
    _locLabel.hidden = YES;
    _locLabel.font = [UIFont systemFontOfSize:14];
    _locLabel.backgroundColor = [UIColor lightTextColor];
    [_editorBar addSubview:_locLabel];
    
    
}

-(void)buttonAction:(ThemeButton *)button {
    NSInteger index = button.tag - 10;
    if (index == 0) {
        //选择照片
        [self _selectPhoto];
    }else if (button.tag == 13){
        //显示位置
        [self _location];
    }else if(button.tag == 14) {
        //显示、隐藏表情
        BOOL isFirstResponder = _textView.isFirstResponder;
        
        //输入框是否是第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder) {
            //隐藏键盘
            [_textView resignFirstResponder];
            //显示表情
            [self _showFaceView];
        }else{
            //隐藏表情
            [self _hideFaceView];
            //显示键盘
            [_textView becomeFirstResponder];
        }
        
    }
}

#pragma mark - 选择照片
-(void)_selectPhoto{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    //选择相机 或者 相册
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }else if (buttonIndex == 1){
        //选择相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//照片选择代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //1 弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //2 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //3 显示缩略图
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc] init];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView];
        _zoomImageView.delegate = self;
    }
    _zoomImageView.image = image;
    _sendImage = image;
}

//导航栏取消
-(void)cancelButtonAction {
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送
-(void)sendButtonAction {
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容不能为空";
    }else if (text.length > 140){
        error = @"微博内容大于140字符";
    }
    //弹出提示错误信息
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
        NSLog(@"%@",result);
        [self showStatusTip:@"发送成功" show:NO operation:nil];
    }];
    
    [self showStatusTip:@"正在发送" show:YES operation:operation];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 键盘弹出通知
-(void)keyBoardWillShow:(NSNotification *)notification{
    
    //1 取出键盘frame，这个frame相对于window
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [bounsValue CGRectValue];
    //2 键盘高度
    CGFloat height = frame.size.height;
    //3 调整视图的高度
    _editorBar.bottom = kScreenHeight - height - 64;
}

#pragma mark - uitextviewdelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - zoomImageViewDelegate
//检测图片放大或者缩小
-(void)imageWillZoomIn:(ZoomImageView *)imageView {
    [_textView resignFirstResponder];
}

-(void)imageWillZoomOut:(ZoomImageView *)imageView {
    [_textView becomeFirstResponder];
}


#pragma mark - 地理位置

/*
 修改 info.plist 增加以下两项
 NSLocationWhenInUseUsageDescription  BOOL YES
 NSLocationAlwaysUsageDescription         string “提示描述”
 */
-(void)_location {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        if (kVersion >8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"已经更新位置");
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 %lf 纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address
    
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:coordinateStr forKey:@"coordinate"];
    
    __weak __typeof(self) weakSelf = self;
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *geos = [result objectForKey:@"geos"];
        if (geos.count > 0) {
            NSDictionary *geoDic = [geos lastObject];
            NSString *addr = [geoDic objectForKey:@"address"];
            NSLog(@"地址 %@",addr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(self) strongSelf = weakSelf;
                strongSelf->_locLabel.text = addr;
                strongSelf->_locLabel.hidden = NO;
            });
        }
    }];
    
    
    
    //二 iOS内置
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *place = [placemarks lastObject];
//        
//        NSLog(@"%@",place.name);
//    }];
    
    
    
}

#pragma mark - 表情处理

-(void)_showFaceView{
    //创建表情面板
    if (_faceViewPannel == nil) {
        
        _faceViewPannel = [[FaceScrollView alloc] init];
        [_faceViewPannel setFaceViewDelegate:self];
        
        //放到底部
        _faceViewPannel.top = kScreenHeight-64;
        [self.view addSubview:_faceViewPannel];
    }
    
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPannel.bottom = kScreenHeight-64;
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPannel.top;
    }];
}

-(void)_hideFaceView{
    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPannel.top = kScreenHeight-64;
    }];
}

-(void)faceDidSelect:(NSString *)text {
    NSLog(@"选中%@",text);
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
