//
//  ViewController.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYArticle.h"

typedef void(^EndEditBlock)(HZYArticle *article, BOOL moveToTrash);
@interface EditViewController : UIViewController

@property (strong, nonatomic) EndEditBlock popedBlk;
@property (strong, nonatomic) HZYArticle *article;

@end

