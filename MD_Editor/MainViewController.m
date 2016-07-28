//
//  MainTableViewController.m
//  MD_Editor
//
//  Created by Michael-Nine on 16/7/5.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "MainViewController.h"
#import "EditViewController.h"
#import "HZYArticle.h"
#import "MainTableViewCell.h"

#define Array_File_Name @"articalList"
@interface MainViewController ()<MainTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *addArticl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)configView{
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"list"];
//    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_bkg1"]];
    self.tableView.contentInset = UIEdgeInsetsMake(16, 0, 20, 0);
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    self.addArticl.layer.cornerRadius = 22;
    self.addArticl.layer.masksToBounds = YES;
}

- (IBAction)newArtical:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditViewController *vc =[sb instantiateViewControllerWithIdentifier:@"editor"];
    vc.popedBlk = ^(HZYArticle *art, BOOL moveToTrash){
        [self.dataArray addObject:art];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        NSData *arrData = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
        [arrData writeToFile:[self pathToFile] atomically:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditViewController *vc =[sb instantiateViewControllerWithIdentifier:@"editor"];
    vc.article = self.dataArray[indexPath.row];
    vc.popedBlk = ^(HZYArticle *art, BOOL moveToTrash){
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:art];
        [tableView reloadData];
        NSData *arrData = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
        [arrData writeToFile:[self pathToFile] atomically:YES];
    };
    [self.navigationController showViewController:vc sender:nil];
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction *actionTop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self.dataArray insertObject:self.dataArray[indexPath.row] atIndex:0];
//        [self.dataArray removeObjectAtIndex:indexPath.row + 1];
//        [self.tableView reloadData];
//        NSData *arrData = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
//        [arrData writeToFile:[self pathToFile] atomically:YES];
//    }];
//    actionTop.backgroundColor = [UIColor blueColor];
//    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.tableView reloadData];
//        NSData *arrData = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
//        [arrData writeToFile:[self pathToFile] atomically:YES];
//    }];
//    return @[actionTop, actionDelete];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    cell.data = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)alertActionAct{
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSData *data = [NSData dataWithContentsOfFile:[self pathToFile]];
        if (data) {
            _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            _dataArray = [NSMutableArray array];
        }
    }
    return _dataArray;
}

- (NSString *)pathToFile{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:Array_File_Name];
    return path;
}
@end
