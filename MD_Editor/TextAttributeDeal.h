//
//  TextAttributeDeal.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(NSDictionary<NSString *, id> *typingAttributes);

@interface TextAttributeDeal : NSObject
+ (NSAttributedString *)setHeadDefaultAttr:(UITextView *)textView complete:(CompleteBlock)blk;
+ (NSAttributedString *)setHeadFirstAttr:(UITextView *)textView complete:(CompleteBlock)blk;
+ (NSAttributedString *)setHeadSecondAttr:(UITextView *)textView complete:(CompleteBlock)blk;
+ (NSAttributedString *)setHeadThirdAttr:(UITextView *)textView complete:(CompleteBlock)blk;
@end
