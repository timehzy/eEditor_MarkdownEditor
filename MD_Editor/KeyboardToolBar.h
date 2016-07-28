//
//  KeyboardToolBar.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardToolBarDelegate <NSObject>
- (void)tabBtnTouched;
- (void)tabBtnLongPress;
- (void)headBtnTouched;
- (void)listBtnTouched;
- (void)checkBtnTouched;
- (void)doneBtnTouche;

- (void)head1BtnTouched;
- (void)head2BtnTouched;
- (void)head3BtnTouched;
@end

@interface KeyboardToolBar : UIView
@property (weak, nonatomic) id<KeyboardToolBarDelegate> delegate;
@end
