//
//  TextAttributeDeal.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "TextAttributeDeal.h"

#define Default_Size 18
#define Head_Default_Size 28
#define Head_First_Size 32
#define Head_Second_Size 28
#define Head_Third_Size 24

@implementation TextAttributeDeal
+ (NSAttributedString *)setHeadDefaultAttr:(UITextView *)textView complete:(CompleteBlock)blk{
    return [self dealAttribute:textView textSize:Head_Default_Size typingAttr:^(NSDictionary<NSString *,id> *typingAttributes) {
        blk(typingAttributes);
    }];
}

+ (NSAttributedString *)setHeadFirstAttr:(UITextView *)textView complete:(CompleteBlock)blk{
    return [self dealAttribute:textView textSize:Head_First_Size typingAttr:^(NSDictionary<NSString *,id> *typingAttributes) {
        blk(typingAttributes);
    }];
}

+ (NSAttributedString *)setHeadSecondAttr:(UITextView *)textView complete:(CompleteBlock)blk{
    return [self dealAttribute:textView textSize:Head_Second_Size typingAttr:^(NSDictionary<NSString *,id> *typingAttributes) {
        blk(typingAttributes);
    }];
}

+ (NSAttributedString *)setHeadThirdAttr:(UITextView *)textView complete:(CompleteBlock)blk{
    return [self dealAttribute:textView textSize:Head_Third_Size typingAttr:^(NSDictionary<NSString *,id> *typingAttributes) {
        blk(typingAttributes);
    }];
}

#pragma mark - private func
+ (NSAttributedString *)dealAttribute:(UITextView *)textView textSize:(NSInteger)size typingAttr:(CompleteBlock)blk{
    NSDictionary *attr = [self completionAttribute:textView.typingAttributes completeFontSize:size];
    NSMutableAttributedString *comStr = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    //如果没有选中文本，光标前后都是换行符（或者光标index＝0且下一个是换行，或光标index＝text.length且上一个是换行），则直接将typingAttributes设置为目标格式
    if (textView.selectedRange.length == 0 &&
        (((textView.selectedRange.location == 0) && ([textView.text characterAtIndex:textView.selectedRange.location + 1] == 10))
         || ((textView.selectedRange.location == textView.text.length) && ([textView.text characterAtIndex:textView.selectedRange.location - 1] == 10))
         || (([textView.text characterAtIndex:textView.selectedRange.location - 1] == 10) && ([textView.text characterAtIndex:textView.selectedRange.location + 1] == 10)))){
            blk(attr);
        }else{
            //设置文本格式
            [comStr setAttributes:attr range:[self attrTextIndex:textView.text cursorPosition:textView.selectedRange]];
        }
    return comStr;
}

/* 该方法通过判断textView的typingAttribute的fontSize是否等于按钮的size来设定实际返回的文本的attribute */
+ (NSDictionary *)completionAttribute:(NSDictionary *)originAttribute completeFontSize:(NSInteger)size{
    NSInteger comSize;
    NSDictionary *textTypingAttr = originAttribute;
    NSInteger textSize = [[[textTypingAttr valueForKey:@"NSFont"]valueForKey:@"pointSize"] integerValue];
    comSize = (textSize == size ? Default_Size : size);
    return @{NSFontAttributeName : [UIFont systemFontOfSize:comSize]};
}

+ (NSRange)attrTextIndex:(NSString *)text cursorPosition:(NSRange)range{
    //向前找到最近的换行符，作为格式化字符串开始的索引
    NSInteger startIndex = range.location;
    if (startIndex > 0) {
        while ([text characterAtIndex:startIndex - 1] != 10) {
            startIndex--;
            if (startIndex == 0) {
                break;
            }
        }
    }
    /*结束索引，分为两种情况
     #没有选中文字
     #选中了文字（选中文字只考虑整行）
     */
    NSInteger endIndex = (range.length == 0 ? range.location : range.location + range.length);
    if (text.length == endIndex) {
        //光标位于文本末尾
    }else{
        //否则向后找到最近的换行符
        while ([text characterAtIndex:endIndex] != 10) {
            endIndex++;
            //如果到文本末尾也没有，则跳出
            if (endIndex == text.length) {
                break;
            }
        }
    }
    return NSMakeRange(startIndex, endIndex - startIndex);
}
@end
