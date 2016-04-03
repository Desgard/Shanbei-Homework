//
//  QFNSlayoutManager.h
//  NSMutableAttributedStringDemo
//
//  Created by Mr.Yao on 15/12/23.
//  Copyright © 2015年 Mr.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFNSlayoutManager : NSLayoutManager
- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color;

@end
