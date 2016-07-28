//
//  HZYArticle.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/7/5.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCoderObject.h"

@interface HZYArticle : YHCoderObject
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *tag;
@property (strong, nonatomic) NSDate *createTime;
@property (strong, nonatomic) NSDate *lastEditTime;
@end
