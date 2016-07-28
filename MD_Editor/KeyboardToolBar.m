//
//  KeyboardToolBar.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "KeyboardToolBar.h"
#import "HeadBtnLongPressView.h"

@interface KeyboardToolBar ()<HeadBtnLongPressViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) UIView *popBtnView;
@end
@implementation KeyboardToolBar
- (IBAction)tabBtnTouched:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBtnTouched)]) {
        [self.delegate tabBtnTouched];
    }
}

- (IBAction)tabBtnLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBtnLongPress)]) {
            [self.delegate tabBtnLongPress];
        }
    }
}

- (IBAction)headBtnTouched:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headBtnTouched)]) {
        [self.delegate headBtnTouched];
    }
}

- (IBAction)listBtnTouched:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listBtnTouched)]) {
        [self.delegate listBtnTouched];
    }
}

- (IBAction)checkBtnTouched:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBtnTouched)]) {
        [self.delegate checkBtnTouched];
    }
}

- (IBAction)doneBtnTouched:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneBtnTouche)]) {
        [self.delegate doneBtnTouche];
    }
}

- (IBAction)headBtnLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        HeadBtnLongPressView *pressView = [HeadBtnLongPressView sharedInstance];
        pressView.delegate = self;
        [pressView showInPosition:[self convertPoint:self.headBtn.center toView:[UIApplication sharedApplication].keyWindow]];
    }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
    }
}

#pragma mark - HeadBtnLongPressViewDelegate
- (void)head1BtnTouched{
    if (self.delegate && [self.delegate respondsToSelector:@selector(head1BtnTouched)]) {
        [self.delegate head1BtnTouched];
    }
}

- (void)head2BtnTouched{
    if (self.delegate && [self.delegate respondsToSelector:@selector(head2BtnTouched)]) {
        [self.delegate head2BtnTouched];
    }
}

- (void)head3BtnTouched{
    if (self.delegate && [self.delegate respondsToSelector:@selector(head3BtnTouched)]) {
        [self.delegate head3BtnTouched];
    }
}
@end
