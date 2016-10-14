//
//  WomanTableViewController.m
//  TestCoreData
//
//  Created by ys on 16/6/19.
//  Copyright © 2016年 jzh. All rights reserved.
//

#import "WomanTableViewController.h"

#import "Woman.h"
#import "WomanCell.h"
#import "AppDelegate.h"
#import "ClassTableViewController.h"

@interface WomanTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WomanTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数据源
    self.dataArray = [NSMutableArray array];
    
    // 获取到Appdelegate里面的临时数据库（数据管理器）
    self.context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    [self fetchDataFromLocal];
    
}

// 查询数据，展示出来
- (void)fetchDataFromLocal
{
    // 查询类，从数据库中查询出来的值就是一个数组
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Woman"];
    
    // 排序类
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    // 查询结果，返回值是一个数组
    NSArray *fetchArray = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        if (fetchArray.count != 0) {
            [self.dataArray setArray:fetchArray];
            [self.tableView reloadData];
        }
    }
}

- (IBAction)change:(UIBarButtonItem *)sender {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Woman"];
    // 设置谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ and age == 20", @"华妃2"];
    [fetchRequest setPredicate:predicate];
    
    // 接收查询结果
    NSError *error = nil;
    NSArray *fetchArray = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        for (Woman *woman in fetchArray) {
            woman.name = @"贵妃";
            woman.age = 0;
            
            // 本来应该写&error，为了节省才写的nil
            [self.context save:nil];
            [self fetchDataFromLocal];
        }
    }
}

- (IBAction)insert:(UIBarButtonItem *)sender {
    
    // 创建实体描述类
    NSEntityDescription *womenED = [NSEntityDescription entityForName:@"Woman" inManagedObjectContext:self.context];
    Woman *woman = [[Woman alloc] initWithEntity:womenED insertIntoManagedObjectContext:self.context];
    static NSInteger n = 0;
    woman.name = [NSString stringWithFormat:@"华妃%ld", n++];
    woman.age = arc4random() % (30 - 18 + 1) + 18;
    woman.imageData = UIImagePNGRepresentation([UIImage imageNamed:@""]);
    woman.vip = n % 2 ? YES : NO;
    
    
    // context都是在内存中操作的数据，如果想要在真实的文件中修改数据，我们需要进行save操作
    NSError *error = nil;
    [self.context save:&error];
    if (!error) {
        [self.dataArray addObject:woman];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else {
        NSLog(@"插入失败");
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Woman *woman = self.dataArray[indexPath.row];
        [self.context deleteObject:woman];
        NSError *error = nil;
        [self.context save:&error];
        if (!error) {
            [self.dataArray removeObject:woman];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WomanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"womanCell"];
    Woman *woman = self.dataArray[indexPath.row];
    cell.headImageView.image = [UIImage imageWithData:woman.imageData];
    cell.nameLabel.text = woman.name;
    cell.ageLabel.text = [[@(woman.age) stringValue] stringByAppendingString:[@(woman.vip) stringValue]];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.navigationController pushViewController:[ClassTableViewController new] animated:YES];
//}


@end
