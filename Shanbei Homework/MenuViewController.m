//
//  MenuViewController.m
//  SunnySports
//
//  Created by 段昊宇 on 16/1/8.
//  Copyright © 2016年 Fenglei Stdio. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tabelArr = @[@"header", @"跑步", @"排行榜", @"挑战", @"运动生涯", @"设置", @"其他功能"];
    [self.view addSubview: self.tabelView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
    [_tabelView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark---------tabelView协议---------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tabelArr.count;
}

- (id) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.drawer reloadCenterViewControllerUsingBlock: ^{
        NSInteger _flag = indexPath.row;
        switch (_flag) {
            case 0:
                break;
            default:
                break;
        }
    }];
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 42;
}

#pragma mark --------懒加载---------
- (UITableView *) tabelView {
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 262, self.view.frame.size.height) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
    }
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tabelView;
}


#pragma mark - ICSDrawerControllerPresenting
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController {
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController {
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController {
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController {
    self.view.userInteractionEnabled = YES;
}


@end
