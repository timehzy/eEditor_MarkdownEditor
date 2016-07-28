//
//  HeadBtnLongPressView.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/27.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadBtnLongPressViewDelegate <NSObject>
- (void)head1BtnTouched;
- (void)head2BtnTouched;
- (void)head3BtnTouched;
@end

@interface HeadBtnLongPressView : UIView
@property (weak, nonatomic) id<HeadBtnLongPressViewDelegate> delegate;
+ (instancetype)sharedInstance;
- (void)showInPosition:(CGPoint)center;
- (void)dismiss;
@end
