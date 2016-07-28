//
//  TextAttributeDeal.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "TextAttributeSymbol.h"
#import "TextAttributeDeal.h"

@implementation TextAttributeSymbol
+ (void)addMark:(MarkType)type textView:(UITextView *)textView completed:(CharsAddedBlock)blk{
    __block NSAttributedString *comStr;
    __block NSRange comRange = textView.selectedRange;
    __block NSDictionary<NSString *, id> *comTypingAttributes;
    
    switch (type) {
        case MarkTypeHeadDefault:
            comStr = [TextAttributeDeal setHeadDefaultAttr:textView complete:^(NSDictionary<NSString *,id> *typingAttributes) {
                comTypingAttributes = typingAttributes;
            }];
            break;
        case MarkTypeHeadFirst:
            comStr = [TextAttributeDeal setHeadFirstAttr:textView complete:^(NSDictionary<NSString *,id> *typingAttributes) {
                comTypingAttributes = typingAttributes;
            }];
            break;
        case MarkTypeHeadSecond:
            comStr = [TextAttributeDeal setHeadSecondAttr:textView complete:^(NSDictionary<NSString *,id> *typingAttributes) {
                comTypingAttributes = typingAttributes;
            }];
            break;
        case MarkTypeHeadThird:
            comStr = [TextAttributeDeal setHeadThirdAttr:textView complete:^(NSDictionary<NSString *,id> *typingAttributes) {
                comTypingAttributes = typingAttributes;
            }];
            break;
        case MarkTypeList:
            [self addMark:@"●" markType:type textView:textView complete:^(NSAttributedString *addedText, NSRange selectedRange, NSDictionary<NSString *, id> *typingAttributes) {
                comStr = addedText;
                comRange = selectedRange;
            }];
            break;
        case MarkTypeTab:
            [self addMark:@"   " markType:type textView:textView complete:^(NSAttributedString *addedText, NSRange selectedRange, NSDictionary<NSString *,id> *typingAttributes) {
                comStr = addedText;
                comRange = selectedRange;
            }];
            break;
        case MarkTypeTabDelete:
            [self addMark:@"   " markType:type textView:textView complete:^(NSAttributedString *addedText, NSRange selectedRange, NSDictionary<NSString *,id> *typingAttributes) {
                comStr = addedText;
                comRange = selectedRange;
            }];
            break;
        case MarkTypeCheck:{
            
            NSTextAttachment *checkMark = [[NSTextAttachment alloc]init];
            checkMark.image = [UIImage imageNamed:@"checkMark_uncheck"];
            checkMark.bounds = CGRectMake(0, 0, 16, 16);
            NSAttributedString *checkMarkString = [NSAttributedString attributedStringWithAttachment:checkMark];
            [self addAttachment:checkMarkString markType:MarkTypeCheck textView:textView complete:^(NSAttributedString *addedText, NSRange selectedRange, NSDictionary<NSString *,id> *typingAttributes) {
                comStr = addedText;
                comRange = selectedRange;
            }];
        }
        default:
            break;
    }
    blk(comStr, comRange , comTypingAttributes);
}

+ (void)addAttachment:(NSAttributedString *)attachment markType:(MarkType)type textView:(UITextView *)textView complete:(CharsAddedBlock)blk{
    NSInteger startIndex = textView.selectedRange.location;
    NSInteger endIndex = textView.selectedRange.location + textView.selectedRange.length;
    NSInteger j = 0;//累计已经添加的文本计数
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
//    NSInteger textSize = [[[textView.typingAttributes valueForKey:@"NSFont"]valueForKey:@"pointSize"] integerValue];
    NSUInteger comLocation = textView.selectedRange.location;
    NSUInteger comLength = textView.selectedRange.length;
    NSUInteger addLength = attachment.length + 1;
    BOOL success = NO;
    
    //向前找到最近一个换行的位置
    if (startIndex > 0) {
        while ([textView.attributedText.string characterAtIndex:startIndex - 1] != 10) {
            startIndex--;
            if (startIndex == 0) {
                break;
            }
        }
    }
    
    startIndex = startIndex == 0 ? 0 : startIndex - 1;//需要考虑第一行的特殊性
    if (type != MarkTypeTabDelete) {
        //找到所有的换行符，并在换行符后面添加相应的符号
        for (NSInteger i = startIndex; i <= endIndex; i++) {
            //如果起始是整个文本的开头且起始位置不是mark，则直接在开头加一个mark
            if (i == 0 && ![[textView.attributedText.string substringWithRange:NSMakeRange(i, attachment.length)] isEqualToString:attachment.string]) {
                [str insertAttributedString:attachment atIndex:i];
                success = YES;
                j = j + addLength;
            }
            //如果遇到换行符
            if (i < endIndex && [textView.attributedText.string characterAtIndex:i] == 10) {
                //如果换行后面有字符
                if (i != textView.attributedText.length - 1) {
                    //如果这个位置已经有符号，则直接返回
                    if ([[textView.attributedText.string substringWithRange:NSMakeRange(i + 1, attachment.length)] isEqualToString:attachment.string] && type != MarkTypeTab) {
                        continue;
                    }else{
                        [str insertAttributedString:attachment atIndex:i + j + 1];
                        success = YES;
                        j = j+addLength;
                    }
                }else{
                    [str appendAttributedString:attachment];
                    success = YES;
                    j = j+addLength;
                }
            }
            comLocation = textView.selectedRange.location + addLength;
            comLength = textView.selectedRange.length + (j > 0 ? j - addLength : 0);
        }
    }
    
    /*如果没有添加mark则删除现有的mark*/
    if (!success || type == MarkTypeTabDelete) {
        for (NSInteger i = startIndex; i < endIndex; i++) {
            //如果起始是整个文本的开头且起始位置是mark，则删除mark
            if (i == 0 && [[textView.attributedText.string substringWithRange:NSMakeRange(i, attachment.length)] isEqualToString:attachment.string]) {
                [str deleteCharactersInRange:NSMakeRange(i, addLength)];
                j = j + addLength;
            }
            //如果遇到换行符
            if ([textView.attributedText.string characterAtIndex:i] == 10) {
                //如果换行后面有字符
                if (i != textView.attributedText.length - 1) {
                    //如果这个位置已经有符号，则删除
                    if ([[textView.attributedText.string substringWithRange:NSMakeRange(i + 1, attachment.length)] isEqualToString:attachment.string]) {
                        [str deleteCharactersInRange:NSMakeRange(i + 1 - j, addLength)];
                        j = j+addLength;
                    }else{
                        continue;
                    }
                }
            }
        }
        comLocation = textView.selectedRange.location - (j > 0 ? addLength : 0);
        comLength = textView.selectedRange.length - (j > 0 ? j - addLength : 0);
    }
    
    blk(str, NSMakeRange(comLocation, comLength), nil);
}

+ (void)addMark:(NSString *)mark markType:(MarkType)type textView:(UITextView *)textView complete:(CharsAddedBlock)blk{
    NSInteger startIndex = textView.selectedRange.location;
    NSInteger endIndex = textView.selectedRange.location + textView.selectedRange.length;
    NSInteger j = 0;//累计已经添加的文本计数
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    NSInteger textSize = [[[textView.typingAttributes valueForKey:@"NSFont"]valueForKey:@"pointSize"] integerValue];
    NSUInteger comLocation = textView.selectedRange.location;
    NSUInteger comLength = textView.selectedRange.length;
    NSUInteger addLength = mark.length + 1;
    BOOL success = NO;

    if (textView.selectedRange.length == 0 && type == MarkTypeTab) {
        [str insertAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", mark] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:textSize]}] atIndex:textView.selectedRange.location];
        comLocation += addLength;
        blk(str, NSMakeRange(comLocation, comLength), nil);
        return;
    }
    
    //向前找到最近一个换行的位置
    if (startIndex > 0) {
        while ([textView.attributedText.string characterAtIndex:startIndex - 1] != 10) {
            startIndex--;
            if (startIndex == 0) {
                break;
            }
        }
    }
    
    startIndex = startIndex == 0 ? 0 : startIndex - 1;//需要考虑第一行的特殊性
    if (type != MarkTypeTabDelete) {
        //找到所有的换行符，并在换行符后面添加相应的符号
        for (NSInteger i = startIndex; i <= endIndex; i++) {
            //如果起始是整个文本的开头且起始位置不是mark，则直接在开头加一个mark
            if (i == 0 && (![[textView.attributedText.string substringWithRange:NSMakeRange(i, mark.length)] isEqualToString:mark] || type == MarkTypeTab)) {
                [str insertAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", mark] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:textSize]}] atIndex:i];
                success = YES;
                j = j + addLength;
            }
            //如果遇到换行符
            if (i < endIndex && [textView.attributedText.string characterAtIndex:i] == 10) {
                //如果换行后面有字符
                if (i != textView.attributedText.length - 1) {
                    //如果这个位置已经有符号，则直接返回
                    if ([[textView.attributedText.string substringWithRange:NSMakeRange(i + 1, mark.length)] isEqualToString:mark] && type != MarkTypeTab) {
                        continue;
                    }else{
                        [str insertAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", mark] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:textSize]}] atIndex:i + j + 1];
                        success = YES;
                        j = j+addLength;
                    }
                }else{
                    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", mark] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:textSize]}]];
                    success = YES;
                    j = j+addLength;
                }
            }
            comLocation = textView.selectedRange.location + addLength;
            comLength = textView.selectedRange.length + (j > 0 ? j - addLength : 0);
        }
    }
    
    /*如果没有添加mark则删除现有的mark*/
    if (!success || type == MarkTypeTabDelete) {
        for (NSInteger i = startIndex; i < endIndex; i++) {
            //如果起始是整个文本的开头且起始位置是mark，则删除mark
            if (i == 0 && [[textView.attributedText.string substringWithRange:NSMakeRange(i, mark.length)] isEqualToString:mark]) {
                [str deleteCharactersInRange:NSMakeRange(i, addLength)];
                j = j + addLength;
            }
            //如果遇到换行符
            if ([textView.attributedText.string characterAtIndex:i] == 10) {
                //如果换行后面有字符
                if (i != textView.attributedText.length - 1) {
                    //如果这个位置已经有符号，则删除
                    if ([[textView.attributedText.string substringWithRange:NSMakeRange(i + 1, mark.length)] isEqualToString:mark]) {
                        [str deleteCharactersInRange:NSMakeRange(i + 1 - j, addLength)];
                        j = j+addLength;
                    }else{
                        continue;
                    }
                }
            }
        }
        comLocation = textView.selectedRange.location - (j > 0 ? addLength : 0);
        comLength = textView.selectedRange.length - (j > 0 ? j - addLength : 0);
    }
    
    blk(str, NSMakeRange(comLocation, comLength), nil);
}
@end
