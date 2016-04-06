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
#import "SFDraggableDialogView.h"

#import <CoreData/CoreData.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *HighlightButton;
@property (nonatomic, strong) UIView *likeNavBar;
@property (nonatomic, strong) UILabel *NavBarTitle;
@property (nonatomic, strong) UIButton *Highlight;
@property (nonatomic, strong) UIButton *Menu;
@property (nonatomic, strong) UISlider *slider;

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
    
    
    // 模仿navbar
    CGRect CGNavBar = CGRectMake(0, 0, self.view.frame.size.width, 64);
    self.likeNavBar = [[UIView alloc] initWithFrame: CGNavBar];
    self.likeNavBar.backgroundColor = [UIColor colorWithRed: 88 / 255.0f green: 184 / 255.0f blue: 140 / 255.0f alpha: 1];
    
    // title
    self.NavBarTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 30, self.view.frame.size.width, 20)];
    self.NavBarTitle.textAlignment = NSTextAlignmentCenter;
    self.NavBarTitle.textColor = [UIColor whiteColor];
    self.NavBarTitle.text = self.pastitle;
    
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
    self.passage = [self.db queryPassageById: self.lessonNum];
    
    // 单词初始化
    self.words = [NSMutableArray arrayWithObjects: @"recount", @"saga", @"legend", @"migration", @"anthropologist", @"archaeologist", @"ancestor", @"Polynesian", @"Indonesia", @"flint", @"desgard", nil];
    
    // 状态初始化
    self.isHighlight = NO;
}


#pragma mark - Set Controller
- (void) startUp {
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed: 240 / 255.0f green: 240 / 255.0f blue: 240 / 255.0f alpha: 1];
    // 设置文本
    NSString *text = self.passage;
    NSTextStorage *passage = [[NSTextStorage alloc] initWithString: text];
    
    QFNSlayoutManager *textLayout = [[QFNSlayoutManager alloc] init];
    [passage addLayoutManager: textLayout];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: self.view.bounds.size];
    [textLayout addTextContainer: textContainer];
    
    self.textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 104) textContainer: textContainer];
    self.textView.delegate = self;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.font = [UIFont fontWithName: @"Courier" size: 14];
    self.textView.backgroundColor = [UIColor colorWithRed: 240 / 255.0f green: 240 / 255.0f blue: 240 / 255.0f alpha: 1];
    self.textView.alwaysBounceVertical = YES;
    self.textView.editable = NO;
    [self.view addSubview: self.textView];
    
    //
    self.slider = [[UISlider alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    self.slider.minimumValue = -3.0;
    self.slider.maximumValue = 6.0;
    [self.view addSubview: self.slider];
    [self.slider addTarget: self action: @selector(sliderValueChanged) forControlEvents: UIControlEventValueChanged];
    
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

#pragma mark - func resign Hightlight
- (void) reHightlight {
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     [UIFont fontWithName: @"Courier" size: 14],                                          NSFontAttributeName,
                     nil];
    [_textView.textStorage setAttributes: attributeDict range: NSMakeRange(0, _textView.text.length)];
}

#pragma mark - InteractWithURL Delegate
- (bool) textView: (UITextView *)textView shouldInteractWithURL: (nonnull NSURL *)URL inRange: (NSRange)characterRange {
    // NSLog(@"%@", [self.passage substringWithRange: characterRange]);
    NSString *lev = [self.db queryByWords: [self.passage substringWithRange: characterRange]];
    // NSLog(@"%@", lev);
    int levNum = [lev intValue];
    NSString *title = @"⭐︎";
    for (int i = 0; i < levNum; ++ i) {
        if (i == 0) title = @"";
        title = [title stringByAppendingString: @"★"];
    }
    
    // 弹出层SFDraggab
    SFDraggableDialogView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"SFDraggableDialogView" owner:self options:nil] firstObject];
    dialogView.frame = self.view.bounds;
    dialogView.photo = [UIImage imageNamed:@"face"];
    dialogView.delegate = self;
    dialogView.titleText = [[NSMutableAttributedString alloc] initWithString: title];
    dialogView.messageText = [[NSMutableAttributedString alloc] initWithString: [self.passage substringWithRange: characterRange]];
    dialogView.firstBtnText = [@"收入囊中" uppercaseString];
    dialogView.dialogBackgroundColor = [UIColor whiteColor];
    dialogView.cornerRadius = 8.0;
    dialogView.backgroundShadowOpacity = 0.2;
    dialogView.hideCloseButton = true;
    dialogView.showSecondBtn = false;
    dialogView.contentViewType = SFContentViewTypeDefault;
    dialogView.firstBtnBackgroundColor = [UIColor colorWithRed:0.230 green:0.777 blue:0.316 alpha:1.000];
    [dialogView createBlurBackgroundWithImage:[self jt_imageWithView:self.view] tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.12] blurRadius:60];
    
    [self.view addSubview:dialogView];
    return YES;
}

#pragma mark - Button Action
- (void) HighlightAction {
    if (self.isHighlight == YES) {
        [self reHightlight];
        self.isHighlight = NO;
        return;
    }
    
    self.words = [self.db queryByLesson: self.lessonNum];
    [self Highlight: self.textView withWords: self.words];
    self.isHighlight = YES;
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
        [self reHightlight];
        self.isHighlight = NO;
    }
    
    id obj = [notification object];
    self.words = [self.db queryByLevel: obj];
    [self Highlight: self.textView withWords: self.words];
    self.isHighlight = YES;
}

- (void) openDrawer {
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Slider Action
- (void) sliderValueChanged {
    if (self.isHighlight == YES) {
        [self reHightlight];
        self.isHighlight = NO;
    }
    
    int x = ceil((double)self.slider.value);
    if (x < 0) return;
    self.words = [self.db queryByLevelDown: [NSString stringWithFormat: @"%d", x]];
    [self Highlight: self.textView withWords: self.words];
    self.isHighlight = YES;
}

#pragma mark - SFDraggableDialogViewDelegate
- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton {
    NSLog(@"The first button pressed");
}

- (void)draggingDidBegin:(SFDraggableDialogView *)dialogView {
    NSLog(@"Dragging has begun");
}

- (void)draggingDidEnd:(SFDraggableDialogView *)dialogView {
    NSLog(@"Dragging did end");
}

- (void)draggableDialogViewWillDismiss:(SFDraggableDialogView *)dialogView {
    NSLog(@"Will be dismissed");
}

- (void)draggableDialogViewDismissed:(SFDraggableDialogView *)dialogView {
    NSLog(@"Dismissed");
}

#pragma mark - Snapshot
- (UIImage *)jt_imageWithView:(UIView *)view {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:true];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
