//
//  StudentTableViewController.m
//  TestCoreData
//
//  Created by ys on 16/6/19.
//  Copyright © 2016年 jzh. All rights reserved.
//

#import "StudentTableViewController.h"

#import "AppDelegate.h"
#import "StudentCell.h"
#import "Student.h"

@interface StudentTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation StudentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    self.context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classes == %@", self.valueClasses];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count != 0) {
        [self.dataArray setArray:fetchedObjects];
    }
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentCell *studentCell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    Student *student = self.dataArray[indexPath.row];
    studentCell.nameLabel.text = student.name;
    studentCell.ageLabel.text = [student.age stringValue];
    studentCell.headerImageView.image = [UIImage imageWithData:student.imageData];
    
    return studentCell;
}


@end
