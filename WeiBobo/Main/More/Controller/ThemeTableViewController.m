//
//  ThemeTableViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ThemeTableViewController.h"
#import "ThemeManager.h"
#import "MoreTableViewCell.h"

@interface ThemeTableViewController ()
{
    NSArray *_themeArray;
}
@end

@implementation ThemeTableViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    NSDictionary *themeDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    _themeArray = [themeDic allKeys];
    [self.tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:@"moreCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    cell.label.text = _themeArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *themeName = _themeArray[indexPath.row];
    [[ThemeManager sharInstance] setThemeName:themeName];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
