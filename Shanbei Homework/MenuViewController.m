//
//  MenuViewController.m
//  SunnySports
//
//  Created by 段昊宇 on 16/1/8.
//  Copyright © 2016年 Fenglei Stdio. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *header;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tabelArr = @[@"☆", @"★", @"★★", @"★★★", @"★★★★", @"★★★★★", @"★★★★★★"];
    [self.view addSubview: self.tabelView];
    self.header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 262, 64)];
    self.header.backgroundColor = [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1];
    [self.view addSubview: self.header];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tabelView协议
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tabelArr.count;
}

- (id) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor colorWithRed: 31 / 255.0 green: 143 / 255.0 blue: 114 / 255.0 alpha: 1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.tabelArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    typeof(self) __weak weakSelf = self;
    [self.drawer reloadCenterViewControllerUsingBlock: ^{
        NSParameterAssert(weakSelf);
        [[NSNotificationCenter defaultCenter] postNotificationName: @"HighlightLevelWords" object: [NSString stringWithFormat: @"%ld", (long)indexPath.row]];
    }];
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 42;
}

#pragma mark - 懒加载
- (UITableView *) tabelView {
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , 262, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = [UIColor colorWithRed: 31 / 255.0 green: 143 / 255.0 blue: 114 / 255.0 alpha: 1];
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
