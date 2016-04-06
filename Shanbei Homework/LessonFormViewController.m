//
//  LessonFormViewController.m
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/6.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "LessonFormViewController.h"
#import "ViewController.h"
#import "dbhelper.h"
#import "MenuViewController.h"
#import "ICSDrawerController.h"

@interface LessonFormViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) dbhelper *db;
@end

@implementation LessonFormViewController

#pragma mark - Age Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self startUp];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void) startUp {
    // nav样式字体颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.db = [[dbhelper alloc] init];
    [self.db open];
    self.titleArray = [self.db queryTitle];
    [self.view addSubview: self.tableView];
}

#pragma mark - TableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MenuViewController *leftVC = [[MenuViewController alloc] init];
    ViewController *plainVC = [[ViewController alloc] init];
    plainVC.pastitle = [NSString stringWithFormat: @"lesson %ld", indexPath.row + 1];
    plainVC.lessonNum = [NSString stringWithFormat: @"%ld", indexPath.row + 1];
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController: leftVC centerViewController: plainVC];
    
    [self.navigationController pushViewController: drawer animated: YES];
}

- (id) tableView: (UITableView *) tabView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Lazy Load
- (UITableView *) tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
