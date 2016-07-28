//
//  HeadBtnLongPressView.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/27.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "HeadBtnLongPressView.h"

@interface HeadBtnLongPressView ()
@property (weak, nonatomic) UIVisualEffectView *stageView;
@property (weak, nonatomic) UIView *shadowView;
@end

@implementation HeadBtnLongPressView
+ (instancetype)sharedInstance{
    static HeadBtnLongPressView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groundTap:)]];
    
    UIVisualEffectView *stageView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    stageView.frame = CGRectMake(0, 0, 84, 120);
    stageView.layer.cornerRadius = 8;
    stageView.layer.masksToBounds = YES;
    
    [self addSubview:stageView];
    self.stageView = stageView;
    
    UIButton *head1 = [UIButton new];
    head1.titleLabel.font = [UIFont systemFontOfSize:20];
    [head1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [head1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [head1 setTitle:@"一级标题" forState:UIControlStateNormal];
    [head1 addTarget:self action:@selector(head1Touched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *head2 = [UIButton new];
    head2.titleLabel.font = [UIFont systemFontOfSize:18];
    [head2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [head2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [head2 setTitle:@"二级标题" forState:UIControlStateNormal];
    [head2 addTarget:self action:@selector(head2Touched:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *head3 = [UIButton new];
    head3.titleLabel.font = [UIFont systemFontOfSize:16];
    [head3 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [head3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [head3 setTitle:@"三级标题" forState:UIControlStateNormal];
    [head3 addTarget:self action:@selector(head3Touched:) forControlEvents:UIControlEventTouchUpInside];

    
    UIStackView *stack = [[UIStackView alloc]initWithArrangedSubviews:@[head1, head2, head3]];
    stack.frame = self.stageView.bounds;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.alignment = UIStackViewAlignmentFill;
    stack.spacing = 4;
    [self.stageView.contentView addSubview:stack];
    
}

- (void)head1Touched:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(head1BtnTouched)]) {
        [self.delegate head1BtnTouched];
    }
}

- (void)head2Touched:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(head2BtnTouched)]) {
        [self.delegate head2BtnTouched];
    }
}

- (void)head3Touched:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(head3BtnTouched)]) {
        [self.delegate head3BtnTouched];
    }
}

- (void)showInPosition:(CGPoint)center{
    self.stageView.center = center;
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *window;
    if (windows > 0) {
        window = windows.lastObject;
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    [window addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)groundTap:(UIGestureRecognizer *)gesture{
    [self removeFromSuperview];
}
@end
