//
//  ClassTableViewController.m
//  TestCoreData
//
//  Created by ys on 16/6/19.
//  Copyright © 2016年 jzh. All rights reserved.
//

#import "ClassTableViewController.h"

#import "Student.h"
#import "Teacher.h"
#import "Classes.h"
#import "ClassCell.h"
#import "AppDelegate.h"
#import "StudentTableViewController.h"

@interface ClassTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ClassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"插入" style:UIBarButtonItemStyleDone target:self action:@selector(insertAciton)];
    self.navigationItem.rightBarButtonItem = button;
    
    
    self.tableView.estimatedRowHeight = 44.0;
    
    // 初始化数组
    self.dataArray = [NSMutableArray array];
    
    // 获取数据管理器
    self.context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    [self fetchObjectsFromLocal];
}

- (void)insertAciton
{
    NSEntityDescription *classED = [NSEntityDescription entityForName:@"Classes" inManagedObjectContext:self.context];
    // 创建实体
    Classes *oneClass = [[Classes alloc] initWithEntity:classED insertIntoManagedObjectContext:self.context];
    
    NSArray *addressArray = @[@"北京", @"大连", @"郑州", @"上海", @"广州", @"西安"];
    oneClass.address = addressArray[arc4random() % addressArray.count];
    oneClass.beginDate = [NSDate date];
    
    static NSInteger n = 0;
    
    oneClass.name = [NSString stringWithFormat:@"woshidi%ldge", n++];
    
    NSArray *teactherArray = @[@"帅哥", @"笨蛋", @"傻逼", @"二球"];
    oneClass.teacher = [[Teacher alloc] initWithEntity:[NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
    oneClass.teacher.name = teactherArray[arc4random() % teactherArray.count];
    
    NSInteger num = arc4random() % (20 - 10 + 1) + 10;
    for (int i = 0; i < num; i++) {
        NSEntityDescription *studentED = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.context];
        
        Student *student = [[Student alloc] initWithEntity:studentED insertIntoManagedObjectContext:self.context];
        student.name = [NSString stringWithFormat:@"小明%ld", n++];
        student.age = @(arc4random() % (50 - 30 + 1) + 30);
        student.imageData = UIImagePNGRepresentation([UIImage imageNamed:@""]);
        // 创建关联
        [oneClass.teacher addStudentsObject:student];
        [oneClass addStudentsObject:student];
    }
    
    NSError *error = nil;
    [self.context save:&error];
    if (!error) {
        [self.dataArray addObject:oneClass];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)fetchObjectsFromLocal
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Classes" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchArray = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchArray.count != 0) {
        [self.dataArray setArray:fetchArray];
        [self.tableView reloadData];
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
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
    Classes *oneClass = self.dataArray[indexPath.row];
    cell.addressLabel.text = oneClass.address;
    cell.beginDateLabel.text = [oneClass.beginDate description];
    cell.nameLabel.text = oneClass.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Classes *oneClass = self.dataArray[indexPath.row];
        [oneClass.students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.context deleteObject:obj];
        }];
        
        // 删除学生和老师还有班级的关联
        [oneClass.teacher removeStudents:oneClass.students];
        [oneClass removeStudents:oneClass.students];
        
        [self.context deleteObject:oneClass.teacher];
        [self.context deleteObject:oneClass];
        
        NSError *error = nil;
        [self.context save:&error];
        if (!error) {
            [self.dataArray removeObject:oneClass];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 点谁跳转，谁就是sender，线是控件的线
    ClassCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Classes *oneClass = self.dataArray[indexPath.row];
    
    StudentTableViewController *studentTVC = segue.destinationViewController;
    
    studentTVC.valueClasses = oneClass;
}











@end
