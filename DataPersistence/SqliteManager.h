//
//  SqliteManager.h
//  DataPersistence
//
//  Created by ma c on 2016/11/3.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface SqliteManager : NSObject
+ (SqliteManager *)sharedManager;
- (NSString *)applicationDocumentsDirectoryFile;
//创建数据库
- (void)createDataBaseIfNeeded;
//插入数据
- (void)create:(Person *)model;
//查找所有数据
- (NSMutableArray *)findAll;
//根据ID查询数据
- (Person *)findByID:(NSString *)ID;
//删除
- (void)remove:(Person *)model;
//更新
- (void)modify:(Person *)model;
@end
