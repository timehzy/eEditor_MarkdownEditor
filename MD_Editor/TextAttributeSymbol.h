//
//  TextAttributeDeal.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MarkType) {
    MarkTypeHeadDefault,
    MarkTypeHeadFirst,
    MarkTypeHeadSecond,
    MarkTypeHeadThird,
    MarkTypeTab,
    MarkTypeTabDelete,
    MarkTypeList,
    MarkTypeCheck
};

typedef void(^CharsAddedBlock)(NSAttributedString *comStr, NSRange selectedRange, NSDictionary<NSString *, id> *typingAttributes);
@interface TextAttributeSymbol : NSObject
@property (copy, nonatomic) NSString *text;
+ (void)addMark:(MarkType)type textView:(UITextView *)textView completed:(CharsAddedBlock)blk;
@end
