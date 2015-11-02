//
//  FriendsListViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendsListCell.h"
#import "AppDelegate.h"

@interface FriendsListViewController ()

@end

@implementation FriendsListViewController{
    UICollectionView *_collectionView;
    NSMutableArray *_modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载数据
    [self _loadData:self.urlString];
    //创建collectionView
    [self _createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建collectionView
-(void)_createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    //注册
    UINib *nib = [UINib nibWithNibName:@"FriendsListCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"FriendsListCell"];
    
}

#pragma mark - UICollectionView 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightTextColor];
    
    NSLog(@"%@",_modelArray[indexPath.row]);
    cell.model = _modelArray[indexPath.row];
    return cell;
}


//数据加载
-(void)_loadData:(NSString *)urlString {
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegete.sinaWeibo;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"100" forKey:@"count"];
    [params setObject:sinaWeibo.userID forKey:@"uid"];
    [sinaWeibo requestWithURL:urlString
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //解析数据
    NSArray *statusesArray = [result objectForKey:@"users"];
    NSMutableArray *usersArray = [NSMutableArray array];
    for (NSDictionary *dic in statusesArray) {
        UserModel *model = [[UserModel alloc] initWithDataDic:dic];
        [usersArray addObject:model];
    }
    _modelArray = usersArray;
    [_collectionView reloadData];
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}

@end
