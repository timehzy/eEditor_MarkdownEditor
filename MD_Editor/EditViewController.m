//
//  ViewController.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "EditViewController.h"
#import "KeyboardToolBar.h"
#import "TextAttributeSymbol.h"
#import "TextAttributeDeal.h"
#import "ScanViewToolBar.h"
#import <Social/Social.h>
@interface EditViewController ()<UITextViewDelegate, KeyboardToolBarDelegate, ScanViewToolBarDelegate>
@property (weak, nonatomic) IBOutlet UITextView *editZoom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editZoomeBottom;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (strong, nonatomic) KeyboardToolBar *kToolBar;
@property (strong, nonatomic) ScanViewToolBar *sToolBar;
@property (assign, nonatomic) BOOL dlt;
@property (strong, nonatomic) NSDictionary *defaultTypingAttributes;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)configView{
    NSArray *toolbars = [[NSBundle mainBundle]loadNibNamed:@"KeyboardToolBar" owner:nil options:nil];
    ScanViewToolBar *scanViewToolBar = toolbars[3];
    scanViewToolBar.delegate = self;
    [self.toolBarView addSubview:scanViewToolBar];
    self.sToolBar = scanViewToolBar;

    KeyboardToolBar *keyboardToolBar = toolbars.firstObject;
    keyboardToolBar.delegate = self;
    [self.toolBarView addSubview:keyboardToolBar];
    [self.toolBarView sendSubviewToBack:keyboardToolBar];
    self.kToolBar = keyboardToolBar;
    
    self.editZoom.typingAttributes = self.defaultTypingAttributes;
}

- (void)initData{
    if (self.article) {
        NSData *textData = [NSData dataWithContentsOfFile:[self savePath:self.article.fileName]];
        self.editZoom.attributedText = [NSKeyedUnarchiver unarchiveObjectWithData:textData];
    }else{
        self.article = [HZYArticle new];
        self.article.fileName = [self stringDate];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSData *textData = [NSKeyedArchiver archivedDataWithRootObject:self.editZoom.attributedText];
    [textData writeToFile:[self savePath:self.article.fileName] atomically:YES];
    self.article.summary = [self.editZoom.text substringToIndex:self.editZoom.text.length > 100 ? 100 : self.editZoom.text.length];
    self.popedBlk(self.article, self.dlt);

}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        textView.typingAttributes = self.defaultTypingAttributes;
    }
    return YES;
}

#pragma mark - keyboardToolBar delegate
- (void)tabBtnTouched{
    [self doAddMark:MarkTypeTab];
}

- (void)tabBtnLongPress{
    [self doAddMark:MarkTypeTabDelete];
}

- (void)headBtnTouched{
    [self doAddMark:MarkTypeHeadDefault];
}

- (void)listBtnTouched{
    [self doAddMark:MarkTypeList];
}

- (void)checkBtnTouched{
    [self doAddMark:MarkTypeCheck];
}

- (void)doneBtnTouche{
    [self.editZoom resignFirstResponder];
}

- (void)head1BtnTouched{
    [self doAddMark:MarkTypeHeadFirst];
}

- (void)head2BtnTouched{
    [self doAddMark:MarkTypeHeadSecond];
}

- (void)head3BtnTouched{
    [self doAddMark:MarkTypeHeadThird];
}

#pragma mark - scanviewtoolbar delegate
- (void)backBtnTouched{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnTouched{
    NSString *textToShare = self.editZoom.text;
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)deleteBtnTouched{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"要将这篇文章放入废纸篓中吗？" message:@"您可以在废纸篓中将这篇文章恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.dlt = YES;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - keyboard control
- (void)keyboardAppear:(NSNotification *)noty{
    NSDictionary *info = noty.userInfo;
    CGRect keyBoardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardEndY = keyBoardRect.origin.y - self.view.frame.size.height;
    self.editZoomeBottom.constant = - keyBoardEndY;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    }];
    if (keyBoardEndY) {
        [UIView transitionFromView:self.sToolBar toView:self.kToolBar duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    }else{
        [UIView transitionFromView:self.kToolBar toView:self.sToolBar duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    }

}

#pragma mark - private func
- (void)doAddMark:(MarkType)type{
    [TextAttributeSymbol addMark:type textView:self.editZoom completed:^(NSAttributedString *comStr, NSRange selectedRange, NSDictionary<NSString *, id> *typingAttributes) {
        self.editZoom.attributedText = comStr;
        self.editZoom.selectedRange = selectedRange;
        if (typingAttributes) {
            self.editZoom.typingAttributes = typingAttributes;
        }
    }];
}

- (NSString *)stringDate{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

- (NSString *)savePath:(NSString *)fileName{
    /*在应用程序中获得自己的documents目录*/
    NSString *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    /*设置自己要使用的文件名*/
    NSString *pathToFile = [paths stringByAppendingPathComponent:fileName ? : [self stringDate]];
    return pathToFile;
}

- (NSDictionary *)defaultTypingAttributes{
    if (!_defaultTypingAttributes) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
        paraStyle.lineSpacing = 6;
        _defaultTypingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paraStyle};
    }
    return _defaultTypingAttributes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
