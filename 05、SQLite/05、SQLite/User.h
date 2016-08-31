//
//  User.h
//  05、SQLite
//
//  Created by tens04 on 16/8/31.
//  Copyright (c) 2016年 tens04. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, assign) int userAge;

@end
