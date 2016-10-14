//
//  AppDelegate.h
//  TestCoreData
//
//  Created by ys on 16/6/19.
//  Copyright © 2016年 jzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 数据管理器（被管理者上下文）
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// 模型管理器（被管理对象模型）
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
// 核心类 数据链接器（持久化存储助理）
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// 上下文操作的数据都是在内存中进行的，只有save操作才会影响到真实的文件
- (void)saveContext;

// 返回沙盒路径
- (NSURL *)applicationDocumentsDirectory;


@end

