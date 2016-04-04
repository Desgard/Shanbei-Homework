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
#import "ICSDrawerController.h"
#import "dbhelper.h"

#import <CoreData/CoreData.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *HighlightButton;
@property (nonatomic, strong) UIView *likeNavBar;
@property (nonatomic, strong) UILabel *NavBarTitle;
@property (nonatomic, strong) UIButton *Highlight;
@property (nonatomic, strong) UIButton *Menu;

@property (nonatomic) bool isHighlight;
@property (nonatomic, weak) ICSDrawerController *drawer;
@property (nonatomic, strong) dbhelper *db;
@end

@implementation ViewController

#pragma mark - age cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self startUp];
    [self setNavBar];
    
}

#pragma mark - Set NavigationBar
- (void) setNavBar {
    // nav样式字体颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.title = @"扇贝作业";
    
    // 模仿navbar
    CGRect CGNavBar = CGRectMake(0, 0, self.view.frame.size.width, 64);
    self.likeNavBar = [[UIView alloc] initWithFrame: CGNavBar];
    self.likeNavBar.backgroundColor = [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1];
    
    // title
    self.NavBarTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 30, self.view.frame.size.width, 20)];
    self.NavBarTitle.textAlignment = NSTextAlignmentCenter;
    self.NavBarTitle.textColor = [UIColor whiteColor];
    self.NavBarTitle.text = @"扇贝作业";
    
    // 左右按钮
    self.Highlight = [UIButton buttonWithType: UIButtonTypeCustom];
    self.Highlight.frame = CGRectMake(self.view.frame.size.width - 35, 35, 15, 15);
    [self.Highlight setImage: [UIImage imageNamed: @"star-full.png"] forState: UIControlStateNormal];
    [self.Highlight addTarget: self action: @selector(HighlightAction) forControlEvents: UIControlEventTouchUpInside];
    
    self.Menu = [UIButton buttonWithType: UIButtonTypeCustom];
    self.Menu.frame = CGRectMake(20, 29.5, 25, 25);
    [self.Menu setImage: [UIImage imageNamed: @"menu.png"] forState: UIControlStateNormal];
    [self.Menu addTarget: self action: @selector(openDrawer) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: self.likeNavBar];
    [self.view addSubview: self.NavBarTitle];
    [self.view addSubview: self.Highlight];
    [self.view addSubview: self.Menu];
}

#pragma mark - Load Data
- (void) loadData {
    self.db = [[dbhelper alloc] init];
    // 数据库操作
    [self.db open];
    
    // 第一次导入数据库操作
    // [self.db FirstLoad];
    
    // 课文数据读取
    self.passage = @"We can read of things that happened 5,000 years ago in the Near East, where people first learned to write. But there are some parts of the word where even now people cannot write. The only way that they can preserve their history is to recount it as sagas -- legends handed down from one generation of another. These legends are useful because they can tell us something about migrations of people who lived long ago, but none could write down what they did. Anthropologists wondered where the remote ancestors of the Polynesian peoples now living in the Pacific Islands came from. The sagas of these people explain that some of them came from Indonesia about 2,000 years ago.\n\nBut the first people who were like ourselves lived so long ago that even their sagas, if they had any, are forgotten. So archaeologists have neither history nor legends to help them to find out where the first 'modern men' came from.\n\nFortunately, however, ancient men made tools of stone, especially flint, because this is easier to shape than other kinds. They may also have used wood and skins, but these have rotted away. Stone does not decay, and so the tools of long ago have remained when even the bones of the men who made them have disappeared without trace.";
    
    // 单词初始化
    self.words = [NSMutableArray arrayWithObjects: @"recount", @"saga", @"legend", @"migration", @"anthropologist", @"archaeologist", @"ancestor", @"Polynesian", @"Indonesia", @"flint", @"desgard", nil];
    
    // 状态初始化
    self.isHighlight = NO;
}


#pragma mark - Set Controller
- (void) startUp {
    // 设置文本
    NSString *text = self.passage;
    NSTextStorage *passage = [[NSTextStorage alloc] initWithString: text];
    
    QFNSlayoutManager *textLayout = [[QFNSlayoutManager alloc] init];
    [passage addLayoutManager: textLayout];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: self.view.bounds.size];
    [textLayout addTextContainer: textContainer];
    
    self.textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) textContainer: textContainer];
    self.textView.delegate = self;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.font = [UIFont fontWithName: @"Courier" size: 14];
    self.textView.backgroundColor = [UIColor colorWithRed: 240 / 255.0f green: 240 / 255.0f blue: 240 / 255.0f alpha: 1];
    self.textView.alwaysBounceVertical = YES;
    self.textView.editable = NO;
    [self.view addSubview: self.textView];
    
    // 设置通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(NotificationToHight:) name: @"HighlightLevelWords" object: nil];
}

#pragma mark - func Hightlight
- (void) Highlight: (UITextView *) textView withWords: (NSMutableArray *) array {
    for (id word in array) {
        NSTextStorage *passage = [[NSTextStorage alloc] initWithString: textView.text];
        // 普通匹配
        // NSRange rang = [[passage string] rangeOfString: word];
        
        // 正则表达式
        NSRange rang = [textView.text rangeOfString: word options: NSRegularExpressionSearch];
        QFNSlayoutManager *textLayout = [[QFNSlayoutManager alloc] init];
        [passage addLayoutManager: textLayout];
        
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: self.view.bounds.size];
        [textLayout addTextContainer: textContainer];
        NSDictionary *attributeDict;
        if (!self.isHighlight) {
            attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1], NSBackgroundColorAttributeName,
                                           [UIFont fontWithName: @"Courier" size: 14],                                          NSFontAttributeName,
                                           [NSURL URLWithString: @""],                                                          NSLinkAttributeName,
                                           [UIColor whiteColor],                                                                NSForegroundColorAttributeName,
                                           nil];
        } else {
            attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName: @"Courier" size: 14],                                          NSFontAttributeName,
                                           nil];
        }
        
        
        [textView.textStorage setAttributes: attributeDict range: NSMakeRange(rang.location, rang.length)];
    }
}

#pragma mark - InteractWithURL Delegate
- (bool) textView: (UITextView *)textView shouldInteractWithURL: (nonnull NSURL *)URL inRange: (NSRange)characterRange {
    NSLog(@"%@", [self.passage substringWithRange: characterRange]);
    return YES;
}

#pragma mark - Button Action
- (void) HighlightAction {
    [self Highlight: self.textView withWords: self.words];
    if (self.isHighlight) self.isHighlight = NO;
    else self.isHighlight = YES;
}

#pragma mark - Notification Action
- (void) NotificationToHight: (NSNotification *)notification {
    /**
     *  @author Desgard_Duan, 2016-04-04
     *
     *  sidebar点击后动作。
     *  高亮对应级别单词。需要先清空之前样式。
     */
    if (self.isHighlight == YES) {
        [self Highlight: self.textView withWords: [[NSMutableArray alloc] initWithObjects: self.textView.text, nil]];
        self.isHighlight = NO;
    }
    
    
    id obj = [notification object];
    self.words = [self.db queryByLevel: obj];
    [self Highlight: self.textView withWords: self.words];
    self.isHighlight = YES;
}

- (void) openDrawer {
    [self.drawer open];
}

@end
