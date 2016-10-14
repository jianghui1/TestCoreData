//
//  StudentTableViewController.h
//  TestCoreData
//
//  Created by ys on 16/6/19.
//  Copyright © 2016年 jzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Classes;

@interface StudentTableViewController : UITableViewController

// 声明属性，接收上个页面传过来的值
@property (nonatomic, strong) Classes *valueClasses;

@end
