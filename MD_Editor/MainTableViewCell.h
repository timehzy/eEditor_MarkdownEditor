//
//  MainTableViewCell.h
//  MD_Editor
//
//  Created by Michael-Nine on 16/7/6.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYArticle.h"

@protocol MainTableViewCellDelegate <NSObject>
- (void)alertActionAct;
@end

@interface MainTableViewCell : UITableViewCell
@property (strong, nonatomic) HZYArticle *data;
@property (strong, nonatomic) id delegate;

@end
