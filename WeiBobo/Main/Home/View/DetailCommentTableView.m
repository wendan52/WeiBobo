//
//  DetailCommentTableView.m
//  WeiBobo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "DetailCommentTableView.h"
#import "UIImageView+WebCache.h"
#import "WeiBoFrameLayout.h"
#import "DetailCell.h"

@implementation DetailCommentTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"DetailCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellReuseIdentifier:@"DetailCell"];
    }
    return self;
}

//创建头视图
-(void)_createHeadView {
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _headView.backgroundColor = [UIColor clearColor];
    
    //头像
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:_weiboModel.userModel.avatar_large]];
    headImgView.layer.cornerRadius = 30;
    headImgView.layer.masksToBounds = YES;
    [_headView addSubview:headImgView];
    //名字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, kScreenWidth-70, 30)];
    titleLabel.text = _weiboModel.userModel.screen_name;
    [_headView addSubview:titleLabel];
    //来源
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, kScreenWidth-70, 30)];
    sourceLabel.text = _weiboModel.source;
    [_headView addSubview:sourceLabel];
    
    //创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _weiboView.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_headView addSubview:_weiboView];

    
}

-(void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self _createHeadView];
        
        //创建微博视图的布局对象
        WeiBoFrameLayout *layout = [[WeiBoFrameLayout alloc] init];
        layout.isDetail = YES;
        layout.model = weiboModel;
        
        _weiboView.layout = layout;
        _weiboView.frame = layout.frame;
        _weiboView.top = 75;
        _headView.height = _weiboView.bottom;
        self.tableHeaderView = _headView;
    }
}

#pragma mark - TabelView 代理

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //1.创建组视图
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    
    //2.评论Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blackColor];
    
    
    //3.评论数量
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"评论:%d",value];
    [sectionHeaderView addSubview:countLabel];
    
    sectionHeaderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    return sectionHeaderView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    cell.commentModel = self.commentDataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = self.commentDataArray[indexPath.row];
    //计算单元格高度
    CGFloat height = [DetailCell getCommentHeight:model];
    return height;
}


@end
