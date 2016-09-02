//
//  CoreDataManager.m
//  07、coreData自定义
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 tens04. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

//创建模型数据属性 （NSManagedObjectModel：是描述应用程序的数据模型，这个模型包含实体（Entity），特性（Property），读取请求（Fetch Request）等。）
@property (nonatomic, strong) NSManagedObjectModel *moModel;

//创建数据文件管理属性 （NSPersistentStoreCoordinator：相当于数据文件管理器，处理底层的对数据文件的读取与写入。）
@property (nonatomic, strong) NSPersistentStoreCoordinator *psCoordinator;

//创建地址属性 （为了后面保存数据并获取本地数据文件地址）
@property (nonatomic, strong) NSURL *dbURL;

@end

//创建全局静态变量，并赋值为空。
static CoreDataManager *manager = nil;

@implementation CoreDataManager

+ (instancetype)shareManager{
    
    //系统自带block进行封装，作用是避免在多线程之下运行造成卡顿。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //对manager自身对象进行初始化
        manager = [[self alloc] init];
    });
    return manager;
}

//创建一个单例方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (manager == nil) {
        
        //如果manager为nil，创建一个单例，并调用。
        manager = [super allocWithZone:zone];
    }
    
    return manager;
}


#pragma mark - 加载模型文件
- (NSManagedObjectModel *)moModel{
    
    if (_moModel == nil ) {
        
        return _moModel;
    }
    
    //获取本地模型文件的地址
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"Model" withExtension:@"momd"];
    
    //加载本地模型文件的地址并创建_moModel文件
    _moModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return _moModel;
}

#pragma mark - 创建数据库保存的本地URL
- (NSURL *)dbURL{
    
    if (_dbURL == nil) {
        
        return _dbURL;
    }
    
    //获取本地目录并创建一个数据库（将数据库地址指向URL）
    _dbURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]URLByAppendingPathComponent:@"db.sqlite"];
    
    return _dbURL;
}


#pragma mark - 创建持久化调度者
- (NSPersistentStoreCoordinator *)psCoordinator {
    if (_psCoordinator != nil) {
        return _psCoordinator;
    }
    
    // 1、创建并加载 模型文件
    _psCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.moModel];
    
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption: @YES};
    
    NSError *error = nil;
    // 2、设置持久化文件类型、配置并设置 持久化文件的URL（configuration:必须为nil，否则会程序崩溃）
    [_psCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.dbURL options:options error:&error];
    
    if (error) {
        NSLog(@"error: %@",error);
    }
    
    return _psCoordinator;
}

#pragma mark - 创建上下文
- (NSManagedObjectContext *)moContext {
    
    if (_moContext != nil) {
        
        return _moContext;
    }
    
    // 1、创建并设置所在的线程队列： NSMainQueueConcurrencyType
    _moContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // 2、指定上下文的持久化调度者
    _moContext.persistentStoreCoordinator = self.psCoordinator;
    
    
    return _moContext;
}

#pragma mark - 保存上下文
- (void)saveContext {
    
    NSError *error = nil;
    if ([self.moContext hasChanges] && [self.moContext save:&error]) {
        
        NSLog(@"保存成功");
    } else {
        
        NSLog(@"error: %@",error);
    }
}


@end
