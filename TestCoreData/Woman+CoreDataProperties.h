//
//  Woman+CoreDataProperties.h
//  TestCoreData
//
//  Created by ys on 16/6/19.
//  Copyright © 2016年 jzh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Woman.h"

NS_ASSUME_NONNULL_BEGIN

@interface Woman (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int16_t age;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nonatomic) BOOL vip;

@end

NS_ASSUME_NONNULL_END
