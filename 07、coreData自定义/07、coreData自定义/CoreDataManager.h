//
//  CoreDataManager.h
//  07、coreData自定义
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 tens04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

//创建属性moContext（NSManagedObjectContext：Managed Object Context 参与对数据对象进行各种操作的全过程，并监测数据对象的变化，以提供对 undo/redo 的支持及更新绑定到数据的 UI）
@property (nonatomic, strong) NSManagedObjectContext *moContext;

+ (instancetype)shareManager;

- (void)saveContext;

@end
