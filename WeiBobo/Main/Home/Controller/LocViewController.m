//
//  LocViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "LocViewController.h"
#include "DataService.h"
#import "UIImageView+WebCache.h"

@interface LocViewController ()

@end

@implementation LocViewController

-(instancetype)init {
    if (self = [super init]) {
        self.title = @"附近商圈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableView
    [self _createTableView];
    
    //定位
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion >= 8.0) {
        //请求允许定位
        [_locationManager requestWhenInUseAuthorization];
    }
    //设置定位的准确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];
    
}

-(void)_createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

#pragma mark - UITableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"locCellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PoiModel *poi = self.dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.textLabel.text = poi.title;
    
    return cell;
}

// 开始加载网络
- (void)loadNearByPoisWithlon:(NSString *)lon lat:(NSString *)lat {
    
    //配置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    [params setObject:@50 forKey:@"count"];
    
    //请求数据
    
    //获取附近商家
    __weak __typeof(self) weakSelf = self;
    [DataService requestUrl:placeNearby httpMethod:@"GET" params:params block:^(id result) {
        NSArray *pois = result[@"pois"];
        NSMutableArray *datalist = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            //创建商圈模型对象
            PoiModel *poi = [[PoiModel alloc] initWithDataDic:dic];
            [datalist addObject:poi];
        }
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.dataList = datalist;
        [strongSelf->_tableView reloadData];
    }];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //停止定位
    [manager stopUpdatingLocation];
    //获取当前请求的位置,coorfinate--坐标
    CLLocation *location = [locations lastObject];
    
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    
    //开始加载网络
    [self loadNearByPoisWithlon:lon lat:lat];
}

-(void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
