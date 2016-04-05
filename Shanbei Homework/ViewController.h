//
//  ViewController.h
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/1.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDraggableDialogView.h"


@interface ViewController : UIViewController<UITextViewDelegate, SFDraggableDialogViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *passage;
@property (nonatomic, strong) NSMutableArray *words;

@end

