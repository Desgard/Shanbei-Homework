//
//  HighlightingTextStorage.m
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/2.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "HighlightingTextStorage.h"

@implementation HighlightingTextStorage {
    NSMutableAttributedString *_imp;
}

- (id) init {
    self = [super init];
    if (self) {
        _imp = [NSMutableAttributedString new];
    }
    return self;
}

#pragma mark - Reading Text
- (NSString *) string {
    return _imp.string;
}

- (NSDictionary *) attributesAtIndex: (NSUInteger)location effectiveRange: (nullable NSRangePointer)range {
    return [_imp attributesAtIndex: location effectiveRange: range];
}

#pragma mark - 文本编辑
// 替换某一范围文字
- (void) replaceCharactersInRange: (NSRange)range withString: (NSString *)str {
    [_imp replaceCharactersInRange: range withString: str];
    [self edited: NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

// 为某一范围文字设置属性
- (void) setAttributes: (NSDictionary *)attrs range: (NSRange)range {
    [_imp setAttributes: attrs range: range];
    [self edited: NSTextStorageEditedAttributes range: range changeInLength: 0];
}

#pragma mark - Syntax highlighting
- (void) processEditing {
    // 正则匹配目的单词
    static NSRegularExpression *Words;
    Words = Words ?: [NSRegularExpression regularExpressionWithPattern: @"word" options: 0 error: nil];
    
    // 清除样式
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    [self removeAttribute: NSForegroundColorAttributeName range: paragaphRange];
    
    // 在范围内找出待查找词语
    [Words enumerateMatchesInString: self.string options: 0 range: paragaphRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        // 增加高亮颜色
        [self addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: result.range];
    }];
    
    [super processEditing];
}
@end
