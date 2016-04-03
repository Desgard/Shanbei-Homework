//
//  MenuViewController.h
//  SunnySports
//
//  Created by 段昊宇 on 16/1/8.
//  Copyright © 2016年 Fenglei Stdio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"

@interface MenuViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property (nonatomic, weak) ICSDrawerController *drawer;
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSArray *tabelArr;
@property (nonatomic, strong) UIImageView *avatar;      //头像
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *stuProAndStuNumber;

@end
