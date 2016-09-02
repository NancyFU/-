//
//  Student+CoreDataProperties.h
//  07、coreData自定义
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 tens04. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stuName;
@property (nullable, nonatomic, retain) NSString *stuID;
@property (nullable, nonatomic, retain) NSNumber *stuAge;

@end

NS_ASSUME_NONNULL_END
