//
//  ViewController.m
//  沙盒目录
//
//  Created by tens04 on 16/8/30.
//  Copyright (c) 2016年 tens04. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Documents:苹果建议将程序中建⽴立的或在程序中浏览到的⽂文件数据保存在该⺫⽬目录下,iTunes备份和恢 复的时候会包括此⺫⽬目录
    //Library:存储程序的默认设置或其它状态信息;(iTunes备份和恢复的时候会包含此⺫⽬目录) Library/Caches:存放缓存⽂文件,iTunes不会备份此⺫⽬目录,此⺫⽬目录下⽂文件不会在应⽤用退出删除,iTunes是一款媒体播放器的应用程序
    //tmp:提供⼀一个即时创建临时⽂文件的地⽅方。(系统重启后会删除tmp⾥里的所有⽂文件)
    
    //沙盒目录的路径
    NSString *homePath = NSHomeDirectory();
    //Documents的目录
    NSString *documentPath = [homePath stringByAppendingPathComponent:@"Documents"];
    
    NSLog(@"%@",documentPath);
    NSLog(@"%@",[self docPath]);
    NSLog(@"%@",[self libPath]);
    NSLog(@"%@",[self temPath]);
    
}

//获取Documents目录
- (NSString *)docPath{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    
}
//获取library目录
- (NSString *)libPath{
   
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
}

//获取缓存目录路径
- (NSString *)cachesPath{
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
}

//获取tem的目录
- (NSString *)temPath{
    
    return NSTemporaryDirectory();
}


@end
