//
//  ViewController.m
//  05、SQLite
//
//  Created by tens04 on 16/8/31.
//  Copyright (c) 2016年 tens04. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "User.h"


//先导入系统库，点击Build Phases的第三个,再点击“+”添加一个libsqlite3.dylib
@interface ViewController () {
    
    sqlite3 *_sqliteDB; // 创建数据库结构体指针,不能使用两个指针指向对象
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 1、导入系统库：libsqlite3.dylib, 路径：/usr/lib/libsqlite3.dylib
    
    // 2、#import <sqlite3.h>
    
    // 3、设置数据库文件的保存路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBasePath = [docPath stringByAppendingPathComponent:@"data.sqlite"];
    
    NSLog(@"%@",docPath);
    
    // 4、创建或者打开数据库，没有时创建，已经有了就直接打开，参数一：数据库文件的保存路径，参数二：sqlite3 结构体指针
    int result = sqlite3_open([dataBasePath UTF8String],&_sqliteDB);
    
    // SQLITE_OK 表示成功
    if (result == SQLITE_OK) {
        
        NSLog(@"数据库创建成功%d",result);
        
         //[self createTable];
        
         //[self insertValues];
        
         [self addColumn];
        
         //[self updateValues];
        
         //[self deleteValues];
        
         //[self selectDatas];
        
        
    } else {
        
        NSLog(@"数据库创建失败%d",result);
    }
    
    // 5、使用完后要关闭数据库，释放资源
    sqlite3_close(_sqliteDB);
    
}

#pragma mark - 创建数据库表
- (void)createTable {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS User('userID' TEXT, 'userName' TEXT, 'userAge' INTEGER)";
    
    // sqlite3_exec() 执行 sql语句 函数
    int result = sqlite3_exec(_sqliteDB,[sql UTF8String],NULL,NULL,NULL);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"创建表成功");
    } else {
        
        NSLog(@"创建失败");
    }
    
}

#pragma mark - 数据库表中插入数据
- (void)insertValues {
    
    NSString *userID = @"10001";
    NSString *userName = @"小燕儿";
    int age = 20;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO User('userID','userName','userAge') VALUES('%@','%@',%d)",userID,userName,age];
    
    // sqlite3_exec() 执行 sql 函数
    int result = sqlite3_exec(_sqliteDB,[sql UTF8String],NULL,NULL,NULL);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"插入数据成功");
    } else {
        
        NSLog(@"失败");
    }
}

#pragma mark - 添加字段(列)
- (void)addColumn {
    
    NSString *columnName = @"userSex TEXT";
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE User ADD COLUMN %@",columnName];
    
    // sqlite3_exec() 执行 sql 函数
    int result = sqlite3_exec(_sqliteDB,[sql UTF8String],NULL,NULL,NULL);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"添加字段成功");
    } else {
        
        NSLog(@"失败");
    }
    
}

#pragma mark - 更新数据
- (void)updateValues {
    
    NSString *userSex = @"男";
    NSString *userName = @"电风扇";
    NSString *sql = [NSString stringWithFormat:@"UPDATE User SET userSex = '%@' WHERE userName = '%@'",userSex,userName];
    
    // sqlite3_exec() 执行 sql 函数
    int result = sqlite3_exec(_sqliteDB,[sql UTF8String],NULL,NULL,NULL);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"修改数据成功成功");
    } else {
        
        NSLog(@"失败");
    }
}

#pragma mark - 删除数据
- (void)deleteValues {
    
    NSString *userName = @"电风扇";
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM User WHERE userName = '%@'",userName];
    
    // sqlite3_exec() 执行 sql 函数
    int result = sqlite3_exec(_sqliteDB,[sql UTF8String],NULL,NULL,NULL);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"删除数据成功");
        
    } else {
        
        NSLog(@"失败");
    }
    
}

#pragma mark - 查询数据
- (void)selectDatas {
    
    //1、创建sql语句结构体指针(可以理解为sql语句对象)
    sqlite3_stmt *_stmt;
    
    // NSString *sql = @"SELECT *FROM User";
    
    NSString *key = @"张";
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM User WHERE userName LIKE '%%%@%%'",key];
    
    
    // 2、编译查询语句
    int result = sqlite3_prepare_v2(_sqliteDB,[sql UTF8String],-1,&_stmt,NULL);
    
    if (result == SQLITE_OK) {
        NSLog(@"sql语句编程通过");
        
        NSMutableArray *users = [NSMutableArray array];
        
        // 3、执行查询语句，== SQLITE_ROW 表示还有下一条数据
        while (sqlite3_step(_stmt) == SQLITE_ROW) {
            
            /* 4、获取每一行数据对应的字段(列)
             
             sqlite3_column_text() 对应 TEXT 类型
             sqlite3_column_int（） 对应 INTERER类型
             */
            char *userID = (char *)sqlite3_column_text(_stmt,0);
            char *userName = (char *)sqlite3_column_text(_stmt,1);
            int userAge = sqlite3_column_int(_stmt,2);
            char *userSex = (char *)sqlite3_column_text(_stmt,3);
            
            NSString *userID_str = [NSString stringWithUTF8String:userID];
            NSString *userName_str = [NSString stringWithUTF8String:userName];
            NSString *userSex_str = [NSString stringWithUTF8String:userSex];
            
            // 把查询到的数据保存为 model 对象
            User *user = [[User alloc] init];
            user.userID = userID_str;
            user.userName = userName_str;
            user.userSex = userSex_str;
            user.userAge = userAge;
            [users addObject:user];
            
            NSLog(@"%@, %@, %d,%@",userID_str,userName_str,userAge,userSex_str);
            
        }
        
    } else {
        
        NSLog(@"失败");
    }
}


@end
