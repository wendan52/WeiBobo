//
//  NearByViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "WeiboDetailViewController.h"

/**
 *  1 定义(遵循MKAnnotation协议 )annotation类-->MODEL
 2 创建 annotation对象，并且把对象加到mapView;
 3 实现mapView 的协议方法 ,创建标注视图
 */
@interface NearByViewController ()

@end

@implementation NearByViewController{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViews];
    
//    CLLocationCoordinate2D coordinate = {30.3243,120.3630};
//    
//    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
//    annotation.coordinate = coordinate;
//    annotation.title = @"汇文教育";
//    annotation.subtitle = @"27班";
//    
//    [_mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)_createViews{
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图种类
    _mapView.mapType = MKMapTypeStandard;
    
    //用户跟踪模式
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark - mapView 代理
//http://open.weibo.com/wiki/2/place/nearby_timeline  附近动态（微博）
//位置更新后被调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 %f 纬度 %f",coordinate.longitude,coordinate.latitude);
    
//    typedef struct {
//        CLLocationDegrees latitudeDelta;
//        CLLocationDegrees longitudeDelta;
//    } MKCoordinateSpan;
//
//    typedef struct {
//        CLLocationCoordinate2D center;
//        MKCoordinateSpan span;
//    } MKCoordinateRegion;
    
    //设置地图的显示区域
    CLLocationCoordinate2D center = coordinate;
    //树枝越小 越精确
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    
    mapView.region = region;
    
    //网络获取附近微博
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    [self _loadNearByData:lon lat:lat];
}

//标注视图获取
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    
//    //处理用户当前位置
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//        
//        //颜色设置
//        pin.pinColor = MKPinAnnotationColorPurple;
//        //从天而降
//        pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        
//        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    }
//    return pin;
//}



//自定义 标注视图
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //处理用户当前位置
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //复用池
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        
        WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if (view == nil) {
            view = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        }
        view.annotation = annotation;
        [view setNeedsLayout];
        return view;
    }
    return nil;
}

//点击标注视图
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"%@",view.annotation);
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]]) {
        return;
    }
    WeiboAnnotation *annotation = view.annotation;
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
    detailVC.weiboModel = annotation.model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//获取附近微博
-(void)_loadNearByData:(NSString *)lon lat:(NSString *)lat{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        NSArray *statues = [result objectForKey:@"statuses"];
        NSMutableArray *annotationAttay = [[NSMutableArray alloc] initWithCapacity:statues.count];
        for (NSDictionary *dic in statues) {
            
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            
            //[_mapView addAnnotation:annotation];
            [annotationAttay addObject:annotation];
        }
        [_mapView addAnnotations:annotationAttay];
    }];
}


@end
