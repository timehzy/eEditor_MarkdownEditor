//
//  ScanViewToolBar.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/7/8.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "ScanViewToolBar.h"

@interface ScanViewToolBar ()


@end
@implementation ScanViewToolBar
- (IBAction)backBtnTouched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnTouched)]) {
        [self.delegate backBtnTouched];
    }
}

- (IBAction)sharedBtnTouched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnTouched)]) {
        [self.delegate shareBtnTouched];
    }
}

- (IBAction)deleteBtnTouched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnTouched)]) {
        [self.delegate deleteBtnTouched];
    }
}
@end
