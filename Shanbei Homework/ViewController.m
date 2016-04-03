//
//  ViewController.m
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/1.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "ViewController.h"
#import "HighlightingTextStorage.h"
#import "QFNSlayoutManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *HighlightButton;

@end

@implementation ViewController

#pragma mark - age cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self startUp];
}

#pragma mark - set navigation bar
- (void) setNavBar {
    // nav样式字体颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    // 设置按键
}

#pragma mark - set controller
- (void) startUp {
    NSString *text = @"We can read of things that happened 5,000 years ago in the Near East, where people first learned to write. But there are some parts of the word where even now people cannot write. The only way that they can preserve their history is to recount it as sagas -- legends handed down from one generation of another. These legends are useful because they can tell us something about migrations of people who lived long ago, but none could write down what they did. Anthropologists wondered where the remote ancestors of the Polynesian peoples now living in the Pacific Islands came from. The sagas of these people explain that some of them came from Indonesia about 2,000 years ago.\n\nBut the first people who were like ourselves lived so long ago that even their sagas, if they had any, are forgotten. So archaeologists have neither history nor legends to help them to find out where the first 'modern men' came from.\n\nFortunately, however, ancient men made tools of stone, especially flint, because this is easier to shape than other kinds. They may also have used wood and skins, but these have rotted away. Stone does not decay, and so the tools of long ago have remained when even the bones of the men who made them have disappeared without trace.";
    NSTextStorage *passage = [[NSTextStorage alloc] initWithString: text];
    
    QFNSlayoutManager *textLayout = [[QFNSlayoutManager alloc] init];
    [passage addLayoutManager: textLayout];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: self.view.bounds.size];
    [textLayout addTextContainer: textContainer];
    self.textView = [[UITextView alloc] initWithFrame: self.view.bounds textContainer: textContainer];
    self.textView.font = [UIFont fontWithName: @"Courier" size: 14];
    self.textView.backgroundColor = [UIColor colorWithRed: 240 / 255.0f green: 240 / 255.0f blue: 240 / 255.0f alpha: 1];
    self.textView.alwaysBounceVertical = YES;
    self.textView.editable = NO;
    //textView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.view addSubview: self.textView];
    
    NSArray *array = [NSArray arrayWithObjects: @"recount", @"saga", @"legend", @"migration", @"anthropologist", nil];
    [self Highlight: self.textView withWords: array];
}

- (void) Highlight: (UITextView *) textView withWords: (NSArray *) array {
    for (id word in array) {
        NSTextStorage *passage = [[NSTextStorage alloc] initWithString: textView.text];
        // 普通匹配
        // NSRange rang = [[passage string] rangeOfString: word];
        
        // 正则表达式
        NSRange rang = [textView.text rangeOfString: word options:NSRegularExpressionSearch];
        QFNSlayoutManager *textLayout = [[QFNSlayoutManager alloc] init];
        [passage addLayoutManager: textLayout];
        
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: self.view.bounds.size];
        [textLayout addTextContainer: textContainer];
        
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                       [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1]  , NSBackgroundColorAttributeName,
                                       [UIFont fontWithName: @"Courier" size: 14], NSFontAttributeName,
                                       nil];
        
        [textView.textStorage setAttributes: attributeDict range: NSMakeRange(rang.location, rang.length)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
