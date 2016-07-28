//
//  ScanViewToolBar.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/7/8.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanViewToolBarDelegate <NSObject>
- (void)backBtnTouched;
- (void)shareBtnTouched;
- (void)deleteBtnTouched;

@end
@interface ScanViewToolBar : UIView
@property (weak, nonatomic) id<ScanViewToolBarDelegate> delegate;
@end
